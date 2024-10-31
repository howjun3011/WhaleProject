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

	.tab-container {
        display: flex;
        justify-content: space-around;
        margin-top: 20px;
        border-bottom: 1px solid #dbdbdb;
    }

    .tab {
        padding: 10px 0;
        cursor: pointer;
        font-weight: bold;
        color: #777;
    }

    .tab.active {
        color: #333;
        border-bottom: 2px solid #333;
    }

    /* 탭 콘텐츠 영역 */
    .tab-content {
        display: none;
        margin-top: 20px;
    }

    .tab-content.active {
        display: block;
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
    
    
	.music-item {
	    position: relative;
	    display: inline-block;
	    overflow: hidden;
	    width: 100%;
	}
	
	.music-item img {
	    width: 100%;
	    height: auto;
	    transition: filter 0.3s ease;
	}
	
	.music-item:hover img {
	    filter: brightness(0.7); /* 이미지 어둡게 */
	}
	
	.overlay {
	    position: absolute;
	    top: 0;
	    left: 0;
	    width: 100%;
	    height: 100%;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    background-color: rgba(0, 0, 0, 0.6); /* 반투명 검정 배경 */
	    opacity: 0;
	    transition: opacity 0.3s ease;
	    color: white;
	    flex-direction: column;
	    gap: 8px;
	    pointer-events: none; /* 기본적으로 클릭 방지 */
	}
	
	.music-item:hover .overlay {
	    opacity: 1;
	    pointer-events: auto; /* 호버 시 클릭 허용 */
	}
	
	.music-item .overlay .play-button {
	    width: 20px;
	    height: 20px;
	    margin-bottom: 10px;
	    cursor: pointer;
	}
	
	.music-info {
	    text-align: center;
	}
	
	.music-title {
	    font-size: 16px;
	    font-weight: bold;
	}
	
	.music-artist {
	    font-size: 14px;
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
                            	<c:choose>
                            		<c:when test="${profile2.target_user_id == now_id}">
                            			<a href="CancelFollowingPlease?u=${userId}"><button>요청됨</button></a>
                            		</c:when>
                            		<c:otherwise>
		                                <a href="DosecretFollowing?u=${userId}"><button>팔로우 요청</button></a>
                            		</c:otherwise>
                            	</c:choose>
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

    <%-- 피드 표시 영역 --%>
    <div class="tab-container">
        <div class="tab active" onclick="showTabContent('feed')"><img src="static/images/btn/write_btn.png" alt="피드" style="width: 40px; height: 40px;" /></div>
        <div class="tab" onclick="showTabContent('music')"><img src="static/images/btn/promusic_btn.png" alt="음악" style=" margin-top:9px; width: 24px; height: 24px;" /></div>
    </div>

    <!-- 피드 탭 콘텐츠 -->
    <div id="feed" class="tab-content active">
        <%-- 기존 피드 표시 코드 --%>
        <c:choose>
            <c:when test="${profile.account_privacy == 1 && !isFollower && now_id != userId}">
                <div>비공개 계정입니다.</div>
            </c:when>
            <c:when test="${empty feedList}">
                <div class="no-feed-message">작성한 피드가 없습니다</div>
            </c:when>
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

    <!-- 음악 탭 콘텐츠 -->
    <div id="music" class="tab-content">
        <!-- 추후 추가할 음악 이미지나 콘텐츠를 여기에 표시 -->
         <c:choose>
            <c:when test="${profile.account_privacy == 1 && !isFollower && now_id != userId}">
                <div>비공개 계정입니다.</div>
            </c:when>
            <c:when test="${empty feedList}">
                <div class="no-feed-message">작성한 피드가 없습니다</div>
            </c:when>
            <c:otherwise>
                <div class="feed-grid">
                    <c:forEach items="${feedList}" var="feed">
                    	<c:if test="${feed.track_id != null}">
							<div class="music-item">
							    <img src="${feed.track_cover}" onerror="this.style.display='none'">
							    <div class="overlay">
							        <img src="static/images/btn/play_btn.png" alt="Play Button" class="play-button" onclick="playMusic(this, '${feed.track_spotify_id}')" />
							        <div class="music-info">
							            <div class="music-title">${feed.track_name}</div>
							            <div class="music-artist">${feed.track_artist}</div>
							        </div>
							    </div>
							</div>
	                    </c:if>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>

	function playMusic(element, spotifyId) {
	    fetch(`/whale/feedPlayMusic?id=\${spotifyId}`)
	        .then(response => {
	        })
	        .catch(error => {
	            console.error('에러 발생:', error);
	            alert('음악 재생 중 오류가 발생했습니다.');
	        });
	}
	

    // 탭 콘텐츠 전환 함수
    function showTabContent(tabId) {
        // 모든 탭 및 콘텐츠에서 active 클래스 제거
        document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

        // 클릭한 탭 및 해당 콘텐츠에 active 클래스 추가
        document.querySelector('.tab-container .tab[onclick="showTabContent(\'' + tabId + '\')"]').classList.add('active');
        document.getElementById(tabId).classList.add('active');
    }
</script>

</body>
</html>