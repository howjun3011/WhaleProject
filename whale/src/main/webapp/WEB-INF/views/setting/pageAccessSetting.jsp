<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>pageAccessSetting</title>
<link rel="stylesheet" href="static/css/setting/settingStyle.css" />
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="static/js/setting/setting.js"></script>
<style>
.setting-item{
	display: block;
	justify-content: space-between;
}
.section #section-top{
	font-weight: bold;
}
.radio-group{
	width: 100%;
	margin-top: 8px;
}
.radio-option{
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 3px;
}
.radio-option label{
	margin-bottom: 3px;
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
<div class="setting-body">
	<div class="setting-container">
		<div class="setting-header">페이지 접근 변경</div>
		
		<form>
			<div class="setting-item">
				<div class="section">
					<label id="section-top">마이페이지</label>
					<div class="radio-group">
						<div class="radio-option">
							<label for="mypage-left">왼쪽</label>
								<input type="radio" id="mypage-left" name="mypage" value="left">
						</div>
						<div class="radio-option">
							<label for="mypage-right">오른쪽</label>
								<input type="radio" id="mypage-right" name="mypage" value="right" checked>
						</div>
					</div>
				</div>
			</div>
			<div class="setting-item">
				<div class="section">
					<label id="section-top">알림</label>
					<div class="radio-group">
						<div class="radio-option">
							<label for="notification-left">왼쪽</label>
								<input type="radio" id="notification-left" name="notification" value="left" checked>
						</div>
						<div class="radio-option">
							<label for="notification-right">오른쪽</label>
								<input type="radio" id="notification-right" name="notification" value="right">
						</div>
					</div>
				</div>
			</div>
			<div class="setting-item">
				<div class="section">
					<label id="section-top">설정</label>
					<div class="radio-group">
						<div class="radio-option">
							<label for="setting-left">왼쪽</label>
								<input type="radio" id="setting-left" name="setting" value="left">
						</div>
						<div class="radio-option">
							<label for="setting-right">오른쪽</label>
								<input type="radio" id="setting-right" name="setting" value="right" checked>
						</div>
					</div>
				</div>
			</div>
			<div class="setting-item">
				<div class="section">
					<label id="section-top">음악</label>
					<div class="radio-group">
						<div class="radio-option">
							<label for="music-left">왼쪽</label>
								<input type="radio" id="music-left" name="music" value="left">
						</div>
						<div class="radio-option">
							<label for="music-right">오른쪽</label>
								<input type="radio" id="music-right" name="music" value="right" checked>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
</div>
<script>
	var mypage = ${mypage};
	var notification = ${notification};
	var setting = ${setting};
	var music = ${music};
	
	window.onload = function() {
		document.getElementById('mypage-left').checked = mypage == 0;
		document.getElementById('notification-left').checked = notification == 0;
		document.getElementById('setting-left').checked = setting == 0;
		document.getElementById('music-left').checked = music == 0;
		document.getElementById('mypage-right').checked = mypage == 1;
		document.getElementById('notification-right').checked = notification == 1;
		document.getElementById('setting-right').checked = setting == 1;
		document.getElementById('music-right').checked = music == 1;
		
		document.querySelector('.setting-container').addEventListener('change', function(event) {
			if(event.target.name === 'mypage' || event.target.name === 'notification' || event.target.name === 'setting' || event.target.name === 'music') {
				
				const settingType = event.target.name; 
				const selectedValue = event.target.value;
				
				updatePageAccessSetting(settingType, selectedValue);
			}
		});
	}
	
	function updatePageAccessSetting(settingType, selectedValue) {
	    $.ajax({
	        url: '/whale/updatePageAccessSetting',
	        type: 'POST',
	        data: {
	            settingType: settingType,
	            selectedValue: selectedValue
	        },
	        success: function(response) {
	            console.log('응답: ', response.message);
	        },
	        error: function(xhr, status, error) {
	            console.error('업데이트 실패: ', error);
	        }
	    });
	}

</script>
</body>
</html>