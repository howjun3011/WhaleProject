package com.tech.whale.admin.report.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.dao.AdminReportIDao;
import com.tech.whale.admin.dto.AdminAccessDto;
import com.tech.whale.admin.dto.AdminReportResultDto;
import com.tech.whale.admin.dto.AdminUserInfoDto;
import com.tech.whale.admin.service.AdminServiceInter;

@Service
public class AdminReportResultService implements AdminServiceInter{

	@Autowired
	private AdminReportIDao adminReportIDao;
	
	
	@Override
	public void execute(Model model) {
		
		
		
	}
	
	@Transactional
	public void reportUser(Model model,
			HttpSession session) {
		
		
	}
	
	@Transactional
	public void rerusltRog(Model model,
			HttpSession session) {
		Map<String, Object> map = model.asMap();
		HttpServletRequest request =
				(HttpServletRequest) map.get("request");
		
//		String report_id = (String) request.getParameter("report_id");
//		String writingType = (String) request.getParameter("writingType");
//		String writingId = (String) request.getParameter("writingId");
		
	}

}
