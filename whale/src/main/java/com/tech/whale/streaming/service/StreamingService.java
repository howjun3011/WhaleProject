package com.tech.whale.streaming.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import se.michaelthelin.spotify.SpotifyApi;
import se.michaelthelin.spotify.exceptions.SpotifyWebApiException;
import se.michaelthelin.spotify.model_objects.specification.Album;
import se.michaelthelin.spotify.model_objects.specification.Artist;
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
import com.tech.whale.streaming.models.StreamingDao;
import com.tech.whale.streaming.models.TrackDto;
import se.michaelthelin.spotify.requests.data.search.simplified.SearchTracksRequest;


@Service
public class StreamingService {

    @Autowired
    private SpotifyApi spotifyApi;
    
    @Autowired
    private StreamingDao streamingDao;

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

    public Track getTrackDetail(HttpSession session, String trackId) {
        initializeSpotifyApi(session);

        try {
            // Spotify API에서 트랙 상세 정보 가져오기
            return spotifyApi.getTrack(trackId).build().execute();
        } catch (IOException | SpotifyWebApiException | ParseException e) {
            System.out.println("Failed to fetch track details: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public Album getAlbumDetail(HttpSession session, String albumId) {
        initializeSpotifyApi(session);

        try {
            // Album 정보 가져오기
            return spotifyApi.getAlbum(albumId).build().execute();
        } catch (IOException | SpotifyWebApiException | ParseException e) {
            System.out.println("Failed to fetch album details: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public Artist getArtistDetail(HttpSession session, String artistId) {
        initializeSpotifyApi(session);

        try {
            // 아티스트 정보 가져오기
            return spotifyApi.getArtist(artistId).build().execute();
        } catch (IOException | SpotifyWebApiException | ParseException e) {
            System.out.println("Failed to fetch artist details: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    // Spotify에서 트랙 검색
    public Paging<Track> searchTracks(HttpSession session, String query) {
        initializeSpotifyApi(session);

        try {
            // 검색 요청 생성
            SearchTracksRequest searchTracksRequest = spotifyApi.searchTracks(query)
                    .limit(50)  // 최대 50개까지 가져올 수 있음
                    .build();

            // 결과 반환
            return searchTracksRequest.execute();
        } catch (IOException | SpotifyWebApiException | ParseException e) {
            System.out.println("Failed to search tracks: " + e.getMessage());
            return null;
        }
    }

    //-----------------------------------------------------------------------------------------------------
    
    // 데이터 베이스에 해당 트랙의 정보 입력 유무 확인 및 프라이머리 키 및 DTO 리턴
    public Integer selectTrackIdService(String track_artist, String track_name, String track_album, String track_cover, String trackSpotifyId) {
    	Integer trackId = streamingDao.selectTrackId(trackSpotifyId);
    	
    	if(trackId != null) {return trackId;}
    	else {
    		streamingDao.insertTrack(track_artist, track_name, track_album, track_cover, trackSpotifyId);
    		trackId = streamingDao.selectTrackId(trackSpotifyId);
    		return trackId;
    	}
    }
    
    public TrackDto selectTrackDtoService(String trackId) {
    	TrackDto trackDto = streamingDao.selectTrackDto(trackId);
    	return trackDto;
    }
    
    // 데이터 베이스에 트랙 좋아요 정보 입력 유무 확인
    public boolean selectTrackLikeService(HttpSession session, String trackSpotifyId) {
    	Integer trackId = streamingDao.selectTrackId(trackSpotifyId);
    	
    	if(trackId != null) {
    		Integer trackLikeId = streamingDao.selectTrackLikeId((String) session.getAttribute("user_id"), trackId);
    		
    		if(trackLikeId != null) {return true;}
        	else {return false;}
    	} else {
    		return false;
    	}
    }
    
    // 트랙 좋아요 인서트
    public void insertTrackLikeService(HttpSession session, String track_artist, String track_name, String track_album, String track_cover, String trackSpotifyId) {
    	Integer trackId = selectTrackIdService(track_artist, track_name, track_album, track_cover, trackSpotifyId);
    	streamingDao.insertTrackLike(trackId, (String) session.getAttribute("user_id"));
    }
    
    // 트랙 좋아요 삭제
    public void deleteTrackLikeService(HttpSession session, String trackSpotifyId) {
    	Integer trackId = streamingDao.selectTrackId(trackSpotifyId);
    	Integer trackLikeId = streamingDao.selectTrackLikeId((String) session.getAttribute("user_id"), trackId);
    	streamingDao.deleteTrackLike(trackLikeId);
    }
    
    // 트랙 좋아요 인서트
    public void insertTrackCntService(HttpSession session, String track_artist, String track_name, String track_album, String track_cover, String trackSpotifyId) {
    	Integer trackId = selectTrackIdService(track_artist, track_name, track_album, track_cover, trackSpotifyId);
    	streamingDao.insertTrackCnt(trackId, (String) session.getAttribute("user_id"));
    }
}
