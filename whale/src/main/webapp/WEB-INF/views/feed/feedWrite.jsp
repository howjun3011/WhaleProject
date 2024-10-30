<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="write-area">
    <form action="feedWriteDo" method="post" enctype="multipart/form-data" onsubmit="validateForm(event)">
        <div class="form-content">
            <br />
			<label for="file-upload" class="file-upload-btn">
			    <img src="static/images/btn/upload_btn.png" alt="업로드" style="vertical-align: middle; width: 40px; height: 40px;">
			</label>
            <input id="file-upload" type="file" name="feedImage" accept="image/*" onchange="previewImage(event)">
            <img id="preview" src="#" alt="이미지 미리보기" style="display:none; max-width:100%; height:auto;">
            <br>
            <textarea name="feedText" placeholder="Write something..."></textarea>
            <br>
            <button type="submit" class="submit-btn"><img class="write-btn" src="static/images/btn/write_btn.png" alt="글 작성" /></button>
        </div>
    </form>
</div>

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
        var feedText = document.getElementsByName("feedText")[0].value.trim();
        if (feedText === "") {
            alert("글 내용을 작성해 주세요.");
            event.preventDefault();  // 폼 제출을 중단
            return false;
        }
        return true;
    }
</script>

<style>
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