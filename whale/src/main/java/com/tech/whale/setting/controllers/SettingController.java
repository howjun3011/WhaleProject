package com.tech.whale.setting.controllers;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.tech.whale.setting.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.tech.whale.setting.dao.ReportDao;
import com.tech.whale.setting.dao.SettingDao;
import com.tech.whale.streaming.service.StreamingService;

@Controller
public class SettingController {
	
	private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	
	UserInfoDto userinfoDto;
	StartpageDto startpageDto;
	UserSettingDto userSettingDto;
	UserNotificationDto userNotificationDto;
	BlockDto blockDto;
	PageAccessDto pageAccessDto;
	LikeListDto likeListDto;
	CommentListDto commentListDto;
    HiddenFeedDto hiddenFeedDto;
	
	// [ 스트리밍 검색 기능 ]
    @Autowired
    private StreamingService streamingService;

    @RequestMapping("/settingHome")
    public String settingHome(HttpServletRequest request, HttpSession session, Model model) {
        System.out.println("settingHome() ctr");

        return "setting/settingHome";
    }

    @Autowired
    private SettingDao settingDao;

    @Autowired
    private ReportDao reportDao;

    @RequestMapping("/profileEdit")
    public String profileEdit(HttpServletRequest request, HttpSession session, Model model) {
        System.out.println("profileEdit() ctr");

        // 세션에서 user_id 가져오기
        String session_user_id = (String) session.getAttribute("user_id");
        System.out.println(session_user_id);

        userinfoDto = settingDao.getProfile(session_user_id);

        model.addAttribute("profile", userinfoDto);
        System.out.println("current_img_url: " + userinfoDto.getUser_image_url()); // debug

        return "setting/profileEdit";
    }

