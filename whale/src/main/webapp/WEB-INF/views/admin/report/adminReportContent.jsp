<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<div class="content" name="content" id="content">
	<h1>유저상세</h1>
	<table class="userInfo">
		<tr>
			<td rowspan="9" class="proImg" style="">
				<div>
					<c:if test="${not empty AccountUserInfo.user_image_url }">
						<img src="/whale/static/images/setting/${AccountUserInfo.user_image_url }" alt="프사" />
					</c:if>
					<c:if test="${empty AccountUserInfo.user_image_url }">
						null
					</c:if>
				</div>
			</td>
			<td>아이디</td>
			<td>${AccountUserInfo.user_id }</td>
		</tr>
		<tr>
			<td>닉네임</td>
			<td>${AccountUserInfo.user_nickname }</td>
		</tr>
		<tr>
			<td>이메일</td>
			<td>${AccountUserInfo.user_email }</td>
		</tr>
		<tr>
			<td>가입일</td>
			<td><fmt:formatDate value="${AccountUserInfo.user_date}" pattern="yyyy.MM.dd" /></td>
		</tr>
		<tr>
			<td>등급</td>
			<td>${AccountUserInfo.user_access_str }</td>
		</tr>
		<tr>
			<td>계정상태</td>
			<td>${AccountUserInfo.user_status_str }</td>
		</tr>
		<tr>
			<td>게시글</td>
			<td>${AccountUserInfo.post_count }</td>
		</tr>
		<tr>
			<td>피드</td>
			<td>${AccountUserInfo.feed_count }</td>
		</tr>
		<tr>
			<td>댓글</td>
			<td>${AccountUserInfo.comments_count }</td>
		</tr>
	</table>
	<hr />
	<table class="contentTable">
        <colgroup>
            <col width="15%" />
            <col width="35%" />
            <col width="15%" />
            <col width="35%" />
        </colgroup>
        <tbody>
            <tr>
                <th>구분</th>
                <td>${reportContent.report_tag }</td>
                <th>신고일</th>
                <td>${reportContent.report_date }</td>
            </tr>
            <tr>
                <th>중복신고</th>
                <td>${reportContent.same_content_count }</td>
                <th>처리일</th>
                <td>${reportContent.post_date }</td>
            </tr>
            <tr>
                <th>신고내용</th>
                <td colspan="3">${reportContent.post_title }</td>
            </tr>
            <tr>
                <th>신고글</th>
                <td colspan="3">${reportContent.post_text }</td>
            </tr>
			<tr>
			    <th>이미지</th>
			    <td colspan="3">
			        <c:forEach var="image" items="${reportContent.images}">
			        	<img src="/whale/static/images/community/${reportContent.post_img_name}" alt="Post Image">
			        </c:forEach>
			    </td>
			</tr>
        </tbody>
    </table>
	
	<br /><br /><br /><br />	
</div>