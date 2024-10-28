package com.tech.whale.main.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.tech.whale.main.models.ComNotiDto;
import com.tech.whale.main.models.LikeNotiDto;
import com.tech.whale.main.models.MainDao;
import com.tech.whale.setting.dao.SettingDao;
import com.tech.whale.setting.dto.PageAccessDto;
import com.tech.whale.setting.dto.StartpageDto;
import com.tech.whale.setting.dto.UserInfoDto;
import com.tech.whale.setting.dto.UserNotificationDto;

@Service
public class MainService {
	private MainDao mainDao;
	private SettingDao settingDao;
	
	public MainService(MainDao mainDao, SettingDao settingDao) {
		this.mainDao = mainDao;
		this.settingDao = settingDao;
	}
	
	// [ 유저 정보 설정 서비스 ]
	public String[] userInfoMainService(HttpSession session) {
		UserInfoDto userInfoDto = settingDao.getProfile((String) session.getAttribute("user_id"));
		return new String[] {userInfoDto.getUser_nickname(),"static/images/setting/"+userInfoDto.getUser_image_url()};
	}
	
	// [ 시작 페이지 설정 서비스 ]
	public String[] checkStartPageMain(HttpSession session) {
		StartpageDto startpageDto = settingDao.getStartpageSetting((String) session.getAttribute("user_id"));
		return new String[] {searchStartPageMain(startpageDto,1),searchStartPageMain(startpageDto,2)};
	}
	private String searchStartPageMain(StartpageDto startpageDto, int x) {
		if (startpageDto.getStartpage_music_setting() == x) {return "streaming";}
		else if (startpageDto.getStartpage_feed_setting() == x) {return "feedHome";}
		else if (startpageDto.getStartpage_community_setting() == x) {return "communityHome";}
		else if (startpageDto.getStartpage_message_setting() == x) {return "message/home";}
		else {return "Error";}
	}
	
	// [ 페이지 접근 설정 서비스 ]
	public PageAccessDto checkPageAccessMain(HttpSession session) {
		PageAccessDto pageAccessDto = settingDao.getPageAccessSetting((String) session.getAttribute("user_id"));
		return pageAccessDto;
	}
	
	// [ 좋아요 알림 서비스 ]
	public List<LikeNotiDto> getLikeNotiMainService(HttpSession session) {
		List<LikeNotiDto> likeNotis = mainDao.getLikeNoti((String) session.getAttribute("user_id"));
		return likeNotis;
	}
	
	// [ 댓글 알림 서비스 ]
	public List<ComNotiDto> getCommentsNotiMainService(HttpSession session) {
		List<ComNotiDto> commentsNotis = mainDao.getCommentsNoti((String) session.getAttribute("user_id"));
		return commentsNotis;
	}
	
	// [ 좋아요 알림 읽음 처리 ]
	public void updateLikeNotiMainService(String likeNotiId) {
		mainDao.updateLikeNoti(likeNotiId);
	}
	
	// [ 댓글 알림 읽음 처리 ]
	public void updateCommentsNotiMainService(String commentsNotiId) {
		mainDao.updateCommentsNoti(commentsNotiId);
	}
	
	// [ 좋아요 알림 삭제 처리 ]
	public void deleteLikeNotiMainService(String likeNotiId) {
		mainDao.deleteLikeNoti(likeNotiId);
	}
	
	// [ 댓글 알림 삭제 처리 ]
	public void deleteCommentsNotiMainService(String commentsNotiId) {
		mainDao.deleteCommentsNoti(commentsNotiId);
	}
}
