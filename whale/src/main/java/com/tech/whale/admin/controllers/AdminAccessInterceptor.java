package com.tech.whale.admin.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AdminAccessInterceptor implements HandlerInterceptor{
	
	@Override
    public boolean preHandle(HttpServletRequest request,
    		HttpServletResponse response,
    		Object handler) throws Exception {
		
        HttpSession session = request.getSession();
        String accessId = (String) session.getAttribute("access_id");

        if (accessId == null || !accessId.equals("1")) {
            response.sendRedirect("/error");
            return false;
        }

        return true;
    }
	
}
