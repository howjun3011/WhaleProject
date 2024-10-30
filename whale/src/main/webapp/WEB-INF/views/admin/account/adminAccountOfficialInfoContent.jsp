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
	<h1>최근활동</h4>
	<h2>게시글</h2>
	<table id="postList">
		<tr>
			<th>번호</th>
			<th>커뮤니티</th>
			<th>제목</th>
			<th>등록일</th>
			<th>조회수</th>
		</tr>
		<c:if test="${empty AccountUserPostList}">
		    <tr>
		        <td colspan="5" align="center">결과가 없습니다.</td>
		    </tr>
		</c:if>
		<c:if test="${not empty AccountUserPostList}">
        <c:forEach items="${AccountUserPostList }" var="dto" >
			<tr>
				<td>${dto.post_id }</td>
				<td>${dto.community_id }</td>
				<td>${dto.post_title }</td>
				<td><fmt:formatDate value="${dto.post_date }" pattern="yyyy.MM.dd" /></td>
				<td>${dto.post_cnt }</td>
			</tr>
		</c:forEach>
		</c:if>
		<%-- <tr>
		    <td colspan="5">
		        <c:choose>
		        
		            <c:when test="${not empty plsearchVO}">
		                <a href="adminAccountUserInfo?plpage=1"
		                   class="${plsearchVO.page == 1 ? 'pagination-disabled' : ''}">[처음]</a>
		
		                <a href="adminAccountUserInfo?plpage=${plsearchVO.page - 1}"
		                   class="${plsearchVO.page == 1 ? 'pagination-disabled' : ''}">[이전]</a>
		
		                <c:forEach begin="${plsearchVO.pageStart}" end="${plsearchVO.pageEnd}" var="i">
		                    <c:choose>
		                        <c:when test="${i eq plsearchVO.page}">
		                            <span class="pagination-active">${i} &nbsp; &nbsp;</span>
		                        </c:when>
		                        <c:otherwise>
		                            <a href="adminAccountUserInfo?plpage=${i}">${i}</a> &nbsp; &nbsp;
		                        </c:otherwise>
		                    </c:choose>
		                </c:forEach>
		
		                <a href="adminAccountUserInfo?plpage=${plsearchVO.page + 1}"
		                   class="${plsearchVO.page == plsearchVO.totPage ? 'pagination-disabled' : ''}">[다음]</a>
		
		                <a href="adminAccountUserInfo?plpage=${plsearchVO.totPage}"
		                   class="${plsearchVO.page == plsearchVO.totPage ? 'pagination-disabled' : ''}">[마지막]</a>
		            </c:when>
		            
		            <c:otherwise>
		                <a href="adminAccountUserInfo?plpage=1" class="pagination-disabled">[처음]</a>
		
		                <a href="adminAccountUserInfo?plpage=1" class="pagination-disabled">[이전]</a>
		
		                <span class="pagination-active">1 &nbsp; &nbsp;</span>
		
		                <a href="adminAccountUserInfo?plpage=1" class="pagination-disabled">[다음]</a>
		
		                <a href="adminAccountUserInfo?plpage=1" class="pagination-disabled">[마지막]</a>
		            </c:otherwise>
		            
		        </c:choose>
		    </td>
		</tr> --%>
	</table>
	<hr />
	<h2>피드</h2>
	<table id="feedList">
		<tr>
			<th>번호</th>
			<th>내용</th>
			<th>등록일</th>
		</tr>
		<c:if test="${empty AccountUserFeedList}">
		    <tr>
		        <td colspan="3" align="center">결과가 없습니다.</td>
		    </tr>
		</c:if>
		<c:if test="${not empty AccountUserFeedList}">
        <c:forEach items="${AccountUserFeedList }" var="dto" >
			<tr>
				<td>${dto.feed_id }</td>
				<td>${dto.feed_text }</td>
				<td><fmt:formatDate value="${dto.feed_date }" pattern="yyyy.MM.dd" /></td>
			</tr>
		</c:forEach>
		</c:if>
		<%-- <tr>
		    <td colspan="3">
		        <c:choose>
		        
		            <c:when test="${not empty flsearchVO}">
		                <a href="adminAccountUserInfo?flpage=1"
		                   class="${flsearchVO.page == 1 ? 'pagination-disabled' : ''}">[처음]</a>
		
		                <a href="adminAccountUserInfo?flpage=${flsearchVO.page - 1}"
		                   class="${flsearchVO.page == 1 ? 'pagination-disabled' : ''}">[이전]</a>
		
		                <c:forEach begin="${flsearchVO.pageStart}" end="${flsearchVO.pageEnd}" var="i">
		                    <c:choose>
		                        <c:when test="${i eq flsearchVO.page}">
		                            <span class="pagination-active">${i} &nbsp; &nbsp;</span>
		                        </c:when>
		                        <c:otherwise>
		                            <a href="adminAccountUserInfo?flpage=${i}">${i}</a> &nbsp; &nbsp;
		                        </c:otherwise>
		                    </c:choose>
		                </c:forEach>
		
		                <a href="adminAccountUserInfo?flpage=${flsearchVO.page + 1}"
		                   class="${flsearchVO.page == flsearchVO.totPage ? 'pagination-disabled' : ''}">[다음]</a>
		
		                <a href="adminAccountUserInfo?flpage=${plsearchVO.totPage}"
		                   class="${flsearchVO.page == flsearchVO.totPage ? 'pagination-disabled' : ''}">[마지막]</a>
		            </c:when>
		            
		            <c:otherwise>
		                <a href="adminAccountUserInfo?flpage=1" class="pagination-disabled">[처음]</a>
		
		                <a href="adminAccountUserInfo?flpage=1" class="pagination-disabled">[이전]</a>
		
		                <span class="pagination-active">1 &nbsp; &nbsp;</span>
		
		                <a href="adminAccountUserInfo?flpage=1" class="pagination-disabled">[다음]</a>
		
		                <a href="adminAccountUserInfo?flpage=1" class="pagination-disabled">[마지막]</a>
		            </c:otherwise>
		            
		        </c:choose>
		    </td>
		</tr> --%>
	</table>
	<hr />
	<h2>댓글</h2>
	<table id="commentList">
		<tr>
			<th>커뮤니티/피드</th>
			<th>번호</th>
			<th>내용</th>
			<th>등록일</th>
		</tr>
		<c:if test="${empty AccountUserCommentsList}">
		    <tr>
		        <td colspan="4" align="center">결과가 없습니다.</td>
		    </tr>
		</c:if>
		<c:if test="${not empty AccountUserCommentsList}">
	        <c:forEach items="${AccountUserCommentsList }" var="dto" >
	        	<c:if test="${dto.feed_comments_id !=0}">
		        	<tr>
						<td>${dto.feed_comments_id }</td>
						<td>${dto.feed_comments_id }</td>
						<td>${dto.feed_comments_text }</td>
						<td><fmt:formatDate value="${dto.post_comments_date }" pattern="yyyy.MM.dd" /></td>
					</tr>
	        	</c:if>
	        	<c:if test="${dto.post_comments_id != 0}"></c:if>
				<tr>
					<td>${dto.post_comments_id }</td>
					<td>${dto.post_comments_id }</td>
					<td>${dto.post_comments_text }</td>
					<td><fmt:formatDate value="${dto.post_comments_date }" pattern="yyyy.MM.dd" /></td>
				</tr>
			</c:forEach>
		</c:if>
		<%-- <tr>
		    <td colspan="4">
		        <c:choose>
		        
		            <c:when test="${not empty plsearchVO}">
		                <a href="adminAccountUserInfo?plpage=1"
		                   class="${plsearchVO.page == 1 ? 'pagination-disabled' : ''}">[처음]</a>
		
		                <a href="adminAccountUserInfo?plpage=${plsearchVO.page - 1}"
		                   class="${plsearchVO.page == 1 ? 'pagination-disabled' : ''}">[이전]</a>
		
		                <c:forEach begin="${plsearchVO.pageStart}" end="${plsearchVO.pageEnd}" var="i">
		                    <c:choose>
		                        <c:when test="${i eq plsearchVO.page}">
		                            <span class="pagination-active">${i} &nbsp; &nbsp;</span>
		                        </c:when>
		                        <c:otherwise>
		                            <a href="adminAccountUserInfo?plpage=${i}">${i}</a> &nbsp; &nbsp;
		                        </c:otherwise>
		                    </c:choose>
		                </c:forEach>
		
		                <a href="adminAccountUserInfo?plpage=${plsearchVO.page + 1}"
		                   class="${plsearchVO.page == plsearchVO.totPage ? 'pagination-disabled' : ''}">[다음]</a>
		
		                <a href="adminAccountUserInfo?plpage=${plsearchVO.totPage}"
		                   class="${plsearchVO.page == searchVO.totPage ? 'pagination-disabled' : ''}">[마지막]</a>
		            </c:when>
		            
		            <c:otherwise>
		                <a href="adminAccountUserInfo?plpage=1" class="pagination-disabled">[처음]</a>
		
		                <a href="adminAccountUserInfo?plpage=1" class="pagination-disabled">[이전]</a>
		
		                <span class="pagination-active">1 &nbsp; &nbsp;</span>
		
		                <a href="adminAccountUserInfo?plpage=1" class="pagination-disabled">[다음]</a>
		
		                <a href="adminAccountUserInfo?plpage=1" class="pagination-disabled">[마지막]</a>
		            </c:otherwise>
		            
		        </c:choose>
		    </td>
		</tr> --%>
	</table>
	<br /><br /><br /><br />	
</div>