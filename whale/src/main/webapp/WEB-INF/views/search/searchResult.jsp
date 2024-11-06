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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/search/searchStyles.css"/>
</head>
<body>
<h1>검색 결과: "${keyword}"</h1>
<c:if test="${not empty userList}">
    <ul>
        <c:forEach var="user" items="${userList}">
            <li>
                아이디: ${user.user_id} <br/>
                닉네임: ${user.user_nickname} <br/>
                <div class="searchProfile">
                    <img src="static/images/setting/${user.user_image_url}" alt="프로필 이미지"/>
                </div>
            </li>
        </c:forEach>
    </ul>
</c:if>
<c:if test="${empty userList}">
    <p>검색 결과가 없습니다.</p>
</c:if>
</body>
</html>