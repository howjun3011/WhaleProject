<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>newChat</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/message/messageHome.css" />
    <style>
        .container {
            padding: 20px 20px;
            width: 100%;
            box-sizing: border-box;
        }
        .scroll-content {
            flex: 1;
            overflow-y: auto;
        }
        .header {
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            margin-bottom: 10px;
        }
        .header #back {
            position: absolute;
            left: 2px;
            top: 50%;
            transform: translateY(-50%);
        }
        .header #back img {
            width: 30px;
            height: 30px;
        }
        .search{
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 10px;
        }
        #search {
            background-color: whitesmoke;
            font-size: 15px;
            color: #B8B8B8;
            border: 1px solid #ccc;
            padding: 5px;
            border-radius: 5px;
        }
        .new-message{
            font-size: 20px;
        }
        .follow-list {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding: 0px 35px;
        }
        .follow-list img{
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 10px;
        }
        .user-nickname {
            font-weight: bold;
            margin: 0;
            padding: 0;
            text-align: left;
        }
        .user-id {
            color: #999999;
            margin: 0;
            padding: 0;
            text-align: left;
        }
        .user-info {
            display: flex;
            flex-direction: column; /* 세로로 배치 */
            margin: 0;
            padding: 0;
            font-size: 15px;
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
        <a href="${pageContext.request.contextPath}/message/home" id="back"><img src="${pageContext.request.contextPath}/static/images/message/back.png" alt="back"></a>
        <div class="new-message">새 메시지</div>
    </div>
    <div class="search">
        <input type="text" id="search" placeholder="사용자 검색">
    </div>
    <br>
    <div class="scroll-content">
        <c:forEach var="follow" items="${followList}">
            <a href="${pageContext.request.contextPath}/messageGo?u=${follow.follow_user_id}">
                <div class="follow-list user-item" data-username="${follow.follow_user_nickname}" data-userid="${follow.follow_user_id}" >
                    <img src="${pageContext.request.contextPath}/static/images/setting/${follow.follow_user_image_url}" alt="user-img">
                    <div class="user-info">
                        <div class="user-nickname">
                            <span>${follow.follow_user_nickname}</span>
                        </div>
                        <div class="user-id">
                            <span>${follow.follow_user_id}</span>
                        </div>
                    </div>
                </div>
            </a>
        </c:forEach>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function() {
       const searchInput = document.getElementById('search');
       const userItems = document.querySelectorAll('.user-item');

       searchInput.addEventListener('input', function() {
          const searchText = searchInput.value.toLowerCase();

          userItems.forEach(function(item) {
              const username = item.getAttribute('data-username').toLowerCase();
              const userid = item.getAttribute('data-userid').toLowerCase();

              if(username.includes(searchText) || userid.includes(searchText)) {
                  item.style.display = 'flex'; // 원래의 display 속성으로 변경
              } else {
                  item.style.display = 'none';
              }
          })
       });
    });
</script>
</body>
</html>