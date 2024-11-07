package com.tech.whale.message.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.tech.whale.message.dao.MessageDao;
import com.tech.whale.message.dto.MessageDto;

@Controller
public class MessageController {

	@Autowired
	private MessageDao messageDao;

	@RequestMapping("/messageGo")
	public String messageGo(HttpServletRequest request, HttpSession session, Model model,
			@RequestParam("u") String userId) {
		String now_id = (String) session.getAttribute("user_id");
		System.out.println(userId);
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

	    messageDao.readMessage(roomId, userId);
	    List<MessageDto> messages = messageDao.getMessagesByRoomId(roomId);

	    ObjectMapper objectMapper = new ObjectMapper();
	    for (MessageDto msg : messages) {
	        if ("LINK".equals(msg.getMessage_type())) {
	            String messageText = msg.getMessage_text();
	            String textContent = messageText.contains("#preview=") ?
	                    messageText.split("#preview=")[0] : messageText;
	            msg.setMessage_text(textContent);

	            // JSON 데이터 파싱하여 previewData 설정
	            if (messageText.contains("#preview=")) {
	                String previewJson = messageText.split("#preview=")[1];
	                try {
	                    Map<String, String> previewData = objectMapper.readValue(previewJson, HashMap.class);
	                    msg.setPreviewData(previewData); // MessageDto에 previewData 추가 필요
	                } catch (Exception e) {
	                    e.printStackTrace();
	                }
	            }
	        }
	    }

	    model.addAttribute("messages", messages);
	    model.addAttribute("now_id", now_id);
	    model.addAttribute("userId", userId);
	    model.addAttribute("roomId", roomId);
	    return "message/messageRoom";
	}
	
	
}
