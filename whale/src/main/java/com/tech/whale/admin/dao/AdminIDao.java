package com.tech.whale.admin.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.tech.whale.admin.dto.AdminAdInfoDto;
import com.tech.whale.admin.dto.AdminOfficialInfoDto;
import com.tech.whale.admin.dto.AdminPFCDto;
import com.tech.whale.admin.dto.AdminUserInfoDto;

@Mapper
public interface AdminIDao {
	
	public int selectUserCnt(String sk, String selNum);
	public int selectAdvertiserCnt(String sk, String selNum);
	public int selectOfficialCnt(String sk, String selNum);
	public ArrayList<AdminUserInfoDto> adminUserList(
			int start, int end, String sk, String selNum);
	public ArrayList<AdminOfficialInfoDto> adminOfficialList(
			int start, int end, String sk, String selNum);
	public ArrayList<AdminAdInfoDto> adminAdvertiserList(
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
	
	public void userNicknameModyfy(String userId, String userNickname);
	public void userImgDelete(String userId, String userImgUrl);
	
	public void userInfoAccessModify(String userId, int userAccess);
	public void accessInfoAdd(
			String userId, int userAccess, String companyName);
	public void userAccessLog(
			String userId, int userAccess, String accessReason, String adminId);
	public void userAccessDrop(String userId, int userAccessNow);
	
	public void userStatusModify(String userId, int userStatus);
	public void userStatusLog(
			String userId, int userStatus, String statusReason, String adminId);
	/////////////////////////////////////////////
	public ArrayList<AdminPFCDto> adminBoardList(
			@Param("start") int start,
			@Param("end") int end, 
			@Param("sk") String sk,
			@Param("selNum") String selNum);
	public int selectBoardCnt(String sk, String selNum);
	
	public ArrayList<AdminPFCDto> adminBoardCommentsList(
			@Param("start") int start,
			@Param("end") int end, 
			@Param("sk") String sk,
			@Param("selNum") String selNum);
	public int selectBoardCommentsCnt(String sk, String selNum);
	
	public void postDelLog(
			@Param("post_id") int post_id,
			@Param("user_id") String user_id,
			@Param("del_reason") String del_reason);
	public void postCommentsDelLog(
			@Param("post_id") int post_id,
			@Param("user_id") String user_id,
			@Param("comments_del_reason") String comments_del_reason);
	public void postDel(int post_id);
	public void postLikeDel(int post_id);
	public void postCommentsLikeDel(int post_id);
	public void postCommentsDel(int post_id);
	
	public void feedDelLog(
			@Param("feed_id") int feed_id,
			@Param("user_id") String user_id,
			@Param("del_reason") String del_reason);
	public void feedCommentsDelLog(
			@Param("feed_id") int feed_id,
			@Param("user_id") String user_id,
			@Param("comments_del_reason") String comments_del_reason);
	public void feedDel(int feed_id);
	public void feedLikeDel(int feed_id);
	public void feedCommentsLikeDel(int feed_id);
	public void feedCommentsDel(int feed_id);
	public void feedCommentsOneDelLog(
			@Param("feed_comments_id") int feed_comments_id,
			@Param("feed_id") int feed_id,
			@Param("user_id") String user_id,
			@Param("comments_del_reason") String comments_del_reason);
	public void feedCommentsLikeOneDel(int feed_comments_id);
	public void feedCommentsOneDel(int feed_comments_id);
	public void postCommentsOneDelLog(
			@Param("post_comments_id") int post_comments_id,
			@Param("post_id") int post_id,
			@Param("user_id") String user_id,
			@Param("comments_del_reason") String comments_del_reason);
	public void postCommentsParentDelLog(
			@Param("post_comments_id") int post_comments_id,
			@Param("post_id") int post_id,
			@Param("user_id") String user_id,
			@Param("comments_del_reason") String comments_del_reason);
	public void postCommentsLikeOneDel(int post_comments_id);
	public void postCommentsOneDel(int post_comments_id);
	public String comName(String postId);
	public int pfIdFind(
			@Param("type") String type, 
			@Param("commentId") int commentId);
	public int myAdminId(String myId);
	
	public void postCommentsParentDel(int post_comments_id);
	public void postCommentsLikeParentDel(int post_comments_id);
	
	
}
