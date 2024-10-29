package com.tech.whale.streaming.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import se.michaelthelin.spotify.SpotifyApi;
import se.michaelthelin.spotify.exceptions.SpotifyWebApiException;
import se.michaelthelin.spotify.model_objects.specification.Paging;
import se.michaelthelin.spotify.model_objects.specification.Track;
import se.michaelthelin.spotify.requests.data.personalization.simplified.GetUsersTopTracksRequest;
import org.apache.hc.core5.http.ParseException;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CompletionException;
import com.google.gson.JsonArray;
import com.google.gson.JsonPrimitive;


@Service
public class StreamingService {

    @Autowired
    private SpotifyApi spotifyApi;

    // Spotify API 초기화 메서드
    private void initializeSpotifyApi(HttpSession session) {
        String accessToken = (String) session.getAttribute("accessToken");
        String refreshToken = (String) session.getAttribute("refreshToken");

        if (accessToken == null || refreshToken == null) {
            System.out.println("accessToken 또는 refreshToken이 세션에 없습니다.");
            return;
        }

        this.spotifyApi = new SpotifyApi.Builder()
                .setAccessToken(accessToken)
                .setRefreshToken(refreshToken)
                .build();
    }

    // Access Token 갱신 메서드
    public void refreshAccessToken(HttpSession session) {
        try {
            var authorizationCodeCredentials = spotifyApi.authorizationCodeRefresh().build().execute();
            String newAccessToken = authorizationCodeCredentials.getAccessToken();

            // 세션에 새로운 accessToken 저장
            session.setAttribute("accessToken", newAccessToken);
            spotifyApi.setAccessToken(newAccessToken);

            System.out.println("새로운 accessToken: " + newAccessToken);
        } catch (IOException | SpotifyWebApiException | ParseException e) {
            System.out.println("Access Token 갱신 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Access Token 유효성 검사 메서드
    private boolean isTokenValid(HttpSession session) {
        initializeSpotifyApi(session);

        try {
            spotifyApi.getCurrentUsersProfile().build().execute();
            return true;
        } catch (SpotifyWebApiException | IOException | ParseException e) {
            System.out.println("유효하지 않은 Access Token입니다. 갱신을 시도합니다.");
            refreshAccessToken(session);
            return false;
        }
    }

    // Top 트랙 가져오기 비동기 메서드
    public CompletableFuture<Paging<Track>> getUsersTopTracksAsync(HttpSession session) {
        initializeSpotifyApi(session);

        GetUsersTopTracksRequest request = spotifyApi.getUsersTopTracks()
                .limit(10)
                .time_range("medium_term")
                .build();

        return request.executeAsync().exceptionally(e -> {
            System.out.println("예상치 못한 오류 발생: " + e.getMessage());
            return null;
        });
    }

    public boolean playTrack(HttpSession session, String trackId) {
        initializeSpotifyApi(session);

        try {
            JsonArray uris = new JsonArray();
            uris.add(new JsonPrimitive("spotify:track:" + trackId)); // URI를 JsonArray에 추가

            spotifyApi.startResumeUsersPlayback()
                    .uris(uris)
                    .build()
                    .execute();
            return true;
        } catch (IOException | SpotifyWebApiException | ParseException e) {
            System.out.println("Failed to play track: " + e.getMessage());
            return false;
        }
    }

}
