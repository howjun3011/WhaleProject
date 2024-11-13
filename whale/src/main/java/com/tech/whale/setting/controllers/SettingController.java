package com.tech.whale.setting.controllers;

import java.io.File;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.tech.whale.login.dao.UserDao;
import com.tech.whale.main.service.MainService;
import com.tech.whale.setting.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.tech.whale.setting.dao.ReportDao;
import com.tech.whale.setting.dao.SettingDao;
import com.tech.whale.streaming.service.StreamingService;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

    @Autowired
    private MainService mainService;

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
        System.out.println("대표곡: " + userinfoDto.getUser_track_id()); // debug

        return "setting/profileEdit";
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

    @PostMapping("/updateProfile")
    public String updateProfile(@RequestParam("user_nickname") String nickname,
                                @RequestParam("user_email") String email,
                                @RequestParam(value = "user_profile_image_url", required = false) String userProfileImageUrl,
                                HttpSession session) {
        System.out.println("updateProfile() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

        // 새로운 프로필 이미지가 없을 경우 기존 이미지 사용
        if (userProfileImageUrl == null || userProfileImageUrl.isEmpty()) {
            userProfileImageUrl = settingDao.getCurrentProfileImage(session_user_id);
        }

        // DB에 변경한 프로필 정보 업데이트
        settingDao.updateProfile(nickname, email, userProfileImageUrl, session_user_id);

        System.out.println("DB 업데이트 완료");

        return "redirect:/profileEdit";
    }

    @RequestMapping("/representiveSong")
    public String representiveSong(HttpSession session, Model model) {
        System.out.println("representiceSong() ctr");

        return "setting/representiveSong";
    }

    @PostMapping(value = "/updateRepresentive", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> updateRepresentive(@RequestBody HashMap<String, Object> map, HttpSession session) {
        System.out.println("updateRepresentive() ctr");

        String session_user_id = (String) session.getAttribute("user_id");
        System.out.println(session_user_id);

        // [ 스트리밍 검색 기능: 트랙 테이블에 해당 정보 확인 후 추가. 프라이머리 키를 반환. ]
        String artistName = ((ArrayList<HashMap<String, String>>) map.get("artists")).get(0).get("name");
        String trackName = map.get("name").toString();
        String albumName = ((Map<String, String>) map.get("album")).get("name");
        String albumCover = (((Map<String, ArrayList<HashMap<String, String>>>) map.get("album")).get("images")).get(0).get("url");
        String trackSpotifyId = map.get("id").toString();

        String trackId = streamingService.selectTrackIdService(trackSpotifyId, artistName, trackName, albumName, albumCover);
        System.out.println(trackId);

        // user_info 테이블의 representivesong 필드에 trackId 업데이트
        settingDao.updateRepresentiveSong(session_user_id, trackId);
        System.out.println("대표곡 업데이트 완료");

        // 성공 응답 반환
        return ResponseEntity.ok().build();
    }

    @RequestMapping("/account")
    public String account(HttpSession session, Model model) {
        System.out.println("account() ctr");

        return "setting/account";
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

    @RequestMapping(value = "/privateFollowNoti", method = RequestMethod.POST)
    @ResponseBody
    public String privateFollowNoti(HttpSession session, Model model) {
        System.out.println("privateFollowNoti() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

        // Follow_noti 테이블에서 팔로우 요청 보낸 사람 리스트 가져오기
        List<String> followList = settingDao.getFollowRequestList(session_user_id);

        // debug
        for (String follow : followList) {
            System.out.println(follow);
        }

        // 비공개 계정에서 공개로 풀었을 경우 follow 테이블에 추가(상대방 팔로잉에 +1) + follow_noti 테이블에서 알림 삭제 + 상대방한테 follow 알림 보내기
        for (String follow_id : followList) {
            mainService.privateFollowNotiMainService(session_user_id, follow_id);
        }

        return "success";
    }

    //  슬라이드 버튼에 의해서 on이면 0(비공개 계정 설정), off면 1(공개 계정 설정)
    @PostMapping("/updatePrivacy")
    @ResponseBody
    public String updatePrivacy(@RequestParam("account_privacy") int accountPrivacy, HttpSession session) {
        System.out.println("updatePrivacy() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

//       DB 업데이트
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

        List<LikeListDto> postLikeList = settingDao.getFilteredPostLikeList(session_user_id, orderBy, postType);

        // debug
        for (LikeListDto likeListDto : postLikeList) {
            System.out.println("post_id: " + likeListDto.getPost_id());
            System.out.println("community_id: " + likeListDto.getCommunity_id());
            System.out.println("post_title: " + likeListDto.getPost_text());
            System.out.println("post_text: " + likeListDto.getPost_title());
            System.out.println("post_tag_text: " + likeListDto.getPost_tag_text());
        }

        model.addAttribute("session_user_id", session_user_id);
        model.addAttribute("postLikeList", postLikeList);
        model.addAttribute("selectedSortOrder", sortOrder);
        model.addAttribute("selectedPostType", postType);

        return "setting/likeList";
    }

    @RequestMapping("/commentList")
    public String commentList(@RequestParam(defaultValue = "최신순") String sortOrder, @RequestParam(defaultValue = "게시글") String postType, HttpSession session, Model model) {
        System.out.println("commentList() ctr");

        String session_user_id = (String) session.getAttribute("user_id");

        String orderBy = sortOrder.equals("최신순") ? "DESC" : "ASC";

        List<CommentListDto> postFeedList = settingDao.getFilteredPostCommentList(session_user_id, orderBy, postType);
        List<CommentListDto> postFeedCommentList = settingDao.getFilteredPostReplyCommentList(session_user_id, orderBy, postType);

        // 게시글과 피드 ID를 각각 중복 없이 저장할 Set
        Set<Integer> uniquePostIds = new HashSet<>();
        Set<Integer> uniqueFeedIds = new HashSet<>();

        // 중복 제거된 게시글과 피드 리스트를 담을 리스트
        List<CommentListDto> filteredPostFeedCommentList = new ArrayList<>();

        for (CommentListDto dto : postFeedList) {
            if ("게시글".equals(postType) && uniquePostIds.add(dto.getPost_id())) {
                filteredPostFeedCommentList.add(dto);  // 중복되지 않은 post_id만 추가
            } else if ("피드".equals(postType) && uniqueFeedIds.add(dto.getFeed_id())) {
                filteredPostFeedCommentList.add(dto);  // 중복되지 않은 feed_id만 추가
            }
        }

        model.addAttribute("postFeedList", filteredPostFeedCommentList); // 중복 제거된 리스트
        model.addAttribute("postFeedCommentList", postFeedCommentList);
        model.addAttribute("selectedSortOrder", sortOrder);
        model.addAttribute("selectedPostType", postType);

        // debug
        for (CommentListDto commentListDto : postFeedCommentList) {
            System.out.println("피드");
            System.out.println("Feed_id: " + commentListDto.getFeed_id());
            System.out.println("Feed_text: " + commentListDto.getFeed_text());
            System.out.println("Feed_comments_text: " + commentListDto.getFeed_comments_text());
            System.out.println("Feed_img_name: " + commentListDto.getFeed_img_name());
            System.out.println("Feed_comments_id: " + commentListDto.getFeed_comments_id());
            System.out.println("Parent_comments_id: " + commentListDto.getParent_comments_id());
            System.out.println("----------------------------------------------------");
        }

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

    @RequestMapping("/report")
    public String report(HttpServletRequest request, HttpSession session, Model model,
                         @RequestParam(value = "p", required = false) String post_id,
                         @RequestParam(value = "f", required = false) String feed_id,
                         @RequestParam(value = "fc", required = false) String feed_comments_id,
                         @RequestParam(value = "pc", required = false) String post_comments_id,
                         @RequestParam(value = "m", required = false) String message_id) {
        String now_id = (String) session.getAttribute("user_id");
        String report_tag = "";
        String userId = "";
        
        if (post_id != null) {
            report_tag = "게시글 신고";
            userId = reportDao.getPostUser(post_id);
            model.addAttribute("report_type_id", post_id);
        } else if (feed_id != null) {
        	userId = reportDao.getFeedUser(feed_id);
            report_tag = "피드 신고";
            model.addAttribute("report_type_id", feed_id);
        } else if (feed_comments_id != null) {
        	userId = reportDao.getFeedCommentsUser(feed_comments_id);
            report_tag = "피드 댓글 신고";
            model.addAttribute("report_type_id", feed_comments_id);
        } else if (post_comments_id != null) {
			userId = reportDao.getPostCommentsUser(post_comments_id);
			report_tag = "게시글 댓글 신고";
			model.addAttribute("report_type_id", post_comments_id);
		} else if (message_id != null) {
			userId = reportDao.getMessageUser(message_id);
			report_tag = "메시지 신고";
			model.addAttribute("report_type_id", message_id);
		}

        model.addAttribute("userId", userId);
        model.addAttribute("report_tag", report_tag);
        model.addAttribute("now_id", now_id);
        return "report/report";
    }

    @RequestMapping("/reportDo")
    public String reportDo(HttpServletRequest request, Model model,
                           HttpSession session,
                           @RequestParam("now_id") String now_id,
                           @RequestParam("report_tag") String report_tag,
                           @RequestParam("report_type_id") String report_type_id,
                           @RequestParam("report_why") String report_why,
                           @RequestParam("userId") String userId) {

        String reportText = "";
        String reportImg = "";

        if (report_tag.equals("게시글 신고")) {
            ReportDto reportDto = reportDao.getReportPost(report_type_id);
            reportText = reportDto.getReport_text();
            reportDao.reportPost(report_type_id, now_id, report_why, report_tag, reportText, userId);
        } else if (report_tag.equals("피드 신고")) {
            ReportDto reportDto = reportDao.getReportFeed(report_type_id);
            reportText = reportDto.getReport_text();
            reportImg = reportDto.getReport_img_url();
            reportDao.reportFeed(report_type_id, now_id, report_why, report_tag, reportText, reportImg, userId);
        } else if (report_tag.equals("피드 댓글 신고")) {
            ReportDto reportDto = reportDao.getReportFeedComments(report_type_id);
            reportText = reportDto.getReport_text();
            reportDao.reportFeedComments(report_type_id, now_id, report_why, report_tag, reportText, userId);
        } else if (report_tag.equals("게시글 댓글 신고")) {
        	ReportDto reportDto = reportDao.getReportPostComments(report_type_id);
			reportText = reportDto.getReport_text();
			reportDao.reportPostComments(report_type_id, now_id, report_why, report_tag, reportText, userId);
		} else if (report_tag.equals("메시지 신고")) {
			ReportDto reportDto = reportDao.getReportMessage(report_type_id);
			reportText = reportDto.getReport_text();
			reportDao.reportMessage(report_type_id, now_id, report_why, report_tag, reportText, userId);
			
		}

        return "redirect:/profileHome?u="+(String) session.getAttribute("user_id");
    }

    @RequestMapping("/deleteAccount")
    public String deleteAccount(HttpServletRequest request, HttpSession session, Model model) {
        System.out.println("deleteAccount 페이지 열림");

        // 세션에서 user_id 가져오기 (필요 시 사용)
        String sessionUserId = (String) session.getAttribute("user_id");
        if (sessionUserId == null) {
            // 세션에 user_id가 없으면 로그인 페이지로 리다이렉트
            return "redirect:/";
        }

        return "setting/deleteAccount";
    }

    @Autowired
    private UserDao userDao;

    @Transactional
    public void deleteUser(String userId) {
        userDao.deleteUserById(userId);
    }

    @PostMapping("/deleteAccountMethod")
    public String deleteAccountMethod(HttpSession session, @RequestParam("password") String password, RedirectAttributes redirectAttributes) {
        System.out.println("deleteAccountMethod 실행");

        // 세션에서 user_id 가져오기
        String sessionUserId = (String) session.getAttribute("user_id");
        System.out.println(sessionUserId);
        if (sessionUserId == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        // 비밀번호 검증 로직
        String storedPassword = userDao.getPasswordByUsername(sessionUserId);
        System.out.println("DB에서 가져온 암호화된 비밀번호: " + storedPassword);
        System.out.println("입력한 비밀번호: " + password);

        // 입력한 비밀번호와 DB의 암호화 비밀번호를 비교
        if (!passwordEncoder.matches(password, storedPassword)) {
            System.out.println("비밀번호 일치하지 않음");
            redirectAttributes.addFlashAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
            return "redirect:/deleteAccount";
        }

        System.out.println("비밀번호 일치함");

        try {
            // 사용자 계정 삭제
            System.out.println("삭제할 사용자 ID: " + sessionUserId);
            userDao.deleteUserById(sessionUserId);
            System.out.println("사용자 삭제 완료");
            session.invalidate();  // 세션 무효화

            redirectAttributes.addFlashAttribute("successMessage", "회원 탈퇴가 완료되었습니다.");
            return "redirect:/";  // 메인 페이지로 이동
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "회원 탈퇴 중 오류가 발생했습니다.");
            return "redirect:/deleteAccount";
        }
    }
}
