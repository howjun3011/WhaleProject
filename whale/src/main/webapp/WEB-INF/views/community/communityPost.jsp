<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Community Board</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;600&display=swap">
<style>
    body {
        font-family: 'Noto Sans', sans-serif;
        margin: 0;
        padding: 0;
        color: #333333;
        background-color: #f8f9fa;
    }

    h2 {
        font-size: 24px;
        font-weight: bold;
        color: #444;
        text-align: center;
        margin-bottom: 20px;
    }

    .content-wrapper {
        max-width: 1200px;
        margin: auto;
        padding: 20px;
        background-color: #ffffff;
    }

    .table-container {
        margin-top: 10px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    th, td {
        padding: 10px;
        border-bottom: 1px solid #e9ecef;
        text-align: left;
    }

    th {
        background-color: #f1f3f5;
        font-weight: 700;
        color: #495057;
    }

    td {
        color: #495057;
    }

    tr:hover td {
        background-color: #f8f9fa;
    }

    .fixed {
        color: #f03e3e;
        font-weight: bold;
    }

    .notice-icon, .post-stats {
        color: #adb5bd;
        font-size: 0.9em;
    }

    td a {
        color: #1a73e8;
        text-decoration: none;
    }

    td a:hover {
        text-decoration: underline;
    }

    .pagination {
        display: flex;
        justify-content: center;
        margin-top: 20px;
    }

    .pagination a, .pagination span {
        padding: 8px 12px;
        margin: 0 4px;
        background-color: #ffffff;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        color: #495057;
        text-decoration: none;
        font-weight: 500;
    }

    .pagination a:hover {
        background-color: #e9ecef;
    }

    .pagination .disabled {
        color: #adb5bd;
        pointer-events: none;
    }

    .footer {
        text-align: center;
        margin-top: 20px;
        font-size: 12px;
        color: #868e96;
    }
    
    .modal {
        display: none;
        position: fixed;
        z-index: 1;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.6);
    }
    
    .modal-content {
        background-color: #ffffff;
        margin: 15% auto;
        padding: 20px;
        border-radius: 8px;
        width: 300px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    }
    
    .close {
        color: #aaa;
        float: right;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
    }
    
    .close:hover,
    .close:focus {
        color: #333;
        text-decoration: none;
        cursor: pointer;
    }
    
    .modal-links a {
        display: block;
        padding: 10px;
        margin-top: 10px;
        text-align: center;
        background-color: #1a73e8;
        color: white;
        border-radius: 5px;
        text-decoration: none;
        font-weight: bold;
    }
    
    .modal-links a:hover {
        background-color: #1666c1;
    }
    
    .user-id {
        font-weight: bold;
        cursor: pointer; /* 마우스 올렸을 때 포인터 표시 */
    }

    .user-id:hover {
        color: #1666c1; /* 호버 시 색상 변경 */
    }
    
    .pagination .current {
	    font-weight: bold;
	    color: #1a73e8;
	}
    
</style>
</head>
<body>

<div class="content-wrapper">
    <h2><a href="communityPost?c=${param.c}" class="community-link" style="color: #333333;">${communityName}</a></h2>

    <div class="table-container">
        <table>
            <tr>
                <th>번호</th>
                <th>태그</th>
                <th>제목</th>
                <th>작성자</th>
                <th>등록일</th>
                <th>조회수</th>
                <th>좋아요</th>
            </tr>
            <c:forEach items="${list}" var="p">
                <tr>
                    <td>${p.post_num}</td>
                    <td>${p.post_tag_text}</td>
                    <td><a href="communityDetail?c=${param.c}&p=${p.post_id}">${p.post_title}</a></td>
                    <td>
					    <span class="user-id" 
					          data-user-id="${p.user_id}" 
					          data-user-nickname="${p.user_nickname}" 
					          data-user-image-url="${p.user_image_url}" 
					          onclick="openModal(this)">
					        ${p.user_id}
					    </span>
					</td>
                    <td>${p.post_date}</td>
                    <td>${p.post_cnt}</td>
                    <td>${p.likeCount}</td> <!-- 좋아요 수 추가 -->
                </tr>
            </c:forEach>
        </table>
    </div>

    <div style="text-align: right; margin-top: 20px;">
        <a href="communityReg?c=${param.c}" class="btn" style="background-color: #1a73e8; color: #ffffff; padding: 10px 20px; border-radius: 4px; text-decoration: none; font-weight: bold;">글 작성</a>
    </div>

    <div class="pagination">
        <c:choose>
            <c:when test="${searchVO.page > 1}">
                <a href="communityPost?c=${param.c}&page=${searchVO.page - 1}">이전</a>
            </c:when>
            <c:otherwise>
                <span class="disabled">이전</span>
            </c:otherwise>
        </c:choose>
	    <c:forEach var="i" begin="1" end="${searchVO.totPage}">
	        <c:choose>
	            <c:when test="${i == searchVO.page}">
	                <span class="current">${i}</span>
	            </c:when>
	            <c:otherwise>
	                <a href="communityPost?c=${param.c}&page=${i}">${i}</a>
	            </c:otherwise>
	        </c:choose>
	    </c:forEach>
        <c:choose>
            <c:when test="${searchVO.page < searchVO.totPage}">
                <a href="communityPost?c=${param.c}&page=${searchVO.page + 1}">다음</a>
            </c:when>
            <c:otherwise>
                <span class="disabled">다음</span>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div id="userModal" class="modal" style="display: none;">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <div class="modal-header">
            <img id="modal-user-image" src="" alt="User Image" style="width: 80px; height: 80px; border-radius: 50%; margin-right: 15px;">
            <div class="modal-info">
                <h2 id="modal-user-nickname"></h2>
                <p id="modal-user-id"></p>
            </div>
        </div>
        <div class="modal-links">
            <a href="" id="profile-link" class="modal-link">프로필</a> 
            <a href="" id="message-link" class="modal-link">쪽지 보내기</a>
        </div>
    </div>
</div>

<div class="footer">
    &copy; Whale Community
</div>

<script>
    // 모달 열기
    function openModal(element) {
        const userId = element.getAttribute("data-user-id");
        const userNickname = element.getAttribute("data-user-nickname");
        const userImageUrl = element.getAttribute("data-user-image-url");

        // 모달에 값 채우기
        document.getElementById("modal-user-id").innerText = "@" + userId;
        document.getElementById("modal-user-nickname").innerText = userNickname;
        document.getElementById("modal-user-image").src = "static/images/setting/" + userImageUrl;

        // 링크 설정
        document.getElementById('profile-link').href = "profileHome?u=" + userId;
        document.getElementById('message-link').href = "sendMessage?u=" + userId;

        // 모달 열기
        document.getElementById("userModal").style.display = "block";
    }

    // 모달 닫기
    function closeModal() {
        document.getElementById("userModal").style.display = "none";
    }

    // 모달 외부 클릭 시 닫기
    window.onclick = function(event) {
        const modal = document.getElementById("userModal");
        if (event.target == modal) {
            closeModal();
        }
    };
</script>

</body>
</html>