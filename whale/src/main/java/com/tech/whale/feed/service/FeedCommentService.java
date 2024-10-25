package com.tech.whale.feed.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tech.whale.feed.dao.FeedDao;
import com.tech.whale.feed.dto.FeedCommentDto;
import com.tech.whale.main.models.MainDao;

@Service
public class FeedCommentService {

	@Autowired
	private FeedDao feedDao;
	
	// [ 메인 알람 기능]
    @Autowired
    private MainDao mainDao;

    public void insertComment(String feedId, String now_id, String comments) {
        feedDao.insertComments(feedId, now_id, comments);
        // [ 메인 알람 기능: 알람의 좋아요 기능이 켜져 있고 자신의 게시물이 아니라면 알람 테이블 추가 ]
        Integer commentNoti = mainDao.selectCommentsNotiFeedId(feedId);
        String feedUserId = mainDao.selectFeedUserId(feedId);
        if (commentNoti == 1 && !feedUserId.equals(now_id)) {
            mainDao.insertFeedCommentsNoti(feedId, now_id, comments);
        }
    }
    
    public void deleteComments(String postCommentsId) {
    	feedDao.deleteComments(postCommentsId);
    }
	
	public List<FeedCommentDto> getCommentsForFeed(String feedId) {
		// TODO Auto-generated method stub
		return feedDao.getComments(feedId);
	}
	
}
