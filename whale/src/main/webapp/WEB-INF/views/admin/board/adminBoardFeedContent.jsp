<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="content" name="content" id="content">
<div class="post" data-post-id="${feedDetail.feed_id}" data-user-id="${feedDetail.user_id}">
    <div class="user-info">
        <a href="adminAccountUserInfo?userId=${feedDetail.user_id}">
            <img src="/whale/static/images/setting/${feedDetail.user_image_url}" alt="User Profile" class="profile-pic">
        </a>
        <span class="username">${feedDetail.user_id}</span>
    </div>

    <button class="other-btn">
        삭제
    </button>

    <!-- 이미지가 존재할 때만 출력 -->
    <c:if test="${not empty feedDetail.feed_img_name}">
        <img src="/whale/static/images/feed/${feedDetail.feed_img_name}" alt="Post Image" class="post-image">
    </c:if>

    <div class="post-text">
        <p>${feedDetail.feed_text}</p>
        <span class="post-time">${feedDetail.feed_date}</span>
    </div>

    <div class="post-actions">
        <button type="button" class="like-btn" data-feed-id="${feedDetail.feed_id}" data-now-id="${now_id}">
            <img class="likebtn" src="/whale/static/images/btn/like_btn.png" alt="like" />
            <span class="like-count">${feedDetail.likeCount}</span>
        </button>
        <div class="comments">
            <img class="commentbtn" src="/whale/static/images/btn/comment_btn.png" alt="comments" />
            <span class="comment-count">${feedDetail.commentsCount}</span>
           </div>
       </div>
   </div>

<div class="comments-section">
    <c:forEach var="comment" items="${feedDetail.feedComments}">
     <div class="comment" data-feed-id="${comment.feed_id}" data-comment-id="${comment.feed_comments_id}" data-user-id="${comment.user_id}">
         <!-- 댓글 헤더 -->
         <div class="comment-header">
             <!-- 프로필 사진 -->
             <a href="adminAccountUserInfo?userId=${comment.user_id}">
                 <img src="/whale/static/images/setting/${comment.user_image_url}" alt="User Profile" class="profile-pic">
             </a>
             <!-- 아이디와 날짜 -->
             <div class="comment-meta">
                 <span class="username">${comment.user_id}</span>
                 <span class="comment-date">${comment.feed_comments_date}</span>
             </div>
             <!-- other_btn -->
             <button class="comment-other-btn">
                 삭제
             </button>
         </div>
         <!-- 댓글 내용 -->
         <p class="comment-text">${comment.feed_comments_text}</p>
         <!-- 좋아요 및 답글 아이콘 -->
         <div class="comment-actions">
             <button type="button" class="comment-like-btn" data-comment-id="${comment.feed_comments_id}" data-now-id="${now_id}">
                 <img class="likebtn" src="/whale/static/images/btn/like_btn.png" alt="like" />
                 <span class="comment-like-count">${comment.likeCount}</span>
             </button>
             <button type="button" class="reply-btn" >
                 <img class="commentbtn" src="/whale/static/images/btn/comment_btn.png" alt="답글" />
                 <span class="comment-reply-count">${comment.replyCount}</span>
             </button>
         </div>
         <!-- 답글 표시 -->
         <c:if test="${not empty comment.replies}">
             <div class="replies">
                 <c:forEach var="reply" items="${comment.replies}">
                     <div class="reply" data-feed-id="${reply.feed_id}" data-comment-id="${reply.feed_comments_id}" data-user-id="${reply.user_id}">
                         <!-- 답글 헤더 -->
                         <div class="comment-header">
                             <!-- 프로필 사진 -->
                             <a href="adminAccountUserInfo?userId=${reply.user_id}">
                                 <img src="/whale/static/images/setting/${reply.user_image_url}" alt="User Profile" class="profile-pic">
                             </a>
                             <!-- 아이디와 날짜 -->
                             <div class="comment-meta">
                                 <span class="username">${reply.user_id}</span>
                                 <span class="comment-date">${reply.feed_comments_date}</span>
                             </div>
                             <!-- other_btn -->
                             <button class="comment-other-btn">
                                 삭제
                             </button>
                         </div>
                         <!-- 답글 내용 -->
                         <p class="comment-text">${reply.feed_comments_text}</p>
                         <!-- 좋아요 아이콘 -->
                         <div class="comment-actions">
                             <button type="button" class="comment-like-btn" data-comment-id="${reply.feed_comments_id}" data-now-id="${now_id}">
                                 <img class="likebtn" src="/whale/static/images/btn/like_btn.png" alt="like" />
                                 <span class="comment-like-count">${reply.likeCount}</span>
                             </button>
                         </div>
                     </div>
                 </c:forEach>
             </div>
         </c:if>
         
     </div>
 </c:forEach>
</div>

<div id="otherModal" class="modal">
    <div class="modal-content">
        <div id="deleteItem" class="modal-item red" style="display: none;">삭제</div>
     <div id="hidePostItem" class="modal-item" style="display: none;">게시글 숨기기</div>
     <div id="reportItem" class="modal-item red" style="display: none;">신고</div>
     <div class="modal-item gray" onclick="closeOtherModal()">취소</div>
    </div>
</div>
<br />
<br />
<br />
</div>

<script type="text/javascript">

 let selectedItemId = null;
 let selectedItemFeedId = null;
 let selectedItemType = null; // 'post', 'comment', 'reply'
 let isOwner = false;

 /* function openOtherModal(itemId, itemFeedId, itemOwnerId, currentUserId, itemType) {
     selectedItemId = itemId;
     selectedItemFeedId = itemFeedId;
     selectedItemType = itemType;
     isOwner = (itemOwnerId === currentUserId);

     // 모든 모달 아이템을 초기화
     document.getElementById("deleteItem").style.display = "none";
     document.getElementById("hidePostItem").style.display = "none";
     document.getElementById("reportItem").style.display = "none";

     if (itemType === 'post') {
         if (isOwner) {
             document.getElementById("deleteItem").style.display = "block";
             document.getElementById("hidePostItem").style.display = "block";
         } else {
             document.getElementById("reportItem").style.display = "block";
         }
     } else if (itemType === 'comment' || itemType === 'reply') {
         if (isOwner) {
             document.getElementById("deleteItem").style.display = "block";
         } else {
             document.getElementById("reportItem").style.display = "block";
         }
     }

     document.getElementById("otherModal").style.display = "flex";
 } */

    
    /* function toggleReplyForm(commentId) {
        const replyForm = document.getElementById(`reply-form-\${commentId}`);
        if (replyForm.style.display === 'none' || replyForm.style.display === '') {
            replyForm.style.display = 'block';
        } else {
            replyForm.style.display = 'none';
        }
    } */
</script>
