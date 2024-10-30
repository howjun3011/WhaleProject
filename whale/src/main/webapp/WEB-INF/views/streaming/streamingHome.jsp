<?xml version="1.0" encoding="UTF-8" ?>
<%@page import="com.tech.whale.main.models.MainAuthorizationCode" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="icon" href="${pageContext.request.contextPath}/static/images/main/whaleLogo.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/streaming/streamingStyles.css"/>
    <title>Whale Streaming</title>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/streaming/mainFunction.js"></script>
</head>
<body>
<div class="header">
    <div class="headerItems">
        <button class="homeBtn">
            <button class="homeBtn" onclick="goMain()">
                <img src="${pageContext.request.contextPath}/static/images/streaming/homeBtn.png"
                     alt="Music Whale Search Button" height="20px">
            </button>
        </button>
        <div class="headerSearch">
            <button class="searchBtn" onclick="goSearch()">
                <img src="${pageContext.request.contextPath}/static/images/streaming/searchBtn.png"
                     alt="Music Whale Search Button" height="14px">
            </button>
            <input class="headerInput" placeholder="어떤 콘텐츠를 감상하고 싶으세요?" onfocus="placeholder=''"
                   onblur="placeholder='어떤 콘텐츠를 감상하고 싶으세요?'">
        </div>
    </div>
</div>
<div class="main">
    <div class="mainLibraryFrame">
        <div class="mainLibrary">
            <svg id="toggleButton"
                 data-encore-id="icon"
                 role="img"
                 aria-hidden="true"
                 viewBox="0 0 24 24"
                 class="libraryBtn"
            >
                <path
                        d="M14.5 2.134a1 1 0 0 1 1 0l6 3.464a1 1 0 0 1 .5.866V21a1 1 0 0 1-1 1h-6a1 1 0 0 1-1-1V3a1 1 0 0 1 .5-.866zM16 4.732V20h4V7.041l-4-2.309zM3 22a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1zm6 0a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1z"
                ></path>
            </svg>
        </div>
    </div>
    <div class="mainContentFrame">
        <div class="mainContent">
            <div class="mainContentMargin">
                <div class="recommendationsHeader"></div>
                <c:choose>
                    <c:when test="${page == 'home'}">
                        <div class="recommendations">
                            <div class="recommendationTitle"><p class="titleName">내가 즐겨 듣는 노래</p></div>
                            <div class="recommendationWrapper">
                                <!-- 왼쪽 버튼 -->
                                <button class="slideButton left" id="scrollLeftBtn" onclick="scrollLeftContent()">
                                    <img src="${pageContext.request.contextPath}/static/images/streaming/prev.png"
                                         alt="Like Button" width="30"
                                         height="30" style="border-radius: 8px; opacity: 0.75;">
                                </button>
                                <div class="recommendationContents" id="recommendationContents">
                                    <!-- trackPaging 데이터를 반복문으로 출력 -->
                                    <c:forEach var="track" items="${trackPaging.items}">
                                        <div class="recommendationContent">
                                            <div class="recommendationLike" onclick="insertTrack('${track.id}')">
                                                <img src="${pageContext.request.contextPath}/static/images/streaming/like.png"
                                                     alt="Like Button" width="30"
                                                     height="30" style="border-radius: 8px; opacity: 0.75;">
                                            </div>
                                            <div class="recommendationCover" onclick="navigateToDetail('${track.id}')">
                                                <img src="${track.album.images[0].url}" alt="${track.name}" width="120"
                                                     height="120" style="border-radius: 8px;">
                                            </div>
                                            <div class="recommendationPlay" onclick="playTrack('${track.id}')">
                                                <img src="${pageContext.request.contextPath}/static/images/streaming/play.png"
                                                     alt="Like Button" width="30"
                                                     height="30" style="border-radius: 8px; opacity: 0.75;">
                                            </div>
                                            <div class="recommendationInfo">
                                                <p class="trackName">${track.name}</p>
                                                <p class="artistName">${track.artists[0].name}</p>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <!-- 오른쪽 버튼 -->
                                <button class="slideButton right" id="scrollRightBtn" onclick="scrollRightContent()">
                                    <img src="${pageContext.request.contextPath}/static/images/streaming/next.png"
                                         alt="Like Button" width="30"
                                         height="30" style="border-radius: 8px; opacity: 0.75;">
                                </button>
                            </div>
                        </div>
                    </c:when>
                    <c:when test="${page == 'detail'}">
                        <div class="trackDetail">
                            <div class="trackDetailContainer">
                                <c:if test="${not empty trackDetail.album.images}">
                                    <!-- 첫 번째 이미지를 불러옵니다 -->
                                    <img src="${trackDetail.album.images[0].url}" alt="${trackDetail.name}" width="150"
                                         height="150" style="border-radius: 8px;">
                                </c:if>
                                <div class="trackDetailInfo">
                                    <p>곡</p>
                                    <p id="trackName" class="trackName">${trackDetail.name}</p>
                                    <p><!-- 아티스트 이미지 표시 -->
                                        <c:if test="${not empty artistDetail.images}">
                                            <img src="${artistDetail.images[0].url}" alt="${artistDetail.name}"
                                                 width="24" height="24" style="border-radius: 50%; margin-top: 10px;">
                                        </c:if> ${trackDetail.artists[0].name} • ${trackDetail.album.name}
                                        • ${albumDetail.releaseDate}</p>
                                </div>
                            </div>
                        </div>
                        <!-- 가사 출력 -->
                        <div class="lyrics">
                            <h3>가사</h3>
                            <pre>${lyrics}</pre>
                        </div>
                    </c:when>
                    <c:when test="${page == 'search'}">
                        <div class="resultContainer">
                            <h3>곡</h3>
                            <div class="searchResults">
                                <!-- 왼쪽 버튼 -->
                                <button class="searchSlideButton left" id="scrollLeftBtn" onclick="scrollLeftContent()">
                                    <img src="${pageContext.request.contextPath}/static/images/streaming/prev.png"
                                         alt="Like Button" width="30"
                                         height="30" style="border-radius: 8px; opacity: 0.75;">
                                </button>
                                <c:forEach var="track" items="${searchResults}">
                                    <div class="searchResult">
                                        <div class="searchCover" onclick="playAndNavigate('${track.id}');">
                                            <img src="${track.album.images[0].url}" alt="${track.name}" width="120"
                                                 height="120" style="border-radius: 8px;">
                                        </div>
                                        <div class="searchInfo">
                                            <p class="trackName">${track.name}</p>
                                            <p class="artistName">${track.artists[0].name}</p>
                                        </div>
                                    </div>
                                </c:forEach>
                                <!-- 오른쪽 버튼 -->
                                <button class="searchSlideButton right" id="scrollRightBtn" onclick="scrollRightContent()">
                                    <img src="${pageContext.request.contextPath}/static/images/streaming/next.png"
                                         alt="Like Button" width="30"
                                         height="30" style="border-radius: 8px; opacity: 0.75;">
                                </button>
                            </div>
                        </div>
                    </c:when>
                </c:choose>
            </div>
        </div>
    </div>
    <div class="mainDetailFrame"></div>
    <MainDetail/>
</div>
<div class="footer"></div>
</body>
</html>