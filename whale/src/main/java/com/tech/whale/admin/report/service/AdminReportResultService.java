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
	@Autowired
	private AdminIDao adminIDao;
	
	
	@Override
	@Transactional
	public void execute(Model model) {
		Map<String, Object> map = model.asMap();
		HttpServletRequest request =
				(HttpServletRequest) map.get("request");
		
		int report_id = Integer.parseInt(request.getParameter("report_id"));
		String writingType = request.getParameter("writingType");
		String writingId = request.getParameter("writingId");
		String userStatus = request.getParameter("userStatus");
		String writingStatus = request.getParameter("writingStatus");
		String myId = (String)model.getAttribute("myId");
		String statusReason = request.getParameter("statusReason");
		String userId = request.getParameter("userId");
		
		int myAdminId = adminIDao.myAdminId(myId);
		
		if(userStatus =="0") {
			userStatus="-";
		}else if(userStatus =="1") {
			userStatus="1일 정지";
		}else if(userStatus =="2") {
			userStatus="영구 정지";
		}
		
		if(writingStatus =="0") {
			writingStatus="-";
		}else if(writingStatus =="1") {
			writingStatus="1일 정지";
		}
		
		if(userStatus !="0") {
			adminReportIDao.reportResult(
					report_id,"user",userId,myAdminId,userStatus,statusReason);
		}
		if(writingStatus !="0") {
			adminReportIDao.reportResult(
					report_id,writingType,writingId,myAdminId,writingStatus,statusReason);
		}
		if(userStatus == "0" && writingStatus =="0"){
			adminReportIDao.reportResult(
					report_id,writingType,writingId,myAdminId,userStatus,statusReason);
		}
	}
	
	@Transactional
	public void userBan(Model model) {
		Map<String, Object> map = model.asMap();
		HttpServletRequest request =
				(HttpServletRequest) map.get("request");
		
		int report_id = Integer.parseInt(request.getParameter("report_id"));
		String writingType = request.getParameter("writingType");
		String writingId = request.getParameter("writingId");
		int userStatus = Integer.parseInt(request.getParameter("userStatus"));
		String myId = (String)model.getAttribute("myId");
		String statusReason = request.getParameter("statusReason");
		String userId = request.getParameter("userId");
		
		if(userStatus >= 1) {
			userStatus = 1;
		}
		
		adminIDao.userStatusModify(userId, userStatus);
		adminIDao.userStatusLog(userId, userStatus,statusReason,myId);
	}
	
	@Transactional
	public void writingDel(Model model) {
		Map<String, Object> map = model.asMap();
		HttpServletRequest request =
				(HttpServletRequest) map.get("request");
		
		int report_id = Integer.parseInt(request.getParameter("report_id"));
		String writingType = request.getParameter("writingType");
		int writingId = Integer.parseInt(request.getParameter("writingId"));
		String userStatus = request.getParameter("userStatus");
		String writingStatus = request.getParameter("writingStatus");
		String myId = (String)model.getAttribute("myId");
		String statusReason = request.getParameter("statusReason");
		String userId = request.getParameter("userId");
		
		System.out.println("글삭제 서비스 writingId: " + writingId);
		System.out.println("글삭제 서비스 writingType: " + writingType);
		String comments_del_reason = "부모글 삭제";
		
		if(writingType.equals("feed")) {
			adminIDao.feedDelLog(writingId,myId,statusReason);
			adminIDao.feedCommentsDelLog(writingId,myId,comments_del_reason);
			adminIDao.feedLikeDel(writingId);
			adminIDao.feedCommentsLikeDel(writingId);
			adminIDao.feedCommentsDel(writingId);
			adminIDao.feedDel(writingId);
		} else if(writingType.equals("feed_comments")) {
			int feed_id = adminIDao.pfIdFind(writingType,writingId);
			adminIDao.feedCommentsOneDelLog(writingId,feed_id,myId,statusReason);
			adminIDao.feedCommentsLikeOneDel(writingId);
			adminIDao.feedCommentsOneDel(writingId);
		} else if(writingType.equals("post")) {
			adminIDao.postDelLog(writingId,myId,statusReason);
			adminIDao.postCommentsDelLog(writingId,myId,comments_del_reason);
			adminIDao.postLikeDel(writingId);
			adminIDao.postCommentsLikeDel(writingId);
			adminIDao.postCommentsDel(writingId);
			adminIDao.postDel(writingId);
		} else if(writingType.equals("post_comments")) {
			int post_id = adminIDao.pfIdFind(writingType,writingId);
			adminIDao.postCommentsOneDelLog(writingId,post_id,myId,statusReason);
			adminIDao.postCommentsLikeOneDel(writingId);
			adminIDao.postCommentsOneDel(writingId);
		} else if(writingType.equals("message")) {
			
		}
		
		
	}
	

}
