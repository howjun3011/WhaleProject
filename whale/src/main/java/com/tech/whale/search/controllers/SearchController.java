package com.tech.whale.search.controllers;

import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SearchController {
	// [ 메인 페이지 이동 ]
    @RequestMapping("/searchHome")
	public String main(HttpSession session) {
    	return "search/searchHome";
	}
}
