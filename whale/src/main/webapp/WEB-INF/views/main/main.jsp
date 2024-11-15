<?xml version="1.0" encoding="UTF-8" ?>
<%@page import="com.tech.whale.main.models.MainAuthorizationCode" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>
    <title>Whale</title>
    <link rel="icon" href="static/images/main/whaleLogo.png">
    <link rel="stylesheet" href="static/css/main/mainStyle.css"/>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script src="https://sdk.scdn.co/spotify-player.js"></script>
    <script> sessionStorage.accessToken = `${ accessToken }`;
    sessionStorage.access_id = `${ access_id }`;
    sessionStorage.user_id = `${ user_id }`;</script>
    <script type="module" src="static/js/main/mainVue.js" defer></script>
    <style>
	    #notification-container {
	        position: fixed;
	        top: 10px;
	        left: 150px; /* 왼쪽 위치를 40px로 조정하여 오른쪽으로 이동 */
	        z-index: 1000;
	    }
	
	    .notification {
	        background-color: white; /* 배경을 흰색으로 변경 */
	        color: #333; /* 텍스트 색상을 어두운 회색으로 변경 */
	        padding: 15px 20px;
	        margin-bottom: 10px;
	        border-radius: 5px;
	        border: 1px solid #ccc; /* 테두리 추가 */
	        cursor: pointer;
	        opacity: 0.9;
	        transition: opacity 0.5s ease, transform 0.5s ease;
	        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
	        display: flex; /* Flexbox 레이아웃 사용 */
	        align-items: center; /* 수직 가운데 정렬 */
	    }
	
	    .notification:hover {
	        opacity: 1;
	        transform: translateY(-2px);
	    }
	
	    /* 다크 모드용 알림 스타일 */
	    .dark .notification {
	        background-color: #335580;
	        color: white;
	    }
	
	    /* 이미지와 텍스트 간 간격 조정 */
	    .notification img {
	        margin-right: 10px;
	    }
	
	    /* 텍스트 내용의 레이아웃 조정 */
	    .notification .text-content {
	        display: flex;
	        flex-direction: column;
	    }
    </style>
</head>
<body>
<div id="main">
    <main-header-component :header-menu-check="headerMenuCheck" :user-image-url="userInfo[1]"
                           :noti-counts-sum="notiCounts.reduce((x,y) => (x+y))" @header-alarm-toggle="menuCheck"
                           @header-profile-toggle="menuCheck" @reset-main="resetMain"></main-header-component>
    <div class="main">
        <main-center-component :frame-names="frameNames" :replace-iframe="replaceIframe" :start-page="startPage"
                               :track-info="trackInfo" :whale-address="whaleAddress"></main-center-component>
        <main-header-menu-component :header-menu-check="headerMenuCheck" :user-nickname="userInfo[0]"
                                    :notifications="notifications" :noti-counts="notiCounts"
                                    :get-notification="getNotification" @header-close-menu="closeMenu"
                                    @menu-redirect-iframe="changeRedirectIndex"></main-header-menu-component>
    </div>
    <main-footer-component :fetch-iframe="fetchIframe" :fetch-web-api="fetchWebApi" :start-page="startPage"
                           :track-info="trackInfo" @footer-music-toggle="changeRedirectIndex"></main-footer-component>
<div id="notification-container"></div>
</div>
</body>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 페이지가 로드될 때 초기 다크 모드 설정 확인
        const darkmodeOn = localStorage.getItem('darkmodeOn');
        const mainElement = document.getElementById('main');

        if (darkmodeOn === "1") {
            mainElement.classList.add("dark");
            mainElement.classList.remove("light");
        } else {
            mainElement.classList.add("light");
            mainElement.classList.remove("dark");
        }

        // localStorage 값이 변경될 때마다 실행
        window.addEventListener('storage', function (event) {
            if (event.key === 'darkmodeOn') {
                if (event.newValue === "1") {
                    mainElement.classList.add("dark");
                    mainElement.classList.remove("light");
                } else {
                    mainElement.classList.add("light");
                    mainElement.classList.remove("dark");
                }
            }
        });
    });
    
    const now_id = `${ user_id }`;

    const protocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
    const socketUrl = protocol + "25.5.112.217:9002/whale/home?userId=" + now_id;
    const socket = new WebSocket(socketUrl);

    console.log(socketUrl);
    socket.onopen = function() {
        console.log("Home WebSocket 연결 성공");
    };

    socket.onmessage = function(event) {
        console.log("새 메시지 수신:", event.data);
        const homeMessage = JSON.parse(event.data);
        updateChatList(homeMessage);
        
        // 알림 표시 함수 호출
        showNotification(homeMessage.userImageUrl, 
        		homeMessage.messageType, 
        		homeMessage.senderId, 
        		homeMessage.senderNickname, 
        		homeMessage.messageText);
    };

    socket.onclose = function(event) {
        console.log("Home WebSocket 연결 종료:", event);
    };

    socket.onerror = function(error) {
        console.error("Home WebSocket 오류:", error);
    };

    function updateChatList(homeMessage) {
        // 기존 채팅 목록 업데이트 로직 ...
    }

    // 알림 생성 함수 추가
    function showNotification(userImageUrl, messageType, senderId, userNickname, messageText) {
        const container = document.getElementById('notification-container');

        const notification = document.createElement('div');
        notification.className = 'notification';

        notification.innerHTML = `
        <a href="/whale/messageGo?u=\${senderId}" style="text-decoration: none; color: inherit;">
            <img src="\${userImageUrl}" alt="User Image" style="width:40px; height:40px; border-radius:50%;">
            <div class="text-content">
                <div><strong>\${userNickname}</strong></div>
                	<div>\${messageText}</div>                	                	
            </div>
        </a>
        `;
        container.appendChild(notification);


        // 2초 후에 알림 제거
        setTimeout(() => {
            notification.style.opacity = '0';
            notification.style.transform = 'translateY(-20px)';
            setTimeout(() => {
                if (notification.parentNode === container) {
                    container.removeChild(notification);
                }
            }, 500); // CSS 트랜지션 시간과 일치시킴
        }, 2000);
    }

    window.addEventListener("message", function(event) {
        // 메시지 내용 확인
        var message = event.data;
        if (message && message.type === "success") {
            // 성공 메시지가 있을 경우, alert로 표시하고 메인 페이지로 이동
            alert(message.text); // 탈퇴 성공 메시지 표시
            window.location.href = "/whale"; // 메인 페이지로 이동
        }
    });
</script>

</html>