package com.tech.whale.login.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.tech.whale.login.service.UserService;
import com.tech.whale.main.models.MainAuthorizationCode;
import com.tech.whale.main.service.MainAuthorizationCodeController;
import org.apache.hc.core5.http.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import se.michaelthelin.spotify.SpotifyApi;
import se.michaelthelin.spotify.exceptions.SpotifyWebApiException;
import se.michaelthelin.spotify.model_objects.specification.User;
import se.michaelthelin.spotify.requests.data.users_profile.GetCurrentUsersProfileRequest;

import java.io.IOException;
import java.net.URI;

@Controller
public class LoginController {
    private final MainAuthorizationCode mainAuthorizationCode;
    private final MainAuthorizationCodeController mainAuthorizationCodeController;

    // 생성자를 통해 MainAuthorizationCode 및 MainAuthorizationCodeController 주입
    public LoginController(MainAuthorizationCode mainAuthorizationCode, MainAuthorizationCodeController mainAuthorizationCodeController) {
        this.mainAuthorizationCode = mainAuthorizationCode;
        this.mainAuthorizationCodeController = mainAuthorizationCodeController;
    }

    @Autowired
    private SpotifyApi spotifyApi; // Spotify API 인스턴스

    @Autowired
    private UserService userService; // 사용자 서비스 주입

    // 로그인 홈 페이지
    @RequestMapping("/")
    public String loginHome() {
        return "login/login"; // 로그인 페이지 뷰 반환
    }

    // 사용자 로그인 API
    @PostMapping("/login")
    public String postLogin(HttpSession session, HttpServletRequest request, Model model) {
        String username = request.getParameter("username"); // 요청에서 사용자 이름 가져오기
        String password = request.getParameter("password"); // 요청에서 비밀번호 가져오기
        System.out.println("username: " + username + " password: " + password);

        boolean isAuthenticated = userService.authenticate(username, password); // 사용자 인증

        if (isAuthenticated) { // 인증 성공 시
            Integer status = userService.getUserStatusService(username); // 사용자 상태 확인

            if (status == 1) { // 계정이 정지 상태일 경우
                session.invalidate(); // 세션 무효화
                model.addAttribute("message", "suspension"); // 정지 메시지 추가
                model.addAttribute("date", userService.getUserEndDateService(username).toString()); // 정지 해제 날짜 추가
                return "login/login"; // 로그인 페이지로 반환
            } else { // 정상 사용자일 경우
                session.setAttribute("logged_in", true); // 로그인 상태 저장
                session.setAttribute("user_id", username); // 사용자 이름 저장
                userService.checkAccessIdLogin(username, session); // 추가 로그인 확인
                return "redirect:/spotify/login"; // Spotify 로그인 페이지로 리디렉션
            }
        } else { // 인증 실패 시
            model.addAttribute("message", false); // 실패 메시지 추가
            return "login/login"; // 로그인 페이지로 반환
        }
    }

    // 회원가입 페이지
    @RequestMapping("/register")
    public String loginRegister() {
        return "login/register"; // 회원가입 페이지 뷰 반환
    }

    // 비밀번호 찾기 페이지
    @RequestMapping("/find")
    public String loginFind() {
        return "login/find"; // 비밀번호 찾기 페이지 뷰 반환
    }

    // 비밀번호 재설정 페이지
    @RequestMapping("/reset-password")
    public String loginResetPassword() {
        return "login/reset-password"; // 비밀번호 재설정 페이지 뷰 반환
    }

    // Spotify 로그인 API
    @RequestMapping("/spotify/login")
    public String login() {
        URI uri = mainAuthorizationCode.getAuthorizationUri(); // Spotify 인증 URI 가져오기
        return "redirect:" + uri.toString(); // 인증 페이지로 리디렉션
    }

    // Spotify 인증 콜백
    @RequestMapping("/spotify/callback")
    public String callback(HttpServletRequest req, HttpSession session) {
        try {
            // Spotify 인증 처리
            mainAuthorizationCodeController.execute(req, session);

            // Spotify 사용자 정보 가져오기
            String[] spotifyInfo = getSpotifyInfo(req, session);

            // 사용자 정보 세션에 저장
            session.setAttribute("spotifyEmail", spotifyInfo[0]);
            session.setAttribute("spotifyId", spotifyInfo[1]);

            // 인증 플로우에 따라 리디렉션
            String isRegistered = (String) session.getAttribute("authFlow");
            if ("register".equals(isRegistered)) {
                return "redirect:/register"; // 회원가입 페이지로 리디렉션
            } else if ("1".equals(session.getAttribute("access_id").toString())) {
                return "redirect:/admin/adminMainView"; // 관리자 페이지로 리디렉션
            } else {
                return "redirect:/main"; // 메인 페이지로 리디렉션
            }
        } catch (Exception e) {
            e.printStackTrace(); // 에러 로그 출력
            return "redirect:/"; // 기본 페이지로 리디렉션
        }
    }

    // Spotify API를 사용해 사용자 정보 가져오기
    public String[] getSpotifyInfo(HttpServletRequest req, HttpSession session) {
        String accessToken = (String) session.getAttribute("accessToken"); // 세션에서 액세스 토큰 가져오기

        System.out.println("Access Token: " + accessToken); // 로그에 액세스 토큰 출력

        // Spotify API 설정
        SpotifyApi spotifyApi = new SpotifyApi.Builder()
                .setAccessToken(accessToken)
                .build();

        try {
            // Spotify 사용자 프로필 요청
            GetCurrentUsersProfileRequest getCurrentUsersProfileRequest = spotifyApi.getCurrentUsersProfile().build();
            User user = getCurrentUsersProfileRequest.execute(); // 사용자 프로필 요청 실행
            String email = user.getEmail(); // 사용자 이메일 가져오기
            String spotifyId = user.getId(); // 사용자 ID 가져오기

            return new String[]{email, spotifyId};
        } catch (SpotifyWebApiException | IOException | ParseException e) {
            // 토큰 만료 시 재발급 후 재시도
            e.printStackTrace(); // 에러 로그 출력
            return null;
        }
    }
}
