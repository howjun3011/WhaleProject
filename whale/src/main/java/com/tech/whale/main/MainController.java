package com.tech.whale.main;

import java.net.URI;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.tech.whale.main.models.MainAuthorizationCode;
import com.tech.whale.main.service.MainAuthorizationCodeController;

@Controller
public class MainController {
	private final MainAuthorizationCode mainAuthorizationCode;
	private final MainAuthorizationCodeController mainAuthorizationCodeController;

    public MainController(MainAuthorizationCode mainAuthorizationCode, MainAuthorizationCodeController mainAuthorizationCodeController) {
    	this.mainAuthorizationCode = mainAuthorizationCode;
        this.mainAuthorizationCodeController = mainAuthorizationCodeController;
    }
	
    // [ 메인 페이지 이동 ]
    @RequestMapping("/main")
	public String main() {
		return "main/main";
	}
    // [ 세션 등록 구간 ]
	@GetMapping("/check-access-id")
	public String checkAccessId(@RequestParam Map<String, String> queryParam, HttpSession session) {
		// 세션 등록
		session.setAttribute("accessToken", queryParam.get("access_token"));
		session.setAttribute("refreshToken", queryParam.get("refresh_token"));
		session.setAttribute("user_id", queryParam.get("user_id"));
		session.setAttribute("logged_in", queryParam.get("logged_in"));
		session.setAttribute("access_id", queryParam.get("access_id"));
		
		// 관리자 번호에 따라 리다이렉트 지점 변경
		if (session.getAttribute("access_id").toString().equals("1")) {return "redirect:/admin/adminMainView";}
		else {return "redirect:main";}
	}
	
	// [ 로그아웃 기능 ]
	@GetMapping("/main/logout")
	public String logout(HttpSession session) {
		// 스프링 서버 세션 정보 초기화
		session.invalidate();
		
		// 노드 서버 정보 초기화 위해 리다이렉트
		// return "redirect:https://localhost:5500/whale/logout\\";
		// 스프링 서버 로그인 화면으로 리다이렉트
		return "redirect:/";
	}
	
	// [ 프레임에 스트리밍 메인 구간 이동 ]
	@RequestMapping("/streaming")
	public String streaming(HttpSession session) {
		return "redirect:https://localhost:5500/whale/streaming\\?accessToken="+(String) session.getAttribute("accessToken")+"&userId="+(String) session.getAttribute("user_id");
	}
}