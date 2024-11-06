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
<header>
    <div class="headerSearch">
        <form action="searchResult" method="get">
            <button class="searchBtn">
                <input type="image" src="/whale/static/images/streaming/searchBtn.png" alt="검색" style="height: 14px;" class="searchBtn"/>
            </button>
            <input class="headerSearchInput" type="text" name="keyword" placeholder="검색어를 입력하세요" required/>
        </form>
    </div>
</header>
</body>
</html>