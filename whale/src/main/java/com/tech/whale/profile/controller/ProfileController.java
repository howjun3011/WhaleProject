package com.tech.whale.profile.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.tech.whale.feed.dao.FeedDao;
import com.tech.whale.feed.dto.FeedDto;
import com.tech.whale.profile.dao.ProDao;
import com.tech.whale.profile.dto.ProfileDto;

@Controller
public class ProfileController {

	
	@Autowired
	private ProDao proDao;
	
	@Autowired
	private FeedDao feedDao;
	
	@RequestMapping("/profile")
	public String profile(HttpSession session) {
		return "redirect:/profileHome?u="+(String) session.getAttribute("user_id");
	}
	
	@RequestMapping("/profileHome")
	public String profileHome(HttpServletRequest request, HttpSession session, @RequestParam("u") String userId, Model model) {
		System.out.println("profile : " + userId);
		ProfileDto profile = proDao.getUserProfile(userId);
		Integer followerCount = proDao.followerCount(userId);
		int frcount = (followerCount != null) ? followerCount : 0;
		Integer followingCount = proDao.followingCount(userId);
		int fncount = (followingCount != null) ? followingCount : 0;
		String now_id = (String) session.getAttribute("user_id");
		
		List<ProfileDto> followerList = proDao.getFollowerList(userId);
		
		List<FeedDto> feedList = feedDao.getFeedsProfile(userId);
		
		model.addAttribute("now_id", now_id);
		model.addAttribute("followerList", followerList);
		model.addAttribute("frCount", frcount);
		model.addAttribute("fnCount", fncount);
		model.addAttribute("profile", profile);
		model.addAttribute("userId", userId);
		model.addAttribute("feedList", feedList);
		return "profile/profileHome";
	}
	
	@RequestMapping("/followers")
	public String followers(HttpServletRequest request, HttpSession session, @RequestParam("u") String userId, Model model) {
		
		String now_id = (String) session.getAttribute("user_id");
		List<ProfileDto> followerList = proDao.getFollowerList(userId);
		model.addAttribute("now_id", now_id);
		model.addAttribute("followerList", followerList);
		model.addAttribute("userId", userId);
		return "profile/followers";
	}
	
	@RequestMapping("/following")
	public String following(HttpServletRequest request, HttpSession session, @RequestParam("u") String userId, Model model) {
		
		String now_id = (String) session.getAttribute("user_id");
		List<ProfileDto> followingList = proDao.getFollowingList(userId);
		
		model.addAttribute("now_id", now_id);
		model.addAttribute("followingList", followingList);
		model.addAttribute("userId", userId);
		return "profile/following";
	}
	
	@RequestMapping("/DoUnfollowing")
	public String doUnfollowing(HttpServletRequest request, HttpSession session, @RequestParam("u") String userId, Model model) {
		String now_id = (String) session.getAttribute("user_id");
		System.out.println("now_id : " + now_id);
		System.out.println("userId : " + userId);
		proDao.doUnfollowing(userId, now_id);
		
		return "redirect:/profileHome?u=" + userId;
	}
	
	@RequestMapping("/DoFollowing")
	public String doFollowing(HttpServletRequest request, HttpSession session, @RequestParam("u") String userId, Model model) {
		String now_id = (String) session.getAttribute("user_id");
		proDao.doFollowing(userId, now_id);
		
		return "redirect:/profileHome?u=" + userId;
	}

	@RequestMapping("/DelFollowing")
	public String delFollowing(HttpServletRequest request, HttpSession session, @RequestParam("u") String userId, Model model) {
		String now_id = (String) session.getAttribute("user_id");
		System.out.println("now_id : " + now_id);
		System.out.println("userId : " + userId);
		proDao.doUnfollowing(userId, now_id);
		
		return "redirect:/following?u=" + now_id;
	}
	
	@RequestMapping("/DelFollower")
	public String delFollower(HttpServletRequest request, HttpSession session, @RequestParam("u") String userId, Model model) {
		String now_id = (String) session.getAttribute("user_id");
		System.out.println("now_id : " + now_id);
		System.out.println("userId : " + userId);
		proDao.doUnfollowing(now_id, userId);
		
		return "redirect:/followers?u=" + now_id;
	}
}
