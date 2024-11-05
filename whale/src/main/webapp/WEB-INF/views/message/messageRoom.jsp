<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅방</title>
<style>
/* 간단한 스타일 추가 */
.chat-container {
    width: 500px;
    margin: 0 auto;
    border: 1px solid #ccc;
}

.chat-header {
    background-color: #f1f1f1;
    padding: 10px;
    text-align: center;
}

.chat-messages {
    height: 300px;
    overflow-y: scroll;
    padding: 10px;
    background-color: #fff;
}

.chat-input {
    padding: 10px;
    background-color: #f1f1f1;
}

.chat-input textarea {
    width: 100%;
    height: 50px;
}

.chat-input button {
    float: right;
    margin-top: 5px;
}
</style>
</head>
<body>
<div class="chat-container">
    <div class="chat-header">
        <h3>${userId}님과 ${now_id}님의 ${roomId}번 채팅방입니다.</h3>
    </div>
    <div class="chat-messages" id="chatMessages">
        <!-- 채팅 메시지들을 표시할 영역 -->
        <c:forEach var="msg" items="${messages}">
            <div class="chat-message">
                <strong>${msg.user_id}:</strong> ${msg.message_text}<br>
                <small>${msg.message_create_date}</small>
            </div>
        </c:forEach>
    </div>
    <div class="chat-input">
        <form action="sendMessage" method="post">
            <input type="hidden" name="roomId" value="${roomId}">
            <input type="hidden" name="userId" value="${userId}">
            <textarea name="message" placeholder="메시지를 입력하세요."></textarea>
            <button type="submit">전송</button>
        </form>
    </div>
</div>
</body>
</html>