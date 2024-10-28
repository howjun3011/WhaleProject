<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
    function confirmUpdate() {
        var result = confirm("저장하시겠습니까?");
        if (result) {
            document.getElementById("nicknameForm").submit();
        } else {
            alert("취소되었습니다.");
        }
    }
    function accessModify() {
        var result = confirm("저장하시겠습니까?");
        if (result) {
            document.getElementById("accessForm").submit();
        } else {
            alert("취소되었습니다.");
        }
    }

    function confirmDelete() {
        var result = confirm("삭제하시겠습니까?");
        if (result) {
            window.location.href =
            	"adminUserImgDelete?userId=${AccountUserInfo.user_id }&userImgUrl=${AccountUserInfo.user_image_url }";
        } else {
            alert("취소되었습니다.");
        }
    }

</script>

<div class="content" name="content" id="content">
	<div calss="userInfoForm">
		<table class="userInfo">
			<tr>
				<td rowspan="5" class="proImg" style="">
					<div>
						<c:if test="${not empty AccountUserInfo.user_image_url }">
							<img src="/whale/static/images/setting/${AccountUserInfo.user_image_url }" alt="프사" />
						</c:if>
						<c:if test="${empty AccountUserInfo.user_image_url }">
							프로필사진 없음
						</c:if>
					</div>
					<button onclick="confirmDelete()" >사진 삭제</button>
				</td>
				<td>아이디</td>
				<td>${AccountUserInfo.user_id }</td>
			</tr>
			<tr>
				<td>닉네임</td>
				<form id="nicknameForm" action="adminUserNicknameModify" method="post">
				<td>
					<input type="hidden" name="userId" value="${AccountUserInfo.user_id }" />&nbsp;
					<input type="text" name="userNickname" value="${AccountUserInfo.user_nickname }" />
					<button onclick="confirmUpdate()" >수정</button>
				</td>
				</form>
			</tr>
			<tr>
				<td>이메일</td>
				<td>${AccountUserInfo.user_email }</td>
			</tr>
			<tr>
				<td>등급</td>
				<td>${AccountUserInfo.user_access_str }</td>
			</tr>
			<tr>
				<td>계정상태</td>
				<td>
				${AccountUserInfo.user_status_str } &nbsp;
				<input type="button" value="수정" />
				</td>
			</tr>
		</table>
	</div>
	<br />
	<br />
	<br />
	<br />
	<div class="accessAddForm">
		<form id="accessForm" action="adminUserAccessModify" method="post">
			<table class="accessAddTable">
				<tr>
					<td class="tdName">상호명</td>
					<td class="tdContent">
						<input type="text" name="companyName" />
					</td>
				</tr>
				<!-- <tr>
					<td class="tdName">파트</td>
					<td class="tdContent">
						<input type="text" />
					</td>
				</tr> -->
				<tr>
					<td class="tdName">권한</td>
					<td class="tdContent">
						<label>
					        <input type="radio" name="userAccess" value="0" />
					        유저
					    </label>
					    &nbsp;&nbsp;
						<label>
					        <input type="radio" name="userAccess" value="1" />
					        관리자
					    </label>
					    &nbsp;&nbsp;
					    <label>
					        <input type="radio" name="userAccess" value="2" />
					        광고주
					    </label>
					    &nbsp;&nbsp;
					    <label>
					        <input type="radio" name="userAccess" value="3" />
					        오피셜
					    </label>
					</td>
				</tr>
				<tr>
					<td class="tdName">변경내용</td>
					<td class="tdContent">
					<textarea name="" id="" cols="60" rows="20"></textarea>
					</td>
				</tr>
			</table>
			<div class="submit">
				<input type="hidden" name="userId" value="${AccountUserInfo.user_id }" />
				<input type="hidden" name="userAccessNow" value="${AccountUserInfo.user_access_id }" />
				<input type="submit" value="저장" />
				<button type="button" onclick="window.location.href='adminAccountUserListView'">취소</button>
			</div>
		</form>
	</div>
	<br />
	<br />
	<br />
</div>