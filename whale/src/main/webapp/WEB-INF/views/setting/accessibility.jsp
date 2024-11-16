<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>accessibility</title>
    <link rel="stylesheet" href="static/css/setting/settingStyle.css"/>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script src="static/js/setting/setting.js"></script>
    <script src="static/js/setting/darkMode.js"></script>
    <style>
        .toggle-slide { display: none; }
        label { width: 50px; height: 25px; background-color: #808080; text-indent: -9999px; border-radius: 25px; position: relative; cursor: pointer; transition: 0.5s; }
        label::after { content: ''; position: absolute; width: 17px; height: 17px; background-color: #e5e5e5; border-radius: 25px; top: 4px; left: 4px; transition: 0.5s; }
        .toggle-slide:checked + label { background-color: #335580; }
        .toggle-slide:checked + label::after { left: 29px; }
        .setting-item { justify-content: space-between; padding: 10px; margin-top: 3px; margin-bottom: 3px; }
        a { text-decoration: none; color: black; }
        a:visited, a:hover, a:focus, a:active { color: black; text-decoration: none; }
        #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
    </style>
</head>
<body>
<div class="setting-body">
    <div class="setting-container">
        <div class="setting-header">
            <a href="settingHome" id="back"><img src="static/images/setting/back.png" alt="back"></a>
            접근성
        </div>
        <div class="setting-grid">
            <a href="startpageSetting">
                <div class="setting-item">
                    <div class="setting-item-text">
                        <p>시작페이지 설정</p>
                        <p class="sub-text">startpage setting</p>
                    </div>
                </div>
            </a>
            <a href="pageAccessSetting">
                <div class="setting-item">
                    <div class="setting-item-text">
                        <p>페이지 접근 변경</p>
                        <p class="sub-text">change page access</p>
                    </div>
                </div>
            </a>
            <div class="setting-item">
                <div class="darkmode-txt">
                    <div class="setting-item-text">
                        <p>다크모드</p>
                        <p class="sub-text">darkmode</p>
                    </div>
                </div>
                <input type="checkbox" id="toggle-slide" class="toggle-slide"/>
                <label for="toggle-slide"></label>
            </div>
        </div>
    </div>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // JSP에서 서버로부터 받은 알림 설정 값을 자바스크립트 변수로 전달
        var darkmodeOn = ${darkmodeOn}

            // 페이지가 로드될 때 기본값 설정
            window.onload = function () {
                document.getElementById('toggle-slide').checked = darkmodeOn == 1;
            };

        document.getElementById('toggle-slide').addEventListener('change', function () {
            let darkmodeOn = this.checked ? 1 : 0;

            // 다크 모드 상태를 localStorage에 저장
            localStorage.setItem('darkmodeOn', darkmodeOn);

            // AJAX 요청
            const xhr = new XMLHttpRequest();
            xhr.open('POST', '/whale/updateDarkmode', true); // 서버에 POST 요청 보냄
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

            // 서버로 데이터 전송
            xhr.send('darkmode_setting_onoff=' + darkmodeOn);

            xhr.onreadystatechange = function () {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        console.log('Darkmode setting update in DB.');
                        // 이 부분에서 event.target.checked 상태에 따라 다른 로그를 출력
                        if (darkmodeOn === 1) {
                            console.log("Dark mode enabled (1)");

                        } else {
                            console.log("Dark mode disabled (0)");
                        }
                    } else {
                        console.log('Error updating darkmode setting. Status:', xhr.status, 'Response:', xhr.responseText);
                    }
                }
            };
        });
    });
</script>
</body>
</html>