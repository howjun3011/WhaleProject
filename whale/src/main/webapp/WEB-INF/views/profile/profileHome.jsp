<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Profile</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;600&display=swap">
<style>
    body {
        font-family: 'Noto Sans', sans-serif;
        margin: 0;
        padding: 0;
        background-color: #fafafa;
        color: #333;
    }

    .container {
        width: 100%;
        max-width: 650px;
        margin: 0 auto;
        padding: 20px;
        background-color: #fff;
        border: 1px solid #dbdbdb;
    }

    /* 프로필 상단 */
    .profile-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding-bottom: 20px;
        border-bottom: 1px solid #dbdbdb;
    }

    .profile-info {
        display: flex;
        align-items: center;
    }

    .profile-image {
        border-radius: 50%;
        width: 100px;
        height: 100px;
        margin-right: 20px;
        background-color: #eee;
    }

    .details {
        display: flex;
        flex-direction: column;
    }

    /* Username and lock button container */
    .username-container {
        display: flex;
        align-items: center;
    }

    .lockbtn {
        width: 30px;
        height: 30px;
        border: none;
        background: none;
        margin-right: 5px;
    }

    .username {
        font-size: 20px;
        font-weight: bold;
        color: #333;
    }

    .stats {
        display: flex;
        gap: 20px;
        font-size: 16px;
        color: #777;
        margin-top: 5px;
    }

    .stats div span {
        font-weight: bold;
        color: #333;
    }

    /* User ID below image */
    .profile-info .user-id {
        font-size: 14px;
        color: #aaa;
        text-align: center;
        margin-top: 5px;
    }

    /* 프로필 버튼 */
    .profile-actions {
        display: flex;
        align-items: center;
        gap: 10px;
        flex-direction: column;
    }

    .profile-actions button {
        padding: 6px 12px;
        background-color: #0095f6;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        transition: background-color 0.3s ease;
        margin-bottom: 8px;
        width: 100px;
    }

    .profile-actions button:hover {
        background-color: #007ac1;
    }

    /* Message button */
    .profile-actions button.message {
        background-color: #fff;
        color: #0095f6;
        border: 1px solid #dbdbdb;
    }

    .profile-actions button.message:hover {
        background-color: #f1f1f1;
    }

    /* Bio */
    .bio {
        padding: 10px 0;
        font-size: 14px;
        line-height: 1.4;
    }

    .bio .website {
        color: #3897f0;
        text-decoration: none;
    }

    /* Stats links */
    .stats a {
        color: inherit;
        text-decoration: none;
        font-weight: bold;
    }

    .stats a:active {
        opacity: 0.8;
    }

    .stats a:hover {
        color: inherit;
        text-decoration: none;
    }

    /* 피드 그리드 */
    .feed-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 2px;
        margin-top: 10px;
    }

    .feed-grid img {
        width: 100%;
        height: 200px;
        object-fit: cover;
    }

    /* '작성한 피드가 없습니다' 메시지 스타일 */
    .no-feed-message {
        text-align: center;
        font-size: 16px;
        color: #aaa;
        margin-top: 20px;
    }
</style>
</head>
<body>

<div class="container">
    <%-- 팔로워 상태 체크 --%>
    <c:set var="isFollower" value="false" />
    <c:forEach items="${followerList}" var="follower">
        <c:if test="${follower.user_id == now_id}">
            <c:set var="isFollower" value="true" />
        </c:if>
    </c:forEach>

    <%-- 프로필 정보 영역 --%>
    <div class="profile-header">
        <div class="profile-info">
            <div>
                <img class="profile-image" src="static/images/setting/${profile.user_image_url}" alt="User Profile Image">
                <div class="user-id">@${userId}</div>
            </div>
            <div class="details">
                <div class="username-container">
                    <c:if test="${profile.account_privacy == 1}">
                        <img class="lockbtn" src="static/images/btn/lock_btn.png" alt="secret" />
                    </c:if>
                    <div class="username">${profile.user_nickname}</div>
                </div>
                <div class="stats">
                    <div>게시물 <span>${fdCount}</span></div>

                    <%-- 본인 또는 팔로우 상태/공개 계정일 때만 팔로워 및 팔로잉 목록 링크 표시 --%>
                    <div>
                        <c:choose>
                            <c:when test="${now_id == userId || isFollower || profile.account_privacy != 1}">
                                <a href="followers?u=${userId}">팔로워 <span>${frCount}</span></a>
                            </c:when>
                            <c:otherwise>
                                <span>팔로워 <span>${frCount}</span></span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${now_id == userId || isFollower || profile.account_privacy != 1}">
                                <a href="following?u=${userId}">팔로우 <span>${fnCount}</span></a>
                            </c:when>
                            <c:otherwise>
                                <span>팔로우 <span>${fnCount}</span></span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <%-- 팔로우/팔로우 요청 버튼 --%>
        <c:if test="${now_id != userId}">
            <div class="profile-actions">
                <c:choose>
                    <c:when test="${isFollower}">
                        <a href="DoUnfollowing?u=${userId}"><button>팔로우 취소</button></a>
                    </c:when>
                    <c:otherwise>
                        <%-- 비공개 계정의 경우 팔로우 요청 링크를 사용 --%>
                        <c:choose>
                            <c:when test="${profile.account_privacy == 1}">
                                <a href="DosecretFollowing?u=${userId}"><button>팔로우 요청</button></a>
                            </c:when>
                            <c:otherwise>
                                <a href="DoFollowing?u=${userId}"><button>팔로우</button></a>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
                <button class="message">메시지</button>
            </div>
        </c:if>
    </div>

    <%-- Bio 정보 --%>
    <div class="bio">
        <p>${bio}</p>
        <a href="${website_url}" class="website">${website_url}</a>
    </div>

    <%-- 피드 표시 영역 --%>
    <c:choose>
        <%-- 비공개 계정이며 본인이 아닌 경우 접근 제한 --%>
        <c:when test="${profile.account_privacy == 1 && !isFollower && now_id != userId}">
            <div>비공개 계정입니다.</div>
        </c:when>
        <%-- 피드가 없는 경우 --%>
        <c:when test="${empty feedList}">
            <div class="no-feed-message">작성한 피드가 없습니다</div>
        </c:when>
        <%-- 피드 목록 표시 --%>
        <c:otherwise>
            <div class="feed-grid">
                <c:forEach items="${feedList}" var="feed">
                    <a href="feedDetail?f=${feed.feed_id}">
                        <img src="static/images/feed/${feed.feed_img_name}" onerror="this.style.display='none'">
                    </a>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>