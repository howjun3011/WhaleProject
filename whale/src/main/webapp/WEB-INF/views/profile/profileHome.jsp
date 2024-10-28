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
        background-color: #000;
        color: #fff;
    }

    .container {
        width: 100%;
        max-width: 600px;
        margin: 0 auto;
        padding: 20px;
    }

    /* 프로필 상단 */
    .profile-header {
        display: flex;
        justify-content: space-between;
        padding-bottom: 20px;
        border-bottom: 1px solid #333;
    }

    .profile-info {
        display: flex;
        align-items: center;
    }

    .profile-info img {
        border-radius: 50%;
        width: 80px;
        height: 80px;
        margin-right: 20px;
    }

    /* 유저 아이디를 이미지 아래에 작은 글씨로 배치 */
    .profile-info .user-id {
        font-size: 14px;
        color: #aaa;
        text-align: center;
        margin-top: 5px;
    }

    .profile-info .details {
        display: flex;
        flex-direction: column;
    }

    /* 유저 닉네임을 이미지 오른쪽에 유지 */
    .profile-info .details .username {
        font-size: 20px;
        font-weight: bold;
        margin-bottom: 5px;
    }

    .profile-info .details .stats {
        display: flex;
        margin-top: 5px;
    }

    .profile-info .details .stats div {
        margin-right: 20px;
        font-size: 14px;
    }

    .profile-info .details .stats div span {
        font-weight: bold;
    }

    /* 버튼 영역 */
    .profile-actions {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .profile-actions button {
        padding: 8px 16px;
        background-color: #3897f0;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 8px;
        width: 100px;
    }

    .profile-actions button.message {
        background-color: #000;
        border: 1px solid #fff;
    }

    .profile-actions button:hover {
        background-color: #287bc9;
    }

    .profile-actions button.message:hover {
        background-color: #333;
    }

    /* 피드 그리드 */
    .feed-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 2px;
        margin-top: 20px;
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
        color: #ccc;
        margin-top: 20px;
    }

    /* 팔로우 정보 및 기타 설명 */
    .bio {
        padding: 10px 0;
        font-size: 14px;
        line-height: 1.4;
    }

    .bio .website {
        color: #3897f0;
        text-decoration: none;
    }

    /* 링크 기본 스타일 제거 (파란색과 밑줄) */
    .profile-info .details .stats a {
        color: inherit; /* 부모 요소의 글자 색상에 따라감 */
        text-decoration: none; /* 밑줄 제거 */
        font-weight: bold; /* 글자 강조 */
    }

    /* 클릭할 때만 클릭한 느낌 주기 */
    .profile-info .details .stats a:active {
        opacity: 0.8; /* 클릭할 때 살짝 어두워지도록 설정 */
    }

    /* 눌러도 색상이나 밑줄에 변화 없도록 설정 */
    .profile-info .details .stats a:hover {
        color: inherit;
        text-decoration: none;
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
                <img src="static/images/setting/${profile.user_image_url}" alt="User Profile Image">
                <div class="user-id">@${userId}</div>
            </div>
            <div class="details">
                <div class="username">${profile.user_nickname}</div>
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