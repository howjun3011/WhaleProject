package com.tech.whale.streaming;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class StreamingController {
	// [ 프레임에 스트리밍 메인 구간 이동 ]
	@RequestMapping("/streaming")
	public String streaming(@RequestParam Map<String, String> queryParam, HttpSession session) {
		// 노드 스트리밍 서버를 위한 리다이렉트
		return "redirect:https://localhost:5500/whale/streaming\\?accessToken="+(String) session.getAttribute("accessToken")+"&userId="+(String) session.getAttribute("user_id")+"&type="+queryParam.get("type");
		// 스프링 스트리밍 서버를 위한 리다이렉트
		// return "streaming/streamingHome";
	}
}
