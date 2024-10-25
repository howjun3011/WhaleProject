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
				<td rowspan="4" class="proImg" style="">
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
					<input type="hidden" name="userId" value="${AccountUserInfo.user_id }" />
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
		</table>
	</div>
	<br />
	<br />
	<br />
	<br />
	<div class="accessAddForm">
		<form action="" method="post">
			<table class="accessAddTable">
				<tr>
					<td class="tdName">상호명</td>
					<td class="tdContent">
						<input type="text" />
					</td>
				</tr>
				<tr>
					<td class="tdName">파트</td>
					<td class="tdContent">
						<input type="text" />
					</td>
				</tr>
				<tr>
					<td class="tdName">권한</td>
					<td class="tdContent">
						<label>
					        <input type="radio" name="userAccess" value="user" />
					        유저
					    </label>
					    &nbsp;&nbsp;
						<label>
					        <input type="radio" name="userAccess" value="official" />
					        오피셜
					    </label>
					    &nbsp;&nbsp;
					    <label>
					        <input type="radio" name="userAccess" value="advertiser" />
					        광고주
					    </label>
					    &nbsp;&nbsp;
					    <label>
					        <input type="radio" name="userAccess" value="admin" />
					        관리자
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
				<input type="submit" value="저장" />
				<button type="button" onclick="adminAccountUserListView">취소</button>
			</div>
		</form>
	</div>
	<br />
	<br />
	<br />
</div>