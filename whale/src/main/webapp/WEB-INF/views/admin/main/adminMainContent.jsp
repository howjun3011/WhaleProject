<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<div class="mainContent">
    <div class="blockContainer">
	    <div class="divStep">
	        <div class="block" id="block1" onclick="window.location.href='adminReportListView'">
	        	신고현황<br />
	        	<div id="reportToday">
	        		오늘완료- ${report_result_today } 건<br />
	        		미완료- ${report_null } 건
	        	</div>
	        </div>
	        <div class="block" id="block2" onclick="window.location.href=''">
	        	오늘 작성된 글
	        	<div id="writingToday">
	        		${writing_today} 건
	        	</div>
	        </div>
	        <div class="block" id="block3" onclick="window.location.href=''">
	        	오늘재생횟수
	        </div>
	        <div class="block" id="block4" onclick="window.location.href=''">
	        	오늘음악태그
	        </div>
	    </div>
	    <div class="divStep">
	        <div class="block" id="block5" onclick="window.location.href='adminNoticeListView'">
	        	관리자공지
	        	<div id="noticce">
	        		<c:forEach items="${mainNotice }" var="mn">
	        			<a href="adminNoticeContentView?postId=${mn.post_id }&page=1&searchType=&sk=&communityName=">${mn.post_title } <fmt:formatDate value="${mn.post_date }" pattern="yyyy.MM.dd" /></a>
	        			<br />
	        		</c:forEach>
	        	</div>
	        </div>
	        <div class="block" id="block6" onclick="window.location.href=''">광고현황</div>
	        <div class="block" id="block7" onclick="window.location.href=''">2024-09-12 (월) <br /> 18:18:18</div>
	    </div>
	    <div class="divStep">
	        <div class="block" id="block8" onclick="window.location.href=''">작성글</div>
	    </div>
    </div>
    <div id="memo">메모장 <br /> <textarea rows="" cols=""></textarea></div>
</div>
