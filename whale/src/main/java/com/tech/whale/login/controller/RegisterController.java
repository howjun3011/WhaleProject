package com.tech.whale.login.controller;

import com.tech.whale.login.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.util.HashMap;

@RestController
public class RegisterController {

    @Autowired
    private UserService userService; // UserService를 통해 사용자 관련 로직 처리

    // 회원가입 완료 API
    @PostMapping(value = "/register/complete", produces = MediaType.APPLICATION_JSON_VALUE)
    public HashMap<String, Object> registerUser(@RequestBody HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> response = new HashMap<>();

        // 입력받은 회원 정보 추출
        String username = (String) map.get("username"); // 사용자 이름
        String password = (String) map.get("password"); // 비밀번호
        String email = (String) map.get("email"); // 이메일 주소
        String nickname = (String) map.get("nickname"); // 닉네임

        // 중복 검사 - 아이디 중복 확인
        if (userService.isUsernameTaken(username)) {
            response.put("success", false);
            response.put("message", "이미 사용 중인 아이디입니다."); // 중복된 아이디 메시지 반환
            return response;
        }
        // 중복 검사 - 닉네임 중복 확인
        if (userService.isNicknameTaken(nickname)) {
            response.put("success", false);
            response.put("message", "이미 사용 중인 닉네임입니다."); // 중복된 닉네임 메시지 반환
            return response;
        }
        // 중복 검사 - 이메일 중복 확인
        if (userService.isEmailTaken(email)) {
            response.put("success", false);
            response.put("message", "이미 사용 중인 이메일입니다."); // 중복된 이메일 메시지 반환
            return response;
        }

        // DB에 사용자 정보 저장 및 회원 등록
        boolean isRegistered = userService.registerUser(
                username,
                password,
                email,
                nickname,
                (String) session.getAttribute("spotifyId") // 세션에서 Spotify ID 가져오기
        );

        if (isRegistered) { // 회원가입 성공 시
            response.put("success", true);
            userService.followAdmin(username, "WHALE"); // 새 유저가 WHALE 계정을 팔로우
            userService.followUser("WHALE", username); // WHALE 계정이 새 유저를 팔로우

            response.put("message", "회원가입 완료되었습니다."); // 성공 메시지 반환
            response.put("redirectTo", "/whale"); // 메인 페이지로 리디렉트 URL 제공
            session.invalidate(); // 세션 초기화
            return response; // 결과 반환
        } else { // 회원가입 실패 시
            response.put("success", false);
            response.put("message", "회원가입 실패했습니다."); // 실패 메시지 반환
            return response;
        }
    }
}
