package com.tech.whale.admin.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.dto.AdminAccessDto;
import com.tech.whale.admin.dto.AdminUserInfoDto;

@Service
public class AdminAccountUserModifyService implements AdminServiceInter{

	@Autowired
	private AdminIDao adminIDao;
	
	
	@Override
	public void execute(Model model) {
		
		Map<String, Object> map = model.asMap();
		HttpServletRequest request = 
				(HttpServletRequest) map.get("request");
		String userId = request.getParameter("userId");
		
		AdminUserInfoDto dto = adminIDao.userAccountInfoSelect(userId);
		
		
		
		model.addAttribute("AccountUserInfo", dto);
		
	}
	
	public void modifyAccess(Model model) {
		Map<String, Object> map = model.asMap();
		HttpServletRequest request =
				(HttpServletRequest) map.get("reqeust");
		String userId = request.getParameter("userId");
		String companyName = request.getParameter("companyName");
		int userAccess = Integer.parseInt(request.getParameter("userAccess"));
		int userAccessNow = Integer.parseInt(request.getParameter("userAccessNow"));
		
		
		String accessOfficial = "";
		String accessAdvertiser = "";
		String accessAdmin = "";
		String accessUser = "";
		
		//권한이 이미 있으면 기존 info 삭제
//		if(userAccessNow ==1) {
//			adminIDao.userAccessDrop(userId, userAccessNow);
//		}else if(userAccessNow ==2){
//			//광고글삭제
//			adminIDao.userAccessDrop(userId, userAccessNow);
//		}else if(userAccessNow ==3){
//			adminIDao.userAccessDrop(userId, userAccessNow);
//		}
		
		
		//권한변경
		//유저인포, 관리테이블, 로그
		if(userAccess==3) {
			adminIDao.userInfoAccessModify(userId, userAccess);
			adminIDao.officialInfoAdd(userId,companyName);
			
			adminIDao.userAccessLog(userId, accessOfficial);
		}else if(userAccess==2) {
			accessAdvertiser = "advertiser";
			adminIDao.userInfoAccessModify(userId, userAccess);
			adminIDao.userAccessLog(userId, accessAdvertiser);
		}else if(userAccess==1) {
			accessAdmin = "admin";
			adminIDao.userInfoAccessModify(userId, userAccess);
			adminIDao.userAccessLog(userId, accessAdmin);
		}else if(userAccess==0) {
			accessUser = "user";
			adminIDao.userAccessModifyUser(userId, userAccess);
			adminIDao.userAccessLog(userId, accessAdmin);
		}
		
	}

}
