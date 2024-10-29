<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>representiveSong</title>
	<link rel="stylesheet" href="static/css/setting/settingStyle.css" />
	<link rel="stylesheet" href="static/css/streaming/searchView.css" />
	<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	<script src="static/js/setting/setting.js"></script>
	<style>
		.complete-btn {
			font-size: 20px;
			position: absolute;
			top: 15px;
			right: 7px;
			background-color: transparent; /* 버튼의 배경색을 투명으로 설정 */
			border: none;
			padding: 5px 10px;
			border-radius: 4px;
			cursor: pointer;
		}
		
		.complete-btn:hover {
			color: #5A5A5A;
		}
	</style>
</head>
<body>
	<div class="setting-body">
		<div class="setting-container">
			<div class="setting-header">
				대표곡 설정
				<button type="button" id="completeBtn" class="complete-btn">완료</button>
			</div>
			<div class="searchContainer">
				<div class="headerSearch">
					<button class="searchBtn" id="search-button">
						<img src="static/images/streaming/searchBtn.png" alt="Music Whale Search Button" height="14px">
				    </button>
				    <input class="headerInput" id="search-input" placeholder="어떤 콘텐츠를 감상하고 싶으세요?" onfocus="this.placeholder=''" onblur="this.placeholder='어떤 콘텐츠를 감상하고 싶으세요?'">
				</div>
			</div>
			<div class="search-result-container">
				<div id="pagination"></div>
				<div id="search-results"></div>
			</div>
		</div>
	</div>
	<script src="static/js/streaming/searchView.js"></script>
	<script>
		// 완료 버튼 클릭 시 데이터 업데이트
		document.getElementById("completeBtn").addEventListener("click", function() {
			const body = $('input[name="track"]:checked')[0].value;
			fetch(`/whale/updateRepresentive`, {
				headers: {
					'Accept': 'application/json',
		            'Content-Type': 'application/json'
		        },
		        method: 'POST',
		        body: body
			})
		});
	</script>
</body>
</html>