package com.tech.whale.message.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tech.whale.message.dao.MessageDao;
import com.tech.whale.message.dto.MessageDto;

@Controller
public class MessageController {

	@Autowired
	private MessageDao messageDao;
	
<<<<<<< Updated upstream:whale/src/main/java/com/tech/whale/message/controller/MessageController.java
	@RequestMapping("/messageHome")
	public String messageHome(HttpServletRequest request, HttpSession session, Model model) {
		String now_id = (String) session.getAttribute("user_id");
		
		return "message/messageHome";
	}
	
=======
>>>>>>> Stashed changes:whale/src/main/java/com/tech/whale/message/controllers/MessageController.java
	@RequestMapping("/messageGo")
	public String messageGo(HttpServletRequest request, HttpSession session, Model model,
			@RequestParam("u") String userId) {
		String now_id = (String) session.getAttribute("user_id");
		MessageDto messageDto = messageDao.getAllRoom(now_id, userId);
		String roomId = "";
		if (messageDto == null || messageDto.getMessage_room_id() == null) {
			roomId = messageDao.getNextRoomId();
			messageDao.createMessageRoom(roomId);
			messageDao.addUserMessageRoom(roomId, userId);
			messageDao.addUserMessageRoom(roomId, now_id);
			messageDto = messageDao.getAllRoom(now_id, userId);
		} else {
			roomId = messageDto.getMessage_room_id();
		}
		
		model.addAttribute("roomId", roomId);
		return "redirect:/messageRoom?r=" + roomId + "&u=" + userId;			
	}

	@RequestMapping("/messageRoom")
	public String messageRoom(HttpServletRequest request, HttpSession session, Model model,
			@RequestParam("r") String roomId,
			@RequestParam("u") String userId) {
		String now_id = (String) session.getAttribute("user_id");
		
		List<MessageDto> messages = messageDao.getMessagesByRoomId(roomId);
		
		model.addAttribute("messages", messages);
		model.addAttribute("now_id", now_id);
		model.addAttribute("userId", userId);
		model.addAttribute("roomId", roomId);
		return "message/messageRoom";
	}
	
	@PostMapping("/sendMessage")
	public String sendMessage(HttpSession session,
	                          @RequestParam("roomId") String roomId,
	                          @RequestParam("message") String message,
	                          @RequestParam("userId") String userId) {
	    String now_id = (String) session.getAttribute("user_id");
	    
	    // 메시지 객체 생성
	    MessageDto messageDto = new MessageDto();
	    messageDto.setMessage_room_id(roomId);
	    messageDto.setUser_id(now_id);
	    messageDto.setMessage_text(message);
	    messageDto.setMessage_create_date(new Date());

	    // 메시지 저장
	    messageDao.saveMessage(messageDto);

	    // 채팅방으로 리다이렉트
	    return "redirect:/messageRoom?r=" + roomId + "&u=" + userId;
	}
	
    @GetMapping("/getMessages")
    @ResponseBody
    public List<MessageDto> getMessages(@RequestParam("roomId") String roomId) {
        // roomId에 해당하는 메시지 목록을 가져옵니다.
        return messageDao.getMessagesByRoomId(roomId);
    }
}
