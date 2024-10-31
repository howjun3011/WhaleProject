<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>hiddenFeed</title>
	<link rel="stylesheet" href="static/css/setting/settingStyle.css" />
	<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	<script src="static/js/setting/setting.js"></script>
	<style>
		.setting-container {
			display: flex;
			flex-direction: column; /* 헤더와 스크롤 콘텐츠를 세로로 배치 */
			overflow: hidden; /* 부모에서 스크롤 숨김 */
		}
		.scroll-content {
			flex: 1; /* 남은 공간을 차지 */
			overflow-y: auto; /* 세로 스크롤 활성화 */
		}
		#back {
			position: absolute;
			left: 15px;
			top: 55%;
			transform: translateY(-50%);
		}
		.no-hidden-list{
			margin-left: 20px;
			color: #ccc;
		}
		a{
			text-decoration: none;
			color: black;
		}
		a:visited, a:hover, a:focus, a:active {
			color: black;
			text-decoration: none;
		}

		.image-grid {
			display: grid;
			grid-template-columns: repeat(3, 1fr); /* 3개의 열 */
			gap: 10px; /* 이미지 사이 간격 */
			padding: 20px;
		}

		.image-item {
			position: relative;
			width: 100%;
			overflow: hidden;
		}

		.image-item::before {
			content: "";
			display: block;
			padding-top: 100%; /* 1:1 비율로 높이 설정 */
		}

		.image-item img {
			position: absolute;
			top: 0;
			left: 0;
			border-radius: 3px;
			width: 100%;
			height: 100%;
			object-fit: cover; /* 이미지의 비율을 유지하면서 컨테이너에 맞게 자름 */
		}
	</style>
</head>
<body>
<div class="setting-body">
	<div class="setting-container">
		<div class="setting-header">
			<a href="settingHome" id="back"><img src="static/images/setting/back.png" alt="back"></a>
			숨긴 피드
		</div>
		<div class="scroll-content">
			<c:choose>
				<c:when test="${empty hiddenFeedList}">
					<div class="no-hidden-list">숨긴 피드가 없습니다.</div>
				</c:when>
				<c:otherwise>
					<div class="image-grid">
						<c:forEach var="hidden" items="${hiddenFeedList}">
							<div class="image-item">
								<a href="/whale/feedDetail?f=${hidden.feed_id}">
									<img src="static/images/feed/${hidden.feed_img_name}" alt="feed_img">
								</a>
							</div>
						</c:forEach>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</div>
</body>
</html>
