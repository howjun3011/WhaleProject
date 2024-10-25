<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>likeList</title>
<link rel="stylesheet" href="static/css/setting/settingStyle.css" />
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="static/js/setting/setting.js"></script>
<style>
.setting-item{
	display : inline-block;
	border-bottom: none;
	margin: 0px;
}
.dropdown{
  position : relative;
  display : inline-block;
}
.dropbtn{
  display : block;
  border : 2px solid #ccc;
  border-radius : 4px;
  background-color: #fcfcfc;
  font-weight: 400;
  color : rgb(124, 124, 124);
  padding : 12px;
  width :100px;
  height: 45px;
  text-align: left;
  cursor : pointer;
  font-size : 12px;
  z-index : 1;
  position : relative;
  margin-right: 3px;
}
.dropdown-content{
  position: absolute;
  display : none;
  font-weight: 400;
  background-color: #fcfcfc;
  min-width : 100px;
  border-radius: 8px;
  height : 50px;
  box-shadow: 0px 0px 10px 3px rgba(190, 190, 190, 0.6);
}
.dropdown-content div{
  display : block;
  text-decoration : none;
  color : rgb(37, 37, 37);
  font-size: 12px;
  padding : 12px 20px;
}
.dropdown-content div:hover{
  background-color: rgb(226, 226, 226);
}
.dropdown-content.show{
  display : block;
}
.post-list{
	display: block;
	margin-bottom: 10px;
	margin-left: 20px;
	margin-right: 20px;
	padding: 10px 10px;
	border: 1px solid #ccc;
	border-radius: 8px;
	border
}
.no-like-message{
	margin-left: 20px;
	color: #ccc;
}
</style>
</head>
<body>
<div class="setting-body">
    <div class="setting-container">
        <div class="setting-header">좋아요</div>
	        <form id="filterForm" action="/whale/likeList" method="get">
	            <!-- 숨겨진 필드에 드롭다운 선택 값을 저장 -->
	            <input type="hidden" name="sortOrder" id="sortOrder" value="${selectedSortOrder}">
	            <input type="hidden" name="postType" id="postType" value="${selectedPostType}">
	
	            <div class="setting-item">
	                <!-- 정렬 순서 드롭다운 -->
	                <div class="dropdown">
	                    <button type="button" class="dropbtn" onclick="toggleDropdown(this)">
	                        <span class="dropbtn_content">${selectedSortOrder}</span>
	                    </button>
	                    <div class="dropdown-content">
	                        <div onclick="updateSelection('sortOrder', '최신순', this)">최신순</div>
	                        <div onclick="updateSelection('sortOrder', '오래된순', this)">오래된순</div>
	                    </div>
	                </div>
	
	                <!-- 게시물 유형 드롭다운 -->
	                <div class="dropdown">
	                    <button type="button" class="dropbtn" onclick="toggleDropdown(this)">
	                        <span class="dropbtn_content">${selectedPostType}</span>
	                    </button>
	                    <div class="dropdown-content">
	                        <div onclick="updateSelection('postType', '게시글', this)">게시글</div>
	                        <div onclick="updateSelection('postType', '피드', this)">피드</div>
	                    </div>
	                </div>
	            </div>
	        </form>
        <!-- 좋아요 게시물 출력 -->
        <div id="post-list">
        	<c:choose>
        		<c:when test="${empty currentPostLikeList }">
        			<div class="no-like-message">좋아요 목록이 없습니다.</div>
        		</c:when>
	        	<c:otherwise>
		            <c:forEach var="like" items="${currentPostLikeList}">
		                <div class="post-list">
		                    <div>제목: ${like.post_title}</div>
		                    <div>내용: ${like.post_text}</div>
		                </div>
		            </c:forEach>
	        	</c:otherwise>
        	</c:choose>
        </div>
    </div>
</div>
<script>
	//드롭다운 토글 함수
	function toggleDropdown(button) {
	    const dropdownContent = button.nextElementSibling;
	    closeAllDropdowns(); // 다른 드롭다운 닫기
	    dropdownContent.classList.toggle('show'); // 드롭다운 열기/닫기
	
	    // 현재 버튼의 텍스트 가져오기
	    const currentValue = button.querySelector('.dropbtn_content').innerText;
	
	    // 가능한 옵션 쌍 설정
	    // optionPairs 객체는 현재 버튼의 텍스트에 대응하는 반대 옵션을 정의
	    const optionPairs = {
	        '최신순': '오래된순',
	        '오래된순': '최신순',
	        '게시글': '피드',
	        '피드': '게시글'
	    };
	
	    // 현재 값에 대한 반대 옵션 표시
	    const options = dropdownContent.querySelectorAll('div');
	    options.forEach(option => {
	    	// 현재 버튼의 값에 대응하는 반대 옵션이면 해당 옵션을 표시, 아니면 숨김
	        option.style.display = option.innerText === optionPairs[currentValue] ? 'block' : 'none';
	    });
	}
	
	// 선택한 값을 hidden 필드에 설정하고 드롭다운 닫기
	function updateSelection(field, value, element) {
	    document.getElementById(field).value = value; // hidden 필드에 값 설정
	
	    // 드롭다운 버튼의 텍스트 변경
	    const dropbtn = element.closest('.dropdown').querySelector('.dropbtn_content');
	    dropbtn.innerText = value;
	
	    // 드롭다운 닫기
	    closeAllDropdowns();
	
	    // 폼 제출
	    document.getElementById('filterForm').submit();
	}
	
	// 모든 드롭다운 닫기
	function closeAllDropdowns() {
	    document.querySelectorAll('.dropdown-content.show').forEach(function (dropdown) {
	        dropdown.classList.remove('show');
	    });
	}
	
	// 외부 클릭 시 드롭다운 닫기
	window.onclick = function (event) {
	    if (!event.target.matches('.dropbtn')) {
	        closeAllDropdowns();
	    }
	};
</script>
</body>
</html>