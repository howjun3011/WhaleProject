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
    	display: flex;
    	justify-content: center;
    	align-items: center;
        font-family: 'Noto Sans', sans-serif;
        margin: 0;
        padding: 0;
        background-color: #fafafa;
        color: #333;
    }
    
    ::-webkit-scrollbar {display: none;}

	.tab-container {
        display: flex;
        justify-content: space-around;
        align-items: center;
        border-bottom: 1px solid #dbdbdb;
        height: 80px;
    }

    .tab {
    	display: flex;
        justify-content: space-around;
        align-items: center;
    	width: 40px;
    	height: 50%;
    	padding-bottom: 10px;
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
        min-height: 715px;
        padding: 20px;
        background-color: #fff;
        border: 1px solid #dbdbdb;
    }

    /* 프로필 상단 */
    .profile-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding-bottom: 30px;
        border-bottom: 1px solid #dbdbdb;
    }

    .profile-info {
    	position: relative;
        display: flex;
        align-items: center;
        width: 100%;
    }

    .profile-image {
        border-radius: 50%;
        width: 100px;
        height: 100px;
        margin: 20px 20px 0 20px;
        background-color: #eee;
    }

    .details {
    	position: absolute;
    	top: 26px;
    	left: 150px;
        display: flex;
        flex-direction: column;
        width: 60%;
    }

    /* Username and lock button container */
    .username-container {
        display: flex;
        align-items: center;
        justify-content: left;
        width: 100%;
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

/*     .stats {
        display: flex;
        gap: 20px;
        font-size: 16px;
        color: #777;
        margin-top: 5px;
    } */

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
    	position: absolute;
        display: flex;
        gap: 10px;
        top: 1px;
        left: 210px;
    }

    .profile-actions button {
        padding: 6px 12px;
        height: 100%;
        background-color: #0095f6;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        transition: background-color 0.3s ease;
    }

    .profile-actions button.message {
        background-color: #fff;
        color: #0095f6;
        border: 1px solid #dbdbdb;
    }

    .profile-actions button:hover {
        background-color: #007ac1;
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
	
    .stats-and-featured-music {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        border-top: 1px solid #dbdbdb;
        padding-top: 15px;
        padding-left: 10px;
        margin-top: 15px;
        width: 100%;
    }

    .stats {
        display: flex;
        gap: 30px;
        font-size: 16px;
        color: #777;
    }

    .stats div span {
        font-weight: bold;
        color: #333;
    }

    .featured-music {
        display: flex;
        align-items: center;
        margin-top: 20px;
        margin-left: -10px;
        width: 100%;
    }

    .featured-music-icon {
        width: 30px;
        height: 30px;
        border-radius: 3px;
        margin-right: 8px;
    }

    /* 마퀴 효과를 위한 스타일 */
    .featured-marquee-container {
        overflow: hidden;
        width: calc(80% - 38px); /* 아이콘 공간을 제외한 너비 */
        position: relative;
    }

    .featured-marquee {
        display: inline-block;
        white-space: nowrap;
        overflow: hidden;
    }
    
    .animated {
        animation: marquee 10s linear infinite; /* 애니메이션 시간을 줄일 수 있음 */    
        animation-delay: 1s;
        animation-play-state: paused;
    }
    
    @keyframes marquee {
	    0% {
	        transform: translateX(1%);
	    }
	    100% {
	        transform: translateX(-50%);
	    }
	}

    .featured-music-title {
        font-size: 14px;
        font-weight: bold;
        color: #333;
    }

    .featured-music-artist {
        font-size: 12px;
        color: #777;
        margin-left: 10px;
    }
    
    .featured-play-button, .featured-pause-button {
    	width: 20px;
	    height: 20px;
        background: none;
        border: none;
        cursor: pointer;
    }
    
    .featured-play-button img, .featured-pause-button img {
    	width: 20px;
	    height: 20px;
    } 
    
    .now-playing-icon {
	    height: 20px;
	    margin-left: 2.5px;
	    visibility: hidden; /* 초기에는 보이지 않도록 설정 */
	    opacity: 0; /* 투명하게 */
	    transition: opacity 0.3s ease; /* 나타나는 효과 */
	}
	
    .deleteAccount {
		display: flex;
		justify-content: center;
		align-items: center;
		font-family: 'Noto Sans', sans-serif;
		font-weight: 600; /* 두껍게 표시할 경우 */
		height: 100vh; /* 화면 세로 중앙 정렬 */
		text-align: center;
    }
</style>
</head>
<body>
<c:choose>
	<c:when test="${profile.account_privacy == 2}">
		<div class="deleteAccount">탈퇴한 사용자입니다.</div>
	</c:when>
	<c:otherwise>
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
                <img class="profile-image" src="${profile.user_image_url}" alt="User Profile Image">
                <div class="user-id">@${userId}</div>
            </div>
            <div class="details">
                <div class="username-container">
                    <c:if test="${profile.account_privacy == 1}">
                        <img class="lockbtn" src="static/images/btn/lock_btn.png" alt="secret" />
                    </c:if>
                    <div class="username">${profile.user_nickname}</div>
	                        <c:if test="${now_id != userId}">
					        <div class="profile-actions">
					            <c:choose>
					                <c:when test="${isFollower}">
					                    <a href="DoUnfollowing?u=${userId}"><button>팔로우 취소</button></a>
					                </c:when>
					                <c:otherwise>
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
					            <a href="messageGo?u=${userId}"><button class="message">메시지</button></a>
					        </div>
					    </c:if>
                </div>
				<div class="stats-and-featured-music">
				    <div class="stats">
				        <div>게시물&nbsp;&nbsp;<span>${fdCount}</span></div>
				        <div>
				            <c:choose>
				                <c:when test="${now_id == userId || isFollower || profile.account_privacy != 1}">
				                    <a href="followers?u=${userId}">팔로워&nbsp;&nbsp;<span>${frCount}</span></a>
				                </c:when>
				                <c:otherwise>
				                    <span>팔로워&nbsp;&nbsp;<span>${frCount}</span></span>
				                </c:otherwise>
				            </c:choose>
				        </div>
				        <div>
				            <c:choose>
				                <c:when test="${now_id == userId || isFollower || profile.account_privacy != 1}">
				                    <a href="following?u=${userId}">팔로잉&nbsp;&nbsp;<span>${fnCount}</span></a>
				                </c:when>
				                <c:otherwise>
				                    <span>팔로잉&nbsp;&nbsp;<span>${fnCount}</span></span>
				                </c:otherwise>
				            </c:choose>
				        </div>
				    </div>
					<c:if test="${profile.track_cover != null}">
					
					<div class="featured-music">
					    <img src="${profile.track_cover}" alt="대표곡" class="featured-music-icon">
					    <div class="featured-marquee-container">
					        <div class="featured-marquee" id="featuredMarquee">
 					            <span class="featured-music-title">${profile.track_name}</span>
					            <span class="featured-music-artist">${profile.track_artist}</span>
					        </div>
					    </div>
					    <button class="featured-play-button" onclick="playProMusic(this, '${profile.track_id}')">
					        <img src="static/images/btn/play_btn.png" alt="Play Button" />
					    </button>
					    <button class="featured-pause-button" onclick="pauseMusic(this, '${profile.track_id}')" style="display: none;">
					        <img src="static/images/btn/pause_btn.png" alt="Pause Button" />
					    </button>
					</div>
					    <img src="static/images/btn/moving_music2.gif" alt="now-playing" class="now-playing-icon" />
					</c:if>
				</div>
            </div>

        </div>
    </div>

    <%-- 피드 표시 영역 --%>
    <div class="tab-container">
        <div class="tab active" onclick="showTabContent('feed')"><img src="static/images/btn/write_btn.png" alt="피드" style="width: 40px; height: 40px;" /></div>
        <div class="tab" onclick="showTabContent('music')"><img src="static/images/btn/promusic_btn.png" alt="음악" style="width: 24px; height: 24px;" /></div>
    </div>

    <!-- 피드 탭 콘텐츠 -->
    <div id="feed" class="tab-content active">
        <%-- 기존 피드 표시 코드 --%>
        <c:choose>
            <c:when test="${profile.account_privacy == 1 && !isFollower && now_id != userId}">
                <div style="padding: 10px 0 0 10px">비공개 계정입니다.</div>
            </c:when>
            <c:when test="${empty feedList}">
                <div class="no-feed-message">작성한 피드가 없습니다</div>
            </c:when>
            <c:otherwise>
                <div class="feed-grid">
                    <c:forEach items="${feedList}" var="feed">
                        <a href="feedDetail?f=${feed.feed_id}">
                            <img src="${feed.feed_img_url}" onerror="this.style.display='none'">
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
                <div style="padding: 10px 0 0 10px">비공개 계정입니다.</div>
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
							        <img src="static/images/btn/play_btn.png" alt="Play Button" class="play-button" onclick="playMusic(this, '${feed.track_id}')" />
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
</c:otherwise>
</c:choose>

<script>

	window.addEventListener('DOMContentLoaded', () => {
	    const marqueeElement = document.getElementById('featuredMarquee');
	    const containerWidth = marqueeElement.parentElement.offsetWidth;
	    const textWidth = marqueeElement.scrollWidth;
	
	    // 텍스트가 컨테이너보다 넓을 경우에만 애니메이션 클래스 추가
	    if (textWidth > containerWidth) {
	        marqueeElement.classList.add('animated');
	        
	        setTimeout(() => {
	            marqueeElement.style.animationPlayState = 'running'; // 애니메이션 시작
	        }, 1000); // 2초 후 애니메이션 시작
	    }
	});

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
    
    function playProMusic(element, spotifyId) {
        fetch(`/whale/feedPlayMusic?id=\${spotifyId}`)
            .then(response => {
                if (response.ok) {
                    element.style.display = 'none';
                    const pauseBtn = element.nextElementSibling;
                    const nowPlayingIcon = document.querySelector('.now-playing-icon');
                    if (pauseBtn) {
                        pauseBtn.style.display = 'inline-block';
                    }
                    if (nowPlayingIcon) {
                        nowPlayingIcon.style.visibility = 'visible';
                        nowPlayingIcon.style.opacity = '1'; // 재생 중 아이콘을 보이게
                    }
                } else {
                    alert('음악 재생에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('에러 발생:', error);
                alert('음악 재생 중 오류가 발생했습니다.');
            });
    }

    function pauseMusic(element, spotifyId) {
        fetch(`/whale/feedPauseMusic?id=\${spotifyId}`)
            .then(response => {
                if (response.ok) {
                    element.style.display = 'none';
                    const playBtn = element.previousElementSibling;
                    const nowPlayingIcon = document.querySelector('.now-playing-icon');
                    if (playBtn) {
                        playBtn.style.display = 'inline-block';
                    }
                    if (nowPlayingIcon) {
                        nowPlayingIcon.style.visibility = 'hidden';
                        nowPlayingIcon.style.opacity = '0'; // 재생 중 아이콘을 숨기기
                    }
                } else {
                    alert('음악 일시정지에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('에러 발생:', error);
                alert('음악 일시정지 중 오류가 발생했습니다.');
            });
    }
    
</script>

</body>
</html>