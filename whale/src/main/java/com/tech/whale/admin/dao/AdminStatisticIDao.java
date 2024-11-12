package com.tech.whale.admin.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.tech.whale.admin.dto.AdminLVDataDto;
import com.tech.whale.admin.dto.AdminRRDataDto;

@Mapper
public interface AdminStatisticIDao {
	public List<AdminLVDataDto> reportStatistic1();
	public List<AdminLVDataDto> reportStatistic2();
	public List<AdminLVDataDto> reportStatistic3();
	public List<AdminLVDataDto> userStatistic1();
	
	
	public List<AdminRRDataDto> reportStatistic99();
}
