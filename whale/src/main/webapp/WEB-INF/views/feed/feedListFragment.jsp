<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 새로 로드된 피드들을 보여주는 JSP 조각 -->
<c:forEach var="feed" items="${feedList}">
    <div class="post">
        <div class="user-info">
            <a href="profileHome?u=${feed.user_id}"><img src="static/images/setting/${feed.user_image_url}" alt="User Profile" class="profile-pic"></a>
            <span class="username">${feed.user_id}</span>
        </div>

        <!-- 이미지가 존재할 때만 출력 -->
        <c:if test="${not empty feed.feed_img_name}">
            <img src="static/images/feed/${feed.feed_img_name}" alt="Post Image" class="post-image">
        </c:if>

        <div class="post-text">
            <p>${feed.feed_text}</p>
            <span class="post-time">${feed.feed_date}</span>
        </div>
        <div class="post-actions">
            <span class="likes">❤ ${feed.likeCount}</span>
            <span class="comments">💬 ${feed.feedComments.size()}</span>
        </div>
    </div>
</c:forEach>