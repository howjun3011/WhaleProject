package com.tech.whale.admin.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tech.whale.admin.dao.AdminIDao;



@Controller
@RequestMapping("/admin/report")
public class AdminReportController {
	
//	@Autowired
//	private AdminServiceInter adService;
	@Autowired
	private AdminIDao AdminIDao;
	private String userId;
	
	
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
	    
	    
		return "/admin/view/adminMainView";
	}
	
	
}
