package com.tech.whale.search.controllers;

import javax.servlet.http.HttpSession;

import com.tech.whale.setting.dto.UserInfoDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tech.whale.search.models.SearchDao;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class SearchController {

	@Autowired
	private SearchDao searchDao;

	// [ 메인 페이지 이동 ]
    @RequestMapping("/searchHome")
	public String main(HttpSession session) {
    	return "search/searchHome";
	}

	// [ 검색 결과 페이지 이동 ]
	@RequestMapping("/searchResult")
	public String searchResult(@RequestParam("keyword") String keyword, Model model) {
		// 검색 로직 추가 (예: 데이터베이스에서 검색)
		List<UserInfoDto> userList = searchDao.selectSearchUserInfo(keyword);
		model.addAttribute("userList", userList);
		model.addAttribute("keyword", keyword);
		return "search/searchResult";
	}
}
