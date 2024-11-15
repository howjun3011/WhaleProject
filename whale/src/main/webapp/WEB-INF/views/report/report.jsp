<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<script src="${pageContext.request.contextPath}/static/js/setting/darkMode.js"></script>
<%--	<style>--%>
<%--		.container[data-darkmode="0"]{background: #f0f0f0; height: 100vh; overflow: hidden; display: flex; justify-content: center; align-items: center;}--%>
<%--		.container[data-darkmode="0"] form{background: #fff; padding: 40px; border-radius: 30px; font-weight: bold; font-size: 1.2rem;}--%>
<%--	</style>--%>
	<style>
		/* 컨테이너 스타일 */
		.container[data-darkmode="0"] {
			background: #f8f9fa; /* 밝은 배경 */
			height: 100vh;
			overflow: hidden;
			display: flex;
			justify-content: center;
			align-items: center;
			font-family: 'Arial', sans-serif;
			color: #333; /* 기본 텍스트 색상 */
		}

		/* 폼 스타일 */
		.container[data-darkmode="0"] form {
			background: #ffffff;
			padding: 30px 40px;
			border-radius: 20px;
			box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* 부드러운 그림자 */
			font-weight: 500;
			font-size: 1rem;
			width: 100%;
			max-width: 500px; /* 폼의 최대 너비 */
			box-sizing: border-box;
		}

		/* 입력 필드 및 텍스트 영역 */
		.container[data-darkmode="0"] input[type="text"],
		.container[data-darkmode="0"] textarea {
			width: 100%;
			padding: 10px 15px;
			margin: 10px 0 20px 0;
			border: 1px solid #ccc;
			border-radius: 8px;
			font-size: 1rem;
			box-sizing: border-box;
		}

		/* 입력 필드 및 텍스트 영역 focus */
		.container[data-darkmode="0"] input[type="text"]:focus,
		.container[data-darkmode="0"] textarea:focus {
			outline: none;
			border: 1px solid #007bff; /* 포커스 시 파란 테두리 */
			box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
		}

		/* 텍스트 영역 */
		.container[data-darkmode="0"] textarea {
			resize: none; /* 크기 조정 비활성화 */
			height: 120px; /* 기본 높이 */
		}

		/* 버튼 스타일 */
		.container[data-darkmode="0"] input[type="submit"],
		.container[data-darkmode="0"] input[type="button"] {
			background: #007bff;
			color: #ffffff;
			border: none;
			padding: 10px 20px;
			margin: 10px 5px 0 0;
			border-radius: 8px;
			cursor: pointer;
			font-size: 1rem;
			transition: background 0.3s ease;
		}

		.container[data-darkmode="0"] input[type="button"].cancel {
			background: #6c757d; /* 회색 */
		}

		/* 버튼 hover */
		.container[data-darkmode="0"] input[type="submit"]:hover {
			background: #0056b3; /* 짙은 파란색 */
		}

		.container[data-darkmode="0"] input[type="button"].cancel:hover {
			background: #5a6268; /* 짙은 회색 */
		}

		/* 라벨 및 텍스트 */
		.container[data-darkmode="0"] label {
			font-weight: bold;
			margin-bottom: 5px;
			display: inline-block;
		}

		/* 반응형 */
		@media (max-width: 600px) {
			.container[data-darkmode="0"] form {
				padding: 20px;
				font-size: 0.9rem;
			}

			.container[data-darkmode="0"] input[type="submit"],
			.container[data-darkmode="0"] input[type="button"] {
				font-size: 0.9rem;
				padding: 8px 15px;
			}
		}
	</style>

</head>
<body class="container">
	<form action="reportDo" method="post">
		신고 항목 : <input type="text" name="report_tag" value="${report_tag}" readonly />
	    <br />

	    <input type="hidden" name="now_id" value="${now_id}" />
	    <input type="hidden" name="report_type_id" value="${report_type_id}" />
	    <input type="hidden" name="userId" value="${userId}" />
	    
		신고 사유 : 
		<textarea name="report_why" id="report_why" class="content">신고 사유를 입력해주십시오.</textarea> <br />
		<br />
		<input type="submit" value="Save" />
		<input type="button" value="Cancel" class="cancel" onClick="history.back();" />
	</form>
</body>
<script>

</script>
</html>