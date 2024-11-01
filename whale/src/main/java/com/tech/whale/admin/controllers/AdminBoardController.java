package com.tech.whale.admin.controllers;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.tech.whale.admin.board.service.AdminBoardPostContentService;
import com.tech.whale.admin.board.service.AdminBoardFeedDelete;
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
import com.tech.whale.feed.dao.FeedDao;
import com.tech.whale.feed.dto.FeedCommentDto;
import com.tech.whale.feed.dto.FeedDto;
import com.tech.whale.feed.service.FeedCommentService;


@Controller
@RequestMapping("/admin")
public class AdminBoardController {

	@Autowired
	private AdminBoardListService adminBoardListService;
	@Autowired
	private AdminBoardPostContentService adminBoardPostContentService;
	@Autowired
	private ComLikeCommentService comLikeCommentService;
	@Autowired
	private AdminBoardPostDelete adminBoardPostDelete;
	@Autowired
	private AdminBoardFeedDelete adminBoardFeedDelete;
	@Autowired
	private FeedCommentService feedCommentsService;
	
	@Autowired
	private AdminIDao adminIDao;
	@Autowired
	private ComDao comDao;
	@Autowired
	private FeedDao feedDao;
	
	@ModelAttribute("myId")
    public String addUserIdToModel(HttpSession session) {
        // 세션에서 user_id 가져오기 (세션에 저장된 user_id가 있다고 가정)
        return (String) session.getAttribute("user_id");
    }
	
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
			@RequestParam("page") int page,
			@RequestParam("searchType") String searchType,
			@RequestParam("sk") String sk,
			@RequestParam("communityName") String communityName,
			@RequestParam("postId") String postId,
			HttpSession session,
			HttpServletRequest request,
			Model model) {
		
		model.addAttribute("request", request);
		model.addAttribute("pname", "게시글");
		model.addAttribute("contentBlockJsp",
				"../board/adminBoardPostContent.jsp");
		model.addAttribute("contentBlockCss",
				"/whale/static/css/admin/board/adminBoardPostContent.css");
		boardSubBar(model);
		
		PostDto postDetail = comDao.getPost(postId);
		List<CommentDto> commentsList = comLikeCommentService.getCommentsForPost(postId);
		postDetail.setComments(commentsList);

		model.addAttribute("page", page);
		model.addAttribute("searchType", searchType);
		model.addAttribute("sk", sk);
		model.addAttribute("communityName", communityName);
		model.addAttribute("postId", postId);
		model.addAttribute("postDetail", postDetail);
		adminBoardPostContentService.execute(model);

//		adminBoardListService.execute(model);
		
		return "/admin/view/adminOutlineForm";
	}
	
	@RequestMapping("/adminBoardPostContentDelete")
	public String adminBoardPostContentDelete(
			@RequestParam("page") int page,
			@RequestParam("searchType") String searchType,
			@RequestParam("sk") String sk,
			HttpSession session,
			HttpServletRequest request,
			Model model) {
		model.addAttribute("request", request);
		String user_id = (String)session.getAttribute("user_id");
		model.addAttribute("user_id", user_id);
		adminBoardPostDelete.execute(model);
		
		return "redirect:adminBoardListView?page="+page+"&sk="+sk+"&searchType="+searchType;
	}
	
	@RequestMapping("/adminBoardFeedContentView")
	public String adminBoardFeedContentView(
			@RequestParam("f") String feedId,
			@RequestParam("page") int page,
			@RequestParam("searchType") String searchType,
			@RequestParam("sk") String sk,
			HttpSession session,
			HttpServletRequest request,
			Model model) {
		
		model.addAttribute("request", request);
		model.addAttribute("pname", "피드");
		model.addAttribute("contentBlockJsp",
				"../board/adminBoardFeedContent.jsp");
		model.addAttribute("contentBlockCss",
				"/whale/static/css/admin/board/adminBoardFeedContent.css");
		boardSubBar(model);
		
		String now_id = (String) session.getAttribute("user_id");
		
		FeedDto feedDetail = feedDao.getFeedOne(feedId);
		
		List<FeedCommentDto> commentsList = feedCommentsService.getCommentsForFeed(feedId);
		
	    for (FeedCommentDto comment : commentsList) {
	        List<FeedCommentDto> replies = feedCommentsService.getRepliesForComment(comment.getFeed_comments_id());
	        comment.setReplies(replies);
	    }
		
		feedDetail.setFeedComments(commentsList);
		
		model.addAttribute("now_id", now_id);
		model.addAttribute("feedDetail", feedDetail);
		
		
		model.addAttribute("page", page);
		model.addAttribute("searchType", searchType);
		model.addAttribute("sk", sk);
		
		return "/admin/view/adminOutlineForm";
	}
	
	@RequestMapping("/adminBoardFeedContentDelete")
	public String adminBoardFeedContentDelete(
			@RequestParam("page") int page,
			@RequestParam("searchType") String searchType,
			@RequestParam("sk") String sk,
			HttpSession session,
			HttpServletRequest request,
			Model model) {
		model.addAttribute("request", request);
		String user_id = (String)session.getAttribute("user_id");
		model.addAttribute("user_id", user_id);
		adminBoardFeedDelete.execute(model);
		
		return "redirect:adminBoardListView?page="+page+"&sk="+sk+"&searchType="+searchType;
	}
	
	@RequestMapping("/adminBoardFeedCommentsContentDelete")
	public String adminBoardFeedCommentsContentDelete(
			@RequestParam("page") int page,
			@RequestParam("f") String f,
			@RequestParam("searchType") String searchType,
			@RequestParam("sk") String sk,
			HttpSession session,
			HttpServletRequest request,
			Model model) {
		model.addAttribute("request", request);
		String user_id = (String)session.getAttribute("user_id");
		model.addAttribute("user_id", user_id);
		adminBoardFeedDelete.commentsDelete(model);
		
		///////  자식 댓글있으면 전부 삭제?
		
		return "redirect:adminBoardFeedContentView?page="+page+"&sk="+sk+"&searchType="+searchType+"&f="+f;
	}
	
	@RequestMapping("/adminBoardPostCommentsContentDelete")
	public String adminBoardPostCommentsContentDelete(
			@RequestParam("page") int page,
			@RequestParam("postId") String postId,
			@RequestParam("communityName") String communityName,
			@RequestParam("searchType") String searchType,
			@RequestParam("sk") String sk,
			HttpSession session,
			HttpServletRequest request,
			Model model) {
		model.addAttribute("request", request);
		String user_id = (String)session.getAttribute("user_id");
		model.addAttribute("user_id", user_id);
		adminBoardPostDelete.commentsDelete(model);
		
		///////  자식 댓글있으면 전부 삭제?
		
		return "redirect:adminBoardPostContentView?page="+page+"&sk="+sk+"&searchType="+searchType+"&postId="+postId+"&communityName="+communityName;
	}
	
}
