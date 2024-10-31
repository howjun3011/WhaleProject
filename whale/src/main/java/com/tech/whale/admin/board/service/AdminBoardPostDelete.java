package com.tech.whale.admin.board.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.tech.whale.admin.dao.AdminIDao;
import com.tech.whale.admin.dto.AdminAccessDto;
import com.tech.whale.admin.dto.AdminUserInfoDto;
import com.tech.whale.admin.service.AdminServiceInter;

@Service
public class AdminBoardPostDelete implements AdminServiceInter{

	@Autowired
	private AdminIDao adminIDao;
	
	
	@Override
	@Transactional
	public void execute(Model model) {
		
		Map<String, Object> map = model.asMap();
		HttpServletRequest request = 
				(HttpServletRequest) map.get("request");
		
		int post_id = Integer.parseInt(request.getParameter("postId"));
		String user_id = (String)model.getAttribute("user_id");
		String post_del_reason = "게시판 규칙 위반";
		String comments_del_reason = "부모게시글 삭제";
		
		adminIDao.postDelLog(post_id,user_id,post_del_reason);
		adminIDao.postCommentsDelLog(post_id,user_id,comments_del_reason);
		adminIDao.postLikeDel(post_id);
		adminIDao.CommentsLikeDel(post_id);
		adminIDao.postCommentsDel(post_id);
		adminIDao.postDel(post_id);
		
		System.out.println("유저 아이디 : "+user_id);
		
		
	}
	
	@Transactional
	public void modifyAccess(Model model,
			HttpSession session) {
		Map<String, Object> map = model.asMap();
		HttpServletRequest request =
				(HttpServletRequest) map.get("request");
		String userId = request.getParameter("userId");
		String companyName = request.getParameter("companyName");
		String accessReason = request.getParameter("accessReason");
		int userAccess = Integer.parseInt(request.getParameter("userAccess"));
		int userAccessNow = Integer.parseInt(request.getParameter("userAccessNow"));
		
		String adminId = (String) session.getAttribute("user_id");
		
		if(userAccessNow == 0) {
			if(userAccess!= 0) {
				adminIDao.userInfoAccessModify(userId, userAccess);
				adminIDao.accessInfoAdd(userId, userAccess, companyName);
				adminIDao.userAccessLog(userId, userAccess,accessReason,adminId);
				model.addAttribute("권한설정 완료", "accessMsg");
			}
		}else {
			adminIDao.userAccessDrop(userId, userAccessNow);
			adminIDao.userInfoAccessModify(userId, userAccess);
			adminIDao.userAccessLog(userId, userAccess,accessReason,adminId);
			if(userAccess!= 0) {
				adminIDao.accessInfoAdd(userId, userAccess, companyName);
			}
			model.addAttribute("권한설정 완료", "accessMsg");
		}
		
		
		
	}
	
	
	@Transactional
	public void modifyStatus(Model model,
			HttpSession session) {
		Map<String, Object> map = model.asMap();
		HttpServletRequest request =
				(HttpServletRequest) map.get("request");
		String userId = request.getParameter("userId");
		String statusReason = request.getParameter("statusReason");
		int userStatus = Integer.parseInt(request.getParameter("userStatus"));
		String adminId = (String) session.getAttribute("user_id");
		adminIDao.userStatusModify(userId, userStatus);
		adminIDao.userStatusLog(userId, userStatus,statusReason,adminId);
		
	}

}
