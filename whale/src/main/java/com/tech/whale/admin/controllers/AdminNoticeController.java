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
public class AdminNoticeController {

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
	public void boardSubBar(Model model) {
	    Map<String, String> subMenu = new LinkedHashMap<>();
	    subMenu.put("adminBoardListView", "게시글");
	    subMenu.put("adminBoardCommentsListView", "댓글");
	    
	    model.addAttribute("subMenu", subMenu);
	}
	
	@RequestMapping("/adminNoticeListView")
	public String adminNoticeListView(
			HttpServletRequest request,
			AdminSearchVO searchVO,
			Model model) {
		
		model.addAttribute("request", request);
		model.addAttribute("searchVO", searchVO);
		model.addAttribute("pname", "공지사항");
		model.addAttribute("contentBlockJsp",
				"../board/adminNoticeListContent.jsp");
	    model.addAttribute("contentBlockCss",
	    		"/whale/static/css/admin/account/adminAccountUserListContent.css");
	    boardSubBar(model);
	    
	    
	    
		return "/admin/view/adminOutlineForm";
	}
	
	
	
	
}
