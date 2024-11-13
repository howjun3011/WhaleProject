<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>profileEdit</title>
    <link rel="stylesheet" href="static/css/setting/settingStyle.css"/>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

    <script src="static/js/setting/setting.js"></script>
    <script src="static/js/setting/darkMode.js"></script>

    <style>
        .setting-body[data-darkmode="0"] a {
            text-decoration: none;
            color: #335580;
        }

        .setting-body[data-darkmode="0"] a:visited, .setting-body[data-darkmode="0"] a:focus, .setting-body[data-darkmode="0"] a:active {
            color: #335580;
            text-decoration: none;
        }

        .setting-body[data-darkmode="0"] a:hover {
            color: black;
        }

        .setting-body[data-darkmode="1"] a {
            text-decoration: none;
            color: lightgray;
        }

        .setting-body[data-darkmode="1"] a:visited, .setting-body[data-darkmode="1"] a:focus, .setting-body[data-darkmode="1"] a:active {
            color: lightgray;
            text-decoration: none;
        }

        .setting-body[data-darkmode="1"] a:hover {
            color: whitesmoke;
        }

        .complete-btn {
            font-size: 20px;
            position: absolute;
            top: 15px;
            right: 7px;
            background-color: transparent; /* 버튼의 배경색을 투명으로 설정 */
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
        }

        .setting-body[data-darkmode="0"] .complete-btn:hover {
            color: #5A5A5A;
        }

        .setting-body[data-darkmode="1"] .complete-btn:hover {
            color: #EAEAEA;
        }

        .setting-body[data-darkmode="0"] .setting-item {
            flex-direction: column; /* 세로 방향으로 정렬 */
            padding: 10px;
            border: none;
            border-radius: 0px;
            border-bottom: 1px solid #EAEAEA;
        }

        .setting-body[data-darkmode="1"] .setting-item {
            flex-direction: column; /* 세로 방향으로 정렬 */
            padding: 10px;
            border: none;
            border-radius: 0px;
            border-bottom: 1px solid #335580;
        }

        .setting-body[data-darkmode="0"] .setting-item img {
            width: 130px;
            height: 130px;
            border-radius: 100px;
            margin-top: 30px;
            margin-left: 20px;
        }

        .setting-body[data-darkmode="1"] .setting-item img {
            width: 130px;
            height: 130px;
            border-radius: 100px;
            margin-top: 30px;
            margin-left: 20px;
        }

        .setting-body[data-darkmode="0"] .setting-item button {
            border-color: white;
            background-color: white;
            border-style: none;
            border: none;
            background: none;
            color: #335580;
            cursor: pointer;
            margin-top: 20px;
            margin-bottom: 10px;
        }

        .setting-body[data-darkmode="1"] .setting-item button {
            border-color: rgb(46, 46, 46);
            background-color: rgb(46, 46, 46);
            border-style: none;
            border: none;
            background: none;
            color: whitesmoke;
            cursor: pointer;
            margin-top: 20px;
            margin-bottom: 10px;
        }

        #editPhotoBtn {
            font-weight: bold;
        }

        .setting-body[data-darkmode="1"] #editPhotoBtn {
            color: whitesmoke;
        }

        .setting-body[data-darkmode="1"] #editPhotoBtn:active,
        .setting-body[data-darkmode="1"] #editPhotoBtn:focus {
            color: whitesmoke;
        }

        table {
            margin-top: 10px;
        }

        table tr td {
            padding: 10px 75px 10px 50px;
        }

        .setting-body[data-darkmode="0"] input[type="text"], .setting-body[data-darkmode="0"] input[type="password"], .setting-body[data-darkmode="0"] input[type="email"] {
            width: 100%;
            padding: 5px;
            background-color: #FCFCFC;
            border: none; /* 테두리 없애기 */
            border-bottom: 2px solid #ccc; /* 밑줄 추가 */
            outline: none; /* 포커스 시 파란 테두리 없애기 */
        }

        .setting-body[data-darkmode="1"] input[type="text"], .setting-body[data-darkmode="1"] input[type="password"], .setting-body[data-darkmode="1"] input[type="email"] {
            width: 100%;
            padding: 5px;
            color: whitesmoke;
            background-color: rgb(46, 46, 46);
            border: none; /* 테두리 없애기 */
            border-bottom: 2px solid #ccc; /* 밑줄 추가 */
            outline: none; /* 포커스 시 파란 테두리 없애기 */
        }

        .setting-body[data-darkmode="0"] input[type="text"]:focus, input[type="password"]:focus, input[type="email"]:focus {
            border-bottom: 2px solid #7E7E7E; /* 포커스 시 밑줄 색 변경 */
        }

        .setting-body[data-darkmode="1"] input[type="text"]:focus, input[type="password"]:focus, input[type="email"]:focus {
            border-bottom: 2px solid #f1f1f1; /* 포커스 시 밑줄 색 변경 */
        }

        #back {
            position: absolute;
            left: 15px;
            top: 55%;
            transform: translateY(-50%);
        }
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
                    <td>그동안 감사했습니다. 또 만나요!</td>
                </tr>

            </table>
        </form>
    </div>
</div>

<!-- 스크립트를 body 끝부분에 추가 -->
<script>
    // DOM이 로드된 후 실행되는 함수
    $(document).ready(function () {
        // 완료 버튼 클릭 시 폼 제출
        $('#completeBtn').on('click', function () {
            $('#profileForm').submit();
        });

        // 버튼이 눌렸을 경우
        $('#editPhotoBtn').on('mousedown', function () {
            $(this).css('color', 'gray');
        });

        // 버튼 뗐을 경우, 다크모드 여부에 따라 색상 설정
        $('#editPhotoBtn').on('mouseup', function () {
            console.log('버튼 클릭');
            if ($('.setting-body').attr('data-darkmode') === '1') {
                $(this).css('color', 'whitesmoke');
            } else {
                $(this).css('color', '#335580');
            }
        });

        setTimeout(() => {
            // 부모 창에 탈퇴 성공 메시지를 보내는 함수
            function sendMessageToParent() {
                var message = {
                    type: "success",
                    text: "${successMessage}"
                };
                // 부모 창에 메시지 전송
                parent.postMessage(message, "*");
            }

            // 메시지 전송 후, 부모 창에서 처리하도록 호출
            sendMessageToParent();
        }, 2000);

    });
</script>
</body>
</html>