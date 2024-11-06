package com.tech.whale.admin.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.tech.whale.admin.dto.AdminAdInfoDto;
import com.tech.whale.admin.dto.AdminOfficialInfoDto;
import com.tech.whale.admin.dto.AdminPFCDto;
import com.tech.whale.admin.dto.AdminReportListDto;
import com.tech.whale.admin.dto.AdminReportResultDto;
import com.tech.whale.admin.dto.AdminUserInfoDto;

@Mapper
public interface AdminReportIDao {
	
	public ArrayList<AdminReportListDto> adminReportList(
			@Param("start") int start,
			@Param("end") int end, 
			@Param("sk") String sk,
			@Param("selNum") String selNum);
	public int selectReportCnt(String sk, String selNum);
	
	public AdminReportResultDto reportContent(String report_id);
	public String selectUserId(int writingId, int writingNum);
	public void reportResult(
			@Param("report_id") int report_id, 
			@Param("target_type") String target_type, 
			@Param("target_id") String target_id, 
			@Param("myId") String myId, 
			@Param("action") String action,
			@Param("actionReason") String actionReason);
	
}
