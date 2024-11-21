package com.tech.whale.login.controller;

import com.tech.whale.main.models.MainAuthorizationCode;
import com.tech.whale.main.service.MainAuthorizationCodeController;
import org.apache.hc.core5.http.ParseException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;

import se.michaelthelin.spotify.SpotifyApi;
import se.michaelthelin.spotify.exceptions.SpotifyWebApiException;
import se.michaelthelin.spotify.requests.authorization.authorization_code.AuthorizationCodeRefreshRequest;
import se.michaelthelin.spotify.model_objects.credentials.AuthorizationCodeCredentials;
import se.michaelthelin.spotify.exceptions.detailed.UnauthorizedException;

@RestController
public class SpotifyController {
    private final MainAuthorizationCode mainAuthorizationCode; // Spotify 인증에 필요한 설정 클래스
    private final MainAuthorizationCodeController mainAuthorizationCodeController; // 인증 처리 컨트롤러
    private SpotifyApi spotifyApi; // Spotify API 클라이언트

    // 생성자를 통해 의존성 주입
    public SpotifyController(MainAuthorizationCode mainAuthorizationCode, MainAuthorizationCodeController mainAuthorizationCodeController, SpotifyApi spotifyApi) {
        this.mainAuthorizationCode = mainAuthorizationCode;
        this.mainAuthorizationCodeController = mainAuthorizationCodeController;
        this.spotifyApi = spotifyApi;
    }

    // 리프레시 토큰을 사용하여 엑세스 토큰을 갱신하는 메서드
    @RequestMapping("/spotify/refresh_token")
    public HashMap<String, Object> refreshAccessToken(HttpSession session) {
        HashMap<String, Object> response = new HashMap<>();
        String refreshToken = (String) session.getAttribute("refreshToken"); // 세션에서 리프레시 토큰 가져오기

        // 로그 추가 - 리프레시 토큰 및 클라이언트 정보 확인
        System.out.println("Refresh Token: " + refreshToken);
        System.out.println("Client ID: " + spotifyApi.getClientId());
        System.out.println("Client Secret: " + spotifyApi.getClientSecret());

        spotifyApi.setRefreshToken(refreshToken); // Spotify API에 리프레시 토큰 설정

        // 리프레시 토큰 요청 객체 생성
        AuthorizationCodeRefreshRequest refreshRequest = spotifyApi.authorizationCodeRefresh().build();

        try {
            // 리프레시 토큰 실행 및 새로운 액세스 토큰 발급
            AuthorizationCodeCredentials credentials = refreshRequest.execute();
            session.setAttribute("accessToken", credentials.getAccessToken()); // 새로운 액세스 토큰 세션에 저장
            response.put("accessToken", credentials.getAccessToken()); // 응답 데이터에 액세스 토큰 추가
            return response;
        } catch (IOException | SpotifyWebApiException | ParseException e) {
            e.printStackTrace(); // 예외 발생 시 로그 출력
            return null; // 실패 시 null 반환
        }
    }

    // Spotify 사용자 데이터를 가져오는 메서드
    @GetMapping("/getSpotifyUserData")
    public ResponseEntity<String> getSpotifyUserData(HttpSession session) {
        String accessToken = (String) session.getAttribute("accessToken"); // 세션에서 액세스 토큰 가져오기

        if (accessToken != null) {
            try {
                spotifyApi.setAccessToken(accessToken); // Spotify API에 액세스 토큰 설정
                // Spotify API를 통해 유저 프로필 데이터 가져오기
                var userProfile = spotifyApi.getCurrentUsersProfile().build().execute();

                return ResponseEntity.ok(userProfile.toString()); // 성공 시 유저 데이터 반환
            } catch (UnauthorizedException e) {
                // Access Token이 만료된 경우
                refreshAccessToken(session); // 리프레시 토큰으로 새 액세스 토큰 발급
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Access token refreshed");
            } catch (Exception e) {
                e.printStackTrace(); // 기타 예외 발생 시 로그 출력
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving user data");
            }
        } else {
            // 액세스 토큰이 없는 경우
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Access token not found");
        }
    }
}
