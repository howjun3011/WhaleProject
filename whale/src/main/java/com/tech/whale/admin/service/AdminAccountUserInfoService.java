package com.tech.whale.admin.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.dto.AdminUserInfoDto;

@Service
public class AdminAccountUserInfoService implements AdminServiceInter{

	@Autowired
	private AdminIDao adminIDao;
	
	
	@Override
	public void execute(Model model) {
		
		Map<String, Object> map = model.asMap();
		HttpServletRequest request = 
				(HttpServletRequest) map.get("request");
		String userId = request.getParameter("userId");
		
		AdminUserInfoDto dto = adminIDao.userAccountInfoSelect(userId);
		
		// 추후에 access_id를 언어로 바꾸는 class파일 만들어야함?
		if(dto.getUser_access_id() == 0) {
			dto.setUser_access_str("일반유저");
		}else if(dto.getUser_access_id() == 1) {
			dto.setUser_access_str("관리자");
		}
		
		model.addAttribute("AccountUserInfo", dto);
		
	}

}
