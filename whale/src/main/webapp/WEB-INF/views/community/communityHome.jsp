<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Community</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap">
<style>
	/* 기본 설정 값 */
	* {margin: 0; padding: 0; box-sizing: border-box;}
    body {
    	min-height: 100vh;
        font-family: 'Roboto', sans-serif;
        background-color: #f5f5f5;
        color: #333333;
    }
	.frame {
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    width: 100%;
	    background-color: #ffffff;
	    border-radius: 10px;
	    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	    padding: 20px;
	    height: auto; /* 여기에서 height: auto; 추가 */
	}
    .container {
        max-width: 900px;
        width: 100%;
        padding: 40px;
        background-color: #ffffff;
        border-radius: 20px;
    }
    h3 {
    	margin-bottom: 40px;
        color: #333;
        text-align: left;
        font-size: 28px;
        font-weight: 600;
        border-bottom: 2px solid #ddd;
        padding-bottom: 10px;
    }
    .grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 25px;
    }
    .card {
        background-color: #ffffff;
        border: 1px solid #e0e0e0;
        border-radius: 10px;
        padding: 20px;
        transition: all 0.3s ease;
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: inherit;
        text-decoration: none;
    }
    .card:hover {
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }
    .card-title {
        font-size: 18px;
        font-weight: 600;
        color: #333;
    }
    .card-subtitle {
        font-size: 14px;
        color: #777;
    }
    .bookmark-btn {
        width: 24px;
        height: 24px;
        cursor: pointer;
    }
</style>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
/* 	$(document).ready(function() {
	    resize();
	});

	$(window).resize(function() {
	    resize();
	});

	function resize() {
	    var windowHeight = $(window).height();
	    $('.frame').css({'height': (windowHeight - 40) + 'px'});
	} */

	var contextPath = '${pageContext.request.contextPath}';
	// 즐겨찾기 버튼 클릭 시 AJAX 요청
    function toggleBookmark(communityId, element) {
        $.ajax({
            url: contextPath + '/toggleBookmark', // 컨텍스트 패스 포함
            type: 'POST',
            data: { communityId: communityId },
            dataType: 'text', // 서버 응답 타입 명시
            success: function(response) {
                if (response === 'followed') {
                    $(element).attr('src', contextPath + '/static/images/btn/starlike_btn.png'); // 즐겨찾기된 이미지
                } else if (response === 'unfollowed') {
                    $(element).attr('src', contextPath + '/static/images/btn/starunlike_btn.png'); // 즐겨찾기되지 않은 이미지
                } else {
                    alert('즐겨찾기 설정에 실패했습니다. 다시 시도해 주세요.');
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.log('AJAX error:', textStatus, errorThrown);
                alert('즐겨찾기 설정에 실패했습니다. 다시 시도해 주세요.');
            }
        });
	}
</script>
</head>
<body>
	<div class="frame">
	    <div class="container">
	        <h3>커뮤니티</h3>
	        <div class="grid">
	            <c:forEach items="${list}" var="c">
	                <a href="communityPost?c=${c.community_id}" class="card">
	                    <div>
	                        <div class="card-title">${c.community_name}</div>
	                        <div class="card-subtitle">${c.community_name_en}</div>
	                    </div>
	                    <!-- 즐겨찾기 버튼 -->
	                    <c:choose>
	                        <c:when test="${c.bookmarked}">
	                            <img src="static/images/btn/starlike_btn.png" 
	                                 class="bookmark-btn" 
	                                 onclick="event.preventDefault(); toggleBookmark(${c.community_id}, this);">
	                        </c:when>
	                        <c:otherwise>
	                            <img src="static/images/btn/starunlike_btn.png" 
	                                 class="bookmark-btn" 
	                                 onclick="event.preventDefault(); toggleBookmark(${c.community_id}, this);">
	                        </c:otherwise>
	                    </c:choose>
	                </a>
	            </c:forEach>
	        </div>
	    </div>
	</div>
	</body>
	</html>
	         