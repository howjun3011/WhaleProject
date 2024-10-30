package com.tech.whale.admin.controllers;

import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tech.whale.admin.board.service.AdminBoardListService;
import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.service.AdminAccountUserInfoService;
import com.tech.whale.admin.util.AdminSearchVO;


@Controller
@RequestMapping("/admin")
public class AdminBoardController {

	@Autowired
	private AdminBoardListService adminBoardListService;
	
	
	@Autowired
	private AdminIDao adminIDao;
	
	
	public void boardSubBar(Model model) {
	    Map<String, String> subMenu = new LinkedHashMap<>();
	    subMenu.put("adminBoardListView", "게시글");
	    subMenu.put("", "댓글");
	    
	    model.addAttribute("subMenu", subMenu);
	}
	
	@RequestMapping("/adminBoardListView")
	public String adminBoardListView(
			HttpServletRequest request,
			AdminSearchVO searchVO,
			Model model) {
		
		model.addAttribute("request", request);
		model.addAttribute("searchVO", searchVO);
		model.addAttribute("pname", "게시글");
		model.addAttribute("contentBlockJsp",
				"../board/adminBoardListContent.jsp");
	    model.addAttribute("contentBlockCss",
	    		"/whale/static/css/admin/account/adminAccountUserListContent.css");
	    boardSubBar(model);
	    
	    adminBoardListService.execute(model);
	    
		return "/admin/view/adminOutlineForm";
	}
	
}
