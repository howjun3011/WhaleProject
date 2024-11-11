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
	<script src="static/js/setting/darkMode.js"></script>
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
		#back {
			position: absolute;
			left: 15px;
			top: 55%;
			transform: translateY(-50%);
		}
		input[type='radio'] {
			margin-left: auto;
			margin-right: 0;
			/* 기본스타일 지우고 라디오 버튼 구현 */
			-webkit-appearance: none; /* 웹킷 브라우저에서 기본 스타일 제거  */
			-moz-appearance: none; /* 모질라 브라우저에서 기본 스타일 제거 */
			appearance: none; /* 기본 브라우저에서 기본 스타일 제거 */
			width: 13px;
			height: 13px;
			border: 1px solid #ccc; /* 체크되지 않았을 때의 테두리 색상 */
			border-radius: 50%;
			outline: none; /* focus 시에 나타나는 기본 스타일 제거 */
			cursor: pointer;
		}
		input[type='radio']:checked {
			background-color: black; /* 체크 시 내부 원으로 표시될 색상 */
			border: 3px solid #ccc; /* 테두리와 원 사이의 색상 */
			box-shadow: 0 0 0 1.6px black; /* 테두리, 그림자로 테두리를 직접 만들어야 함 (퍼지는 정도를 0으로 주면 테두리처럼 보임, 그림자가 없으면 그냥 설정한 색상이 꽉 찬 원으로 나옴) */
		}
	</style>
</head>
<body>
	<div class="setting-body" data-darkmode="${darkMode.scndAttrName}">
		<div class="setting-container">
			<div class="setting-header">
				<a href="profileEdit" id="back"><img src="static/images/setting/back.png" alt="back"></a>
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
			.then(response => {
				if(response.ok) {
					// 서버에서 성공 응답을 받은 경우 페이지 이동
					window.location.href = '/whale/profileEdit';
				} else {
					console.log('서버 응답에 오류가 있습니다.');
				}
			})
			.catch(error => {
				console.log('요청 중 오류 발생:', error);
			});
		});
	</script>
</body>
</html>