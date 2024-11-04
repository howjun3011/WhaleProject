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
                    <td>${p.user_id}</td>
                    <td>${p.post_date}</td>
                    <td>${p.post_cnt}</td>
                    <td>${p.likeCount}</td> <!-- 좋아요 수 추가 -->
                </tr>
            </c:forEach>
        </table>
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
        <span>${searchVO.page}</span>
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

<div class="footer">
    &copy; Whale Community
</div>

</body>
</html>