<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script> <!-- jQuery 추가 -->
<meta charset="UTF-8">
<title>채팅방</title>
<link rel="stylesheet" href="static/css/streaming/searchView.css" />
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600&display=swap">
<style>
    /* 기본 스타일 */
    
    
    body {
        font-family: 'Noto Sans KR', Arial, sans-serif;
        background-color: #f8f9fa;
        margin: 0;
        padding: 0;
    }

    .container {
        width: 100%;
        max-width: 900px;
        margin: 0 auto;
        background-color: #ffffff;
        padding: 40px 20px;
        box-sizing: border-box;
    }

    /* 채팅 헤더 스타일 */
    .chat-header {
        background: linear-gradient(to right, #e0e0e0, #ffffff);
        padding: 15px 20px;
        font-size: 1.0em;
        font-weight: bold;
        color: #343a40;
        margin-bottom: 30px;
        text-align: center;
    }

    /* 채팅 메시지 영역 스타일 */
    .chat-messages {
        height: 500px;
        overflow-y: scroll;
        padding: 20px;
        background-color: #f8f9fa;
        border: 1px solid #e9ecef;
        box-sizing: border-box;
        margin-bottom: 30px;
    }

    .chat-message {
        margin-bottom: 20px;
        display: flex;
        align-items: flex-end;
    }

    .chat-message.left {
        justify-content: flex-start;
    }

    .chat-message.right {
        justify-content: flex-end;
    }

    .chat-message .message-bubble {
        max-width: 60%;
        padding: 15px;
        border-radius: 15px;
        position: relative;
        font-size: 1em;
        line-height: 1.6;
        word-wrap: break-word;
    }

    .chat-message.left .message-bubble {
        background-color: #ffffff;
        border: 1px solid #e9ecef;
    }

    .chat-message.right .message-bubble {
        background-color: #d1e7dd;
        border: 1px solid #c7d9d3;
    }

    .chat-message.left .message-bubble::after {
        content: '';
        position: absolute;
        top: 10px;
        left: -10px;
        border: 10px solid transparent;
        border-right-color: #ffffff;
    }

    .chat-message.right .message-bubble::after {
        content: '';
        position: absolute;
        top: 10px;
        right: -10px;
        border: 10px solid transparent;
        border-left-color: #d1e7dd;
    }

    .chat-message .message-info {
        font-size: 0.9em;
        color: #868e96;
        margin-top: 5px;
    }

    /* 채팅 입력 영역 스타일 */
    .chat-input {
        display: flex;
        align-items: center;
        padding: 10px;
        background-color: #ffffff;
        border-top: 1px solid #e9ecef;
        gap: 10px;
    }

    .chat-input textarea {
        flex-grow: 1;
        height: 50px;
        border: 1px solid #ced4da;
        border-radius: 5px;
        padding: 10px;
        resize: none;
        font-size: 1em;
    }

    .chat-input button {
        width: 90px;
        height: 50px;
        background-color: #12b886;
        border: none;
        color: #ffffff;
        border-radius: 5px;
        font-size: 1em;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .chat-input button:hover {
        background-color: #0ca678;
    }

    .unread-badge {
        font-size: 0.8em;
        color: red;
        position: absolute;
    }

    .chat-message.left .unread-badge {
        bottom: 5px;
        right: -10px;
    }

    .chat-message.right .unread-badge {
        bottom: 5px;
        left: -10px;
    }
    
    .chat-message .message-bubble iframe {
	    width: 100%; /* 말풍선의 너비에 맞춰 YouTube iframe 크기 조절 */
	    height: 200px; /* 적당한 높이 지정 */
	    border-radius: 5px;
	    border: none;
	}
	
	.message-url {
	    font-size: 0.8em; /* 작은 폰트 크기 */
	    color: #888888;   /* 회색 톤으로 색상 지정 */
	    margin-top: 5px;  /* 위쪽에 약간의 간격 추가 */
	    word-break: break-all; /* 긴 URL이 잘리도록 설정 */
	}
	
    .profile-pic {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        margin-right: 0px;
    }
    
    .menu-button {
	    position: absolute;
	    top: 0px;
	    right: 10px;
	    font-size: 1.2em;
	    color: #f0eded;
	    cursor: pointer;
	}
	
	.menu-button:hover {
	    color: #555555;
	}
	
	.modal {
	    display: none; /* 기본적으로 숨김 */
	    position: fixed;
	    z-index: 1000;
	    left: 0;
	    top: 0;
	    width: 100%;
	    height: 100%;
	    overflow: auto;
	    background-color: rgba(0,0,0,0.4); /* 검은색 투명 배경 */
	}
	
	/* 모달 내용 스타일 */
	.modal-content {
	    background-color: #fefefe;
	    margin: 15% auto; /* 화면 가운데에 위치 */
	    padding: 20px;
	    border: 1px solid #888;
	    width: 300px; /* 너비 설정 */
	    border-radius: 10px;
	    position: relative;
	}
	
	/* 닫기 버튼 스타일 */
	.close {
	    color: #aaa;
	    float: right;
	    font-size: 28px;
	    font-weight: bold;
	    cursor: pointer;
	}
	
	.close:hover,
	.close:focus {
	    color: black;
	    text-decoration: none;
	    cursor: pointer;
	}
	
	/* 옵션 목록 스타일 */
	#messageMenuOptions {
	    list-style: none;
	    padding: 0;
	    margin: 0;
	}
	
	#messageMenuOptions li {
	    padding: 10px;
	    cursor: pointer;
	    border-bottom: 1px solid #ddd;
	}
	
	#messageMenuOptions li:hover {
	    background-color: #f2f2f2;
	}
	
	.music-info { display: flex; align-items: center; gap: 10px; padding: 10px; background-color: #f9f9f9; border-radius: 5px; margin-bottom: 10px; }
	.modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.6); justify-content: center; align-items: center; }
	.modal .modal-content-music { background-color: white; border-radius: 12px; width: 50%; height: 80%; text-align: center; overflow: hidden; }

