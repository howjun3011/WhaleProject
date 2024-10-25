package com.tech.whale.main.models;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MainDao {
	public Integer selectLikeNotiPostId(String postId);
	public Integer selectLikeNotiFeedId(String feedId);
	public Integer selectCommentsNotiPostId(String postId);
	public Integer selectCommentsNotiFeedId(String feedId);
	public String selectPostUserId(String postId);
	public String selectFeedUserId(String feedId);
	public List<LikeNotiDto> getLikeNoti(String userId);
	public List<ComNotiDto> getCommentsNoti(String userId);
	public void insertPostLikeNoti(String postId, String userId);
	public void insertFeedLikeNoti(String feedId, String userId);
	public void insertPostCommentsNoti(String postId, String userId, String commentText);
	public void insertFeedCommentsNoti(String feedId, String userId, String commentText);
}
