package com.tech.whale.admin.notice.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.dao.AdminNoticeIDao;
import com.tech.whale.admin.dto.AdminNoticeListDto;
import com.tech.whale.admin.dto.AdminOfficialInfoDto;
import com.tech.whale.admin.dto.AdminPFCDto;
import com.tech.whale.admin.dto.AdminUserInfoDto;
import com.tech.whale.admin.service.AdminServiceInter;
import com.tech.whale.admin.util.AdminSearchVO;

@Service
public class AdminNoticeListService implements AdminServiceInter{
	
	@Autowired
	private AdminNoticeIDao adminNoticeIDao;
	
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
	    String notice_title = "";
	 	
		String brdTitle = request.getParameter("searchType");
		
		if (brdTitle == null || brdTitle.trim().isEmpty()) {
	        user_id = "user_id";
	        model.addAttribute("user_id", "true");
	    } else if(brdTitle != null) {
			if(brdTitle.equals("user_id")) {
				model.addAttribute("user_id", "true");
				user_id="user_id";
			}else if(brdTitle.equals("notice_title")) {
				model.addAttribute("notice_title", "true");
				notice_title="notice_title";
			}
		}
		String searchKeyword = request.getParameter("sk");
		if(searchKeyword == null || searchKeyword.trim().isEmpty()) {
			searchKeyword = "";
		}

		int total = 0;
		if(user_id.equals("user_id")) {
			total = adminNoticeIDao.selectNoticeCnt(searchKeyword,"1");
		}else if(notice_title.equals("notice_title")) {
			total = adminNoticeIDao.selectNoticeCnt(searchKeyword,"2");
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
		
		ArrayList<AdminNoticeListDto> list = null;
		if(user_id.equals("user_id")) {
			list = adminNoticeIDao.adminNoticeList(rowStart,rowEnd, searchKeyword,"1");
		}
		else if(notice_title.equals("notice_title")) {
			list = adminNoticeIDao.adminNoticeList(rowStart,rowEnd,searchKeyword,"2");
		}
		
		if(list != null) {
			for(AdminNoticeListDto val : list) {
				if(val.getNotice_group() == 0) {
					val.setNotice_name("유저");
				}else if(val.getNotice_group() == 1) {
					val.setNotice_name("관리자");
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
