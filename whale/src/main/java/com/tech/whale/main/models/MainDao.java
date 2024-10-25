package com.tech.whale.main.models;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MainDao {
	public void insertPostLikeNoti(String postId, String userId);
	public Integer selectLikeNoti(String postId);
	public String selectPostUserId(String postId);
	public List<LikeNotiDto> getLikeNoti(String userId);
	public void insertPostCommentsNoti(String postId, String userId, String commentText);
	public Integer selectCommentNoti(String postId);
}
