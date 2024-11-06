package com.tech.whale.message.controller;

import com.tech.whale.message.dao.MessageDao;
import com.tech.whale.message.dto.AllChatListDto;
import com.tech.whale.message.dto.FollowListDto;
import com.tech.whale.message.dto.ReadChatDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class MessageController2 {

	@Autowired
	private MessageDao messageDao;
	
	@RequestMapping("/message/home")
	public String messageHome(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("maeeageHome() ctr");
		String now_id = (String) session.getAttribute("user_id");

		List<AllChatListDto> allChatList = messageDao.getAllChatList(now_id);
		List<ReadChatDto> readChatList = messageDao.getReadChatList(now_id);

		for (ReadChatDto list : readChatList) {
			int minutes = list.getMinutes_since_last_message();
			String timeDifference = "";

			if (minutes < 60) {
				timeDifference = minutes + "분 전";
			} else if (minutes < 1440) {
				int hours = minutes / 60;
				timeDifference = hours + "시간 전";
			} else {
				int days = minutes / 1440;
				timeDifference = days + "일 전";
			}

			list.setTime_difference(timeDifference);
		}

		// debug
		for (AllChatListDto chatListDto : allChatList) {
			System.out.println("User_id: " + chatListDto.getUser_id());
			System.out.println("User_nickname: " + chatListDto.getUser_nickname());
			System.out.println("User_image_url: " + chatListDto.getUser_image_url());
			System.out.println("Message_read: " + chatListDto.getMessage_read());
			System.out.println("Last_message_text: " + chatListDto.getLast_message_text());
			System.out.println("--------------------------");
		}

		// debug
		for (ReadChatDto chatListDto : readChatList) {
			System.out.println("User_id: " + chatListDto.getUser_id());
			System.out.println("Minutes_since_last_message: " + chatListDto.getMinutes_since_last_message());
			System.out.println("Last_message_text: " + chatListDto.getLast_message_text());
			System.out.println("Unread_message_count: " + chatListDto.getUnread_message_count());
			System.out.println("--------------------------");
		}

		model.addAttribute("allChatList", allChatList);
		model.addAttribute("readChatList", readChatList);
		model.addAttribute("now_id", now_id);
		
		return "message/home";
	}

	@RequestMapping("/message/newChat")
	public String newChat(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("newChat() ctr");
		String now_id = (String) session.getAttribute("user_id");

		List<FollowListDto> followList = messageDao.getFollowList(now_id);

		//debug
		for (FollowListDto followListDto : followList) {
			System.out.println(followListDto.getFollow_user_id());
			System.out.println(followListDto.getFollow_user_nickname());
			System.out.println(followListDto.getFollow_user_image_url());
			System.out.println("--------------------");
		}

		model.addAttribute("followList", followList);

		return "/message/newChat";
	}
	
}
