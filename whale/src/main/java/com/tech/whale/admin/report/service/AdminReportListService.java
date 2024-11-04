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
	
	
}
