package com.tech.whale.main;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tech.whale.main.models.LikeNotiDto;
import com.tech.whale.main.service.MainService;
import com.tech.whale.setting.dto.PageAccessDto;

@RestController
@RequestMapping("/main")
public class MainRestController {
	private MainService mainService;
	
	public MainRestController(MainService mainService) {
		this.mainService = mainService;
	}
	
	// [ 디바이스 아이디 스프링 서버 세션 등록 API ]
	@PostMapping(value = "/device_id", produces = MediaType.APPLICATION_JSON_VALUE)
    public void mainGetDeviceId(@RequestBody HashMap<String, Object> map, HttpSession session) {
		session.setAttribute("device_id", map.get("device_id"));
    }
	
	// [ 페이지 접근 설정 값 ]
	@GetMapping(value = "/userInfo", produces = MediaType.APPLICATION_JSON_VALUE)
	public HashMap<String, Object> userInfoMain(HttpSession session) {
		String[] userInfos = mainService.userInfoMainService(session);
		HashMap<String, Object> map = new HashMap<>();
		
		map.put("nickname",userInfos[0]);
		map.put("imageUrl",userInfos[1]);
		
		return map;
	}
	
	// [ 시작페이지 설정 값 ]
	@GetMapping(value = "/checkStartPage", produces = MediaType.APPLICATION_JSON_VALUE)
	public HashMap<String, Object> checkStartPage(HttpSession session) {
		String[] startPages = mainService.checkStartPageMain(session);
		HashMap<String, Object> map = new HashMap<>();
		
		map.put("leftStartPage",startPages[0]);
		map.put("rightStartPage",startPages[1]);
		
		return map;
	}
	
	// [ 페이지 접근 설정 값 ]
	@GetMapping(value = "/checkPageAccess", produces = MediaType.APPLICATION_JSON_VALUE)
	public PageAccessDto checkPageAccess(HttpSession session) {
		PageAccessDto pageAccesses = mainService.checkPageAccessMain(session);
		return pageAccesses;
	}
	
	// [ 좋아요 알림 값 ]
	@GetMapping(value = "/likeNoti", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<LikeNotiDto> getLikeNotiMain(HttpSession session) {
		List<LikeNotiDto> likeNotis = mainService.getLikeNotiMainService(session);
		return likeNotis;
	}
}
