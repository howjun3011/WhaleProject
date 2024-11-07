package com.tech.whale.search.controllers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tech.whale.search.service.SearchService;
import com.tech.whale.setting.dto.UserInfoDto;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class SearchController {

	@Autowired
	private SearchService searchService;

	// [ 메인 페이지 이동 ]
    @RequestMapping("/searchHome")
	public String main(HttpSession session) {
    	return "search/searchHome";
	}
	
	// [ 유저 검색 결과 송출 ]
	@GetMapping("/search/user")
    @ResponseBody
    public Map<String, Object> commentLike(@RequestParam("keyword") String keyword) {
        Map<String, Object> result = new HashMap<>();
        try {
        	List<UserInfoDto> userList = searchService.getSearchUserService(keyword);
            result.put("success", true);
            result.put("userList", userList);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        
        return result; // JSON 형식으로 응답
    }
}
