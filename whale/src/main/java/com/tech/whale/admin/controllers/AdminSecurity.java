package com.tech.whale.admin.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class AdminSecurity implements WebMvcConfigurer{
	
	@Autowired
    private AdminAccessInterceptor adminInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        
        registry.addInterceptor(adminInterceptor)
                .addPathPatterns("/admin/**");
    }
}
