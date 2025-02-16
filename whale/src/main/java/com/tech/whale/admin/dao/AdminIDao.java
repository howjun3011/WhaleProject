package com.tech.whale.admin.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

import com.tech.whale.admin.dto.AdminPFCDto;
import com.tech.whale.admin.dto.AdminUserInfoDto;

@Mapper
public interface AdminIDao {
   
   public int selectUserCnt(String sk, String selNum);
   public ArrayList<AdminUserInfoDto> adminUserList(
         int start, int end, String sk, String selNum);
   public AdminUserInfoDto userAccountInfoSelect(String userId);
   
   public ArrayList<AdminPFCDto> userAccountFeedSelect(
         int start, int end, String userId);
   public ArrayList<AdminPFCDto> userAccountPostSelect(
         int start, int end, String userId);
   public ArrayList<AdminPFCDto> userAccountCommentsSelect(
         int start, int end, String userId);
   
   public int selectPostCnt(String userId);
   public int selectFeedCnt(String userId);
   public int selectCommentsCnt(String userId);
   
}
