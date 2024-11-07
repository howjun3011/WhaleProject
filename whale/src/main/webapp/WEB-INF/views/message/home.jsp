<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
            margin-bottom: 40px;
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
            padding: 5px 5px;
            margin: 10px 10px;
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
<h1>message</h1>
<div class="container">
    <div class="header">
        <div class="left">
            <a href="##" id="back"><img src="${pageContext.request.contextPath}/static/images/message/back.png"
                                        alt="back"></a>
            <div class="nowId">${now_id}</div>
        </div>
        <a href="${pageContext.request.contextPath}/message/newChat" id="new-chat"><img
                src="${pageContext.request.contextPath}/static/images/message/newchatIcon.png" id="newchat"
                alt="newchatIcon"></a>
    </div>

    <div class="scroll-content">
        <c:forEach var="list" items="${allChatList}">
            <a href="${pageContext.request.contextPath}/messageGo?u=${list.user_id}">
                <div class="room-list">
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
</body>
</html>