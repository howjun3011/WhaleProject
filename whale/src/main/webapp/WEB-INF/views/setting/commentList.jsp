<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>commentList</title>
	<link rel="stylesheet" href="static/css/setting/settingStyle.css" />
	<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	<script src="static/js/setting/setting.js"></script>
	<style>
		.setting-container {
			display: flex;
			flex-direction: column;
			overflow: hidden;
		}

		.scroll-content {
			flex: 1;
			overflow-y: auto;
		}
		.setting-item {
			display: inline-block;
			border-bottom: none;
			margin: 0px;
		}
		.dropdown {
			position: relative;
			display: inline-block;
		}
		.dropbtn {
			display: block;
			border: 2px solid #ccc;
			border-radius: 4px;
			background-color: #fcfcfc;
			font-weight: 400;
			color: rgb(124, 124, 124);
			padding: 12px;
			width: 100px;
			height: 45px;
			text-align: left;
			cursor: pointer;
			font-size: 12px;
			z-index: 1;
			position: relative;
			margin-right: 3px;
		}
		.dropdown-content {
			position: absolute;
			display: none;
			font-weight: 400;
			background-color: #fcfcfc;
			min-width: 100px;
			border-radius: 8px;
			height: 50px;
			box-shadow: 0px 0px 10px 3px rgba(190, 190, 190, 0.6);
		}
		.dropdown-content div {
			display: block;
			text-decoration: none;
			color: rgb(37, 37, 37);
			font-size: 12px;
			padding: 12px 20px;
		}
		.dropdown-content div:hover {
			background-color: rgb(226, 226, 226);
		}
		.dropdown-content.show {
			display: block;
		}
		.post-list {
			display: block;
			margin-bottom: 10px;
			margin-left: 20px;
			margin-right: 20px;
			padding: 10px 10px;
			border: 1px solid #ccc;
			border-radius: 8px;
		}
		.no-comment-message {
			margin-left: 20px;
			color: #ccc;
		}

		a {
			text-decoration: none;
			color: black;
		}
		a:visited, a:hover, a:focus, a:active {
			color: black;
			text-decoration: none;
		}
		#back {
			position: absolute;
			left: 15px;
			top: 55%;
			transform: translateY(-50%);
		}

		#feed-list, #post-list {
			margin-left: 20px;
			margin-right: 20px;
		}

		.feed-item {
			display: flex;
			align-items: center;
			margin-bottom: 10px;
			justify-content: space-between;
			padding: 10px;
			border: 1px solid #ddd;
			border-radius: 8px;
		}

		.post-item {
			display: flex;
			flex-direction: column;
			margin-bottom: 10px;
			justify-content: space-between;
			padding: 15px 10px;
			border: 1px solid #ddd;
			border-radius: 8px;
		}

		#feed-img {
			width: 100%;
			max-height: 50px;
			max-width: 50px;
			border-radius: 6px;
			margin-left: auto;
		}

		.comments-section {
			margin-top: 10px;
			padding-left: 10px;
			margin-bottom: 10px;
		}

		.comment, .reply {
			display: flex;
			align-items: center;
			margin-bottom: 5px;
		}

		.reply {
			margin-left: 40px;
		}

		.comment-img, .reply-img, .owner-image {
			width: 30px;
			height: 30px;
			border-radius: 50%;
			margin-right: 10px;
		}

		.comment-text, .reply-text {
			background-color: #f1f1f1;
			padding: 8px 12px;
			border-radius: 20px;
		}

		.post-list-writer{
			display: flex;
			justify-content: space-between;
			align-items: center;
		}

	</style>
