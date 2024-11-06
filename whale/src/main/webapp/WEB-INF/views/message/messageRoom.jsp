<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script> <!-- jQuery 추가 -->
<meta charset="UTF-8">
<title>채팅방</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600&display=swap">
<style>
    /* 기본 스타일 */
    body {
        font-family: 'Noto Sans KR', Arial, sans-serif;
        background-color: #f8f9fa;
        margin: 0;
        padding: 0;
    }

    .container {
        width: 100%;
        max-width: 900px;
        margin: 0 auto;
        background-color: #ffffff;
        padding: 40px 20px;
        box-sizing: border-box;
    }

    /* 채팅 헤더 스타일 */
    .chat-header {
        background: linear-gradient(to right, #e0e0e0, #ffffff);
        padding: 15px 20px;
        font-size: 1.5em;
        font-weight: bold;
        color: #343a40;
        margin-bottom: 30px;
        text-align: center;
    }

    /* 채팅 메시지 영역 스타일 */
    .chat-messages {
        height: 500px;
        overflow-y: scroll;
        padding: 20px;
        background-color: #f8f9fa;
        border: 1px solid #e9ecef;
        box-sizing: border-box;
        margin-bottom: 30px;
    }

    .chat-message {
        margin-bottom: 20px;
        display: flex;
        align-items: flex-end;
    }

    .chat-message.left {
        justify-content: flex-start;
    }

    .chat-message.right {
        justify-content: flex-end;
    }

    .chat-message .message-bubble {
        max-width: 60%;
        padding: 15px;
        border-radius: 15px;
        position: relative;
        font-size: 1em;
        line-height: 1.6;
        word-wrap: break-word;
    }

    .chat-message.left .message-bubble {
        background-color: #ffffff;
        border: 1px solid #e9ecef;
    }

    .chat-message.right .message-bubble {
        background-color: #d1e7dd;
        border: 1px solid #c7d9d3;
    }

    .chat-message.left .message-bubble::after {
        content: '';
        position: absolute;
        top: 10px;
        left: -10px;
        border: 10px solid transparent;
        border-right-color: #ffffff;
    }

    .chat-message.right .message-bubble::after {
        content: '';
        position: absolute;
        top: 10px;
        right: -10px;
        border: 10px solid transparent;
        border-left-color: #d1e7dd;
    }

    .chat-message .message-info {
        font-size: 0.9em;
        color: #868e96;
        margin-top: 5px;
    }

    /* 채팅 입력 영역 스타일 */
    .chat-input {
        display: flex;
        align-items: center;
        padding: 15px;
        background-color: #ffffff;
        border-top: 1px solid #e9ecef;
    }

    .chat-input textarea {
        flex-grow: 1;
        height: 50px;
        border: 1px solid #ced4da;
        border-radius: 5px;
        padding: 10px;
        resize: none;
        font-size: 1em;
    }

    .chat-input button {
        width: 80px;
        height: 50px;
        margin-left: 10px;
        background-color: #12b886;
        border: none;
        color: #ffffff;
        border-radius: 5px;
        font-size: 1em;
        cursor: pointer;
    }

    .chat-input button:hover {
        background-color: #0ca678;
    }

</style>
</head>
<body>

<div class="container">
    <!-- 채팅 헤더 -->
    <div class="chat-header">
        ${userId}님과 ${now_id}님의 채팅방
    </div>

    <!-- 채팅 메시지 영역 -->
    <div class="chat-messages" id="chatMessages">
        <!-- 채팅 메시지들을 표시할 영역 -->
        <c:forEach var="msg" items="${messages}">
            <div class="chat-message <c:choose>
                <c:when test="${msg.user_id == now_id}">
                    right
                </c:when>
                <c:otherwise>
                    left
                </c:otherwise>
            </c:choose>">
                <div class="message-bubble">
                    <div>${msg.message_text}</div>
                    <div class="message-info">
                        ${msg.user_id} • 
                        <fmt:formatDate value="${msg.message_create_date}" pattern="yyyy-MM-dd HH:mm:ss" />
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 채팅 입력 영역 -->
    <div class="chat-input">
		<form onsubmit="sendMessage(); return false;">
		    <input type="hidden" name="roomId" value="${roomId}">
		    <input type="hidden" name="userId" value="${userId}">
		    <textarea id="messageInput" placeholder="메시지를 입력하세요." required 
		              onkeypress="if(event.keyCode==13 && !event.shiftKey){ sendMessage(); return false;}"></textarea>
		    <button type="submit">전송</button>
		</form>
    </div>
</div>

<script>
    // JSP에서 컨텍스트 패스를 동적으로 가져옵니다.
    const contextPath = '${pageContext.request.contextPath}';
    const roomId = '${roomId}';
    const now_id = '${now_id}';

    console.log(contextPath);
    
    // 프로토콜을 동적으로 설정합니다. HTTPS인 경우 wss, 그렇지 않으면 ws를 사용합니다.
    const protocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';

    // WebSocket URL을 설정합니다. 컨텍스트 패스를 포함합니다.
    const socket = new WebSocket(protocol + window.location.host + contextPath + "/chat?roomId=" + roomId);

    socket.onopen = function() {
        console.log("WebSocket 연결 성공");
        console.log(socket);
    };

    socket.onmessage = function(event) {
        console.log("Received message: " + event.data);
        const chatMessages = document.getElementById('chatMessages');
        const [msgRoomId, msgUserId, msgText] = event.data.split(':');

        console.log("Parsed message - roomId: " + msgRoomId + ", userId: " + msgUserId + ", messageText: " + msgText);
        
        // 현재 채팅방 메시지만 표시
        if (msgRoomId === roomId) {
            const msgDiv = document.createElement('div');
            msgDiv.className = "chat-message " + (msgUserId === now_id ? 'right' : 'left');
            msgDiv.innerHTML =
                '<div class="message-bubble">' +
                    '<div>' + msgText + '</div>' +
                    '<div class="message-info">' + msgUserId + '</div>' +
                '</div>';
            chatMessages.appendChild(msgDiv);
            chatMessages.scrollTop = chatMessages.scrollHeight; // 스크롤을 맨 아래로 이동
        }
    };

    socket.onclose = function(event) {
        console.log("WebSocket 연결 종료", event);
    };

    socket.onerror = function(error) {
        console.error("WebSocket 에러: ", error);
    };

    function sendMessage() {
        const messageInput = document.getElementById("messageInput");
        const message = messageInput.value.trim();
        if (message) {
            const payload = `${roomId}:${now_id}:\${message}`;
            socket.send(payload);
            messageInput.value = "";
        }
    }

    // 페이지 로드 시 자동으로 채팅 메시지 영역을 스크롤합니다.
    window.onload = function() {
        const chatMessages = document.getElementById('chatMessages');
        chatMessages.scrollTop = chatMessages.scrollHeight;
    };
</script>

</body>
</html>