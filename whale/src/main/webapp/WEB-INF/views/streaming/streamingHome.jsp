<?xml version="1.0" encoding="UTF-8" ?>
<%@page import="com.tech.whale.main.models.MainAuthorizationCode"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="icon" href="static/images/main/whaleLogo.png">
	<link rel="stylesheet" href="static/css/streaming/streamingStyles.css" />
	<title>Whale Streaming</title>
	<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	<script src="static/js/streaming/mainFunction.js"></script>
</head>
<body>
	<div class="header">
        <div class="headerItems">
            <button class="homeBtn">
                <img src="static/images/streaming/homeBtn.png" alt="Music Whale Search Button" height="20px" @click="goMain()">
            </button>
            <div class="headerSearch">
                <button class="searchBtn" @click="goSearch()">
                    <img src="static/images/streaming/searchBtn.png" alt="Music Whale Search Button" height="14px">
                </button>
                <input class="headerInput" placeholder="어떤 콘텐츠를 감상하고 싶으세요?" onfocus="this.placeholder=''" onblur="this.placeholder='어떤 콘텐츠를 감상하고 싶으세요?'" v-model="this.query">
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
				    <div class="recommendations">
				        <div class="recommendationTitle"><p class="titleName">내가 즐겨 듣는 노래</p></div>
				        <div class="recommendationContents">
							<!-- trackPaging 데이터를 반복문으로 출력 -->
							<c:forEach var="track" items="${trackPaging.items}">
								<div class="recommendationContent">
									<div class="recommendationLike" onclick="insertTrack('${track.id}')">
										<img src="static/images/streaming/like.png" alt="Like Button" width="30" height="30" style="border-radius: 8px; opacity: 0.75;">
									</div>
									<div class="recommendationCover">
										<img src="${track.album.images[0].url}" alt="${track.name}" width="120" height="120" style="border-radius: 8px;">
									</div>
									<div class="recommendationPlay" onclick="playTrack('${track.id}')">
										<img src="static/images/streaming/play.png" alt="Like Button" width="30" height="30" style="border-radius: 8px; opacity: 0.75;">
									</div>
									<div class="recommendationInfo">
										<p class="trackName">${track.name}</p>
										<p class="artistName">${track.artists[0].name}</p>
									</div>
								</div>
							</c:forEach>
				        </div>
				    </div>
	            </div>
	        </div>
	    </div>
		<div class="mainDetailFrame"></div>
        <MainDetail />
    </div>
    <div class="footer"></div>
</body>
</html>