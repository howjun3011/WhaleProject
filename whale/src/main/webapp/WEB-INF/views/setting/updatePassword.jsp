<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>updatePassword</title>
	<link rel="stylesheet" href="static/css/setting/settingStyle.css" />
	<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	<script src="static/js/setting/setting.js"></script>
	<style>
		a{
			text-decoration: none;
			color: black;
		}
		a:visited, a:hover, a:focus, a:active {
			color: black;
			text-decoration: none;
		}
		#back {
			position: absolute;
			left: 15px;
			top: 55%;
			transform: translateY(-50%);
		}
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
		button{
			background-color: transparent;
			border: none;
			cursor: pointer;
			margin-left: 5px;
		}
		button:hover{
			color: #9f9f9f;
		}
		/* 변경할 비밀번호 필드 기본적으로 숨기기 */
		#new-password-fields {
			display: none;
		}
		#current-password-fields{
			margin-top: 20px;
			margin-left: 20px;
		}
		/* 필드와 이미지를 같은 줄에 정렬 */
		.input-container{
			display: flex;
			align-items: center;
			margin-top: 20px;
			margin-left: 20px;
		}
		.hint-icon img {
			width: 17px;
			height: 17px;
		}
		#current-password-fields input{
			margin-left: 10px;
		}
		.input-container input{
			margin-left: 10px;
		}
		#password_hint, #password_match_hint {
			margin-left: 5px;
			font-size: 13px;
		}

		input[type="password"] {
			padding: 5px;
			background-color: #FCFCFC;
			border: none; /* 테두리 없애기 */
			border-bottom: 2px solid #ccc; /* 밑줄 추가 */
			outline: none; /* 포커스 시 파란 테두리 없애기 */
		}
		input[type="password"]:focus {
			border-bottom: 2px solid #7E7E7E; /* 포커스 시 밑줄 색 변경 */
		}
	</style>
	<script>
		$(document).ready(function() {
			// 비밀번호 입력 이벤트를 제대로 바인딩
			$("#update_password, #check_password").on("input", validatePassword);
		});

		function checkCurrentPassword(current_password) {
			console.log("Current Password: ", current_password); // 입력된 비밀번호 로그 확인

			$.ajax({
				url: "/whale/checkCurrentPassword", // 서버의 API URL
				type: "POST",
				data: { current_password: current_password }, // 사용자가 입력한 비밀번호를 전송
				success: function(response) {
					console.log("응답: ", response); // 서버에서 받은 응답 로그

					// 응답의 status가 'valid'인 경우
					if (response.status === "valid") {
						alert("비밀번호가 확인되었습니다.");
						// 현재 비밀번호 필드와 버튼 숨기기
						$("#current-password-fields").hide();
						// 새로운 비밀번호 필드 보이기
						$("#new-password-fields").show();
					} else {
						alert("현재 비밀번호가 일치하지 않습니다.");
					}
				},
				error: function(xhr, status, error) {
					console.error("오류: ", error); // 오류 로그
					alert("서버와 통신 중 문제가 발생했습니다.");
				}
			});
		}

		// 비밀번호 유효성 검사 함수
		function validatePassword() {
			let newPassword = $("#update_password").val();
			let checkPassword = $("#check_password").val();
			let passwordRegex = /^.{4,}$/;

			// 비밀번호가 4자리 이상인지 검사
			if(newPassword.length === 0) {
				$("#password_hint").html("");
			} else if (!passwordRegex.test(newPassword)) {
				$("#password_hint").text("4자리 이상 입력").css("color", "red");
			} else {
				$("#password_hint").html('<img src="static/images/setting/passcheck.png" alt="일치">');
			}

			// 두 비밀번호가 일치하는지 검사
			if(newPassword.length === 0 || checkPassword.length === 0) { // 필드가 비어있으면
				$("#password_match_hint").html("");
			} else if (newPassword === checkPassword && passwordRegex.test(newPassword)) { // 정규식을 만족하면서 두 필드가 일치할 때
				// 이미지 동적 추가
				$("#password_match_hint").html('<img src="static/images/setting/passcheck.png" alt="일치">');

			} else {
				$("#password_match_hint").text("불일치").css("color", "red");
			}
		}

		function updatePassword() {
			let newPassword = $("#update_password").val();
			let checkPassword = $("#check_password").val();

			if (newPassword !== checkPassword) {
				alert("비밀번호가 일치하지 않습니다.");
				return;
			}

			console.log("new_password:", newPassword); // 값 확인

			$.ajax({
				url: "/whale/updateNewPassword",
				type: "POST",
				data: { new_password: newPassword },
				success: function(response) {
					// JSON 응답 처리
					if (response.status === "success") {
						alert("비밀번호가 성공적으로 변경되었습니다.");
						window.location.href = "/whale/profileEdit";
					} else {
						alert("비밀번호 변경에 실패했습니다.");
					}
				},
				error: function(xhr, status, error) {
					console.error("오류: ", error); // 오류 로그
					alert("비밀번호 변경 요청에 실패했습니다: " + xhr.responseText);
				}
			});
		}

	</script>
</head>
<body>
<div class="setting-body">
	<div class="setting-container">
		<div class="setting-header">
			<a href="profileEdit" id="back"><img src="static/images/setting/back.png" alt="back"></a>
			비밀번호 변경
			<button type="button" id="completeBtn" class="complete-btn" onclick="updatePassword();">완료</button>
		</div>
		<div id="current-password-fields">현재 비밀번호
			<input type="password" id="current_password" name="current_password" />
			<button type="button" onclick="checkCurrentPassword($('#current_password').val());">확인</button>
		</div>
		<div id="new-password-fields">
			<div class="input-container">변경할 비밀번호
				<input type="password" id="update_password" name="update_password" />
				<span id="password_hint" class="hint-icon"></span>
			</div>
			<div class="input-container">변경할 비밀번호 확인
				<input type="password" id="check_password" name="check_password" />
				<span id="password_match_hint" class="hint-icon"></span>
			</div>
		</div>
	</div>
</div>
</body>
</html>