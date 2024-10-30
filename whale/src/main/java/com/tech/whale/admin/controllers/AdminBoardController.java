package com.tech.whale.admin.controllers;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.tech.whale.admin.board.service.AdminBoardContentService;
import com.tech.whale.admin.board.service.AdminBoardListService;
import com.tech.whale.admin.board.service.AdminBoardPostDelete;
import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.service.AdminAccountUserInfoService;
import com.tech.whale.admin.util.AdminSearchVO;
import com.tech.whale.community.dao.ComDao;
import com.tech.whale.community.dto.CommentDto;
import com.tech.whale.community.dto.PostDto;
import com.tech.whale.community.service.ComDetailService;
import com.tech.whale.community.service.ComLikeCommentService;


@Controller
@RequestMapping("/admin")
public class AdminBoardController {

	@Autowired
	private AdminBoardListService adminBoardListService;
	@Autowired
	private AdminBoardContentService adminBoardContentService;
	@Autowired
	private ComLikeCommentService comLikeCommentService;
	@Autowired
	private AdminBoardPostDelete adminBoardPostDelete;
	
	
	@Autowired
	private AdminIDao adminIDao;
	@Autowired
	private ComDao comDao;
	
	
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
	
	@RequestMapping("/adminBoardPostContentView")
	public String adminBoardContentView(
			@RequestParam("communityName") String communityName,
			@RequestParam("postId") String postId,
			HttpSession session,
			HttpServletRequest request,
			Model model) {
		
		model.addAttribute("request", request);
		model.addAttribute("pname", "게시글");
		model.addAttribute("contentBlockJsp",
				"../board/adminBoardContent.jsp");
		model.addAttribute("contentBlockCss",
				"/whale/static/css/admin/board/adminBoardContent.css");
		boardSubBar(model);
		
		
		PostDto postDetail = comDao.getPost(postId);
		List<CommentDto> commentsList = comLikeCommentService.getCommentsForPost(postId);
		postDetail.setComments(commentsList);

		model.addAttribute("communityName", communityName);
		model.addAttribute("postId", postId);
		model.addAttribute("postDetail", postDetail);
		model.addAttribute("request", request);
		adminBoardContentService.execute(model);

		adminBoardListService.execute(model);
		
		return "/admin/view/adminOutlineForm";
	}
	
	@RequestMapping("/adminBoardPostContentDelete")
	public String adminBoardPostContentDelete(
			HttpSession session,
			HttpServletRequest request,
			Model model) {
		model.addAttribute("request", request);
		model.addAttribute("user_id", session.getAttribute("user_id"));
		
		adminBoardPostDelete.execute(model);
		
		
		return "redirect:adminBoardListView";
	}
	
}
