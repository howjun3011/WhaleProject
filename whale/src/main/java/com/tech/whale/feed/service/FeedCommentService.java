package com.tech.whale.feed.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tech.whale.feed.dao.FeedDao;
import com.tech.whale.feed.dto.FeedCommentDto;

@Service
public class FeedCommentService {

	@Autowired
	private FeedDao feedDao;

    public void insertComment(String feedId, String now_id, String comments) {
        feedDao.insertComments(feedId, now_id, comments);
    }
    
    public void deleteComments(String postCommentsId) {
    	feedDao.deleteComments(postCommentsId);
    }
	
	public List<FeedCommentDto> getCommentsForFeed(String feedId) {
		// TODO Auto-generated method stub
		return feedDao.getComments(feedId);
	}
	
}
