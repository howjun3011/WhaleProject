<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>profileEdit</title>
<link rel="stylesheet" href="static/css/setting/settingStyle.css" />
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="static/js/setting/setting.js"></script>
<script src="static/js/setting/darkMode.js"></script>
<style>
.setting-body[data-darkmode="0"] #profileForm{ display: flex; flex-direction: column; margin-top: 15px; justify-content: center; align-items: center; }
.setting-body[data-darkmode="0"] input[type="password"] { width: 100%; padding: 5px; background-color: #FCFCFC; border: none; /* 테두리 없애기 */ border-bottom: 2px solid #ccc; /* 밑줄 추가 */ outline: none; }
.setting-body[data-darkmode="0"] input[type="password"]:focus { border-bottom: 2px solid #7E7E7E; }
.setting-body[data-darkmode="0"] .complete-btn { font-size: 20px; position: absolute; top: 15px; right: 7px; background-color: transparent; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; }
.setting-body[data-darkmode="0"] .complete-btn:hover { color: #5A5A5A; }
.setting-body[data-darkmode="0"] #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
.setting-body[data-darkmode="1"] #profileForm{ display: flex; flex-direction: column; margin-top: 15px; justify-content: center; align-items: center; }
.setting-body[data-darkmode="1"] input[type="password"] { width: 100%; padding: 5px; color: whitesmoke; background-color: rgb(46, 46, 46); border: none; border-bottom: 2px solid #ccc; outline: none; }
.setting-body[data-darkmode="1"] input[type="password"]:focus { border-bottom: 2px solid #f1f1f1; }
.setting-body[data-darkmode="1"] .complete-btn { font-size: 20px; position: absolute; top: 15px; right: 7px; background-color: transparent; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; }
.setting-body[data-darkmode="1"] .complete-btn:hover { color: lightgray; }
.setting-body[data-darkmode="1"] #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
</style>
</head>
<body>
    <div class="setting-body">
        <div class="setting-container">
            <div class="setting-header">
                <a href="account" id="back"><img src="static/images/setting/back.png" alt="back"></a>
                회원 탈퇴
                <button type="button" id="completeBtn" class="complete-btn">완료</button>
            </div>
            <!-- 프로필 정보 수정 폼 -->
            <form id="profileForm" action="/whale/deleteAccountMethod" method="post">
                <table>
                    <tr>
                        <td><input type="password" name="password" placeholder="비밀번호 확인"/></td>
                        <td>
                            <button type="submit" style="display: none;" id="hiddenSubmitBtn">탈퇴하기</button>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>
    <script>
    // 완료 버튼 클릭 시 폼 제출
    $('#completeBtn').on('click', function (e) {
        e.preventDefault(); // 기본 동작(페이지 리로드) 방지
        const passwordInput = $('input[name="password"]').val();

        if (passwordInput.trim() === '') {
            alert('비밀번호를 입력해주세요.');
            return;
        }

        // 숨겨진 "탈퇴하기" 버튼 클릭 이벤트 트리거
        $('#hiddenSubmitBtn').click();

        // 버튼이 눌렸을 경우
        $('#editPhotoBtn').on('mousedown', function() {
            $(this).css('color', 'gray');
        });

        // 버튼 뗐을 경우, 다크모드 여부에 따라 색상 설정
        $('#editPhotoBtn').on('mouseup', function() {
            console.log('버튼 클릭');
            if ($('.setting-body').attr('data-darkmode') === '1') {
                $(this).css('color', 'whitesmoke');
            } else {
                $(this).css('color', '#335580');
            }
        });
    });
    </script>
</body>
</html>