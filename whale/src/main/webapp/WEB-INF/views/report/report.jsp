<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="reportDo" method="post">
	<br />
		신고 항목 : <input type="text" name="report_tag" value="${report_tag}" readonly />
	    <br />

	    <input type="hidden" name="now_id" value="${now_id}" />
	    <input type="hidden" name="report_type_id" value="${report_type_id}" />
	    
		신고 사유 : 
		<textarea name="report_why" id="report_why" class="content">신고 사유를 입력해주십시오.</textarea> <br />
		<br />
		<input type="submit" value="Save" />
		<input type="button" value="Cancel" class="cancel" onClick="history.back();" />
	</form>
</body>
</html>