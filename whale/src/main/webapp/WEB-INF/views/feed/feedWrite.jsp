<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="write-area">
    <form action="feedWriteDo" method="post" enctype="multipart/form-data" onsubmit="validateForm(event)">
        <div class="form-content">
            <br />
			<label for="file-upload" class="file-upload-btn">
			    <img src="static/images/btn/upload_btn.png" alt="업로드" style="vertical-align: middle; width: 40px; height: 40px;">
			</label>
			<label for="music-upload" class="music-upload-btn">
			    <img src="static/images/btn/music_btn.png" alt="업로드" style="vertical-align: middle; width: 40px; height: 40px;">
			</label>
            <input id="file-upload" type="file" name="feedImage" accept="image/*" onchange="previewImage(event)">
            <img id="preview" src="#" alt="이미지 미리보기" style="display:none; max-width:100%; height:auto;">
            <br>
            <div id="music-info" class="music-info" style="display: none;">
                <img id="album-icon" src="" alt="Album Icon" style="width: 50px; height: 50px;">
                <div>
                    <span id="music-title"></span> - <span id="artist-name"></span>
                </div>
            </div>
            <input type="hidden" name="selectedTrackId" id="selectedTrackId">
            <br />
            <textarea name="feedText" placeholder="Write something..."></textarea>
            <br>
            <button type="submit" class="submit-btn"><img class="write-btn" src="static/images/btn/write_btn.png" alt="글 작성" /></button>
        </div>
    </form>
</div>

<div id="musicModal" class="modal">
    <div class="modal-content">
	  	<div class="searchContainer">
			<div class="headerSearch">
				<button class="searchBtn" id="search-button">
					<img src="static/images/streaming/searchBtn.png" alt="Music Whale Search Button" height="14px">
			    </button>
			    <input class="headerInput" id="search-input" placeholder="어떤 콘텐츠를 감상하고 싶으세요?" onfocus="this.placeholder=''" onblur="this.placeholder='어떤 콘텐츠를 감상하고 싶으세요?'">
			</div>
		</div>
		<div class="search-result-container">
			<div id="pagination"></div>
			<div id="search-results"></div>
		</div>
		<div class="modal-item gray" id="completeBtn">완료</div>
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

            // 서버로부터 받은 데이터를 사용하여 music-info 섹션을 업데이트합니다
            const musicInfo = {
                albumIcon: data.track_cover,
                musicTitle: data.track_name,
                artistName: data.track_artist
            };

            // 음악 정보를 미리보기 영역에 표시
            document.getElementById("album-icon").src = musicInfo.albumIcon;
            document.getElementById("music-title").textContent = musicInfo.musicTitle;
            document.getElementById("artist-name").textContent = musicInfo.artistName;

            // 음악 정보 영역을 보여주도록 설정
            document.getElementById("music-info").style.display = "flex";

            // 음악 정보를 숨겨진 필드에 저장 (폼 제출 시 전송하기 위해)
			document.getElementById("selectedTrackId").value = data.track_id;
            
            // 모달을 닫습니다
            closeMusicModal();
        })
        .catch(error => {
            console.error('에러 발생:', error);
            alert('음악 정보를 가져오는 중 오류가 발생했습니다.');
        });
    });
</script>

<script src="static/js/streaming/searchView.js"></script>
    
<script type="text/javascript">
    function previewImage(event) {
        var reader = new FileReader();
        reader.onload = function(){
            var output = document.getElementById('preview');
            output.src = reader.result;
            output.style.display = 'block';
        };
        reader.readAsDataURL(event.target.files[0]);
    }
    
    function validateForm(event) {
        var feedImage = document.getElementsByName("feedImage")[0].value.trim();
        if (feedImage === "") {
            alert("사진을 올려주세요.");
            event.preventDefault();  // 폼 제출을 중단
            return false;
        }
        return true;
    }
</script>

<style>

	.music-info {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	    padding: 10px;
	    background-color: #f9f9f9;
	    border-radius: 5px;
	    margin-bottom: 10px;
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
	
	.modal .modal-content {
		width: 50%;
		height: 65%;
	}

    .write-area {
        text-align: center;
    }
    
    .form-content {
        width: 80%;
        max-width: 1200px;
        margin: 0 auto;
        text-align: center;
    }
    
    textarea {
        width: 100%;
        max-width: 100%;
        box-sizing: border-box;
        padding: 10px;
        margin-bottom: 10px;
    }
    
    input[type="file"] {
        display: none; /* 기본 파일 입력 요소를 숨깁니다 */
    }
    
    .file-upload-btn {
    	width: 80%;
    	max-width: 1200px;
        background-color: #f0f0f0; /* 연한 그레이톤 배경 */
        color: #333; /* 다크 그레이 글자색 */
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        cursor: pointer;
        border-radius: 5px; /* 모서리 둥글게 */
        transition: background-color 0.3s;
        display: inline-block; /* 버튼처럼 보이도록 설정 */
        margin-bottom: 10px;
    }
    
    .file-upload-btn:hover {
        background-color: #e0e0e0; /* 호버 시 조금 더 진한 그레이톤 */
    }
    
    .music-upload-btn {
    	width: 80%;
    	max-width: 1200px;
        background-color: #f0f0f0; /* 연한 그레이톤 배경 */
        color: #333; /* 다크 그레이 글자색 */
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        cursor: pointer;
        border-radius: 5px; /* 모서리 둥글게 */
        transition: background-color 0.3s;
        display: inline-block; /* 버튼처럼 보이도록 설정 */
        margin-bottom: 10px;
    }
    
    .music-upload-btn:hover {
        background-color: #e0e0e0; /* 호버 시 조금 더 진한 그레이톤 */
    }
    
    img#preview {
        max-width: 60%;
        height: auto;
        display: block;
        margin: 10px auto;
    }
    
    .write-btn {
		width: 40px;
		height: 40px;
	}
	
    .submit-btn {
        background-color: #f0f0f0;
        color: #333;
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        cursor: pointer;
        border-radius: 5px;
        transition: background-color 0.3s;
    }
    
    .submit-btn:hover {
        background-color: #e0e0e0;
    }
</style>