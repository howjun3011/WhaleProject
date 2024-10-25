package com.tech.whale.admin.controllers;

import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.service.AdminAccountUserInfoService;
import com.tech.whale.admin.service.AdminAccountUserListService;
import com.tech.whale.admin.service.AdminUserInfoCommentService;
import com.tech.whale.admin.service.AdminUserInfoFeedService;
import com.tech.whale.admin.service.AdminUserInfoPostService;
import com.tech.whale.admin.util.AdminSearchVO;
import com.tech.whale.community.vo.SearchVO;


/*

- 광고 업무
광고주가 신청서를 작성할 수 있는 양식. (페이지)
광고를 심사하고 승인할 수 있는 양식(승인 거절 남김)
승인된 광고 게시
광고id, 제목, 내용, 이미지url, 광고주정보, 광고상태, 시작 종료날짜
광고 기간에만 게시되도록 종료날짜에 광고 비활성화
노출횟수, 클릭수, 광고종료시 연장 및 새로신청

*/

//   http://localhost:9002/whale/admin/adminMainView


@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private AdminAccountUserListService adminAccountUserListService;
	@Autowired
	private AdminAccountUserInfoService adminAccountUserInfoService;
	@Autowired
	private AdminUserInfoPostService adminUserInfoPostService;
	@Autowired
	private AdminUserInfoFeedService adminUserInfoFeedService;
	@Autowired
	private AdminUserInfoCommentService adminUserInfoCommentService;
	
	
	@Autowired
	private AdminIDao adminIDao;
	
	private String userId;
	
	public void accountSubBar(Model model) {
	    Map<String, String> subMenu = new LinkedHashMap<>();
	    subMenu.put("adminAccountOfficialListView", "오피셜관리");
	    subMenu.put("adminAccountClientListView", "광고주관리");
	    subMenu.put("adminAccountUserListView", "유저관리");
	    
	    model.addAttribute("subMenu", subMenu);
	}

	
	@RequestMapping("/adminMainView")
	public String adminMainView(HttpServletRequest request,
			HttpSession session,
			Model model) {
		
		userId = (String) session.getAttribute("user_id");
		
		model.addAttribute("request", request);
		model.addAttribute("pname", "HOME");
		model.addAttribute("contentBlockJsp",
				"../main/adminMainContent.jsp");
	    model.addAttribute("contentBlockCss",
	    		"/whale/static/css/admin/main/adminMainContent.css");
	    model.addAttribute("subBarBlockJsp",
	    		null);
	    model.addAttribute("subBarBlockCss",
	    		null);
	    accountSubBar(model);
	    
		return "/admin/view/adminMainView";
	}
	
	@RequestMapping("/adminAccountOfficialListView")
	public String adminAccountOfficialView(
			HttpServletRequest request,
			AdminSearchVO searchVO,
			Model model) {
		model.addAttribute("request", request);
		model.addAttribute("pname", "오피셜관리");
		model.addAttribute("contentBlockJsp",
				"../account/adminAccountOfficialContent.jsp");
	    model.addAttribute("contentBlockCss",
	    		"/whale/static/css/admin/account/adminAccountOfficialListContent.css");
	    accountSubBar(model);
	    
		return "/admin/view/adminOutlineForm";
	}
	
	@RequestMapping("/adminAccountClientListView")
	public String adminAccountClientView(
			HttpServletRequest request,
			AdminSearchVO searchVO,
			Model model) {
		model.addAttribute("request", request);
		model.addAttribute("pname", "광고주관리");
		model.addAttribute("contentBlockJsp",
				"../account/adminAccountClientContent.jsp");
	    model.addAttribute("contentBlockCss",
	    		"/whale/static/css/admin/account/adminAccountClientListContent.css");
	    accountSubBar(model);
	    
		return "/admin/view/adminOutlineForm";
	}
	
	@RequestMapping("/adminAccountUserListView")
	public String adminAccountUserListView(
			HttpServletRequest request,
			AdminSearchVO searchVO,
			Model model) {
		
		model.addAttribute("request", request);
		model.addAttribute("searchVO", searchVO);
		model.addAttribute("pname", "유저관리");
		model.addAttribute("contentBlockJsp",
				"../account/adminAccountUserContent.jsp");
	    model.addAttribute("contentBlockCss",
	    		"/whale/static/css/admin/account/adminAccountUserListContent.css");
	    accountSubBar(model);
	    
	    adminAccountUserListService.execute(model);
		
		return "/admin/view/adminOutlineForm";
	}
	
	
	
	@RequestMapping("/adminAccountAddView")
	public String adminAccountAddView(
			HttpServletRequest request,
			AdminSearchVO searchVO ,
			Model model) {
		
		model.addAttribute("request", request);
		model.addAttribute("searchVO", searchVO);
		model.addAttribute("pname", "권한추가");
		model.addAttribute("contentBlockJsp",
				"../account/adminAccountAddContent.jsp");
	    model.addAttribute("contentBlockCss",
	    		"/whale/static/css/admin/account/adminAccountAddContent.css");
	    accountSubBar(model);
	    
		return "/admin/view/adminOutlineForm";
	}
	
	
	@RequestMapping("/adminMyInfoView")
	public String adminMyInfoView(HttpServletRequest request, Model model) {
		
		model.addAttribute("request", request);
		model.addAttribute("pname", "나의정보");
		model.addAttribute("contentBlockJsp",
				"../account/adminMyInfoContent.jsp");
	    model.addAttribute("contentBlockCss",
	    		null);
	    accountSubBar(model);
		return "/admin/view/adminOutlineForm";
	}
	
	
	@RequestMapping("/adminAccountUserInfo")
	public String adminAccountUserInfo(
			HttpServletRequest request,
			SearchVO searchVO,
			Model model) {
		
		model.addAttribute("request", request);
		model.addAttribute("searchVO", searchVO);
		model.addAttribute("pname", "유저정보");
		model.addAttribute("contentBlockJsp",
				"../account/adminAccountUserInfoContent.jsp");
	    model.addAttribute("contentBlockCss",
	    		"/whale/static/css/admin/account/adminAccountUserInfoContent.css");
	    accountSubBar(model);
	    
	    adminAccountUserInfoService.execute(model);
		adminUserInfoPostService.execute(model);
		adminUserInfoFeedService.execute(model);
		adminUserInfoCommentService.execute(model);
		
		return "/admin/view/adminOutlineForm";
	}
	
	
}
