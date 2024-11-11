package com.tech.whale.admin.controllers;

import java.net.http.HttpRequest;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tech.whale.admin.dao.AdminIDao;


@Controller
@RequestMapping("/admin")
public class AdminStatisticController {
	
	
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
	
	public void statisticSubBar(Model model) {
	    Map<String, String> subMenu = new LinkedHashMap<>();
	    subMenu.put("adminStatisticView", "통계");
	    
	    model.addAttribute("subMenu", subMenu);
	}
	
	@RequestMapping("/adminStatisticView")
	public String adminStatisticView(
			HttpRequest request,
			Model model) {
		model.addAttribute("request", request);
		model.addAttribute("pname", "HOME");
		model.addAttribute("contentBlockJsp",
				"../main/adminStatisticContent.jsp");
	    model.addAttribute("contentBlockCss",
	    		"/whale/static/css/admin/main/adminStatisticContent.css");
	    model.addAttribute("subBarBlockJsp",
	    		null);
	    model.addAttribute("subBarBlockCss",
	    		null);
	    statisticSubBar(model);
	    
	    //데이터 불러오는 자리?
		
		return "/admin/view/adminMainView";
	}
	
}
