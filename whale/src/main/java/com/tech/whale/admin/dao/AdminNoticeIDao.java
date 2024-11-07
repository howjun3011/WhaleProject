package com.tech.whale.admin.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.tech.whale.admin.dto.AdminAdInfoDto;
import com.tech.whale.admin.dto.AdminNoticeListDto;
import com.tech.whale.admin.dto.AdminOfficialInfoDto;
import com.tech.whale.admin.dto.AdminPFCDto;
import com.tech.whale.admin.dto.AdminReportListDto;
import com.tech.whale.admin.dto.AdminReportResultDto;
import com.tech.whale.admin.dto.AdminUserInfoDto;

@Mapper
public interface AdminNoticeIDao {
	
	public ArrayList<AdminNoticeListDto> adminNoticeList(
			@Param("start") int start,
			@Param("end") int end, 
			@Param("sk") String sk,
			@Param("selNum") String selNum);
	public int selectNoticeCnt(String sk, String selNum);
	
}
