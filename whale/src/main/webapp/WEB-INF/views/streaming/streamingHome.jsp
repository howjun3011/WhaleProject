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
    <!-- 조건에 따라 JavaScript 파일을 포함 -->
    <c:if test="${page == 'detail' || page == 'playlistDetail' || page == 'artistDetail' || page == 'albumDetail'}">
        <script src="${pageContext.request.contextPath}/static/js/streaming/mainContentBackground.js" defer></script>
    </c:if>
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
            <p class="mainLibraryName">내 라이브러리</p>
            <div class="userPlaylists">
            	<div class="playlist-content">
            		<div class="playlistCover">
            			<img src="https://misc.scdn.co/liked-songs/liked-songs-64.png" alt="WHALE LIKE TRACK" width="45" height="45"
            			style="border-radius: 2px; opacity: 0.8;">
                    </div>
                    <div class="libraryInfo">
                    	<p class="libraryInfoFont">좋아요 표시한 곡</p>
                    	<p class="libraryInfoFont" style="margin-top: 2px; font-size: 10px;">플레이리스트•5곡</p>
                    </div>
                </div>
                <c:forEach var="playlist" items="${userPlaylists}">
                    <div class="playlist-content">
                        <c:if test="${not empty playlist.images}">
                        	<div class="playlistCover" onclick="playPlaylist('${playlist.id}')">
                        		<img src="${playlist.images[0].url}" alt="${playlist.name}" width="45" height="45"
                                 style="border-radius: 2px; opacity: 0.8;">
                        	</div>
                        	<div class="libraryInfo">
                        		<p class="libraryInfoFont">${playlist.name}</p>
                        		<p class="libraryInfoFont" style="margin-top: 2px; font-size: 10px;">플레이리스트•${playlist.owner.displayName}</p>
                        	</div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
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
                                            <div class="recommendationLike"
                                                 onclick="insertTrackLike('<c:out value="${track.album.images[0].url}" />', '<c:out value="${fn:escapeXml(track.name)}" />', '<c:out value="${fn:escapeXml(track.artists[0].name)}" />', '<c:out value="${fn:escapeXml(track.album.name)}" />', '${track.id}', false)">
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
                                                <p class="trackName"
                                                   onclick="navigateToDetail('${track.id}')">${track.name}</p>
                                                <p class="artistName"
                                                   onclick="navigateToArtistDetail('${track.artists[0].id}')">${track.artists[0].name}</p>
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
                                    <img src="${trackDetail.album.images[0].url}" alt="${trackDetail.name}" width="230"
                                         height="230" style="border-radius: 8px;">
                                </c:if>
                                <div class="trackDetailInfo">
                                    <p class="detailSort">곡</p>
                                    <p id="trackName" class="trackName">${trackDetail.name}</p>
                                    <div class="trackDescription">
                                        <!-- 아티스트 이미지 표시 -->
                                        <c:if test="${not empty artistDetail.images}">
                                            <img src="${artistDetail.images[0].url}" alt="${artistDetail.name}"
                                                 width="24" height="24" style="border-radius: 50%;">
                                        </c:if>
                                        <p class="artistName" style="margin-left: 2px;" onclick="navigateToArtistDetail('${trackDetail.artists[0].id}')">${trackDetail.artists[0].name}</p>
                                        <p> • </p>
                                        <p class="albumName" onclick="navigateToAlbumDetail('${trackDetail.album.id}')">${trackDetail.album.name}</p>
                                        <p> • </p>
                                        <p>${albumDetail.releaseDate}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button class="playAllButton">
                        	<svg style="width: 20px;" data-v-057e38be="" data-encore-id="icon" role="img"
                                 aria-hidden="true" viewBox="0 0 24 24" class="playlistBtn">
                                 <path data-v-057e38be=""
                                      d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"></path>
                            </svg>
                        </button>
                        <!-- 가사 출력 -->
                        <div class="lyrics">
                            <h3>가사</h3>
                            <pre>${lyrics}</pre>
                        </div>
                    </c:when>
                    <c:when test="${page == 'search'}">
                        <div class="resultContainer">
                            <h3 class="resultContainerTitle">곡</h3>
                            <div class="searchResults">
                                <!-- 왼쪽 버튼 -->
                                <button class="searchSlideButton left" id="searchScrollLeftBtn"
                                        onclick="scrollLeftSearchContent()">
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
                                            <p class="artistName"
                                               onclick="navigateToArtistDetail('${track.artists[0].id}')">${track.artists[0].name}</p>
                                        </div>
                                    </div>
                                </c:forEach>
                                <!-- 오른쪽 버튼 -->
                                <button class="searchSlideButton right" id="searchScrollRightBtn"
                                        onclick="scrollRightSearchContent()">
                                    <img src="${pageContext.request.contextPath}/static/images/streaming/next.png"
                                         alt="Like Button" width="30"
                                         height="30" style="border-radius: 8px; opacity: 0.75;">
                                </button>
                            </div>
                        </div>
                    </c:when>
                    <c:when test="${page == 'artistDetail'}">
                        <div class="artistDetail">
                            <div class="artistDetailContainer">
                                <div class="artistDetailInfo">
                                    <div class="artistDetailWrap">
                                        <div class="artistDetailImage">
                                            <c:if test="${not empty artistDetail.images}">
                                                <!-- 첫 번째 이미지를 불러옵니다 -->
                                                <img src="${artistDetail.images[0].url}" alt="${artistDetail.name}"
                                                     width="230"
                                                     height="230" style="border-radius: 8px;">
                                            </c:if>
                                        </div>
                                        <div class="artistDetailGenre">
                                            <p class="detailSort">아티스트</p>
                                            <p id="artistName" class="trackName">${artistDetail.name}</p>
                                                <%--<p>팔로워 수: ${artistDetail.followers.total}</p>--%>
                                            <p class="artistDesc">장르:
                                                <c:forEach var="genre" items="${artistDetail.genres}"
                                                           varStatus="status">
                                                    ${genre}<c:if test="${!status.last}">, </c:if>
                                                </c:forEach>
                                            </p>
                                                <%--<p>인기도: ${artistDetail.popularity}</p>--%>
                                        </div>
                                    </div>


                                    <!-- 인기 곡 목록 -->
                                    <div class="topTracks">
                                        <h3 style="margin: 0 0 15px 10px;">인기</h3>
                                        <div class="topTracks-tracks" style="height: 25px; margin-top: 5px; pointer-events: none;">
                                            <div class="topTracks-tracks-top" style="justify-content: center;">#</div>
                                            <div class="topTracks-tracks-top" style="padding-left: 5px;">제목</div>
                                            <div class="topTracks-tracks-top" style="padding-left: 5px;">앨범</div>
                                            <div class="topTracks-tracks-top" style="justify-content: center;">시간</div>
                                        </div>
                                        <c:forEach var="track" items="${topTracks}" varStatus="status">
                                            <div class="topTrackItem">
                                                <!-- 순위 표시 -->
                                                <span class="rank">${status.index + 1}</span>
                                                <!-- 재생/일시정지 버튼 -->
                                                <button class="playPauseButton"
                                                        onclick="togglePlayPause('${track.id}', this)">
                                                    <svg class="icon" style="width: 20px; filter: invert(1);"
                                                         viewBox="0 0 24 24">
                                                        <!-- 초기 재생 아이콘 -->
                                                        <path d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"></path>
                                                    </svg>
                                                </button>
                                                <div class="topTrackInfo" onclick="playAndNavigate('${track.id}');">
                                                    <!-- 곡 이미지와 이름 -->
                                                    <c:if test="${not empty track.album.images}">
                                                        <!-- 곡 이미지 클릭 시 재생 후 디테일 페이지로 이동 -->
                                                        <img src="${track.album.images[0].url}" alt="${track.name}"
                                                             width="50" height="50"
                                                             style="border-radius: 4px; padding-left: 5px; cursor: pointer;"
                                                             onclick="playAndNavigate('${track.id}')">
                                                    </c:if>
                                                    <p>${track.name}</p>
                                                </div>
                                                <!-- 앨범 이름 -->
                                                <p class="albumName" onclick="navigateToAlbumDetail('${track.album.id}')"
                                                   style="padding-left: 5px;">${track.album.name}</p>
                                                <!-- 트랙의 길이 표시 (분/초 변환) -->
                                                <c:set var="minutes" value="${track.durationMs / 60000}"/>
                                                <c:set var="seconds" value="${(track.durationMs % 60000) / 1000}"/>

                                                <!-- 소수점 제거 후 출력 -->
                                                <p style="justify-content: center;">${minutes.intValue()}분 ${seconds.intValue()}초</p>

                                            </div>
                                        </c:forEach>
                                    </div>
                                    <div class="albumsContainer">
                                        <h3 class="albumsContainerTitle">앨범</h3>
                                        <!-- 왼쪽 버튼 -->
                                        <button class="artistDetailSlideButton left" id="artistDetailScrollLeftBtn"
                                                onclick="scrollLeftArtistDetailContent()">
                                            <img src="${pageContext.request.contextPath}/static/images/streaming/prev.png"
                                                 alt="Like Button" width="30"
                                                 height="30" style="border-radius: 8px; opacity: 0.75;">
                                        </button>
                                        <!-- 앨범 목록 -->
                                        <div class="albums">
                                            <div class="albumsWrap">
                                                <c:forEach var="album" items="${albums}">
                                                    <div class="albumItem"
                                                         onclick="navigateToAlbumDetail('${album.id}')">
                                                        <c:if test="${not empty album.images}">
                                                            <img src="${album.images[0].url}" alt="${album.name}"
                                                                 width="150"
                                                                 height="150" style="border-radius: 4px;">
                                                        </c:if>
                                                        <p class="trackName" style="margin-left: 2px; font-size: 14px;">${album.name}</p>
                                                        <p class="trackName" style="margin-left: 2px; font-size: 13px;">${album.releaseDate}</p>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <!-- 오른쪽 버튼 -->
                                        <button class="artistDetailSlideButton right" id="artistDetailScrollRightBtn"
                                                onclick="scrollRightArtistDetailContent()">
                                            <img src="${pageContext.request.contextPath}/static/images/streaming/next.png"
                                                 alt="Like Button" width="30"
                                                 height="30" style="border-radius: 8px; opacity: 0.75;">
                                        </button>
                                    </div>
                                    <!-- 연관된 아티스트 목록 -->
                                        <%--                                    <div class="relatedArtists">--%>
                                        <%--                                        <h3>연관된 아티스트</h3>--%>
                                        <%--                                        <c:forEach var="relatedArtist" items="${relatedArtists}">--%>
                                        <%--                                            <p>${relatedArtist.name}</p>--%>
                                        <%--                                        </c:forEach>--%>
                                        <%--                                    </div>--%>
                                    <!-- 관련된 플레이리스트 목록 -->
                                    <div class="playListContainer">
                                        <h3 class="playListContainerTitle">관련된 플레이리스트</h3>
                                        <!-- 왼쪽 버튼 -->
                                        <button class="playListSlideButton left" id="playListScrollLeftBtn"
                                                onclick="scrollLeftPlayListContent()">
                                            <img src="${pageContext.request.contextPath}/static/images/streaming/prev.png"
                                                 alt="Like Button" width="30"
                                                 height="30" style="border-radius: 8px; opacity: 0.75;">
                                        </button>
                                        <div class="relatedPlaylists">
                                            <c:forEach var="playlist" items="${relatedPlaylists}">
                                                <div class="playlistItem">
                                                    <c:if test="${not empty playlist.images}">
                                                        <img src="${playlist.images[0].url}" alt="${playlist.name}"
                                                             width="150" height="150" style="border-radius: 4px;"
                                                             onclick="playPlaylist('${playlist.id}')">
                                                    </c:if>
                                                    <p class="trackName" style="margin-left: 2px; font-size: 14px;">${playlist.name}</p>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <!-- 오른쪽 버튼 -->
                                        <button class="playListSlideButton right" id="playListScrollRightBtn"
                                                onclick="scrollRightPlayListContent()">
                                            <img src="${pageContext.request.contextPath}/static/images/streaming/next.png"
                                                 alt="Like Button" width="30"
                                                 height="30" style="border-radius: 8px; opacity: 0.75;">
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:when test="${page == 'playlistDetail'}">
                        <div class="playlistDetail">
                            <div class="playListInfo">
                                <c:if test="${not empty playlistDetail.images}">
                                    <img src="${playlistDetail.images[0].url}" alt="${playlistDetail.name}" width="170"
                                         height="170" style="border-radius: 8px;">
                                </c:if>
                                <div>
                                    <p class="detailSort">플레이리스트</p>
                                    <h1 id="playlistName">${playlistDetail.name}</h1>
                                    <p class="playlistDesc">설명: ${playlistDetail.description}</p>
                                    <p class="playlistOpt">WHALE • ${playlistDetail.tracks.total}곡</p>
                                </div>
                            </div>
                            <!-- 전체 재생 버튼 추가 -->
                            <button class="playAllButton" onclick="playAllPlaylist('${playlistDetail.id}')">
                                <svg style="width: 20px;" data-v-057e38be="" data-encore-id="icon" role="img"
                                     aria-hidden="true" viewBox="0 0 24 24" class="playlistBtn">
                                    <path data-v-057e38be=""
                                          d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"></path>
                                </svg>
                            </button>
                            <div class="playlist-tracks" style="height: 25px; margin-top: 5px; pointer-events: none;">
                                <div class="playlist-tracks-top" style="justify-content: center;">#</div>
                                <div class="playlist-tracks-top" style="padding-left: 10px;">제목</div>
                                <div class="playlist-tracks-top" style="padding-left: 5px;">앨범</div>
                                <div class="playlist-tracks-top" style="justify-content: center;">시간</div>
                            </div>
                            <div class="playlistTracks">
                                <c:forEach var="trackItem" items="${playlistDetail.tracks.items}" varStatus="status">
                                    <div class="trackItem"
                                         style="${status.last ? 'padding-bottom: 20px;' : ''}">
                                        <!-- 순위 표시 -->
                                        <span class="rank">${status.index + 1}</span>
                                        <!-- 재생/일시정지 버튼 -->
                                        <button class="playPauseButton"
                                                onclick="togglePlayPause('${trackItem.track.id}', this)">
                                            <svg class="icon" style="width: 20px;"
                                                 viewBox="0 0 24 24">
                                                <path d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"></path>
                                            </svg>
                                        </button>
                                        <div class="trackImageAndTitle" onclick="playAndNavigate('${trackItem.track.id}');">
                                            <!-- 트랙 이미지 표시 -->
                                            <c:if test="${not empty trackItem.track.album.images}">
                                                <img src="${trackItem.track.album.images[0].url}"
                                                     alt="${trackItem.track.name}" width="50" height="50"
                                                     style="border-radius: 4px; padding-left: 5px;">
                                            </c:if>
                                            <!-- 트랙 제목과 아티스트 이름 표시 -->
                                            <p>${trackItem.track.name} - ${trackItem.track.artists[0].name}</p>
                                        </div>
                                        <!-- 앨범 이름 -->
                                        <p class="albumName"
                                           style="padding-left: 5px;">${trackItem.track.album.name}</p>
                                        <!-- 트랙 재생 시간 표시 -->
                                        <c:set var="minutes" value="${trackItem.track.durationMs / 60000}"/>
                                        <c:set var="seconds" value="${(trackItem.track.durationMs % 60000) / 1000}"/>
                                        <!-- 소수점 제거 후 출력 -->
                                        <p style="justify-content: center;">${minutes.intValue()}분 ${seconds.intValue()}초</p>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:when>
                    <c:when test="${page == 'albumDetail'}">
                        <div class="albumDetail">
                            <!-- 앨범 이미지와 제목, 발매일 -->
                            <div class="albumInfo">
                                <c:if test="${not empty albumDetail.images}">
                                    <img src="${albumDetail.images[0].url}" alt="${albumDetail.name}" width="230"
                                         height="230"
                                         style="border-radius: 8px;">
                                </c:if>
                                <div class="trackDetailInfo">
                                    <p class="detailSort">${albumDetail.albumType}</p>
                                    <p id="trackName" class="trackName">${albumDetail.name}</p>
                                    <div class="trackDescription">
                                        <!-- 아티스트 이미지 표시 -->
                                        <c:if test="${not empty artistDetail.images}">
                                            <img src="${artistDetail.images[0].url}" alt="${artistDetail.name}"
                                                 width="24" height="24" style="border-radius: 50%;">
                                        </c:if>
                                        <p class="artistName" style="margin-left: 2px;" onclick="navigateToArtistDetail('${albumDetail.artists[0].id}')">${albumDetail.artists[0].name}</p>
                                        <p> • </p>
                                        <!-- 앨범 전체 시간 구하기 -->
                                        <c:set var="albumTotal" value="0"/>
                                        <c:forEach var="trackItem" items="${tracks}" varStatus="status">
	                                        <c:set var="albumTotal" value="${albumTotal+trackItem.durationMs}"/>
                                        </c:forEach>
                                        <p>${fn:length(tracks)}곡</p>
                                        <p> • </p>
                                        <!-- 소수점 제거 후 출력 -->
                                        <p>${(albumTotal / 60000).intValue()}분 ${((albumTotal % 60000) / 1000).intValue()}초</p>
                                        <p> • </p>
                                        <p>${albumDetail.releaseDate}</p>
                                    </div>
                                </div>
                            </div>
                            <!-- 전체 재생 버튼 추가 -->
                            <button class="playAllButton">
                                <svg style="width: 20px;" data-v-057e38be="" data-encore-id="icon" role="img"
                                     aria-hidden="true" viewBox="0 0 24 24" class="playlistBtn">
                                    <path data-v-057e38be=""
                                          d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"></path>
                                </svg>
                            </button>
                            <div class="playlist-tracks" style="height: 25px; grid-template-columns: 6% 83% 11%; margin-top: 5px; pointer-events: none;">
                                <div class="playlist-tracks-top" style="justify-content: center;">#</div>
                                <div class="playlist-tracks-top" style="padding-left: 5px;">제목</div>
                                <div class="playlist-tracks-top" style="justify-content: center;">시간</div>
                            </div>
                            <!-- 트랙 목록 -->
                            <div class="albumTracks">
                                <c:forEach var="trackItem" items="${tracks}" varStatus="status">
                                    <div class="trackItem" onclick="playAndNavigate('${trackItem.id}');"
                                         style="${status.last ? 'padding-bottom: 20px;' : ''}">
                                        <!-- 순위 표시 -->
                                        <span class="rank">${status.index + 1}</span>
                                        <!-- 재생/일시정지 버튼 -->
                                        <button class="playPauseButton"
                                                onclick="togglePlayPause('${trackItem.id}', this)">
                                            <svg class="icon" style="width: 20px; filter: invert(1);"
                                                 viewBox="0 0 24 24">
                                                <path d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"></path>
                                            </svg>
                                        </button>
                                        <!-- 트랙 제목과 아티스트 이름 표시 -->
                                        <div style="display: block;">
                                        	<p style="font-weight: 400;">${trackItem.name}</p>
                                        	<p>${trackItem.artists[0].name}</p>
                                        </div>
                                        <!-- 트랙 재생 시간 표시 -->
                                        <c:set var="minutes" value="${trackItem.durationMs / 60000}"/>
                                        <c:set var="seconds" value="${(trackItem.durationMs % 60000) / 1000}"/>
                                        <!-- 소수점 제거 후 출력 -->
                                        <p style="justify-content: center;">${minutes.intValue()}분 ${seconds.intValue()}초</p>
                                    </div>
                                </c:forEach>
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