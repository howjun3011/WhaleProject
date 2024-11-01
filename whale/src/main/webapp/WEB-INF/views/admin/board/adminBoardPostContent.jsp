<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;600&display=swap">
<script>
    function postDelete(postId,page,searchType,sk) {
        const deleteConfirm = confirm("게시글을 삭제하시겠습니까?");
        if (deleteConfirm) {
        	window.location.href = 
        		"adminBoardPostContentDelete?postId="+postId
        				+"&sk="+sk
        				+"&page="+page
        				+"&searchType="+searchType
        }
    }
    function postCommentsDelete(communityName,commentId,postId,page,searchType,sk) {
        const deleteConfirm = confirm("댓글을 삭제하시겠습니까?");
        if (deleteConfirm) {
        	window.location.href = encodeURI(
        		"adminBoardPostCommentsContentDelete?commentId="+commentId
        				+"&communityName="+encodeURIComponent(communityName)
        				+"&postId="+postId
        				+"&sk="+sk
        				+"&page="+page
        				+"&searchType="+searchType)
        }
    }
</script>
<div class="content">
    <h2>" ${communityName} "</h2>
    
    <table class="contentTable">
        <colgroup>
            <col width="15%" />
            <col width="35%" />
            <col width="15%" />
            <col width="35%" />
        </colgroup>
        <tbody>
            <tr>
                <th>태그</th>
                <td>${postDetail.post_tag_text }</td>
                <th>작성자</th>
                <td>${postDetail.user_id }</td>
            </tr>
            <tr>
                <th>조회수</th>
                <td>${postDetail.post_cnt }</td>
                <th>등록일</th>
                <td>${postDetail.post_date }</td>
            </tr>
            <tr>
                <th>제목</th>
                <td colspan="3">${postDetail.post_title }</td>
            </tr>
            <tr>
                <th>내용</th>
                <td colspan="3">${postDetail.post_text }</td>
            </tr>
			<tr>
			    <th>이미지</th>
			    <td colspan="3">
			        <c:forEach var="image" items="${postDetail.images}">
			        	<img src="/whale/static/images/community/${image.post_img_name}" alt="Post Image">
			        </c:forEach>
			    </td>
			</tr>
        </tbody>
    </table>
	<br />
	<div class="btnBlock">
	좋아요 : <span id="likeCount">${postDetail.likeCount}</span> &nbsp;&nbsp; <!-- 좋아요 수 표시 -->
    <div class="samllDiv"><a href="#" onclick="postDelete('${postId }','${page}','${searchType }','${sk }')" class="samllBtn">삭제</a></div>
    <div class="samllDiv"><a href="adminBoardListView?page=${page }&searchType=${searchType }&sk=${sk}" class="samllBtn">목록</a></div>
	</div>
<table class="contentTable">
    <colgroup>
        <col style="width: 15%;"> <!-- 작성자 칸 -->
        <col style="width: 55%;"> <!-- 코멘트 칸 (넓게) -->
        <col style="width: 20%;"> <!-- 날짜 칸 (좁게) -->
        <col style="width: 10%;"> <!-- 관리 칸 -->
    </colgroup>
    <thead>
        <tr>
            <th>작성자</th>
            <th>코멘트</th>
            <th>작성일</th>
            <c:if test= "${comment.user_id eq now_id}">
	            <th>관리</th>
			</c:if>
        </tr>
    </thead>
    <tbody>
    	<c:if test="${not empty postDetail.comments}">
        <c:forEach var="comment" items="${postDetail.comments}">
            <tr>
                <td>${comment.user_id}</td> <!-- 작성자 열 -->
                <td>${comment.post_comments_text}</td> <!-- 코멘트 열 -->
                <td>${comment.post_comments_date}</td> <!-- 작성일 열 -->
                <td>
                    <form action="#" method="post">
                        <input type="hidden" name="postCommentsId" value="{comment.post_comments_id}" />
                        <input type="hidden" name="postId" value="{postDetail.post_id}" />
                        <input type="hidden" name="communityId" value="{param.c}" />
	                    <button type="button" onclick="postCommentsDelete('${communityName}','${comment.post_comments_id}','${postDetail.post_id}','${page}','${searchType }','${sk }')">삭제</button>
                    </form>
                </td> <!-- 관리(삭제) 열 -->
            </tr>
        </c:forEach>
        </c:if>
        <c:if test="${empty postDetail.comments}">
        	<tr>
        		<td colspan="4">댓글이 없습니다.</td>
        	</tr>
        </c:if>
    </tbody>
</table>
<br />
<br />
<br />
</div>
