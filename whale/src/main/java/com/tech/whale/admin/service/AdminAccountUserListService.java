package com.tech.whale.admin.service;

import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.dto.AdminUserInfoDto;
import com.tech.whale.admin.util.AdminSearchVO;

@Service
public class AdminAccountUserListService implements AdminServiceInter{
	
	@Autowired
	private AdminIDao adminIDao;
	
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
	    String user_email = "";
	 	
		//search
		String[] brdTitle = request.getParameterValues("searchType");
		
		if (brdTitle == null) {
	        user_id = "user_id";
	        model.addAttribute("user_id", "true");
	    } else if(brdTitle != null) {
			for (String val : brdTitle) {
				if(val.equals("user_id")) {
					model.addAttribute("user_id", "true");
					user_id="user_id";
				}else if(val.equals("user_email")) {
					model.addAttribute("user_email", "true");
					user_email="user_email";
				}
			}
		}
		String searchKeyword = request.getParameter("sk");
		if(searchKeyword == null || searchKeyword.isEmpty()) {
			searchKeyword = "";
		}

		
		//------------ 검색후에 조건들-------------
		int total = 0;
		if(user_id.equals("user_id")) {
			total = adminIDao.selectUserCnt(searchKeyword,"1");
		}else if(user_email.equals("user_email")) {
			total = adminIDao.selectUserCnt(searchKeyword,"2");
		}
		
		String strPage = request.getParameter("page");
		
	 // null검사
 		if(strPage == null || strPage.isEmpty()) {
 			strPage="1";
 		}
		
		int page = Integer.parseInt(strPage);
		searchVO.setPage(page);
		
		//글의 총갯수
		searchVO.pageCalculate(total);
		
		int rowStart = searchVO.getRowStart();
		int rowEnd = searchVO.getRowEnd();
		
		ArrayList<AdminUserInfoDto> list = null;
		if(user_id.equals("user_id")) {
			list = adminIDao.adminUserList(rowStart,rowEnd, searchKeyword,"1");
		}else if(user_email.equals("user_email")) {
			list = adminIDao.adminUserList(rowStart,rowEnd,searchKeyword,"2");
		}
		

		
		model.addAttribute("list", list);
		model.addAttribute("ultotRowcnt", total);
		model.addAttribute("ulsearchVO", searchVO);
		
		
	}
	
}
