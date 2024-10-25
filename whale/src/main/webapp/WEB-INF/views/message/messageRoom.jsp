<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="../static/css/message/messageRoom.css">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<div class="top">
			<div class="top-left">
				<img class="profile-img"
					src="../static/images/message/test/people.png" />
				<div class="profile-name">${ids }</div>
			</div>
		</div>

		<div class="middle">
			<div class="you1">
				<img class="chat-img" src="../static/images/message/test/people.png" />
				<div class="you">
					<div class="chat-name">내 친구</div>
					밥 머것냐?
					<div class="you-time">오후 3:40</div>
				</div>
			</div>
			<div class="me1">
				<div class="me">
					ㅇㅇ
					<div class="me-time">오후 3:40</div>
				</div>
				<br>
				<div class="me">
					너는?
					<div class="me-time">오후 3:41</div>
				</div>
				<br>
				<div class="me">
					너는?
					<div class="me-time">오후 3:41</div>
				</div>
				<br>
				<div class="me">
					너는?
					<div class="me-time">오후 3:41</div>
				</div>
				<br>
				<div class="me">
					너는?
					<div class="me-time">오후 3:41</div>
				</div>
				<br>
				<div class="me">
					너는?
					<div class="me-time">오후 3:41</div>
				</div>
				<br>
				<div class="me">
					너는?
					<div class="me-time">오후 3:41</div>
				</div>
				<br>
				<div class="me">
					너는?
					<div class="me-time">오후 3:41</div>
				</div>
				<br>
				<div class="me">
					너는?
					<div class="me-time">오후 3:41</div>
				</div>
				<br>
				<div class="me">
					너는?
					<div class="me-time">오후 3:41</div>
				</div>
				<br>
				<div class="me">
					너는?
					<div class="me-time">오후 3:41</div>
				</div>
			</div>

			<div class="bottom">
				<textarea class="textarea"></textarea>
				<button type="submit" class="button">전송</button>
				<div class="option">
				<input type="submit" id="emoji_btn" onchange="previewImage(event)" style='display: none;'>
					<img class="emoticon" src="../static/images/message/emoji.svg" onclick='document.all.emoji_btn.click();' />
					<input type="file" id="file" accept="image/png, image/jpeg"
						multiple onchange="previewImage(event)" style='display: none;'>
					<img class="file" src="../static/images/message/picture.svg"
						onclick='document.all.file.click();' />
				</div>
			</div>
		</div>
</body>
</html>