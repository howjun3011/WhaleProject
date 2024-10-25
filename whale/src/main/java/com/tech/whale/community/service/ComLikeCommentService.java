package com.tech.whale.community.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tech.whale.community.dao.ComDao;
import com.tech.whale.community.dto.CommentDto;
import com.tech.whale.main.models.MainDao;

@Service
public class ComLikeCommentService {

    @Autowired
    private ComDao comDao;
    
    // [ 메인 알람 기능]
    @Autowired
    private MainDao mainDao;

    public int toggleLike(String postId, String userId) {
        // 사용자가 이미 좋아요를 눌렀는지 확인
        int userLiked = comDao.checkUserLikedPost(postId, userId);
        
        if (userLiked > 0) {
            // 이미 좋아요를 눌렀다면 좋아요 취소
            comDao.deleteLike(postId, userId);
        } else {
            // 좋아요를 누르지 않았다면 좋아요 추가
            comDao.insertLike(postId, userId);
            // [ 메인 알람 기능: 알람의 좋아요 기능이 켜져 있고 자신의 게시물이 아니라면 알람 테이블 추가 ]
            Integer likeNoti = mainDao.selectLikeNoti(postId);
            String postUserId = mainDao.selectPostUserId(postId);
            if (likeNoti == 1 && !postUserId.equals(userId)) {
                mainDao.insertPostLikeNoti(postId, userId);
            }
        }

        // 최종적으로 게시글의 최신 좋아요 수를 반환
        return comDao.getLikeCount(postId);
    }
    
    // 코멘트 삽입 메소드
    public void insertComment(String postId, String userId, String commentText) {
        comDao.insertComments(postId, userId, commentText);
        // [ 메인 알람 기능: 알람의 좋아요 기능이 켜져 있고 자신의 게시물이 아니라면 알람 테이블 추가 ]
        Integer commentNoti = mainDao.selectCommentNoti(postId);
        String postUserId = mainDao.selectPostUserId(postId);
        if (commentNoti == 1 && !postUserId.equals(userId)) {
            mainDao.insertPostCommentsNoti(postId, userId, commentText);
        }
    }
    
    public void deleteComments(String postCommentsId) {
    	comDao.deleteComments(postCommentsId);
    }

    // 게시글에 달린 코멘트 리스트 조회
    public List<CommentDto> getCommentsForPost(String postId) {
        return comDao.getComments(postId);
    }
}