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
			margin-left: 10px;
		    margin-top: 10px;
		    display: flex;
		    align-items: center;
		}
		
		.post-content {
		    flex: 1;
		}
		
		.post-text p {
		    margin: 0;
		}
		
		.post-time {
			float: right;
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
		.comment {
		    position: relative;
		    padding: 20px 0;
		    margin-left: 10px;
		    border-bottom: 1px solid #e0e0e0;
		}
		
		.comment-form {
			margin-left: 30px;
		}
		
		.comment-header {
		    display: flex;
		    align-items: center;
		}
		
		.comment .profile-pic {
		    width: 30px;
		    height: 30px;
		    border-radius: 50%;
		}
		
		.comment-meta {
		    display: flex;
		    flex-direction: column;
		    margin-left: 10px;
		}
		
		.comment-meta .username {
		    font-size: 0.9em;
		    font-weight: bold;
		}
		
		.comment-meta .comment-date {
		    font-size: 0.8em;
		    color: gray;
		}
		
		.comment-other-btn {
		    background: none;
		    border: none;
		    cursor: pointer;
		    margin-left: auto;
		}
		
		.comment-other-btn img {
		    width: 20px;
		    height: 20px;
		}
		
		.comment-text {
		    margin: 5px 0;
		    padding-left: 40px;
		}
		
		.comment-actions {
		    display: flex;
		    align-items: center;
		    padding-left: 40px;
		}
		
		/* 답글 스타일 */
		.replies {
		    margin-left: 40px;
		}
		
		.reply {
		    position: relative;
		    padding: 10px 0;
		    border-bottom: 1px solid #e0e0e0;
		}
		
		.reply .comment-header {
		    display: flex;
		    align-items: center;
		}
		
		.reply .profile-pic {
		    width: 25px;
		    height: 25px;
		    border-radius: 50%;
		}
		
		.reply .comment-meta {
		    display: flex;
		    flex-direction: column;
		    margin-left: 10px;
		}
		
		.reply .username {
		    font-size: 0.85em;
		    font-weight: bold;
		}
		
		.reply .comment-date {
		    font-size: 0.75em;
		    color: gray;
		}
		
		.reply .comment-other-btn {
		    background: none;
		    border: none;
		    cursor: pointer;
		    margin-left: auto;
		}
		
		.reply .comment-other-btn img {
		    width: 18px;
		    height: 18px;
		}
		
		.reply .comment-text {
		    margin: 5px 0;
		    padding-left: 35px;
		}
		
		.reply .comment-actions {
		    display: flex;
		    align-items: center;
		    padding-left: 35px;
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
        
		.music-info {
		    display: flex;
		    align-items: center;
		    justify-content: space-between; /* 양 끝에 요소 배치 */
		    padding: 10px;
		    background-color: #f9f9f9;
		    border-radius: 5px;
		    margin-bottom: 10px;
		}
		
		.music-info > div {
		    flex-grow: 1; /* 제목과 아티스트 영역이 남은 공간 차지 */
		}
		
		.music-info label {
		    margin-left: 10px; /* 버튼 간 간격 조정 */
		}
		
    </style>
</head>
<body>

    <div class="post" data-post-id="${feedDetail.feed_id}" data-user-id="${feedDetail.user_id}" data-open-id="${feedDetail.feed_open}">
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
		<br />
		<br />
		<div class="post-text">
		    <div class="post-content">
		        <p>${feedDetail.feed_text}</p>
		    </div>
		</div>
		    <br />
                <c:if test="${not empty feedDetail.track_id}">
                    <div id="music-info" class="music-info">
		                <img id="album-icon" src="${feedDetail.track_cover}" alt="Album Icon" style="width: 50px; height: 50px;">
		                <div>
		                    <span id="music-title">${feedDetail.track_name}</span> - <span id="artist-name">${feedDetail.track_artist}</span>
		                </div>
 				        <label class="play-button" onclick="playMusic(this, '${feedDetail.track_spotify_id}')" style="display: inline-block;">
				            <img src="static/images/btn/play_btn.png" alt="play" style="width: 40px; height: 40px;" />
				        </label>
				        <!-- Pause 버튼 -->
				        <label class="pause-button" onclick="pauseMusic(this, '${feedDetail.track_spotify_id}')" style="display: none;">
				            <img src="static/images/btn/pause_btn.png" alt="pause" style="width: 40px; height: 40px;" />
				        </label>
		            </div>
                </c:if>
		    <span class="post-time">${feedDetail.feed_date}</span>

		<br />


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

	<div class="comments-section">
	    <c:forEach var="comment" items="${feedDetail.feedComments}">
	        <div class="comment" data-feed-id="${comment.feed_id}" data-comment-id="${comment.feed_comments_id}" data-user-id="${comment.user_id}">
	            <!-- 댓글 헤더 -->
	            <div class="comment-header">
	                <!-- 프로필 사진 -->
	                <a href="profileHome?u=${comment.user_id}">
	                    <img src="static/images/setting/${comment.user_image_url}" alt="User Profile" class="profile-pic">
	                </a>
	                <!-- 아이디와 날짜 -->
	                <div class="comment-meta">
	                    <span class="username">${comment.user_id}</span>
	                    <span class="comment-date">${comment.feed_comments_date}</span>
	                </div>
	                <!-- other_btn -->
	                <button class="comment-other-btn">
	                    <img src="static/images/btn/other_btn.png" alt="Other Button">
	                </button>
	            </div>
	            <!-- 댓글 내용 -->
	            <p class="comment-text">${comment.feed_comments_text}</p>
	            <!-- 좋아요 및 답글 아이콘 -->
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
	                        <div class="reply" data-feed-id="${reply.feed_id}" data-comment-id="${reply.feed_comments_id}" data-user-id="${reply.user_id}">
	                            <!-- 답글 헤더 -->
	                            <div class="comment-header">
	                                <!-- 프로필 사진 -->
	                                <a href="profileHome?u=${reply.user_id}">
	                                    <img src="static/images/setting/${reply.user_image_url}" alt="User Profile" class="profile-pic">
	                                </a>
	                                <!-- 아이디와 날짜 -->
	                                <div class="comment-meta">
	                                    <span class="username">${reply.user_id}</span>
	                                    <span class="comment-date">${reply.feed_comments_date}</span>
	                                </div>
	                                <!-- other_btn -->
	                                <button class="comment-other-btn">
	                                    <img src="static/images/btn/other_btn.png" alt="Other Button">
	                                </button>
	                            </div>
	                            <!-- 답글 내용 -->
	                            <p class="comment-text">${reply.feed_comments_text}</p>
	                            <!-- 좋아요 아이콘 -->
	                            <div class="comment-actions">
	                                <button type="button" class="comment-like-btn" data-comment-id="${reply.feed_comments_id}" data-now-id="${now_id}">
	                                    <img class="likebtn" src="static/images/btn/like_btn.png" alt="like" />
	                                    <span class="comment-like-count">${reply.likeCount}</span>
	                                </button>
	                            </div>
	                        </div>
	                    </c:forEach>
	                </div>
	            </c:if>
	            <!-- 답글 입력 폼 -->
	            <div class="reply-form" id="reply-form-${comment.feed_comments_id}" style="display: none;" onsubmit="validateReplyForm(event)">
	                <form action="feedDetail/reply" method="post">
	                    <input type="hidden" name="feedId" value="${feedDetail.feed_id}">
	                    <input type="hidden" name="parentCommentId" value="${comment.feed_comments_id}">
	                    <input type="hidden" name="userId" value="${now_id}">
	                    <input type="text" name="replyText" placeholder="답글을 입력하세요" />
	                    <button type="submit">답글 달기</button>
	                </form>
	            </div>
	        </div>
	    </c:forEach>
	    <!-- 댓글 입력 폼 -->
	    <div class="comment-form">
	        <form action="feedDetail/comments" method="post" onsubmit="validateCommentForm(event)">
	            <input type="hidden" name="feedId" value="${feedDetail.feed_id}">
	            <input type="hidden" name="userId" value="${now_id}">
	            <input type="text" name="comments" placeholder="댓글을 입력하세요" />
	            <button type="submit" class="btn">입력</button>
	        </form>
	    </div>
	</div>

	<div id="otherModal" class="modal">
	    <div class="modal-content">
	        <div id="deleteItem" class="modal-item red" style="display: none;">삭제</div>
	        <div id="hidePostItem" class="modal-item" style="display: none;">게시글 비공개</div>
	        <div id="openPostItem" class="modal-item" style="display: none;">게시글 공개</div>
	        <div id="reportItem" class="modal-item red" style="display: none;">신고</div>
	        <div class="modal-item gray" onclick="closeOtherModal()">취소</div>
	    </div>
	</div>

	<script type="text/javascript">
	    function validateCommentForm(event) {
	        var comments = document.getElementsByName("comments")[0].value.trim();
	        if (comments === "") {
	            alert("댓글 내용을 작성해 주세요.");
	            event.preventDefault();  // 폼 제출을 중단
	            return false;
	        }
	        return true;
	    }
	    function validateReplyForm(event) {
	        var replyText = event.target.querySelector("[name='replyText']").value.trim();
	        if (replyText === "") {
	            alert("답글 내용을 작성해 주세요.");
	            event.preventDefault();  // 폼 제출을 중단
	            return false;
	        }
	        return true;
	    }
	</script>

	<script>
	    let selectedItemId = null;
	    let selectedItemFeedId = null;
	    let selectedOpenId = null;
	    let selectedItemType = null; // 'post', 'comment', 'reply'
	    let isOwner = false;
	
	    function openOtherModal(itemId, openId, itemFeedId, itemOwnerId, currentUserId, itemType) {
	        selectedItemId = itemId;
	        selectedItemFeedId = itemFeedId;
	        selectedOpenId = openId;
	        selectedItemType = itemType;
	        isOwner = (itemOwnerId === currentUserId);
	
	        // 모든 모달 아이템을 초기화
	        document.getElementById("deleteItem").style.display = "none";
	        document.getElementById("hidePostItem").style.display = "none";
	        document.getElementById("openPostItem").style.display = "none";
	        document.getElementById("reportItem").style.display = "none";
	
	        if (itemType === 'post') {
	            if (isOwner) {
	                document.getElementById("deleteItem").style.display = "block";
	                if (selectedOpenId == 1) {
	                	document.getElementById("openPostItem").style.display = "block";
	                } else {	                	
	                	document.getElementById("hidePostItem").style.display = "block";
	                }
	            } else {
	                document.getElementById("reportItem").style.display = "block";
	            }
	        } else if (itemType === 'comment' || itemType === 'reply') {
	            if (isOwner) {
	                document.getElementById("deleteItem").style.display = "block";
	            } else {
	                document.getElementById("reportItem").style.display = "block";
	            }
	        }
	
	        document.getElementById("otherModal").style.display = "flex";
	    }
	
	    function closeOtherModal() {
	        document.getElementById("otherModal").style.display = "none";
	        selectedItemId = null;
	        selectedItemType = null;
	    }
	
	    document.getElementById("deleteItem").addEventListener("click", function() {
	        if (confirm("정말로 삭제하시겠습니까?")) {
	            if (selectedItemType === 'post') {
	                window.location.href = `feedDel?f=\${selectedItemId}`;
	            } else if (selectedItemType === 'comment' || selectedItemType === 'reply') {
	                window.location.href = `feedDetail/deleteComment?feedCommentsId=\${selectedItemId}&feedId=\${selectedItemFeedId}`;
	            }
	        }
	        closeOtherModal();
	    });
	
	    document.getElementById("hidePostItem").addEventListener("click", function() {
	        alert("게시글을 숨깁니다.");
	        window.location.href = `feedHide?f=\${selectedItemId}`;
	        closeOtherModal();
	    });
	    
	    document.getElementById("openPostItem").addEventListener("click", function() {
	        alert("게시글을 공개합니다.");
	        window.location.href = `feedOpen?f=\${selectedItemId}`;
	        closeOtherModal();
	    });
	
	    document.getElementById("reportItem").addEventListener("click", function() {
            if (selectedItemType === 'post') {
                window.location.href = `report?f=\${selectedItemId}`;
            } else if (selectedItemType === 'comment' || selectedItemType === 'reply') {
                window.location.href = `report?fc=\${selectedItemId}`;
            }
	        closeOtherModal();
	    });
	
	    window.addEventListener('click', function(event) {
	        const modal = document.getElementById("otherModal");
	        if (event.target === modal) {
	            closeOtherModal();
	        }
	    });
	
	    // 게시글의 other-btn 클릭 시 모달 열기
	    document.querySelectorAll('.other-btn').forEach(button => {
	        button.addEventListener('click', function(event) {
	            event.stopPropagation();
	            const postElement = this.closest('.post');
	            const itemId = postElement.getAttribute('data-post-id');
	            const itemFeedId = postElement.getAttribute('data-feed-id');
	            const openId = postElement.getAttribute('data-open-id');
	            const itemOwnerId = postElement.getAttribute('data-user-id');
	            const currentUserId = '${now_id}';
	
	            openOtherModal(itemId, openId, itemFeedId, itemOwnerId, currentUserId, 'post');
	        });
	    });
	
	    // 댓글 및 답글의 other-btn 클릭 시 모달 열기
	    document.querySelectorAll('.comment-other-btn, .reply-other-btn').forEach(button => {
	        button.addEventListener('click', function(event) {
	            event.stopPropagation();
	            const itemElement = this.closest('.comment, .reply');
	            const itemId = itemElement.getAttribute('data-comment-id');
	            const openId = 0;
	            const itemFeedId = itemElement.getAttribute('data-feed-id');
	            const itemOwnerId = itemElement.getAttribute('data-user-id');
	            const currentUserId = '${now_id}';
	            const itemType = itemElement.classList.contains('reply') ? 'reply' : 'comment';
	
	            openOtherModal(itemId, openId, itemFeedId, itemOwnerId, currentUserId, itemType);
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


        function playMusic(element, spotifyId) {
        	fetch(`/whale/feedPlayMusic?id=\${spotifyId}`)
	            .then(response => {
	                if (response.ok) {
	                    // Play 버튼 숨기고 Pause 버튼 보이기
	                    element.style.display = 'none';
	                    const pauseBtn = element.parentElement.querySelector('label[onclick^="pauseMusic"]');
	                    if (pauseBtn) {
	                        pauseBtn.style.display = 'inline-block';
	                    }
	                } else {
	                    alert('음악 재생에 실패했습니다.');
	                }
	            })
	            .catch(error => {
	                console.error('에러 발생:', error);
	                alert('음악 재생 중 오류가 발생했습니다.');
	            });
	    }

	    function pauseMusic(element, spotifyId) {
	        fetch('/whale/feedPauseMusic?id=${spotifyId}')
	            .then(response => {
	                if (response.ok) {
	                    // Pause 버튼 숨기고 Play 버튼 보이기
	                    element.style.display = 'none';
	                    const playBtn = element.parentElement.querySelector('label[onclick^="playMusic"]');
	                    if (playBtn) {
	                        playBtn.style.display = 'inline-block';
	                    }
	                } else {
	                    alert('음악 일시정지에 실패했습니다.');
	                }
	            })
	            .catch(error => {
	                console.error('에러 발생:', error);
	                alert('음악 일시정지 중 오류가 발생했습니다.');
	            });
	    }
    </script>

</body>
</html>