<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feed Detail</title>
    <style>
        /* 기존 feedHome 페이지와 동일한 스타일 사용 */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f0f0;
        }

        .post {
            position: relative;
            background-color: white;
            width: 90%;
            max-width: 600px;
            margin: 20px auto;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 15px;
        }

        .user-info {
            display: flex;
            align-items: center;
        }

        .profile-pic {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
        }

        .username {
            font-weight: bold;
            font-size: 1.2em;
        }

        .post-image {
            width: 100%;
            height: auto;
            margin: 10px 0;
            border-radius: 10px;
        }

        .post-actions {
            display: flex;
            justify-content: space-around;
            align-items: center; /* 아이템들을 수직 가운데 정렬 */
            margin-top: 10px;
            font-size: 1em;
        }

        .post-actions .like-btn,
        .post-actions .comments {
            display: flex; /* 수평 배치 */
            align-items: center; /* 수직 가운데 정렬 */
            background: none;
            border: none;
            cursor: pointer;
        }

        .post-actions .likebtn,
        .post-actions .commentbtn {
            width: 30px; /* 아이콘 크기 조정 */
            height: 30px;
            margin-right: 5px; /* 아이콘과 텍스트 사이 간격 */
        }

        .like-count,
        .comment-count {
            font-size: 1em; /* 글자 크기 통일 */
            color: #333;    /* 필요 시 색상 지정 */
        }

        .post-text {
            margin-top: 10px;
        }

        .post-time {
            font-size: 0.8em;
            color: gray;
        }

        .other-btn {
            position: absolute;
            top: 20px;
            right: 15px;
            background: none;
            border: none;
            cursor: pointer;
        }

        .other-btn img {
            width: 30px;
            height: 30px;
        }

        .modal {
            display: none; /* 기본적으로 숨김 상태 */
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            justify-content: center;
            align-items: center;
        }

        /* 모달 내용 */
        .modal-content {
            background-color: white;
            border-radius: 12px;
            width: 80%;
            max-width: 300px;
            text-align: center;
            overflow: hidden;
        }

        /* 모달 항목 스타일 */
        .modal-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            font-size: 16px;
            cursor: pointer;
        }

        .modal-item.red {
            color: red;
        }

        .modal-item.gray {
            color: gray;
        }

        .modal-item:last-child {
            border-bottom: none;
        }

        .modal-item:hover {
            background-color: #f9f9f9;
        }

        /* 댓글 스타일 */
        .comments-section {
            margin-top: 30px;
            padding: 15px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 600px;
            margin: 20px auto;
        }

        .comment {
            display: flex;
            padding: 10px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .comment:last-child {
            border-bottom: none;
        }

        .comment .profile-pic {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            margin-right: 10px;
        }

        .comment-info {
            display: flex;
            flex-direction: column;
        }

        .comment-info .username {
            font-size: 0.9em;
            font-weight: bold;
            margin-top: 5px;
        }

        .comment .comment-text {
            flex-grow: 1;
        }

        .comment .comment-date {
            font-size: 0.8em;
            color: gray;
        }

        .comment-form {
            display: flex;
            align-items: center;
            margin-top: 10px;
        }

        .comment-form input[type="text"] {
            flex-grow: 1;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-right: 10px;
        }

        .comment-form button {
            padding: 8px 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        /* 댓글 삭제 아이콘 버튼 */
        .delete-comment-btn {
            background: none;
            border: none;
            cursor: pointer;
        }

        .delete-comment-btn img {
            width: 20px;
            height: 20px;
        }
        
        .comment-actions {
		    display: flex;
		    align-items: center;
		    margin-top: 5px;
		}
		
		.comment-like-btn {
		    display: flex;
		    align-items: center;
		    background: none;
		    border: none;
		    cursor: pointer;
		}
		
		.comment-like-btn .likebtn {
		    width: 20px;
		    height: 20px;
		    margin-right: 5px;
		}
        
        .reply-btn {
        	display: flex;
		    align-items: center;
		    background: none;
		    border: none;
		    cursor: pointer;
        }
        
        .reply-btn .commentbtn {
        	width: 20px;
		    height: 20px;
		    margin-right: 5px;
        }
        
        .replies {
		    margin-left: 40px; /* 들여쓰기 효과 */
		}
		
		.reply {
		    padding: 5px 0;
		    border-bottom: 1px solid #e0e0e0;
		}
		
		.reply-form {
		    margin-top: 5px;
		    margin-left: 40px; /* 부모 댓글과 동일한 들여쓰기 */
		}
		
		.reply-form input[type="text"] {
		    width: 80%;
		    padding: 5px;
		}
		
		.reply-form button {
		    padding: 5px 10px;
		    margin-left: 5px;
		}
        
    </style>
</head>
<body>

    <div class="post" data-post-id="${feedDetail.feed_id}" data-user-id="${feedDetail.user_id}">
        <div class="user-info">
            <a href="profileHome?u=${feedDetail.user_id}">
                <img src="static/images/setting/${feedDetail.user_image_url}" alt="User Profile" class="profile-pic">
            </a>
            <span class="username">${feedDetail.user_id}</span>
        </div>

        <button class="other-btn">
            <img src="static/images/btn/other_btn.png" alt="Other Button">
        </button>

        <!-- 이미지가 존재할 때만 출력 -->
        <c:if test="${not empty feedDetail.feed_img_name}">
            <img src="static/images/feed/${feedDetail.feed_img_name}" alt="Post Image" class="post-image">
        </c:if>

        <div class="post-text">
            <p>${feedDetail.feed_text}</p>
            <span class="post-time">${feedDetail.feed_date}</span>
        </div>

        <div class="post-actions">
            <button type="button" class="like-btn" data-feed-id="${feedDetail.feed_id}" data-now-id="${now_id}">
                <img class="likebtn" src="static/images/btn/like_btn.png" alt="like" />
                <span class="like-count">${feedDetail.likeCount}</span>
            </button>
            <div class="comments">
                <img class="commentbtn" src="static/images/btn/comment_btn.png" alt="comments" />
                <span class="comment-count">${feedDetail.commentsCount}</span>
            </div>
        </div>
    </div>

    <!-- 댓글 섹션 -->
    <div class="comments-section">
        <h3>댓글</h3>
        <c:forEach var="comment" items="${feedDetail.feedComments}">
            <div class="comment" data-comment-id="${comment.feed_comments_id}">
                <a href="profileHome?u=${comment.user_id}">
                    <img src="static/images/setting/${comment.user_image_url}" alt="User Profile" class="profile-pic">
                </a>
                <div class="comment-info">
                    <span class="username">${comment.user_id}</span>
                    <p>${comment.feed_comments_text}</p>
                	<div class="comment-actions">
                	<button type="button" class="comment-like-btn" data-comment-id="${comment.feed_comments_id}" data-now-id="${now_id}">
                    	<img class="likebtn" src="static/images/btn/like_btn.png" alt="like" />
                    	<span class="comment-like-count">${comment.likeCount}</span>
                	</button>
                	<button type="button" class="reply-btn" onclick="toggleReplyForm(${comment.feed_comments_id})">
                		<img class="commentbtn" src="static/images/btn/comment_btn.png" alt="답글" />
                		<span class="comment-reply-count">${comment.replyCount}</span>
                	</button>
                </div>

	            <!-- 답글 표시 -->
	            <c:if test="${not empty comment.replies}">
	                <div class="replies">
	                    <c:forEach var="reply" items="${comment.replies}">
	                        <a href="profileHome?u=${reply.user_id}">
                    			<img src="static/images/setting/${reply.user_image_url}" alt="User Profile" class="profile-pic">
                			</a>
	                        <div class="reply">
	                            <span class="username">${reply.user_id}</span>
	                            <p>${reply.feed_comments_text}</p>
	                            <!-- 답글에도 좋아요 버튼 추가 가능 -->
	                            <div class="comment-actions">
	                                <button type="button" class="comment-like-btn" data-comment-id="${reply.feed_comments_id}" data-now-id="${now_id}">
	                                    <img class="likebtn" src="static/images/btn/like_btn.png" alt="like" />
	                                    <span class="comment-like-count">${reply.likeCount}</span>
	                                </button>
					                <c:if test="${reply.user_id eq now_id}">
				                        <form action="feedDetail/deleteComment" method="post" style="margin: 0;">
				                            <input type="hidden" name="feedCommentsId" value="${reply.feed_comments_id}" />
				                            <input type="hidden" name="feedId" value="${feedDetail.feed_id}" />
				                            <button type="submit" class="delete-comment-btn">
				                                <img src="static/images/setting/delete_button.png" alt="Delete Button">
				                            </button>
				                        </form>
				                    </c:if>
	                            </div>
	                        </div>
	                    </c:forEach>
	                </div>
	            </c:if>
	            <div class="reply-form" id="reply-form-${comment.feed_comments_id}" style="display: none;">
	                <form action="feedDetail/reply" method="post">
	                    <input type="hidden" name="feedId" value="${feedDetail.feed_id}">
	                    <input type="hidden" name="parentCommentId" value="${comment.feed_comments_id}">
	                    <input type="hidden" name="userId" value="${now_id}">
	                    <input type="text" name="replyText" placeholder="답글을 입력하세요" />
	                    <button type="submit">답글 달기</button>
	                </form>
	            </div>
            </div>
            
                <div style="display: flex; flex-direction: column; align-items: flex-end; margin-left: auto;">
                    <c:if test="${comment.user_id eq now_id}">
                        <form action="feedDetail/deleteComment" method="post" style="margin: 0;">
                            <input type="hidden" name="feedCommentsId" value="${comment.feed_comments_id}" />
                            <input type="hidden" name="feedId" value="${feedDetail.feed_id}" />
                            <button type="submit" class="delete-comment-btn">
                                <img src="static/images/setting/delete_button.png" alt="Delete Button">
                            </button>
                        </form>
                    </c:if>
                    <div class="comment-date" style="font-size: 0.8em; color: gray; margin-top: 5px;">${comment.feed_comments_date}</div>
                </div>
            </div>
        </c:forEach>
        
        
        <!-- 코멘트 입력 폼 -->
        <div class="comment-form">
            <form action="feedDetail/comments" method="post">
                <input type="hidden" name="feedId" value="${feedDetail.feed_id}">
                <input type="hidden" name="userId" value="${now_id}">
                <input type="text" name="comments" placeholder="댓글을 입력하세요" />
                <button type="submit" class="btn">입력</button>
            </form>
        </div>
    </div>

    <div id="otherModal" class="modal">
        <div class="modal-content">
            <div id="deletePost" class="modal-item red" style="display: none;">게시글 삭제</div>
            <div id="hidePost" class="modal-item" style="display: none;">게시글 숨기기</div>
            <div id="reportPost" class="modal-item red" style="display: none;">게시글 신고</div>
            <div class="modal-item gray" onclick="closeOtherModal()">취소</div>
        </div>
    </div>

    <script>
        let selectedPostId = null;
        let isOwner = false;

        function openOtherModal(postId, postOwnerId, currentUserId) {
            selectedPostId = postId;
            isOwner = (postOwnerId === currentUserId);

            document.getElementById("deletePost").style.display = isOwner ? "block" : "none";
            document.getElementById("hidePost").style.display = isOwner ? "block" : "none";
            document.getElementById("reportPost").style.display = isOwner ? "none" : "block";

            document.getElementById("otherModal").style.display = "flex";
        }

        function closeOtherModal() {
            document.getElementById("otherModal").style.display = "none";
            selectedPostId = null;
        }

        document.getElementById("deletePost").addEventListener("click", function() {
            if (confirm("정말로 게시글을 삭제하시겠습니까?")) {
                window.location.href = `feedDel?f=\${selectedPostId}`;
            }
            closeOtherModal();
        });

        document.getElementById("hidePost").addEventListener("click", function() {
            alert("게시글을 숨깁니다.");
            window.location.href = `feedHide?f=\${selectedPostId}`;
            closeOtherModal();
        });

        document.getElementById("reportPost").addEventListener("click", function() {
            alert("게시글을 신고했습니다.");
            closeOtherModal();
        });

        window.addEventListener('click', function(event) {
            const modal = document.getElementById("otherModal");
            if (event.target === modal) {
                closeOtherModal();
            }
        });

        // other-btn 클릭 시 모달 열기
        document.querySelectorAll('.other-btn').forEach(button => {
            button.addEventListener('click', function(event) {
                event.stopPropagation();  // 부모로의 클릭 이벤트 전파 방지
                const postElement = this.closest('.post');
                const postId = postElement.getAttribute('data-post-id');
                const postOwnerId = postElement.getAttribute('data-user-id');
                const currentUserId = '${now_id}'; // 현재 사용자 ID

                openOtherModal(postId, postOwnerId, currentUserId);
            });
        });
    </script>

    <script>
        // 좋아요 처리 로직
        document.querySelector('.like-btn').addEventListener('click', function() {
            const feedId = this.getAttribute('data-feed-id');
            const nowId = this.getAttribute('data-now-id');

            fetch('/whale/feedLike', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: new URLSearchParams({
                    'feedId': feedId,
                    'now_id': nowId
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    this.querySelector('.like-count').textContent = data.newLikeCount;
                } else {
                    alert("좋아요 처리에 실패했습니다.");
                }
            })
            .catch(error => console.error('Error:', error));
        });
        
        document.querySelectorAll('.comment-like-btn').forEach(button => {
            button.addEventListener('click', function() {
                const commentId = this.getAttribute('data-comment-id');
                const nowId = this.getAttribute('data-now-id');

                fetch('/whale/commentLike', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: new URLSearchParams({
                        'commentId': commentId,
                        'now_id': nowId
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        this.querySelector('.comment-like-count').textContent = data.newLikeCount;
                    } else {
                        alert("좋아요 처리에 실패했습니다.");
                    }
                })
                .catch(error => console.error('Error:', error));
            });
        });
        
        function toggleReplyForm(commentId) {
            const replyForm = document.getElementById(`reply-form-\${commentId}`);
            if (replyForm.style.display === 'none' || replyForm.style.display === '') {
                replyForm.style.display = 'block';
            } else {
                replyForm.style.display = 'none';
            }
        }
    </script>

</body>
</html>