</style>
</head>
<body>

<div class="container">
    <!-- 채팅 헤더 -->
    <div class="chat-header">
        <a href="profileHome?u=${userId}"><img src="${userImage}" alt="${userId}" class="profile-pic" /></a>
        <div>${userId}</div>
    </div>

    <!-- 채팅 메시지 영역 -->
    <div class="chat-messages" id="chatMessages">
        <!-- 채팅 메시지들을 표시할 영역 -->
		<c:forEach var="msg" items="${messages}">
		    <div class="chat-message <c:choose>
		        <c:when test="${msg.user_id == now_id}">
		            right
		        </c:when>
		        <c:otherwise>
		            left
		        </c:otherwise>
		    </c:choose>" id="message-${msg.message_id}">
		        <div class="message-bubble">
		            <div class="menu-button" onclick="openMessageMenu(${msg.message_id}, '${msg.user_id}')">
				        •
				    </div>
			<c:choose>
			    <c:when test="${msg.message_type eq 'TEXT'}">
			        <div>${msg.message_text}</div>
			    </c:when>
				<c:when test="${msg.message_type == 'MUSIC'}">
				    <div class="music-info">
				        <img src="${msg.track_cover}" alt="Album Cover" style="width: 50px; height: 50px; border-radius: 5px;">
				        <div>
				            <div><strong>${msg.track_name}</strong></div>
				            <div>${msg.track_artist}</div>
				        </div>
				        <label class="play-button" onclick="playMusic(this, '${msg.message_text}')" style="display: inline-block;">
				            <img src="static/images/btn/play_btn.png" alt="play" style="width: 40px; height: 40px;">
				        </label>
				        <label class="pause-button" onclick="pauseMusic(this, '${msg.message_text}')" style="display: none;">
				            <img src="static/images/btn/pause_btn.png" alt="pause" style="width: 40px; height: 40px;">
				        </label>
				    </div>
				</c:when>
			    <c:when test="${msg.message_type eq 'LINK'}">
			        <c:if test="${!empty msg.previewData}">
			            <div class="preview">
			                <a href="${msg.previewData['url']}" target="_blank" style="text-decoration: none; color: inherit;">
			                    <img src="${msg.previewData['image']}" alt="${msg.previewData['title']}" style="width: 60px; height: 60px; border-radius: 5px; margin-right: 10px;">
			                    <div style="display: inline-block; vertical-align: top;">
			                        <div><strong>${msg.previewData['title']}</strong></div>
			                        <div>${msg.previewData['description']}</div>
			                    </div>
			                </a>
			            </div>
			        </c:if>
			        <div class="message-url">${msg.previewData['url']}</div>
			    </c:when>
			    <c:otherwise>
			        <div><img src="${msg.message_text}" alt="Image" style="max-width: 100%; border-radius: 5px;"></div>
			    </c:otherwise>
			</c:choose>

		            <div class="message-info">
		                ${msg.user_id} • 
		                <fmt:formatDate value="${msg.message_create_date}" pattern="yyyy-MM-dd HH:mm:ss" />
		            </div>
		            <!-- 안 읽은 메시지일 경우 읽지 않음 표시 -->
		            <c:if test="${msg.message_read eq 1}">
		                <span class="unread-badge">1</span>
		            </c:if>
		        </div>
		    </div>
		</c:forEach>
    </div>

    <!-- 채팅 입력 영역 -->
	<div class="chat-input">
	    <form onsubmit="sendMessage(); return false;" style="display: flex; align-items: center; gap: 10px; width: 100%;">
	        <input type="hidden" name="roomId" value="${roomId}">
	        <input type="hidden" name="userId" value="${userId}">
	        <textarea id="messageInput" placeholder="메시지를 입력하세요." required 
	                  onkeypress="if(event.keyCode==13 && !event.shiftKey){ sendMessage(); return false;}"></textarea>
	        <input type="file" id="imageInput" accept="image/*" onchange="uploadImageAndSendURL()" style="display:none;">
	        <button type="submit" style="width:60px;"><img src="static/images/btn/write_btn.png" alt="" style="width: 40px; height: 40px;" /></button>
	        <button type="button" style="width:60px;" onclick="document.getElementById('imageInput').click();"><img src="static/images/btn/picsong_btn.png" alt="" style="width: 40px; height: 40px;" /></button>
	        <button type="button" class="music-upload-btn" style="width:60px;"><img src="static/images/btn/promusic_btn.png" alt="" style="width: 25px; height: 25px;" /></button>
	    </form>
	</div>
