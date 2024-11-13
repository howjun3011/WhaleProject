<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Follower List</title>
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

    .container {
        width: 100%;
        max-width: 650px;
        min-height: 715px;
        padding: 20px;
        background-color: #fff;
        border: 1px solid #dbdbdb;
    }

    .follower-list {
        list-style: none;
        margin-top: -10px;
        padding: 0;
    }

    .follower-list li {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px;
        border-bottom: 1px solid #dbdbdb;
    }

    .follower-list img {
        border-radius: 50%;
        width: 50px;
        height: 50px;
        margin-right: 20px;
    }

    .follower-info {
        display: flex;
        flex-direction: column;
    }

    .follower-info .nickname {
        font-weight: bold;
        font-size: 16px;
        margin-left: 5px;
    }

    .follower-info .name {
        font-size: 14px;
        color: #aaa;
    }

    .delete-button {
        background-color: #e74c3c;
        color: white;
        padding: 8px 12px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        margin-right: 5px;
    }

    .delete-button:hover {
        background-color: #c0392b;
    }
</style>
</head>
<body>

<div class="container">
    <h2 style="padding: 20px; border-bottom: 1px solid #dbdbdb;">팔로워</h2>

    <c:if test="${empty followerList}">
        <p style="padding: 5px 0 0 15px;">팔로워가 없습니다.</p>
    </c:if>

    <c:if test="${!empty followerList}">
        <ul class="follower-list">
            <c:forEach items="${followerList}" var="follower">
                <li>
                    <div style="display: flex; align-items: center;">
                        <a href="profileHome?u=${follower.user_id}"><img src="${follower.user_image_url}" alt="${follower.user_nickname}의 프로필 사진"></a>
                        <div class="follower-info">
                            <div class="nickname">${follower.user_nickname}</div>
                            <div class="name">@${follower.user_id}</div>
                        </div>
                    </div>
                    
                    <!-- 삭제 버튼 생성 -->
                    <c:if test =  "${now_id eq userId}">
                    <form action="DelFollower" method="post">
                        <input type="hidden" name="u" value="${follower.user_id}" />
                        <button type="submit" class="delete-button">삭제</button>
                    </form>
                    </c:if>
                </li>
            </c:forEach>
        </ul>
    </c:if>

</div>

    <script>
        document.addEventListener('dblclick', function(event) {
            // 화면의 왼쪽 절반을 두 번 클릭했는지 확인
            if (event.clientX < window.innerWidth / 2) {
                window.history.back(); // 뒤로 가기
            }
        });
    </script>

</body>
</html>