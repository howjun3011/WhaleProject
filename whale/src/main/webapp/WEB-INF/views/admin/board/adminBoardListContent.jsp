<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="content" name="content" id="content">

    <div class="accountSearch">
		<form action="adminBoardListView" method="post" >
	        <select name="searchType" id="searchType">
			    <option value="user_id" <c:if test="${researchType == 'user_id'}">selected</c:if>>아이디</option>
			    <option value="post_title" <c:if test="${researchType == 'post_title'}">selected</c:if>>제목</option>
			    <option value="all_text" <c:if test="${researchType == 'all_text'}">selected</c:if>>내용</option>
			    <option value="idPostFeed" <c:if test="${researchType == 'idPostFeed'}">selected</c:if>>전체</option>
			</select>
	        <input type="text" name="sk" size="50" value="${not empty searchKeyword ? searchKeyword : ''}" />
	        <input type="submit" value="검색" />
		</form>
    </div>
	
    <table>
        <thead>
            <tr>
                <th>커뮤/피드</th>
                <th>번호</th>
                <th>제목/내용</th>
                <th>태그</th>
                <th>아이디</th>
                <th>등록일</th>
                <th>신고</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
			<c:if test="${empty list}">
			    <tr>
			        <td colspan="7" align="center">결과가 없습니다.</td>
			    </tr>
			</c:if>
			<c:if test="${not empty list}">
	        <c:forEach items="${list }" var="dto" >
				<tr>
					<c:if test="${not empty dto.feed_id && dto.feed_id != 0}">
					<td>피드</td>
					<td>${dto.feed_id }</td>
					<td>${dto.text }</td>
					<td></td>
					<td>${dto.user_id }</td>
					<td><fmt:formatDate value="${dto.date_field}" pattern="yyyy.MM.dd" /></td>
					<td>${dto.report_feed_count }</td>
					<td>
						<button onclick = "location.href = '?'">조회</button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick = "location.href = '?'" >수정</button>
					</td>
					</c:if>
					
					<c:if test="${not empty dto.post_id && dto.post_id !=0}">
					<td>${dto.community_name }</td>
					<td>${dto.post_id }</td>
					<td>${dto.post_title }</td>
					<td>${dto.post_tag_text }</td>
					<td>${dto.user_id }</td>
					<td><fmt:formatDate value="${dto.date_field}" pattern="yyyy.MM.dd" /></td>
					<td>${dto.report_post_count }</td>
					<td>
						<button onclick = "location.href = '?'">조회</button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick = "location.href = '?'" >수정</button>
					</td>
					</c:if>
					
				</tr>
			</c:forEach>
			</c:if>
        </tbody>
        <tfoot>
        	<tr>
			    <td colspan="7">
			        <c:choose>
			        
			            <c:when test="${not empty ulsearchVO}">
			                <a href="adminBoardListView?page=1&sk=${searchKeyword}"
			                   class="${ulsearchVO.page == 1 ? 'pagination-disabled' : ''}">[처음]</a>
			
			                <a href="adminBoardListView?page=${ulsearchVO.page - 1}&sk=${searchKeyword}"
			                   class="${ulsearchVO.page == 1 ? 'pagination-disabled' : ''}">[이전]</a>
			
			                <c:forEach begin="${ulsearchVO.pageStart}" end="${ulsearchVO.pageEnd}" var="i">
			                    <c:choose>
			                        <c:when test="${i eq ulsearchVO.page}">
			                            <span class="pagination-active">${i} &nbsp; &nbsp;</span>
			                        </c:when>
			                        <c:otherwise>
			                            <a href="adminBoardListView?page=${i}&sk=${searchKeyword}">${i}</a> &nbsp; &nbsp;
			                        </c:otherwise>
			                    </c:choose>
			                </c:forEach>
			
			                <a href="adminBoardListView?page=${ulsearchVO.page + 1}&sk=${searchKeyword}"
			                   class="${ulsearchVO.page == ulsearchVO.totPage ? 'pagination-disabled' : ''}">[다음]</a>
			
			                <a href="adminBoardListView?page=${searchVO.totPage}&sk=${searchKeyword}"
			                   class="${ulsearchVO.page == ulsearchVO.totPage ? 'pagination-disabled' : ''}">[마지막]</a>
			            </c:when>
			            
			            <c:otherwise>
			                <a href="adminBoardListView?page=1&sk=${searchKeyword}" class="pagination-disabled">[처음]</a>
			
			                <a href="adminBoardListView?page=1&sk=${searchKeyword}" class="pagination-disabled">[이전]</a>
			
			                <span class="pagination-active">1 &nbsp; &nbsp;</span>
			
			                <a href="adminBoardListView?page=1&sk=${searchKeyword}" class="pagination-disabled">[다음]</a>
			
			                <a href="adminBoardListView?page=1&sk=${searchKeyword}" class="pagination-disabled">[마지막]</a>
			            </c:otherwise>
			            
			        </c:choose>
			    </td>
			</tr>
        </tfoot>
    </table>
</div>