</div>

<div id="musicModal" class="modal">
    <div class="modal-content-music">
	  	<div class="searchContainer" style="margin-top: 20px;">
			<div class="headerSearch" style="width: 60%;">
				<button class="searchBtn" id="search-button">
					<img src="static/images/streaming/searchBtn.png" alt="Music Whale Search Button" height="14px">
			    </button>
			    <input class="headerInput" id="search-input" placeholder="어떤 콘텐츠를 감상하고 싶으세요?" onfocus="this.placeholder=''" onblur="this.placeholder='어떤 콘텐츠를 감상하고 싶으세요?'">
			</div>
		</div>
		<div class="search-result-container">
			<div id="pagination" style="margin-top: 3px;"></div>
			<div id="search-results"></div>
		</div>
		<div class="modal-item gray" id="completeBtn" style="margin-top: -14px;">완료</div>
        <div class="modal-item gray" onclick="closeMusicModal()">취소</div>
    </div>
</div>

<script>
    window.addEventListener('click', function(event) {
        const modal = document.getElementById("musicModal");
        if (event.target === modal) {
            closeOtherModal();
        }
    });

    document.querySelectorAll('.music-upload-btn').forEach(button => {
        button.addEventListener('click', function(event) {
            event.stopPropagation();  // 부모로의 클릭 이벤트 전파 방지
            openMusicModal();  // 모달을 여는 함수 호출
        });
    });
    
    function openMusicModal() {
        const musicModal = document.getElementById("musicModal");
        musicModal.style.display = "flex";  // 모달을 표시
    }

    function closeMusicModal() {
        const musicModal = document.getElementById("musicModal");
        musicModal.style.display = "none";  // 모달을 닫음
    }

    window.addEventListener('click', function(event) {
        const musicModal = document.getElementById("musicModal");
        if (event.target === musicModal) {
            closeMusicModal();  // 모달 바깥을 클릭하면 닫음
        }
    });
    
    document.getElementById("completeBtn").addEventListener("click", function() {
        const selectedTrackInput = document.querySelector('input[name="track"]:checked');
        if (!selectedTrackInput) {
            alert("음악을 선택해주세요.");
            return;
        }

        // 선택한 트랙의 정보를 가져옵니다 (JSON 문자열로 가정)
        const body = selectedTrackInput.value;

        // 서버로 선택한 트랙 정보를 POST 요청으로 전송합니다
        fetch('/whale/updateMusic', {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            method: 'POST',
            body: body
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('서버 응답에 문제가 있습니다: ' + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            console.log('서버로부터 받은 데이터:', data);
            
		    const payload = roomId + ":" + now_id + ":MUSIC:" + data.track_id;
		    socket.send(payload);
            
            // 모달을 닫습니다
            closeMusicModal();
        })
        .catch(error => {
            console.error('에러 발생:', error);
            alert('음악 정보를 가져오는 중 오류가 발생했습니다.');
        });
    });
    
    let currentPlayingTrackId = null; // 현재 재생 중인 트랙 ID를 저장

    
    
    
    // 음악 재생 함수
    function playMusic(element, trackId) {
        resetAllMusicButtons(); // 모든 버튼 초기화
        fetch(`/whale/feedPlayMusic?id=\${trackId}`)
            .then(response => {
                if (response.ok) {
                    currentPlayingTrackId = trackId;
                    element.style.display = 'none';
                    const pauseBtn = element.parentElement.querySelector('label[onclick^="pauseMusic"]');
                    if (pauseBtn) {
                        pauseBtn.style.display = 'inline-block';
                    }
                } else {
                    alert('음악 재생에 실패했습니다.');
                }
            })
            .catch(error => console.error('에러 발생:', error));
    }

    // 음악 일시 정지 함수
    function pauseMusic(element, trackId) {
        fetch(`/whale/feedPauseMusic?id=\${trackId}`)
            .then(response => {
                if (response.ok) {
                    currentPlayingTrackId = null;
                    element.style.display = 'none';
                    const playBtn = element.parentElement.querySelector('label[onclick^="playMusic"]');
                    if (playBtn) {
                        playBtn.style.display = 'inline-block';
                    }
                } else {
                    alert('음악 일시정지에 실패했습니다.');
                }
            })
            .catch(error => console.error('에러 발생:', error));
    }

    // 모든 버튼 초기화
    function resetAllMusicButtons() {
        document.querySelectorAll('.play-button').forEach(btn => btn.style.display = 'inline-block');
        document.querySelectorAll('.pause-button').forEach(btn => btn.style.display = 'none');
    }
</script>

<script src="static/js/streaming/searchView.js"></script>

<script>
	const roomId = '${roomId}';
	const now_id = '${now_id}';
	const userId = '${userId}';
	
	// WebSocket 설정
	const protocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
	const socket = new WebSocket(protocol + "25.5.112.217:9002/whale/chat?roomId=" + roomId + "&userId=" + now_id);
	
	socket.onopen = function() {
	    console.log("WebSocket 연결 성공");
	};
	
	// 이미지 업로드 및 URL 전송
	function uploadImageAndSendURL() {
	    const fileInput = document.getElementById("imageInput");
	    const file = fileInput.files[0];
	    if (file) {
	        const formData = new FormData();
	        formData.append("file", file);
	
	        $.ajax({
	            url: "/whale/uploadImageMessage",
	            type: "POST",
	            data: formData,
	            contentType: false,
	            processData: false,
	            success: function(response) {
	                const imageUrl = response.imageUrl;
	                const payload = roomId + ":" + now_id + ":IMAGE:" + imageUrl;
	                socket.send(payload);
	            },
	            error: function(error) {
	                console.error("Image upload failed:", error);
	            }
	        });
	    }
	}
	
	// 텍스트 메시지 전송
	function sendMessage() {
	    const messageInput = document.getElementById("messageInput");
	    const message = messageInput.value.trim();
	    if (message) {
	        const payload = roomId + ":" + now_id + ":TEXT:" + message;
	        socket.send(payload);
	        messageInput.value = "";
	    }
	}
	
	socket.onmessage = function(event) {
	    console.log("Received message:", event.data);

	    if (event.data.startsWith("READ:")) {
	        // 읽음 상태 변경 알림 처리
	        const parts = event.data.split(':');
	        const msgRoomId = parts[1];
	        const messageIdsStr = parts[2];
	        if (msgRoomId === roomId) {
	            const messageIds = messageIdsStr.split(',');
	            updateMessagesAsRead(messageIds);
	        }
	    } else {
	    
		    const chatMessages = document.getElementById('chatMessages');
	
		    // 메시지 파싱
		    const data = event.data.split('#');
		    const msgRoomId = data[0];
		    const msgUserId = data[1];
		    const msgType = data[2];
		    const msgId = data[3];
		    
		    let msgContent, msgRead, msgDate;
		    
		    if (msgType === 'MUSIC') {
		        msgContent = data.slice(4, data.length - 2).join('#');
		        msgRead = data[data.length - 2];
		        msgDate = data[data.length - 1];
		    } else if (msgType === 'TEXT') {
		        msgContent = data[4];
		        msgRead = data[5];
		        msgDate = data[6];
		    } else {
		        msgContent = data.slice(4, data.length - 2).join('#');
		        msgRead = data[data.length - 2];
		        msgDate = data[data.length - 1];
		    }
	
		    if (msgRoomId === roomId) {
		        const msgDiv = document.createElement('div');
		        msgDiv.className = 'chat-message ' + (msgUserId === now_id ? 'right' : 'left');
		        msgDiv.id = 'message-' + msgId;
	
		        console.log("1: " + msgId);
		        console.log("2: " + msgUserId);
		        
		        let contentHTML = '';
		        contentHTML += '<div class="message-bubble">';
		        contentHTML += '<div class="menu-button" onclick="openMessageMenu(' + msgId + ', \'' + msgUserId + '\')">•</div>';
		        
		        if (msgType === 'MUSIC') {
		            try {
		                const trackData = JSON.parse(msgContent);
		                contentHTML += `
		                    <div class="music-info">
		                        <img src="\${trackData.TRACK_COVER}" alt="Album Cover" style="width: 50px; height: 50px; border-radius: 5px;">
		                        <div>
		                            <div><strong>\${trackData.TRACK_NAME}</strong></div>
		                            <div>\${trackData.TRACK_ARTIST}</div>
		                        </div>
		                        <label class="play-button" onclick="playMusic(this, '\${trackData.TRACK_ID}')" style="display: inline-block;">
		                            <img src="static/images/btn/play_btn.png" alt="play" style="width: 40px; height: 40px;">
		                        </label>
		                        <label class="pause-button" onclick="pauseMusic(this, '\${trackData.TRACK_ID}')" style="display: none;">
		                            <img src="static/images/btn/pause_btn.png" alt="pause" style="width: 40px; height: 40px;">
		                        </label>
		                    </div>
		                `;
		            } catch (e) {
		                console.error("Failed to parse MUSIC message content:", e);
		                contentHTML += '<div>Error loading music content</div>';
		            }
		        } if (msgType === 'TEXT') {
		            contentHTML += '<div>' + msgContent + '</div>';
		        } else if (msgType === 'IMAGE') {
		            contentHTML += '<img src="' + msgContent + '" alt="Image" style="max-width: 100%; border-radius: 5px;">';
		        } else if (msgType === 'LINK') {
		            console.log("LINK message content:", msgContent);
	
		            // Use regex to find #preview= and JSON data after it
		            const previewMatch = msgContent.match(/#preview=(\{.*\})/);
		            if (!previewMatch) {
		                console.log("Preview data not found in message content");
		                contentHTML += '<div>' + msgContent + '</div>';
		            } else {
		                const textContent = msgContent.substring(0, previewMatch.index); // Text before #preview=
		                const previewJsonString = previewMatch[1]; // JSON part only
	
		                try {
		                    const previewData = JSON.parse(previewJsonString);
		                    contentHTML += 
		                        '<div>' + textContent + '</div>' +
		                        '<div class="preview">' +
		                            '<a href="' + previewData.url + '" target="_blank" style="text-decoration: none; color: inherit;">' +
		                                '<img src="' + previewData.image + '" alt="' + previewData.title + '" style="width: 60px; height: 60px; border-radius: 5px; margin-right: 10px;">' +
		                                '<div style="display: inline-block; vertical-align: top;">' +
		                                    '<div><strong>' + previewData.title + '</strong></div>' +
		                                    '<div>' + previewData.description + '</div>' +
		                                '</div>' +
		                            '</a>' +
		                        '</div>';
		                } catch (e) {
		                    console.error("Failed to parse preview data:", e);
		                    contentHTML += '<div>' + msgContent + '</div>';
		                }
		            }
		        }
	
		        contentHTML += '<div class="message-info">' + msgUserId + ' • ' + msgDate + '</div>';
	
		        // 읽지 않은 메시지 표시
		        if (msgRead === '1') {
		            contentHTML += '<span class="unread-badge">1</span>';
		        }
	
		        contentHTML += '</div>'; // message-bubble 닫기
	
		        msgDiv.innerHTML = contentHTML;
		        chatMessages.appendChild(msgDiv);
		        chatMessages.scrollTop = chatMessages.scrollHeight;
		    }
	    }
	};

    // 페이지 로드 시 자동으로 채팅 메시지 영역을 스크롤합니다.
    window.onload = function() {
        const chatMessages = document.getElementById('chatMessages');
        chatMessages.scrollTop = chatMessages.scrollHeight;
    };
    
    function updateMessagesAsRead(messageIds) {
        messageIds.forEach(function(messageId) {
            const messageElement = document.getElementById('message-' + messageId);
            if (messageElement) {
                const unreadBadge = messageElement.querySelector('.unread-badge');
                if (unreadBadge) {
                    unreadBadge.parentNode.removeChild(unreadBadge);
                }
                // 필요에 따라 추가적인 스타일 또는 클래스 변경
                messageElement.classList.add('message-read');
            }
        });
    }
</script>

<div id="messageMenuModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeMessageMenu()">&times;</span>
        <ul id="messageMenuOptions">
            <!-- 옵션 목록이 동적으로 생성됩니다. -->
        </ul>
    </div>
</div>

<script>
	let selectedMessageId = null;
	let selectedMessageUserId = null;
	
	function openMessageMenu(messageId, messageUserId) {
	    selectedMessageId = messageId;
	    selectedMessageUserId = messageUserId;
	
	    const modal = document.getElementById('messageMenuModal');
	    const optionsList = document.getElementById('messageMenuOptions');
	    optionsList.innerHTML = ''; // 기존 옵션 초기화
	
	    // 현재 사용자 ID와 메시지의 사용자 ID 비교
	    if (messageUserId === now_id) {
	        // 본인 메시지인 경우 삭제 옵션 추가
	        const deleteOption = document.createElement('li');
	        deleteOption.innerText = '삭제';
	        deleteOption.onclick = deleteMessage;
	        optionsList.appendChild(deleteOption);
	    } else {
	        // 상대방 메시지인 경우 신고 옵션 추가
	        const reportOption = document.createElement('li');
	        reportOption.innerText = '신고';
	        reportOption.onclick = reportMessage;
	        optionsList.appendChild(reportOption);
	    }
	
	    // 모달 창 열기
	    modal.style.display = 'block';
	}
	
	function closeMessageMenu() {
	    const modal = document.getElementById('messageMenuModal');
	    modal.style.display = 'none';
	}
	
	// 모달 바깥 영역 클릭 시 모달 닫기
	window.onclick = function(event) {
	    const modal = document.getElementById('messageMenuModal');
	    if (event.target === modal) {
	        modal.style.display = 'none';
	    }
	}
	
	function deleteMessage() {
	    if (confirm('메시지를 삭제하시겠습니까?')) {
	        // 서버로 삭제 요청 전송
	        $.ajax({
	            url: '/whale/deleteMessage',
	            type: 'POST',
	            data: { messageId: selectedMessageId },
	            success: function(response) {
	                if (response.status === 'success') {
	                    // 메시지 삭제 성공 시 화면에서 제거
	                    removeMessageFromView(selectedMessageId);
	                } else {
	                    alert('메시지 삭제에 실패했습니다.');
	                }
	            },
	            error: function(error) {
	                console.error('Delete message error:', error);
	                alert('서버 오류로 메시지 삭제에 실패했습니다.');
	            }
	        });
	    }
	    closeMessageMenu();
	}
	
	function reportMessage() {
	    // 신고 페이지로 이동
	    window.location.href = '/whale/report?m=' + selectedMessageId;
	    closeMessageMenu();
	}
	
	function removeMessageFromView(messageId) {
	    // 메시지 ID를 기반으로 화면에서 메시지 제거
	    const messageElement = document.getElementById('message-' + messageId);
	    if (messageElement) {
	        messageElement.parentNode.removeChild(messageElement);
	    }
	}
</script>

</body>
</html>