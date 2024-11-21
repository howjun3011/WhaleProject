package com.tech.whale.login.controller;

import com.tech.whale.login.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@RestController
public class AuthController {

    @Autowired
    private UserService userService;

    // 로그인 여부 확인 API
    // 세션에 저장된 "logged_in" 속성을 확인하여 사용자가 로그인 상태인지 확인
    @GetMapping("/check-login")
    public ResponseEntity<Map<String, Object>> checkLogin(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        Boolean loggedIn = (Boolean) session.getAttribute("logged_in"); // 세션에서 로그인 상태 확인
        if (loggedIn != null && loggedIn) { // 로그인 상태일 경우
            response.put("loggedIn", true);
            response.put("username", session.getAttribute("user_id")); // 세션에서 사용자 ID 가져오기
        } else { // 로그인 상태가 아닐 경우
            response.put("loggedIn", false);
        }
        return ResponseEntity.ok(response); // 결과 반환
    }

    // 사용자 회원가입 시작 API
    // 세션에 "authFlow"를 "register"로 설정하고 리다이렉트 URL 반환
    @PostMapping("/register/initiate")
    public ResponseEntity<Map<String, Object>> initiateRegister(HttpSession session) {
        session.setAttribute("authFlow", "register"); // 회원가입 플로우 상태 저장
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("redirectTo", "/whale/spotify/login"); // 회원가입 이후 리다이렉트 경로 설정
        return ResponseEntity.ok(response); // 결과 반환
    }

    // 비밀번호 재설정 링크 이메일 발송
    // 사용자가 입력한 이메일이 유효한지 확인하고 재설정 링크를 발송
    @PostMapping("/find/initiate")
    public ResponseEntity<Map<String, Object>> initiateFind(@RequestBody HashMap<String, Object> map, HttpSession session) {
        String email = map.get("email").toString(); // 요청 데이터에서 이메일 추출
        Map<String, Object> response = new HashMap<>();
        if (!userService.isEmailTaken(email)) { // 이메일이 등록되지 않은 경우
            response.put("success", false);
            response.put("message", "등록된 이메일이 아닙니다."); // 에러 메시지 반환
            return ResponseEntity.ok(response);
        }
        session.setAttribute("authFlow", "find"); // 비밀번호 찾기 플로우 상태 저장
        userService.sendResetPasswordEmail(email); // 비밀번호 재설정 이메일 발송
        response.put("success", true);
        response.put("message", "비밀번호 재설정 링크가 이메일로 전송되었습니다.");
        return ResponseEntity.ok(response); // 결과 반환
    }

    // 비밀번호 재설정 API
    // 토큰을 검증하고 새 비밀번호로 업데이트
    @PostMapping("/find/reset-password")
    public Map<String, Object> resetPassword(@RequestBody Map<String, String> requestData) {
        Map<String, Object> response = new HashMap<>();

        // requestData에서 token과 newPassword 추출
        String token = requestData.get("token");
        String newPassword = requestData.get("newPassword");

        // 비밀번호 재설정을 위한 토큰 검증
        boolean isTokenValid = userService.verifyResetToken(token);

        if (isTokenValid) { // 토큰이 유효할 경우
            userService.updatePassword(token, newPassword); // 비밀번호 업데이트
            response.put("success", true);
            response.put("message", "비밀번호가 성공적으로 변경되었습니다.");
        } else { // 토큰이 유효하지 않을 경우
            response.put("success", false);
            response.put("message", "유효하지 않은 토큰입니다.");
        }

        return response; // 결과 반환
    }
}
