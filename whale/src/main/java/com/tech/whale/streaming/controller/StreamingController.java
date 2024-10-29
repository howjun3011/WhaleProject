package com.tech.whale.streaming.controller;

import javax.servlet.http.HttpSession;

import com.tech.whale.streaming.service.StreamingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;  // ResponseEntity 추가 필요
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;  // PostMapping 추가 필요
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import se.michaelthelin.spotify.model_objects.specification.Paging;
import se.michaelthelin.spotify.requests.data.personalization.interfaces.IArtistTrackModelObject;
import se.michaelthelin.spotify.model_objects.specification.Track;

import java.util.Map;
import java.util.concurrent.CompletableFuture;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class StreamingController {

	@Autowired
	private StreamingService streamingService;

	// [ 프레임에 스트리밍 메인 구간 이동 ]
	@RequestMapping("/streaming")

	public String streaming(@RequestParam Map<String, String> queryParam, HttpSession session, Model model) {

		// 노드 스트리밍 서버를 위한 리다이렉트
//		return "redirect:https://localhost:5500/whale/streaming\\?accessToken="+(String) session.getAttribute("accessToken")+"&userId="+(String) session.getAttribute("user_id")+"&type="+queryParam.get("type");

		// 스프링 스트리밍 서버를 위한 리다이렉트
//		 CompletableFuture로 반환되는 비동기 결과를 가져오기 위해 join() 사용
		CompletableFuture<Paging<Track>> topTracksFuture = streamingService.getUsersTopTracksAsync(session);
		Paging<Track> trackPaging = topTracksFuture.join(); // 결과를 동기적으로 기다림

		if (trackPaging != null && trackPaging.getItems().length > 0) {
			model.addAttribute("trackPaging", trackPaging);
		} else {
			model.addAttribute("error", "Unable to retrieve top tracks");
		}

		return "streaming/streamingHome";
	}

	// getDeviceId POST 요청 처리 메서드
	@PostMapping("/streaming/getDeviceId")
	public ResponseEntity<String> getDeviceId(HttpSession session) {
		// 임시로 예시 ID 반환 또는 원하는 처리를 여기에 작성
		return ResponseEntity.ok("Device ID가 성공적으로 생성되었습니다.");
	}

	@PostMapping("/streaming/playTrack")
	public ResponseEntity<String> playTrack(HttpSession session, @RequestBody Map<String, String> body) {
		String trackId = body.get("trackId");

		// 트랙 재생 메서드 호출
		boolean isPlayed = streamingService.playTrack(session, trackId);
		if (isPlayed) {
			return ResponseEntity.ok("Track is playing");
		} else {
			return ResponseEntity.status(500).body("Failed to play track");
		}
	}

}