</head>
<body>
<div class="setting-body">
	<div class="setting-container">
		<div class="setting-header">
			<a href="activity" id="back"><img src="static/images/setting/back.png" alt="back"></a>
			댓글
		</div>
		<div class="scroll-content">
			<form id="filterForm" action="/whale/commentList" method="get">
				<input type="hidden" name="sortOrder" id="sortOrder" value="${selectedSortOrder}">
				<input type="hidden" name="postType" id="postType" value="${selectedPostType}">

				<div class="setting-item">
					<div class="dropdown">
						<button type="button" class="dropbtn" onclick="toggleDropdown(this)">
							<span class="dropbtn_content">${selectedSortOrder}</span>
						</button>
						<div class="dropdown-content">
							<div onclick="updateSelection('sortOrder', '최신순', this)">최신순</div>
							<div onclick="updateSelection('sortOrder', '오래된순', this)">오래된순</div>
						</div>
					</div>

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
			<!-- 댓글 목록 출력 -->
			<div id="comment-list">
				<c:choose>
					<c:when test="${empty postFeedList && empty postFeedCommentList}">
						<div class="no-comment-message">댓글 목록이 없습니다.</div>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${selectedPostType == '게시글'}">
								<c:forEach var="post" items="${postFeedList }">
									<a href="/whale/communityDetail?c=${post.community_id}&p=${post.post_id}">
										<div id="post-list">
											<div class="post-item">
												<div class="post-list-writer">
													<div>${post.post_tag_text}&nbsp;${post.post_title}</div>
													<div>${post.post_owner_id}</div>
												</div>
													<div>${post.post_text}</div>
											</div>

											<div class="comments-section">
												<c:forEach var="comment" items="${postFeedCommentList}">
													<c:if test="${post.post_id == comment.re_post_id}">
														<div class="${comment.re_post_parent_comments_id != null ? 'reply' : 'comment'}">
															<img src="static/images/setting/${comment.re_post_commenter_image}" alt="commenter_img" class="comment-img">
															<div class="comment-text">
																<span>${comment.re_post_commenter_id}</span>: ${comment.re_post_comments_text}
															</div>
														</div>
													</c:if>
												</c:forEach>
											</div>
										</div>
									</a>
								</c:forEach>
							</c:when>
							<c:when test="${selectedPostType == '피드'}">
								<c:forEach var="feed" items="${postFeedList}">
									<a href="/whale/feedDetail?f=${feed.feed_id}">
										<div id="feed-list">
											<div class="feed-item">
												<img src="static/images/setting/${feed.feed_owner_image}" alt="owner_image" class="owner-image">
												${feed.feed_owner_id} ${feed.feed_text}
												<img src="static/images/feed/${feed.feed_img_name}" alt="feed_img" id="feed-img">
											</div>

											<div class="comments-section">
												<c:forEach var="comment" items="${postFeedCommentList}">
													<c:if test="${feed.feed_id == comment.re_feed_id}">
														<div class="${comment.re_parent_comments_id != null ? 'reply' : 'comment'}">
															<img src="static/images/setting/${comment.re_commenter_image}" alt="commenter_img" class="comment-img">
															<div class="comment-text">
																<span>${comment.re_commenter_id}</span>: ${comment.re_feed_comments_text}
															</div>
														</div>
													</c:if>
												</c:forEach>
											</div>
										</div>
									</a>
								</c:forEach>
							</c:when>
						</c:choose>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</div>
<script>
	function toggleDropdown(button) {
		const dropdownContent = button.nextElementSibling;
		closeAllDropdowns();
		dropdownContent.classList.toggle('show');
		const currentValue = button.querySelector('.dropbtn_content').innerText;
		const optionPairs = {
			'최신순': '오래된순',
			'오래된순': '최신순',
			'게시글': '피드',
			'피드': '게시글'
		};
		const options = dropdownContent.querySelectorAll('div');
		options.forEach(option => {
			option.style.display = option.innerText === optionPairs[currentValue] ? 'block' : 'none';
		});
	}

	function updateSelection(field, value, element) {
		document.getElementById(field).value = value;
		const dropbtn = element.closest('.dropdown').querySelector('.dropbtn_content');
		dropbtn.innerText = value;
		closeAllDropdowns();
		document.getElementById('filterForm').submit();
	}

	function closeAllDropdowns() {
		document.querySelectorAll('.dropdown-content.show').forEach(function (dropdown) {
			dropdown.classList.remove('show');
		});
	}

	window.onclick = function (event) {
		if (!event.target.matches('.dropbtn')) {
			closeAllDropdowns();
		}
	};
</script>
</body>
</html>
