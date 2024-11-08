package com.tech.whale.admin.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.dto.AdminMainCntDto;

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
	
}
