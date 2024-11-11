<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script type="text/javascript">
        function logoutWhale() {
            // 스프링 클라이언트 정보 초기화
            localStorage.clear();
            // 스프링 서버 정보 초기화
            location.href = '/whale/main/logout';
        }
</script>

<div id="adminSideBar" name="adminSideBar" class="adminSideBar">
 	<div class="profile">
	 	<div class="proImgBox">
	 		<img src="/whale/static/images/setting/${myImgUrl }" alt="user_img" class="proImg"/> <br />
	 	</div>
    </div>
 	<div class="logoutstr">
        <a href="adminMyInfoView">${myId }</a> <br />
        <a href="#" onclick="logoutWhale()">로그아웃</a>
    </div>
    <ul>
		<li><a href="adminMainView">관리자메인</a></li>
	    <li><a href="adminAccountUserListView">계정관리</a></li>
	    <li><a href="adminBoardListView">게시판</a></li>
	    <li><a href="adminReportListView">신고|문의</a></li>
	    <li><a href="adminStatisticView">통계</a></li>
	    <li><a href="">매출</a></li>
	    <li><a href="">관리자설정</a></li>
	    <li><a href="">사용가이드</a></li>
	    <li><a href="/whale/main">Whale</a></li>
	</ul>
</div>