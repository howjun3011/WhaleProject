<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="content" name="content" id="content">

    <div class="accountSearch">
		<form action="adminAccountOfficialListView" method="post" >
	        <select name="searchType" id="searchType">
			    <option value=user_id <c:if test="${not empty user_id}">selected</c:if>>아이디</option>
			    <option value="official_name" <c:if test="${not empty official_name}">selected</c:if>>활동명</option>
			</select>

	        
	        <input type="text" name="sk" size="50" value="${not empty sk ? sk : ''}" />
	        <input type="submit" value="검색" />
		</form>
    </div>
	
    <table>
        <thead>
            <tr>
                <th>아이디</th>
                <th>활동명</th>
                <th>게시글</th>
                <th>피드</th>
                <th>댓글</th>
                <th>등록일</th>
                <th>팔로우/팔로워</th>
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
					<td>${dto.user_id }</td>
					<td>${dto.official_name }</td>
					<td>${dto.post_count }</td>
					<td>${dto.feed_count }</td>
					<td>${dto.comments_count }</td>
					<td><fmt:formatDate value="${dto.user_date}" pattern="yyyy.MM.dd" /></td>
					<td>${dto.follow} / ${dto.follower }</td>
					<td>
						<button onclick = "location.href = 'adminAccountOfficialInfo?userId=${dto.user_id }'">조회</button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick = "location.href = 'adminAccountUserModify?userId=${dto.user_id }'" >수정</button>
					</td>
				</tr>
			</c:forEach>
			</c:if>
        </tbody>
        <tfoot>
        	<tr>
			    <td colspan="7">
			        <c:choose>
			        
			            <c:when test="${not empty ulsearchVO}">
			                <a href="adminAccountOfficialListView?page=1"
			                   class="${ulsearchVO.page == 1 ? 'pagination-disabled' : ''}">[처음]</a>
			
			                <a href="adminAccountOfficialListView?page=${ulsearchVO.page - 1}"
			                   class="${ulsearchVO.page == 1 ? 'pagination-disabled' : ''}">[이전]</a>
			
			                <c:forEach begin="${ulsearchVO.pageStart}" end="${ulsearchVO.pageEnd}" var="i">
			                    <c:choose>
			                        <c:when test="${i eq ulsearchVO.page}">
			                            <span class="pagination-active">${i} &nbsp; &nbsp;</span>
			                        </c:when>
			                        <c:otherwise>
			                            <a href="adminAccountOfficialListView?page=${i}">${i}</a> &nbsp; &nbsp;
			                        </c:otherwise>
			                    </c:choose>
			                </c:forEach>
			
			                <a href="adminAccountOfficialListView?page=${ulsearchVO.page + 1}"
			                   class="${ulsearchVO.page == ulsearchVO.totPage ? 'pagination-disabled' : ''}">[다음]</a>
			
			                <a href="adminAccountOfficialListView?page=${searchVO.totPage}"
			                   class="${ulsearchVO.page == ulsearchVO.totPage ? 'pagination-disabled' : ''}">[마지막]</a>
			            </c:when>
			            
			            <c:otherwise>
			                <a href="adminAccountOfficialListView?page=1" class="pagination-disabled">[처음]</a>
			
			                <a href="adminAccountOfficialListView?page=1" class="pagination-disabled">[이전]</a>
			
			                <span class="pagination-active">1 &nbsp; &nbsp;</span>
			
			                <a href="adminAccountOfficialListView?page=1" class="pagination-disabled">[다음]</a>
			
			                <a href="adminAccountOfficialListView?page=1" class="pagination-disabled">[마지막]</a>
			            </c:otherwise>
			            
			        </c:choose>
			    </td>
			</tr>
        </tfoot>
    </table>
</div>