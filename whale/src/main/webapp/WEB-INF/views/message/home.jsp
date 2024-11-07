<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% response.setHeader("Cache-Control","no-cache, no-store, must-revalidate"); response.setHeader("Pragma", "no-cache"); response.setDateHeader("Expires", 0);%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>messageHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/message/messageHome.css"/>
    <style>
        .container {
            padding: 20px 20px;
        }
        .scroll-content {
            flex: 1;
            overflow-y: auto;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .left {
            display: flex;
            align-items: center;
        }
        .nowId {
            font-size: 25px;
            line-height: 30px; /* 이미지 높이와 동일하게 설정 */
        }
        #back img, #new-chat img {
            display: block;
            width: 30px;
            height: 30px;
        }
        .room-list {
            display: flex;
            align-items: center;
            margin: 20px 10px;
            padding: 0px 35px;
        }
        .user-nickname {
            font-weight: bold;
        }
        .room-list img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 10px;
        }
        .new-message {
            display: flex;
            font-weight: bold;
            line-height: 30px;
        }
        .before-message {
            display: flex;
            line-height: 30px;
        }
        .diff {
            font-weight: normal;
            display: flex;
            color: #999999;
        }
        a {
            text-decoration: none;
            color: black;
        }
        a:visited, a:hover, a:focus, a:active {
            color: black;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <div class="left">
            <div class="nowId">메시지</div>
        </div>
        <a href="${pageContext.request.contextPath}/message/newChat" id="new-chat">
            <img src="${pageContext.request.contextPath}/static/images/message/newchatIcon.png" id="newchat" alt="newchatIcon">
        </a>
    </div>

    <div class="scroll-content" id="chatList">
        <c:forEach var="list" items="${allChatList}">
            <a href="${pageContext.request.contextPath}/messageGo?u=${list.user_id}">
                <div class="room-list" id="chat-${list.user_id}" data-read-id="${list.unread_message_count}">
                    <img src="${pageContext.request.contextPath}/static/images/setting/${list.user_image_url}"
                         alt="user-img">
                    <div class="chat">
                        <div class="user-nickname">
                            <span>${list.user_nickname}</span>
                        </div>
                        <c:choose>
                            <c:when test="${list.last_message_sender_id == now_id}">
                                <div class="before-message">
                                    <span>${list.last_message_text}</span>&nbsp;&nbsp;
                                    <div class="diff">${list.time_difference}</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${list.unread_message_count > 0}">
                                    <div class="new-message">
                                        <span>새 메시지 ${list.unread_message_count}개</span>&nbsp;&nbsp;
                                        <div class="diff">${list.time_difference}</div>
                                    </div>
                                </c:if>
                                <c:if test="${list.unread_message_count == 0}">
                                    <div class="before-message">
                                        <span>${list.last_message_text}</span>&nbsp;&nbsp;
                                        <div class="diff">${list.time_difference}</div>
                                    </div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </a>
        </c:forEach>
    </div>
</div>
<!-- Home WebSocket 클라이언트 -->
<script>
    const now_id = '${now_id}';

    // WebSocket 연결 설정
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
    };

    socket.onclose = function(event) {
        console.log("Home WebSocket 연결 종료:", event);
    };

    socket.onerror = function(error) {
        console.error("Home WebSocket 오류:", error);
    };

    function updateChatList(homeMessage) {
        const senderId = homeMessage.senderId;
        const messageType = homeMessage.messageType;
        let messageText = homeMessage.messageText;
        const timeDifference = homeMessage.timeDifference;
        const userImageUrl = homeMessage.userImageUrl;

        // 기존 채팅 목록에서 senderId에 해당하는 요소 찾기
        const chatElement = document.getElementById('chat-' + senderId);
        console.log(messageType);
        console.log(chatElement);
        if (chatElement) {
            // 읽지 않은 메시지 수 업데이트
            const unreadBefore = parseInt(chatElement.getAttribute('data-read-id')) || 0;
            let unreadCount = parseInt(chatElement.getAttribute('data-unread-count')) || 0;
            unreadCount += 1;
            chatElement.setAttribute('data-unread-count', unreadCount);
            // 메시지 유형에 따른 텍스트 설정
            if (messageType === 'IMAGE') {
                messageText = "이미지를 보냈습니다.";
            } else if (messageType === 'LINK') {
                messageText = "링크를 보냈습니다.";
            } else if (messageType === 'MUSIC') {
                messageText = "음악을 보냈습니다.";
            } else if (messageType === 'TEXT') {
                if (messageText.length > 40) {
                    messageText = messageText.substring(0, 40) + "...";
                }
            } else {
                messageText = "알 수 없는 메시지 유형입니다.";
            }
            // 새로운 메시지 HTML 생성
            let newMessageHTML = '';
            const totalUnreadCount = unreadCount + unreadBefore;
            if (totalUnreadCount > 0) {
                newMessageHTML = `
                    <div class="new-message">
                        <span>새 메시지 \${totalUnreadCount}개</span>&nbsp;&nbsp;
                        <div class="diff">\${timeDifference}</div>
                    </div>
                `;
            } else {
                newMessageHTML = `
                    <div class="before-message">
                        <span>\${messageText}</span>&nbsp;&nbsp;
                        <div class="diff">\${timeDifference}</div>
                    </div>
                `;
            }

            // 채팅 내용 업데이트
            const chatDiv = chatElement.querySelector('.chat');
            chatDiv.innerHTML = `
                <div class="user-nickname">
                    <span>\${chatDiv.querySelector('.user-nickname span').textContent}</span>
                </div>
                \${newMessageHTML}
            `;


            // 채팅 목록을 맨 위로 이동
            const chatList = document.getElementById('chatList');
            chatList.insertBefore(chatElement.parentElement, chatList.firstChild);
        } else {
        	console.log(userImageUrl);
            // 새로운 채팅 목록 추가 (기존에 없을 경우)
            const chatList = document.getElementById('chatList');
            const newChatHTML = `
                <a href="${pageContext.request.contextPath}/messageGo?u=\${senderId}">
                    <div class="room-list" id="chat-\${senderId}" data-unread-count="1">
                    <img src="${pageContext.request.contextPath}/static/images/setting/\${userImageUrl}" alt="user-img">
                        <div class="chat">
                            <div class="user-nickname">
                                <span>\${senderId}</span>
                            </div>
                            <div class="new-message">
                                <span>새 메시지 1개</span>&nbsp;&nbsp;
                                <div class="diff">\${timeDifference}</div>
                            </div>
                        </div>
                    </div>
                </a>
            `;
            chatList.insertAdjacentHTML('afterbegin', newChatHTML);
        }
    }
</script>
</body>
</html>