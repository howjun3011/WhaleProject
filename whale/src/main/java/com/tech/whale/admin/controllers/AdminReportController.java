package com.tech.whale.admin.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tech.whale.admin.dao.AdminIDao;



@Controller
@RequestMapping("/admin/report")
public class AdminReportController {
	
//	@Autowired
//	private AdminServiceInter adService;
	@Autowired
	private AdminIDao AdminIDao;

	
	
}