    @PostMapping("/updateProfile")
    public String updateProfile(@RequestParam("user_nickname") String nickname,
                                @RequestParam("user_password") String password,
                                @RequestParam("user_email") String email,
                                HttpSession session) {
        System.out.println("updateProfile() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

        if (session.getAttribute("user_profile_image") == null) { // 세션에 이미지가 저장 안 되어 있으면
            session.setAttribute("user_profile_image", userinfoDto.getUser_image_url()); // DB에서 불러온 이미지 url을 세션에 user_profile_image라는 이름으로 저장
            System.out.println("session에 이미지 저장 안 되어 있어서 새로 저장: " + userinfoDto.getUser_image_url()); // debug
        }

        // 세션에 저장된 새로운 프로필 이미지 가져오기
        String newProfileImage = (String) session.getAttribute("user_profile_image");
        System.out.println("session_storaged_img_url: " + session.getAttribute("user_profile_image")); // debug

        // password 필드가 비어있으면 DB에 비밀번호 업데이트 X, 비밀번호를 변경해서 필드에 값이 있으면 필드에 입력한 값을 암호화 처리해서 DB 업데이트
        if (password.isEmpty()) {
            // DB에 변경한 프로필 정보 업데이트(PW 제외)
            settingDao.updateProfileNP(nickname, email, newProfileImage, session_user_id);
        } else {
            // 비밀번호 암호화
            String encodedPassword = passwordEncoder.encode(password);
            System.out.println("encodedpassword: " + encodedPassword); // debug
            // DB에 변경한 프로필 정보 업데이트
            settingDao.updateProfile(nickname, encodedPassword, email, newProfileImage, session_user_id);
        }

        System.out.println("DB 업데이트 완료");

        return "redirect:/profileEdit";
    }

    @RequestMapping("/updatePassword")
    public String updatePassword(HttpServletRequest request, HttpSession session, Model model) {
        System.out.println("updatePassword() ctr");

        return "setting/updatePassword";
    }

    @PostMapping("/checkCurrentPassword")
    @ResponseBody
    public Map<String, String> checkCurrentPassword(@RequestParam("current_password") String currentPassword, HttpSession session) {
        System.out.println("checkCurrentPassword() ctr");

        String session_user_id = (String) session.getAttribute("user_id");
        String dbPassword = settingDao.getCurrentPassword(session_user_id);

        Map<String, String> response = new HashMap<>();
        if (passwordEncoder.matches(currentPassword, dbPassword)) {
            response.put("status", "valid");
        } else {
            response.put("status", "invalid");
        }

        return response;
    }

    @PostMapping("/updateNewPassword")
    @ResponseBody
    public ResponseEntity<Map<String, String>> updateNewPassword(
            @RequestParam("new_password") String newPassword, HttpSession session) {
        System.out.println("updateNewPassword() ctr");

        String session_user_id = (String) session.getAttribute("user_id");
        String encodedPassword = passwordEncoder.encode(newPassword); // 암호화된 새로운 pw

        // JSON 응답으로 success 메시지 반환
        Map<String, String> response = new HashMap<>();

        settingDao.updatePassword(session_user_id, encodedPassword);
        response.put("status", "success");

        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/uploadProfileImage")
    @ResponseBody
    public Map<String, String> uploadProfileImage(MultipartHttpServletRequest mtfRequest, HttpSession session) {
        System.out.println("uploadProfileImage() ctr");

        Map<String, String> response = new HashMap<>();

        String session_user_id = (String) session.getAttribute("user_id");

        String workPath = System.getProperty("user.dir");
        System.out.println(workPath);
        String root = workPath + "/src/main/resources/static/images/setting";
        MultipartFile mf = mtfRequest.getFile("file");

        if (mf != null && !mf.isEmpty()) {
            String originalFileName = mf.getOriginalFilename();
            long currentTime = System.currentTimeMillis();
            String newFileName = currentTime + "_" + originalFileName;

            String savePath = root + "/" + newFileName;

            try {
                File saveFile = new File(savePath);
                mf.transferTo(saveFile);

                // 세션에 변경한 이미지 파일명 저장
                session.setAttribute("user_profile_image", newFileName);
                System.out.println("session_set_img_url" + session.getAttribute("user_profile_image")); // debug
                response.put("fileName", newFileName);
                response.put("status", "success");

            } catch (Exception e) {
                e.printStackTrace();
                response.put("status", "error");
            }
        } else {
            response.put("status", "no_file");
        }

        return response;
    }

    @RequestMapping("/representiveSong")
    public String representiveSong(HttpSession session, Model model) {
        System.out.println("representiceSong() ctr");

        return "setting/representiveSong";
    }
    
    @PostMapping(value = "/updateRepresentive", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> updateRepresentive(@RequestBody HashMap<String, Object> map, HttpSession session) {
    	System.out.println("updateRepresentive() ctr");
    	
    	// [ 스트리밍 검색 기능: 트랙 테이블에 해당 정보 확인 후 추가. 프라이머리 키를 반환. ]
    	String artistName = ((ArrayList<HashMap<String, String>>) map.get("artists")).get(0).get("name");
    	String trackName = map.get("name").toString();
    	String albumName = ((Map<String, String>) map.get("album")).get("name");
    	String albumCover = (((Map<String, ArrayList<HashMap<String, String>>>) map.get("album")).get("images")).get(0).get("url");
    	String trackSpotifyId = map.get("id").toString();
    	
    	Integer trackId = streamingService.selectTrackIdService(artistName, trackName, albumName, albumCover, trackSpotifyId);

    	System.out.println("DB 업데이트 완료");

        // 성공 응답 반환
        return ResponseEntity.ok().build();
    }

    @RequestMapping("/account")
    public String account(HttpSession session, Model model) {
        System.out.println("account() ctr");

        return "setting/account";
    }

    @RequestMapping("/connectAccount")
    public String connectAccount(HttpSession session, Model model) {
        System.out.println("connectAccount() ctr");

        return "setting/connectAccount";
    }

    @RequestMapping("/accountPrivacy")
    public String accountPrivacy(HttpSession session, Model model) {
        System.out.println("accountPrivacy() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

//      비공개 계정 설정 값 가져오기  
        userSettingDto = settingDao.getAccountPrivacyByUserId(session_user_id);
        System.out.println("accountPrivacy value : " + userSettingDto.getAccount_privacy());

//      JSP로 데이터 전달
        model.addAttribute("accountPrivacyOn", userSettingDto.getAccount_privacy());

        return "setting/accountPrivacy";
    }

    //  슬라이드 버튼에 의해서 on이면 0(비공개 계정 설정), off면 1(공개 계정 설정)
    @PostMapping("/updatePrivacy")
    @ResponseBody
    public String updatePrivacy(@RequestParam("account_privacy") int accountPrivacy, HttpSession session) {
        System.out.println("updatePrivacy() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

//    	DB 업데이트
        settingDao.updateAccountPrivacy(session_user_id, accountPrivacy);

        return "success";
    }

    @RequestMapping("/hiddenFeed")
    public String hiddenFeed(HttpSession session, Model model) {
        System.out.println("hiddenFeed() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

        List<HiddenFeedDto> hiddenFeedList = settingDao.getHiddenFeedList(session_user_id);

        model.addAttribute("hiddenFeedList", hiddenFeedList);

        return "setting/hiddenFeed";
    }

    @RequestMapping("/activity")
    public String activity(HttpSession session, Model model) {
        System.out.println("activity() ctr");

        return "setting/activity";
    }

    @RequestMapping("/likeList")
    public String likeList(@RequestParam(defaultValue = "최신순") String sortOrder, @RequestParam(defaultValue = "게시글") String postType, HttpSession session, Model model) {
        System.out.println("likeList() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

        String orderBy = sortOrder.equals("최신순") ? "DESC" : "ASC";

        List<LikeListDto> currentPostLikeList = settingDao.getFilteredPostLikeList(session_user_id, orderBy, postType);

        // debug
        for (LikeListDto likeListDto : currentPostLikeList) {
            System.out.println("post_id: " + likeListDto.getPost_id());
            System.out.println("community_id: " + likeListDto.getCommunity_id());
            System.out.println("post_text: " + likeListDto.getPost_title());
            System.out.println("post_title: " + likeListDto.getPost_text());
            System.out.println("post_tag_text: " + likeListDto.getPost_text());
            System.out.println("feed_id: " + likeListDto.getFeed_id());
            System.out.println("feed_img_name: " + likeListDto.getFeed_img_name());
        }

        model.addAttribute("currentPostLikeList", currentPostLikeList);
        model.addAttribute("selectedSortOrder", sortOrder);
        model.addAttribute("selectedPostType", postType);

        return "setting/likeList";
    }

    @RequestMapping("/commentList")
    public String commentList(@RequestParam(defaultValue = "최신순") String sortOrder, @RequestParam(defaultValue = "게시글") String postType, HttpSession session, Model model) {
        System.out.println("commentList() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

        String orderBy = sortOrder.equals("최신순") ? "DESC" : "ASC";

        List<CommentListDto> currentPostCommentList = settingDao.getFilteredPostCommentList(session_user_id, orderBy, postType);

        // debug
        for (CommentListDto commentListDto : currentPostCommentList) {
            System.out.println("post_id: " + commentListDto.getPost_id());
            System.out.println("community_id: " + commentListDto.getCommunity_id());
            System.out.println("post_title: " + commentListDto.getPost_title());
            System.out.println("post_comment: " + commentListDto.getPost_comments_text());
            System.out.println("post_tag: " + commentListDto.getPost_tag_text());
            System.out.println("feed_id: " + commentListDto.getFeed_id());
            System.out.println("feed_img_name: " + commentListDto.getFeed_img_name());
            System.out.println("feed_text: " + commentListDto.getFeed_text());
            System.out.println("feed_owner_image: " + commentListDto.getFeed_owner_image());
            System.out.println("feed_comments_id: " + commentListDto.getFeed_comments_id());
            System.out.println("parent_comments_id: " + commentListDto.getParent_comments_id());
            System.out.println("commenter_image: " + commentListDto.getCommenter_image());
            System.out.println("commenter_id: " + commentListDto.getCommenter_id());
            System.out.println("feed_comments_text: " + commentListDto.getFeed_comments_text());
        }

        model.addAttribute("currentPostCommentList", currentPostCommentList);
        model.addAttribute("selectedSortOrder", sortOrder);
        model.addAttribute("selectedPostType", postType);

        return "setting/commentList";
    }

    @RequestMapping("/notification")
    public String notification(HttpSession session, Model model) {
        System.out.println("notification() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

//      알림 설정 값 가져오기 + Dto에 저장
        userNotificationDto = settingDao.getNotificationSettingsByUserId(session_user_id);

//      debug
        System.out.println("1: " + userNotificationDto.getAll_notification_off());
        System.out.println("2: " + userNotificationDto.getLike_notification_onoff());
        System.out.println("3: " + userNotificationDto.getComment_notification_onoff());
        System.out.println("4: " + userNotificationDto.getMessage_notification_onoff());

//      JSP로 데이터 전달
        model.addAttribute("allNotificationOff", userNotificationDto.getAll_notification_off());
        model.addAttribute("likeNotificationOn", userNotificationDto.getLike_notification_onoff());
        model.addAttribute("commentNotificationOn", userNotificationDto.getComment_notification_onoff());
        model.addAttribute("messageNotificationOn", userNotificationDto.getMessage_notification_onoff());

        return "setting/notification";
    }

    @PostMapping("/updateNotifications")
    @ResponseBody
    public String updateNotifications(
            @RequestParam("all_notification_off") int allNotificationOff,
            @RequestParam("like_notification_onoff") int likeNotificationOnoff,
            @RequestParam("comment_notification_onoff") int commentNotificationOnoff,
            @RequestParam("message_notification_onoff") int messageNotificationOnoff,
            HttpSession session) {

        System.out.println("updateNotifications() ctr");

//      debug
        System.out.println("all_notification_off: " + allNotificationOff);
        System.out.println("like_notification_onoff: " + likeNotificationOnoff);
        System.out.println("comment_notification_onoff: " + commentNotificationOnoff);
        System.out.println("message_notification_onoff: " + messageNotificationOnoff);

        String session_user_id = (String) session.getAttribute("user_id");
        System.out.println("session_user_id: " + session_user_id); // debug

        if (session_user_id == null) {
            System.out.println("session_user_id is null");
            return "failed";
        }

        try {
            // DB 업데이트 호출
            settingDao.updateNotificationSettings(session_user_id, allNotificationOff, likeNotificationOnoff, commentNotificationOnoff, messageNotificationOnoff);
            System.out.println("DB 업데이트 성공");
        } catch (Exception e) {
            System.err.println("DB 업데이트 중 오류 발생");
            e.printStackTrace();
            return "failed";
        }

        return "success";
    }

    @PostMapping("/updateIndividualNotification")
    @ResponseBody
    public String updateIndividualNotification(@RequestParam("like_notification_onoff") Optional<Integer> likeNotificationOnOff,
                                               @RequestParam("comment_notification_onoff") Optional<Integer> commentNotificationOnOff,
                                               @RequestParam("message_notification_onoff") Optional<Integer> messageNotificationOnOff,
                                               HttpSession session) {
        System.out.println("updateIndividualNotification() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

        // 각 알림 상태에 따라 DB 업데이트 처리
        if (likeNotificationOnOff.isPresent()) {
            settingDao.updateLikeNotification(session_user_id, likeNotificationOnOff.get());
        }
        if (commentNotificationOnOff.isPresent()) {
            settingDao.updateCommentNotification(session_user_id, commentNotificationOnOff.get());
        }
        if (messageNotificationOnOff.isPresent()) {
            settingDao.updateMessageNotification(session_user_id, messageNotificationOnOff.get());
        }

        return "success";
    }

    @RequestMapping("/blockList")
    public String blockList(HttpSession session, Model model) {
        System.out.println("blockList() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

//      DB의 block_user_id에 데이터가 콤마 형식으로 들어올 경우 DB 상에서 콤마를 구분자로 이름을 추출하고, 그 이름의 아이디, 이미지 사진을 가져올 수 있도록 수정해야 함

//      차단된 회원의 아이디, 닉네임, 프로필 사진을 가져와서 blocklist에 저장하기
        List<BlockDto> bloclist = settingDao.getBlockList(session_user_id);
        model.addAttribute("blockList", bloclist);

        // debug
        for (BlockDto blockDto : bloclist) {
            System.out.println(blockDto.getUser_id());
            System.out.println(blockDto.getUser_image_url());
            System.out.println(blockDto.getUser_nickname());
        }

        return "setting/blockList";
    }

    @PostMapping("/unblockUser")
    @ResponseBody
    public ResponseEntity<Map<String, String>> unblockUser(@RequestParam("user_id") String block_userId, HttpSession session) {
        System.out.println("unblockUser() ctr");
        System.out.println("차단 해제 요청 수신됨. 차단 당할 사용자 ID: " + block_userId); // debug

        String session_user_id = (String) session.getAttribute("user_id");
        System.out.println("세션 사용자 ID: " + session_user_id); // debug

        // 차단 해제
        settingDao.unblockUser(session_user_id, block_userId);
        System.out.println("차단 해제 성공"); // debug

        Map<String, String> response = new HashMap<>();
        response.put("message", "차단 해제 성공");

        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @RequestMapping("/accessibility")
    public String accessibility(HttpSession session, Model model) {
        System.out.println("accessibility() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

        userSettingDto = settingDao.getDarkmode(session_user_id);
        System.out.println("darkmodeOn: " + userSettingDto.getDarkmode_setting_onoff());

        model.addAttribute("darkmodeOn", userSettingDto.getDarkmode_setting_onoff());

        return "setting/accessibility";
    }

    @PostMapping("/updateDarkmode")
    @ResponseBody
    public String updateDarkmode(@RequestParam("darkmode_setting_onoff") int darkmodeOn, HttpSession session) {
        System.out.println("updateDarkmode() ctr");
        System.out.println("darkmode_setting_onoff: " + darkmodeOn); // debug

        String session_user_id = (String) session.getAttribute("user_id");
        System.out.println("session_user_id: " + session_user_id); // debug

        if (session_user_id == null) {
            System.out.println("session_user_id is null");
            return "failed";
        }

        try {
            settingDao.updateDarkmode(session_user_id, darkmodeOn);
            System.out.println("DB 업데이트 성공");
        } catch (Exception e) {
            System.out.println("DB 업데이트 중 오류 발생");
            e.printStackTrace();
            return "failed";
        }

        return "success";
    }

    @RequestMapping("/startpageSetting")
    public String startpageSetting(HttpSession session, Model model) {
        System.out.println("startpageSetting() ctr");

        String session_user_id = (String) session.getAttribute("user_id");
        System.out.println("session_user_id: " + session_user_id); // debug

        startpageDto = settingDao.getStartpageSetting(session_user_id);

//      debug
        System.out.println(startpageDto.getStartpage_music_setting());
        System.out.println(startpageDto.getStartpage_feed_setting());
        System.out.println(startpageDto.getStartpage_community_setting());
        System.out.println(startpageDto.getStartpage_message_setting());

        // jsp로 전달
        model.addAttribute("music", startpageDto.getStartpage_music_setting());
        model.addAttribute("feed", startpageDto.getStartpage_feed_setting());
        model.addAttribute("community", startpageDto.getStartpage_community_setting());
        model.addAttribute("message", startpageDto.getStartpage_message_setting());

        return "setting/startpageSetting";
    }

    @PostMapping("/updateStartpageSetting")
    @ResponseBody
    public ResponseEntity<Map<String, String>> updateStartpageSetting(@RequestBody Map<String, String> request, @SessionAttribute("user_id") String userId) {
        System.out.println("updateStartpageSetting() ctr");

        String left = request.get("left");
        String right = request.get("right");

        try {
            // 선택된 값에 따라 DB 업데이트
            settingDao.updateStartpageSetting(userId, left, right);

            Map<String, String> response = new HashMap<>();
            response.put("message", "업데이트 성공");
            return new ResponseEntity<>(response, HttpStatus.OK);

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> response = new HashMap<>();
            response.put("message", "업데이트 실패");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping("/pageAccessSetting")
    public String pageAccessSetting(HttpSession session, Model model) {
        System.out.println("pageAccessSetting() ctr");

        String session_user_id = (String) session.getAttribute("user_id");
        System.out.println("session_user_id: " + session_user_id); // debug

        pageAccessDto = settingDao.getPageAccessSetting(session_user_id);

        // debug
        System.out.println("PA mypage : " + pageAccessDto.getPage_access_mypage());
        System.out.println("PA noficiation : " + pageAccessDto.getPage_access_notification());
        System.out.println("PA setting : " + pageAccessDto.getPage_access_setting());
        System.out.println("PA music : " + pageAccessDto.getPage_access_music());

        // jsp로 전달
        model.addAttribute("mypage", pageAccessDto.getPage_access_mypage());
        model.addAttribute("notification", pageAccessDto.getPage_access_notification());
        model.addAttribute("setting", pageAccessDto.getPage_access_setting());
        model.addAttribute("music", pageAccessDto.getPage_access_music());

        return "setting/pageAccessSetting";
    }

    @PostMapping("/updatePageAccessSetting")
    @ResponseBody
    public ResponseEntity<Map<String, String>> updatePageAccessSetting(@RequestParam("settingType") String settingType,
                                                                       @RequestParam("selectedValue") String selectedValue,
                                                                       @SessionAttribute("user_id") String userId) {
        System.out.println("updatePageAccessSetting() ctr");

        try {
            settingDao.updatePageAccessSetting(userId, settingType, selectedValue);

            Map<String, String> response = new HashMap<>();
            response.put("message", "업데이트 성공");
            return new ResponseEntity<>(response, HttpStatus.OK);

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> response = new HashMap<>();
            response.put("message", "업데이트 실패");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
