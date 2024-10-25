package com.tech.whale.main.service;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

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
		List<LikeNotiDto> LikeNotis = mainDao.getLikeNoti((String) session.getAttribute("user_id"));
		return LikeNotis;
	}
}
