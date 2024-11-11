package com.tech.whale.admin.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.tech.whale.admin.dto.AdminUserDataDto;

@Mapper
public interface AdminStatisticIDao {
	public List<AdminUserDataDto> reportStatistic();
	
}
