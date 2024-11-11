package com.tech.whale.admin.service;

import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.dto.AdminMainCntDto;
import com.tech.whale.admin.dto.AdminMemoDto;

@Service
public class AdminMainPageService implements AdminServiceInter{

	@Autowired
	private AdminIDao adminIDao;
	
	
	@Override
	public void execute(Model model) {
		int report_null = adminIDao.reportCnt();
		int report_result_today = adminIDao.reportResultCnt();
		int writing_today = adminIDao.writingCnt();
		ArrayList<AdminMainCntDto> mainNotice = adminIDao.mainNotice();
		
		
		model.addAttribute("mainNotice", mainNotice);
		model.addAttribute("writing_today", writing_today);
		model.addAttribute("report_null", report_null);
		model.addAttribute("report_result_today", report_result_today);
	}
	
	@Transactional
	public void adminMemo(Model model) {
		String myId = (String)model.getAttribute("myId");
		
		int memoCheck = adminIDao.memoCheck(myId);
		if(memoCheck < 1) {
			adminIDao.memoCreate(myId);
		}
		AdminMemoDto admin_Memo = adminIDao.adminMemo(myId);
		if(admin_Memo.getMemo_writing() == null || admin_Memo.getMemo_writing().trim().isEmpty()) {
			admin_Memo.setMemo_writing("메모입력");
		}
		
		model.addAttribute("admin_Memo", admin_Memo);
	}
	
	@Transactional
	public void memoUpdate(Model model) {
		Map<String, Object> map = model.asMap();
		HttpServletRequest request =
				(HttpServletRequest) map.get("request");
		String memoUpdateStr = (String)request.getParameter("admin_Memo");
		String myId = (String)model.getAttribute("myId");
		
		System.out.println("메모서비스 memoUpdateStr : "+memoUpdateStr);
		System.out.println("메모서비스 myId : " + myId);
		System.out.println("메모서비스 마이바티스 전");
		System.out.println("메모서비스 마이바티스 전");
		System.out.println("메모서비스 마이바티스 전");
		adminIDao.memoUpdate(memoUpdateStr,myId);
		System.out.println("메모 서비스 끝");
	}
	
}
