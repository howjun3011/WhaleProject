package com.tech.whale.admin.service;

import java.io.File;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.dto.AdminUserInfoDto;

@Service
public class AdminUserImgDeleteService implements AdminServiceInter{

	@Autowired
	private AdminIDao adminIDao;
	
	
	@Override
	@Transactional
	public void execute(Model model) {
		
		Map<String, Object> map = model.asMap();
		HttpServletRequest request = 
				(HttpServletRequest) map.get("request");
		
		String userId = request.getParameter("userId");
		String userImgUrl = request.getParameter("userImgUrl");
		
		adminIDao.userImgDelete(userId,userImgUrl);
		
		String workPath = System.getProperty("user.dir");
        String root = workPath + "/src/main/resources/static/images/setting";
        String userImgPath = root + "/" + userImgUrl;
        File file = new File(userImgPath);
        
        if(userImgUrl.equals("pro.png")) {
        	
        }else if(userImgUrl.trim().isEmpty() || userImgUrl == null) {
        	
        }else {
        	
        	if (file.exists()) {
        		if (file.delete()) {
        			System.out.println("파일이 삭제 성공: " + userImgPath);
        		} else {
        			throw new RuntimeException("파일 삭제 실패: " + userImgPath);
        		}
        	} else {
        		throw new RuntimeException("삭제할 파일명 없음: " + userImgPath);
        	}
        }
        

	}

}
