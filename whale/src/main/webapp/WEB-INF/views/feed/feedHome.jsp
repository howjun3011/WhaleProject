<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feed Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f0f0;
        }

        /* 상단 바 스타일 */
        .top-bar {
            background-color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
            height: 20px;
        }

        .top-bar img {
            width: 80px;
            cursor: pointer;
        }

        /* 글 작성 영역 */
        .write-area-container {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.5s ease;
            background-color: white;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 0 10px;
        }

        .write-area-container.open {
            max-height: 300px;
        }

        .write-area textarea {
            width: 90%;
            height: 150px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            resize: none;
            font-size: 1em;
            margin-top: 10px;
        }

        .submit-btn {
            display: block;
            width: 90%;
            margin: 10px auto;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
        }

        /* 피드 레이아웃 */
        .feed {
            margin-top: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .post {
            background-color: white;
            width: 90%;
            max-width: 600px;
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 15px;
        }

        .user-info {
            display: flex;
            align-items: center;
        }

        .user-info .profile-pic {
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
            margin-top: 10px;
            font-size: 1em;
        }

        .post-actions span {
            cursor: pointer;
        }

        .post-text {
            margin-top: 10px;
        }

        .post-time {
            font-size: 0.8em;
            color: gray;
        }
    </style>
</head>
<body>

<!-- 상단 바 -->
<div class="top-bar">
    <img src="static/images/feed/pencel.png" alt="Apple Pencil" id="writeButton">
</div>

<!-- 글 작성 영역 (jsp:include로 가져옴) -->
<div class="write-area-container" id="writeAreaContainer">
    <jsp:include page="feedWrite.jsp" />
</div>

<!-- 피드 섹션 -->
<div class="feed">
    <!-- 반복문으로 글 출력 -->
    <c:forEach var="feed" items="${feedList}">
        <div class="post">
            <div class="user-info">
                <a href="profileHome?u=${feed.user_id}"><img src="static/images/setting/${feed.user_image_url}" alt="User Profile" class="profile-pic"></a>
                <span class="username">${feed.user_id}</span>
            </div>

            <!-- 이미지가 존재할 때만 출력 -->
            <c:if test="${not empty feed.feed_img_name}">
                <a href="feedDetail?f=${feed.feed_id}"><img src="static/images/feed/${feed.feed_img_name}" alt="Post Image" class="post-image"></a>
            </c:if>

            <div class="post-text">
                <p>${feed.feed_text}</p>
                <span class="post-time">${feed.feed_date}</span>
            </div>
            <div class="post-actions">
                <button type="button" class="like-btn" data-feed-id="${feed.feed_id}" data-now-id="${now_id}">
                    ❤ <span class="likes">${feed.likeCount}</span>
                </button>
                <span class="comments">💬 ${feed.commentsCount}</span>
            </div>
        </div>
    </c:forEach>
</div>

<script>

    document.querySelectorAll('.like-btn').forEach(button => {
        button.addEventListener('click', function() {
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
                .then(response => response.json()) // 서버에서 JSON 응답을 기대
                .then(data => {
                    if (data.success) {
                        // 좋아요 수 업데이트
                        this.querySelector('.likes').textContent = data.newLikeCount;
                    } else {
                        alert("좋아요 처리에 실패했습니다.");
                    }
                })
                .catch(error => console.error('Error:', error));
        });
    });


    var offset = 10;  // 첫 로딩에서 시작하는 offset 값
    const size = 10;  // 한 번에 가져올 피드 수
    var isLastPage = false;  // 마지막 페이지 여부를 추적
    var isLoading = false;  // 로딩 상태를 추적

    function loadMoreFeeds() {
        if (isLoading || isLastPage) {
            return;  // 이미 로딩 중이거나 마지막 페이지라면 더 이상 요청하지 않음
        }

        isLoading = true;  // 로딩 시작 상태로 변경

        console.log("현재 offset 값:", offset);  // 현재 offset 값 로그

        // 서버로 offset과 size를 전송하여 피드 데이터를 가져옴
        fetch(`/whale/loadMoreFeeds?offset=\${offset}&size=${size}`)
            .then(response => response.text())
            .then(newFeeds => {
                const feedContainer = document.querySelector('.feed');
                feedContainer.insertAdjacentHTML('beforeend', newFeeds);  // 피드를 추가합니다.

                offset += size;  // 다음 요청을 위해 offset 값을 업데이트
                console.log("업데이트된 offset 값:", offset);  // 업데이트된 offset 값 로그

                // 서버로부터 마지막 페이지 여부 확인 (예: hidden input으로 받았다고 가정)
                const isLastPageElement = document.getElementById('isLastPage');
                if (isLastPageElement) {
                    isLastPage = isLastPageElement.value === "true";
                }

                isLoading = false;  // 로딩 상태 해제
            })
            .catch(error => {
                console.error("피드 로드 실패:", error);
                isLoading = false;  // 실패 시에도 로딩 상태 해제
            });
    }

    // 스크롤 이벤트로 페이지 끝에 도달했을 때 추가 피드 로드
    window.addEventListener('scroll', () => {
        if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight) {
            loadMoreFeeds();  // 페이지 끝에 도달하면 피드 로드를 시작
        }
    });

    // 펜 이미지를 클릭하면 글 작성 영역이 확장됨
    document.getElementById('writeButton').addEventListener('click', function() {
        const writeAreaContainer = document.getElementById('writeAreaContainer');
        writeAreaContainer.classList.toggle('open'); // 클릭 시 open 클래스를 토글
    });
</script>

</body>
</html>