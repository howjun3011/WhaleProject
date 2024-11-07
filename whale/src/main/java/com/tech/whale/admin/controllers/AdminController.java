package com.tech.whale.admin.controllers;

import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.service.AdminAccountUserInfoService;
import com.tech.whale.admin.service.AdminAccountUserListService;
import com.tech.whale.admin.service.AdminAccountUserModifyService;
import com.tech.whale.admin.service.AdminUserImgDeleteService;
import com.tech.whale.admin.service.AdminUserInfoCommentService;
import com.tech.whale.admin.service.AdminUserInfoFeedService;
import com.tech.whale.admin.service.AdminUserInfoPostService;
import com.tech.whale.admin.service.AdminUserNicknameModifyService;
import com.tech.whale.admin.util.AdminSearchVO;
import com.tech.whale.community.vo.SearchVO;



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
	private AdminAccountUserModifyService adminAccountUserModifyService;
	@Autowired
	private AdminUserNicknameModifyService adminUserNicknameModifyService;
	@Autowired
	private AdminUserImgDeleteService adminUserImgDeleteService;
	
	@Autowired
	private AdminIDao adminIDao;
	
	@ModelAttribute("myId")
    public String addUserIdToModel(HttpSession session) {
        return (String) session.getAttribute("user_id");
    }
	@ModelAttribute("myImgUrl")
	public String myImgUrl(Model model) {
		String myId = (String)model.getAttribute("myId");
		String myImgSty = adminIDao.myImg(myId);
		return myImgSty;
	}
	
	public void accountSubBar(Model model) {
	    Map<String, String> subMenu = new LinkedHashMap<>();
	    subMenu.put("adminAccountUserListView", "유저관리");
	    subMenu.put("adminAccountOfficialListView", "오피셜관리");
	    subMenu.put("adminAccountClientListView", "광고주관리 오류남");
	    
	    model.addAttribute("subMenu", subMenu);
	}

	
	@RequestMapping("/adminMainView")
	public String adminMainView(HttpServletRequest request,
			HttpSession session,
			Model model) {
		
		String userId = (String) session.getAttribute("user_id");
		
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
	public String adminAccountOfficialListView(
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
	    
	    adminAccountUserListService.officialList(model);
	    
		return "/admin/view/adminOutlineForm";
	}
	
	
//	@RequestMapping("/adminAccountClientListView")
//	public String adminAccountClientListView(
//			HttpServletRequest request,
//			AdminSearchVO searchVO,
//			Model model) {
//		
//		model.addAttribute("request", request);
//		model.addAttribute("searchVO", searchVO);
//		model.addAttribute("pname", "광고주관리");
//		model.addAttribute("contentBlockJsp",
//				"../account/adminAccountClientContent.jsp");
//		model.addAttribute("contentBlockCss",
//				"/whale/static/css/admin/account/adminAccountUserListContent.css");
//		accountSubBar(model);
//		
//		adminAccountUserListService.clientList(model);
//		return "/admin/view/adminOutlineForm";
//	}
	
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
	    adminAccountUserInfoService.excuteArray(model);
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
	
	@RequestMapping("/adminAccountOfficialInfo")
	public String adminAccountOfficialInfo(
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
	
	
	
	@RequestMapping("/adminAccountUserModify")
	public String adminAccountUserModify(
			HttpServletRequest request,
			Model model) {
		
		model.addAttribute("request", request);
		model.addAttribute("pname", "유저정보수정");
		model.addAttribute("contentBlockJsp",
				"../account/adminAccountUserModifyContent.jsp");
		model.addAttribute("contentBlockCss",
				"/whale/static/css/admin/account/adminAccountUserModifyContent.css");
		accountSubBar(model);
		
		adminAccountUserModifyService.execute(model);
		adminAccountUserInfoService.execute(model);
		
		return "/admin/view/adminOutlineForm";
	}
	
	@RequestMapping("/adminUserAccessModify")
	public String adminUserAccessModify(
			HttpSession session,
			HttpServletRequest request,
			Model model) {
		model.addAttribute("request", request);
		String userId = request.getParameter("userId");
		
		adminAccountUserModifyService.modifyAccess(model,session);
		
		
		return "redirect:adminAccountUserModify?userId="+userId;
	}
	
	@RequestMapping("/adminUserStatusModify")
	public String adminUserStatusModify(
			HttpSession session,
			HttpServletRequest request,
			Model model) {
		model.addAttribute("request", request);
		String userId = request.getParameter("userId");
		
		adminAccountUserModifyService.modifyStatus(model,session);
		
		
		return "redirect:adminAccountUserModify?userId="+userId;
	}
	
	@RequestMapping("/adminUserNicknameModify")
	public String adminUserNicknameModify(
			HttpServletRequest request,
			Model model) {
		model.addAttribute("request", request);
		String userId = request.getParameter("userId");
		
		adminUserNicknameModifyService.execute(model);
		
				
		return "redirect:adminAccountUserModify?userId="+userId;
	}
	
	@RequestMapping("/adminUserImgDelete")
	public String adminUserImgDelete(
			HttpServletRequest request,
			Model model) {
		model.addAttribute("request", request);
		String userId = request.getParameter("userId");
		
		adminUserImgDeleteService.execute(model);
		
		
		return "redirect:adminAccountUserModify?userId="+userId;
	}
	
	///////////////////////////////////////// 보드
	
	
	
	
}
