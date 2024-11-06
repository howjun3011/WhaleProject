package com.tech.whale.admin.report.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.dao.AdminReportIDao;
import com.tech.whale.admin.dto.AdminOfficialInfoDto;
import com.tech.whale.admin.dto.AdminPFCDto;
import com.tech.whale.admin.dto.AdminReportListDto;
import com.tech.whale.admin.dto.AdminReportResultDto;
import com.tech.whale.admin.dto.AdminUserInfoDto;
import com.tech.whale.admin.service.AdminServiceInter;
import com.tech.whale.admin.util.AdminSearchVO;

@Service
public class AdminReportListService implements AdminServiceInter{
	
	@Autowired
	private AdminReportIDao adminReportIDao;
	
	@Override
	public void execute(Model model) {
		
		Map<String, Object> map = model.asMap();
		HttpServletRequest request =
				(HttpServletRequest) map.get("request");
		AdminSearchVO searchVO = (AdminSearchVO) map.get("searchVO");
		
		if (searchVO == null) {
		    searchVO = new AdminSearchVO();
		    model.addAttribute("searchVO", searchVO);
		}
		
		String user_id = "";
	    
	 	
		String brdTitle = request.getParameter("searchType");
		
		if (brdTitle == null || brdTitle.trim().isEmpty()) {
	        user_id = "user_id";
	        model.addAttribute("user_id", "true");
	    } else if(brdTitle != null) {
			if(brdTitle.equals("user_id")) {
				model.addAttribute("user_id", "true");
				user_id="user_id";
			}
		}
		
		String searchKeyword = request.getParameter("sk");
		if(searchKeyword == null || searchKeyword.trim().isEmpty()) {
			searchKeyword = "";
		}

		int total = 0;
		if(user_id.equals("user_id")) {
			total = adminReportIDao.selectReportCnt(searchKeyword,"1");
		}
		
		String strPage = request.getParameter("page");
		
 		if(strPage == null || strPage.isEmpty()) {
 			strPage="1";
 		}
		
		int page = Integer.parseInt(strPage);
		searchVO.setPage(page);
		
		searchVO.pageCalculate(total);
		
		int rowStart = searchVO.getRowStart();
		int rowEnd = searchVO.getRowEnd();
		
		ArrayList<AdminReportListDto> list = null;
		if(user_id.equals("user_id")) {
			list = adminReportIDao.adminReportList(rowStart,rowEnd, searchKeyword,"1");
		}
		
		if(list !=null) {
			for (AdminReportListDto var : list) {
				if(var.getFeed_id() != 0) {
					var.setWriting_id(var.getFeed_id());
					var.setTag_name("피드");
				}else if(var.getPost_id() != 0) {
					var.setWriting_id(var.getPost_id());
					var.setTag_name("커뮤");
				}else if(var.getFeed_comment_id() != 0) {
					var.setWriting_id(var.getFeed_comment_id());
					var.setTag_name("피드댓글");
				}else if(var.getPost_comment_id() != 0) {
					var.setWriting_id(var.getPost_comment_id());
					var.setTag_name("커뮤댓글");
				}else if(var.getMessage_id() != 0) {
					var.setWriting_id(var.getMessage_id());
					var.setTag_name("메시지");
				}
			}
		}
		
		
		
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("searchType", brdTitle);
		model.addAttribute("list", list);
		model.addAttribute("ultotRowcnt", total);
		model.addAttribute("ulsearchVO", searchVO);
		
	}
	
	public void content(Model model) {
		
		Map<String, Object> map = model.asMap();
		HttpServletRequest request =
				(HttpServletRequest) map.get("request");
		
		String report_id = request.getParameter("report_id");
		if(report_id.trim().isEmpty() || report_id == null) {
			
		}
		AdminReportResultDto reportContent =
				adminReportIDao.reportContent(report_id);	
		
		int feed_id = reportContent.getFeed_id();
		int feed_comment_id = reportContent.getFeed_comment_id();
		int post_id = reportContent.getPost_id();
		int post_comment_id = reportContent.getPost_comment_id();
		int message_id = reportContent.getMessage_id();
		String userId = reportContent.getReport_user_id();
		System.out.println("리포트콘텐트 유저 아이디" + userId);
		String imgPath = null;
		String writingType = null;
		String writingId = null;
		if(feed_id != 0) {
			imgPath = "feed";
			writingType ="feed";
			writingId = Integer.toString(feed_id);
		}else if(feed_comment_id != 0) {
			imgPath = "feed";
			writingType ="feed_comments";
			writingId = Integer.toString(feed_comment_id);
		}else if(post_id != 0) {
			imgPath = "community";
			writingType ="post";
			writingId = Integer.toString(post_id);
		}else if(post_comment_id != 0) {
			imgPath = "community";
			writingType ="post_comments";
			writingId = Integer.toString(post_comment_id);
		}else if(message_id != 0) {
			imgPath = "";
			writingType ="message";
			writingId = Integer.toString(message_id);
		}
		
		model.addAttribute("userId", userId);
		model.addAttribute("writingType", writingType);
		model.addAttribute("writingId", writingId);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("reportContent", reportContent);
	}
	
//	public void reportUserId(Model model) {
//		
//		Map<String, Object> map = model.asMap();
//		AdminReportResultDto reportContent =
//				(AdminReportResultDto) map.get("reportContent");
//		int feed_id = reportContent.getFeed_id();
//		int feed_comment_id = reportContent.getFeed_comment_id();
//		int post_id = reportContent.getPost_id();
//		int post_comment_id = reportContent.getPost_comment_id();
//		int message_id = reportContent.getMessage_id();
//		String userId = null;
//		if(feed_id != 0) {
//			userId = adminReportIDao.selectUserId(feed_id,1);
//		}else if(feed_comment_id != 0) {
//			userId = adminReportIDao.selectUserId(feed_comment_id,2);
//		}else if(post_id != 0) {
//			userId = adminReportIDao.selectUserId(post_id,3);
//		}else if(post_comment_id != 0) {
//			userId = adminReportIDao.selectUserId(post_comment_id,4);
//		}else if(message_id != 0) {
//			userId = adminReportIDao.selectUserId(message_id,5);
//		}
//		
//		model.addAttribute("userId", userId);
//		
//		
//	}
}
