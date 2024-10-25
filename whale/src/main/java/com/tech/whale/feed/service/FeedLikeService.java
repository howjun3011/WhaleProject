package com.tech.whale.feed.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tech.whale.feed.dao.FeedDao;

@Service
public class FeedLikeService {

	@Autowired
	private FeedDao feedDao;
	
	public int toggleLike(String feedId, String now_id) {
		// TODO Auto-generated method stub
		
		int userLiked = feedDao.checkUserLikedFeed(feedId, now_id);
		
        if (userLiked > 0) {
            // 이미 좋아요를 눌렀다면 좋아요 취소
            feedDao.deleteLike(feedId, now_id);
        } else {
            // 좋아요를 누르지 않았다면 좋아요 추가
            feedDao.insertLike(feedId, now_id);
        }

        // 최종적으로 게시글의 최신 좋아요 수를 반환
        return feedDao.getLikeCount(feedId);
	}

}
