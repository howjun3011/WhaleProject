package com.tech.whale.streaming.controller;

// 필요한 Spring Framework 클래스 및 어노테이션 임포트
import com.tech.whale.streaming.service.LyricsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller // Spring MVC의 컨트롤러로 선언. 클라이언트의 요청을 처리하고 뷰를 반환
public class LyricsController {

    // 가사를 가져오는 비즈니스 로직을 처리하는 서비스 클래스 주입
    @Autowired // Spring의 의존성 주입 어노테이션으로, lyricsService 객체를 자동으로 주입
    private LyricsService lyricsService;


//     GET 요청을 처리하여 특정 곡의 가사를 반환
//     @param artist 가수 이름 (쿼리 파라미터에서 가져옴)
//     @param title  곡 제목 (쿼리 파라미터에서 가져옴)
//     @param model  뷰로 데이터를 전달하기 위한 객체
//     @return 가사를 표시할 JSP 또는 HTML 페이지의 이름

    @GetMapping("/lyrics") // "/lyrics" URL 경로에 대한 GET 요청 처리
    public String showLyrics(
            @RequestParam("artist") String artist, // 요청에서 "artist"라는 파라미터를 가져와 매핑
            @RequestParam("title") String title,   // 요청에서 "title"라는 파라미터를 가져와 매핑
            Model model // 뷰로 데이터를 전달하기 위해 사용
    ) {
        // LyricsService를 사용하여 가사를 가져옴
        String lyrics = lyricsService.getLyrics(artist, title);

        // 뷰에 전달할 데이터를 설정
        model.addAttribute("lyrics", lyrics); // "lyrics"라는 이름으로 가사를 뷰에 전달

        // 가사를 표시할 뷰 페이지 이름 반환 (예: "lyricsView.jsp" 또는 "lyricsView.html")
        return "lyricsView";
    }
}
