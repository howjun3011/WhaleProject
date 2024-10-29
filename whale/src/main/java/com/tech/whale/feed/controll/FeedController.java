package com.tech.whale.feed.controll;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.tech.whale.feed.dao.FeedDao;
import com.tech.whale.feed.dto.FeedCommentDto;
import com.tech.whale.feed.dto.FeedDto;
import com.tech.whale.feed.service.FeedCommentService;
import com.tech.whale.feed.service.FeedLikeService;
import com.tech.whale.feed.service.FeedWriteService;

@Controller
public class FeedController {

	@Autowired
	private FeedDao feedDao;
	
	@Autowired
	private FeedWriteService feedWriteService;
	
	@Autowired
	private FeedLikeService feedLikeService;
	
	@Autowired
	private FeedCommentService feedCommentsService;
	
	@RequestMapping("/loadMoreFeeds")
	public String loadMoreFeeds(HttpServletRequest request, HttpSession session, Model model,
			 @RequestParam("offset") int offset,
             @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
	    String now_id = (String) session.getAttribute("user_id");

	    System.out.println("offset : " + offset);
	    // 페이징 처리를 위해 offset과 size 사용
	    List<FeedDto> feedList = feedDao.getFeeds(now_id, offset, size);

	    
	    
	    boolean isLastPage = feedList.size() < size;
	    
	    model.addAttribute("isLastPage", isLastPage);
	    model.addAttribute("offset", offset);
	    model.addAttribute("feedList", feedList);
	    
	    // 추가된 피드만 반환할 수 있도록 JSP 조각을 새로 생성 (피드 부분만)
	    return "feed/feedListFragment"; // 이 JSP는 피드 HTML 조각만 반환하도록 해야 함
	}
	
	@RequestMapping("/feedHome")
	public String feedHome(HttpServletRequest request, HttpSession session, Model model, 
			@RequestParam(value = "offset", required = false, defaultValue = "0") int offset,
	        @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
		System.out.println("feedHome");
		String now_id = (String) session.getAttribute("user_id");

		
		List<FeedDto> feedList = feedDao.getFeeds(now_id, offset, size);
		boolean isLastPage = feedList.size() < size;
		
		model.addAttribute("isLastPage", isLastPage);
		model.addAttribute("now_id", now_id);
		model.addAttribute("offset", offset);
		model.addAttribute("size", size);
		model.addAttribute("feedList", feedList);
		return "feed/feedHome";
	}
	
	@RequestMapping("/feedDetail")
	public String feedDetail(@RequestParam("f") String feedId, HttpServletRequest request, HttpSession session, Model model) {
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
		return "feed/feedDetail";
	}
	
	@RequestMapping("/feedDel")
	public String feedDel(@RequestParam("f") String feed_id, HttpServletRequest request, HttpSession session, Model model) {
		
		feedDao.deleteFeed(feed_id);
		
		return "redirect:/feedHome";
	}
	
	@RequestMapping("/feedHide")
	public String feedHide(@RequestParam("f") String feed_id, HttpServletRequest request, HttpSession session, Model model) {
		
		feedDao.hideFeed(feed_id);
		
		return "redirect:/feedHome";
	}
	
	@RequestMapping("/feedWriteDo")
	public String feedWriteDo(HttpServletRequest request, HttpSession session, Model model,
			@RequestParam("feedText") String feed_text,
			@RequestParam("feedImage") MultipartFile file) {
		
		System.out.println("feedWriteDo");
		
		String now_id = (String) session.getAttribute("user_id");
		
		FeedDto feedDto = new FeedDto();
		feedDto.setFeed_text(feed_text);
		feedDto.setUser_id(now_id);
		try {
			feedWriteService.registerFeed(feedDto, file);
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		
		return "redirect:/feedHome";
	}
	
	@RequestMapping("/feedLike")
	public @ResponseBody Map<String, Object> feedLike(@RequestParam("feedId") String feedId, 
	                                                  @RequestParam("now_id") String now_id) {
	    Map<String, Object> result = new HashMap<>();
	    
	    try {
	        int newLikeCount = feedLikeService.toggleLike(feedId, now_id);
	        result.put("success", true);
	        result.put("newLikeCount", newLikeCount);
	    } catch (Exception e) {
	        result.put("success", false);
	        result.put("message", e.getMessage());
	    }
	    
	    return result; // JSON 형식으로 응답
	}
	
	
	@RequestMapping("/feedDetail/comments")
	public String commentsFeed(@RequestParam("comments") String comments, @RequestParam("feedId") String feedId, @RequestParam("userId") String now_id, Model model) {
		
		feedCommentsService.insertComment(feedId, now_id, comments);
		
		List<FeedCommentDto> commentsList = feedCommentsService.getCommentsForFeed(feedId);
		
		FeedDto feedDetail = feedDao.getFeedOne(feedId);
		feedDetail.setFeedComments(commentsList);
		
		model.addAttribute("feedDetail", feedDetail);
		
		return "redirect:/feedDetail?f=" + feedId;
	}
	
    @PostMapping("/feedDetail/deleteComment")
    public String deleteComments(@RequestParam("feedCommentsId") String feedCommentsId,
                                @RequestParam("feedId") String feedId) {
    	
    	System.out.println("feedCommentsId : " + feedCommentsId);
        // 댓글 삭제
        feedCommentsService.deleteComments(feedCommentsId);

        // 삭제 후 해당 게시글 디테일 페이지로 리다이렉트
        return "redirect:/feedDetail?f=" + feedId;
    }
    
    @PostMapping("/commentLike")
    @ResponseBody
    public Map<String, Object> commentLike(@RequestParam("commentId") String commentId, 
                                           @RequestParam("now_id") String now_id) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            int newLikeCount = feedCommentsService.toggleCommentLike(commentId, now_id);
            result.put("success", true);
            result.put("newLikeCount", newLikeCount);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        
        return result; // JSON 형식으로 응답
    }
    
    @PostMapping("/feedDetail/reply")
    public String replyToComment(@RequestParam("feedId") int feedId,
                                 @RequestParam("parentCommentId") String parentCommentId,
                                 @RequestParam("userId") String userId,
                                 @RequestParam("replyText") String replyText) {

        feedCommentsService.addReply(feedId, parentCommentId, userId, replyText);

        return "redirect:/feedDetail?f=" + feedId;
    }

}
