package com.tech.whale.streaming.controller;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.tech.whale.streaming.service.StreamingService;

@RestController
public class StreamingRestController {
	private StreamingService streamingService;
	
	public StreamingRestController(StreamingService streamingService) {
		this.streamingService = streamingService;
	}
	
	@PostMapping(value = "/streaming/currentTrackInfo", produces = MediaType.APPLICATION_JSON_VALUE)
    public HashMap<String, Object> currentTrackInfo(@RequestBody HashMap<String, Object> map, HttpSession session) {
		HashMap<String, Object> response = new HashMap<>();
		
    	String artistName = map.get("artistName").toString();
    	String trackName = map.get("trackName").toString();
    	String albumName = map.get("albumName").toString();
    	String albumCover = map.get("trackCover").toString();
    	String trackSpotifyId = map.get("trackSpotifyId").toString();
    	
    	// 트랙 아이디 반환 및 세션 저장
    	Integer trackId = streamingService.selectTrackIdService(artistName, trackName, albumName, albumCover, trackSpotifyId);
    	
    	session.setAttribute("trackId", trackId);
    	
    	// 좋아요 테이블 확인 및 반환
    	if (streamingService.selectTrackLikeService(session, trackSpotifyId)) {response.put("result", "yes"); return response;}
    	else {response.put("result", "no"); return response;}
    }
	
	@PostMapping(value = "/streaming/insertTrackLike", produces = MediaType.APPLICATION_JSON_VALUE)
    public void insertTrackLike(@RequestBody HashMap<String, Object> map, HttpSession session) {
    	String artistName = map.get("artistName").toString();
    	String trackName = map.get("trackName").toString();
    	String albumName = map.get("albumName").toString();
    	String albumCover = map.get("trackCover").toString();
    	String trackSpotifyId = map.get("trackSpotifyId").toString();
    	
    	// 트랙 아이디 반환 및 트랙 좋아요 테이블 삽입
    	streamingService.insertTrackLikeService(session, artistName, trackName, albumName, albumCover, trackSpotifyId);
    }
	
	@PostMapping(value = "/streaming/insertTrackCnt", produces = MediaType.APPLICATION_JSON_VALUE)
    public void insertTrackCnt(@RequestBody HashMap<String, Object> map, HttpSession session) {
    	String artistName = map.get("artistName").toString();
    	String trackName = map.get("trackName").toString();
    	String albumName = map.get("albumName").toString();
    	String albumCover = map.get("trackCover").toString();
    	String trackSpotifyId = map.get("trackSpotifyId").toString();
    	
    	// 트랙 아이디 반환 및 트랙 좋아요 테이블 삽입
    	streamingService.insertTrackCntService(session, artistName, trackName, albumName, albumCover, trackSpotifyId);
    }
	
	@PostMapping(value = "/streaming/deleteTrackLike", produces = MediaType.APPLICATION_JSON_VALUE)
    public void deleteTrackLike(@RequestBody HashMap<String, Object> map, HttpSession session) {
    	String trackSpotifyId = map.get("trackSpotifyId").toString();
    	// 트랙 좋아요 테이블 삭제
    	streamingService.deleteTrackLikeService(session, trackSpotifyId);
    }
}
