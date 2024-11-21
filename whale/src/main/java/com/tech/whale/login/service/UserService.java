package com.tech.whale.login.service;

import com.tech.whale.login.dto.UserDto;
import com.tech.whale.login.dao.UserDao;

import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;

@Service
public class UserService {

    @Autowired
    private UserDao userDao; // UserDao 주입

    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder(); // 비밀번호 암호화를 위한 인코더

    @Autowired
    private JavaMailSender mailSender; // JavaMailSender 주입

    @Autowired
    private SqlSessionTemplate sqlSession; // MyBatis SQL 세션 템플릿

    // 사용자 인증 메서드
    public boolean authenticate(String username, String password) {
        String storedPassword = userDao.getPasswordByUsername(username); // DB에서 비밀번호 가져오기
        return passwordEncoder.matches(password, storedPassword); // 입력한 비밀번호와 DB 비밀번호 비교
    }

    // Access ID 로그인 체크
    public void checkAccessIdLogin(String username, HttpSession session) {
        Integer accessId = userDao.checkAccessId(username); // DB에서 Access ID 조회
        session.setAttribute("access_id", accessId.toString()); // 세션에 저장
    }

    // 사용자 등록 메서드
    public boolean registerUser(String username, String password, String email, String nickname, String spotifyId) {
        try {
            // 비밀번호 암호화
            String encodedPassword = passwordEncoder.encode(password);

            // UserDto 객체 생성
            UserDto userDto = new UserDto(username, encodedPassword, email, nickname, spotifyId);

            // DB에 사용자 정보 저장
            userDao.insertUserInfo(userDto);

            // 기본 환경 설정 데이터 추가
            userDao.insertUserNotification(username);
            userDao.insertPageAccessSetting(username);
            userDao.insertStartPageSetting(username);
            userDao.insertUserSetting(username);
            userDao.insertFollow(username);

            // 팔로우 ID 가져와 프로필 데이터 추가
            Integer followId = userDao.selectFollowId(username);
            userDao.insertProfile(username, followId);
            return true;
        } catch (Exception e) {
            return false; // 예외 발생 시 false 반환
        }
    }

    // 사용자 ID 중복 검사
    public boolean isUsernameTaken(String user_id) {
        Integer count = userDao.existsByUsername(user_id); // DB에서 ID 중복 여부 확인
        return count != null && count > 0; // 중복 시 true 반환
    }

    // 사용자 닉네임 중복 검사
    public boolean isNicknameTaken(String user_nickname) {
        Integer count = userDao.existsByNickname(user_nickname); // DB에서 닉네임 중복 여부 확인
        return count != null && count > 0; // 중복 시 true 반환
    }

    // 사용자 이메일 중복 검사
    public boolean isEmailTaken(String user_email) {
        Integer count = userDao.existsByEmail(user_email); // DB에서 이메일 중복 여부 확인
        return count != null && count > 0; // 중복 시 true 반환
    }

    // 비밀번호 재설정 이메일 전송
    public void sendResetPasswordEmail(String email) {
        List<UserDto> users = userDao.getUsersByEmail(email); // 이메일로 사용자 목록 조회

        for (UserDto user : users) {
            String token = generateRandomToken(); // 랜덤 토큰 생성
            String resetLink = "http://localhost:9002/whale/reset-password?token=" + token; // 비밀번호 재설정 링크 생성
            userDao.saveResetToken(user.getUser_id(), token); // 토큰 저장

            // 이메일 메시지 생성
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(user.getUser_email());
            message.setSubject("Whale 계정 비밀번호 재설정");
            message.setText("안녕하세요, " + user.getUser_id() + "님,\n\n"
                    + "비밀번호를 재설정하려면 아래 링크를 클릭하세요:\n" + resetLink
                    + "\n\n만약 이 요청을 본인이 한 것이 아니라면, 이 메일을 무시해 주세요."
                    + "\n\n감사합니다.\nWhale 팀");
            message.setFrom("Music Whale Support <" + System.getenv("EMAIL_USER") + ">");

            try {
                mailSender.send(message); // 이메일 전송
                System.out.println("비밀번호 재설정 이메일이 성공적으로 전송되었습니다.");
            } catch (Exception e) {
                e.printStackTrace(); // 전송 실패 시 에러 출력
                System.out.println("이메일 전송에 실패했습니다.");
            }
        }
    }

    // 비밀번호 재설정 토큰 검증
    public boolean verifyResetToken(String token) {
        Integer count = userDao.isValidToken(token); // DB에서 토큰 유효성 확인
        return count != null && count > 0; // 유효할 경우 true 반환
    }

    // 비밀번호 업데이트
    public void updatePassword(String token, String newPassword) {
        String hashedPassword = passwordEncoder.encode(newPassword); // 새 비밀번호 암호화
        userDao.updatePasswordByToken(hashedPassword, token); // DB에서 비밀번호 업데이트
    }

    // 랜덤 토큰 생성
    private String generateRandomToken() {
        return UUID.randomUUID().toString(); // UUID를 이용해 랜덤 토큰 생성
    }

    // 사용자 상태 조회
    public Integer getUserStatusService(String userId) {
        return userDao.getUserStatus(userId); // 사용자 상태 코드 반환
    }

    // 사용자 정지 기간 조회
    public Date getUserEndDateService(String userId) {
        return userDao.getUserEndDate(userId); // 정지 해제 날짜 반환
    }

    // 팔로우 로직 공통화
    private void addFollow(String followerId, String followeeId) {
        String currentFollowees;
        try {
            currentFollowees = sqlSession.selectOne("com.tech.whale.login.dao.UserDao.getFollowUserIds", followerId); // 현재 팔로우 목록 조회
        } catch (EmptyResultDataAccessException e) {
            currentFollowees = null; // 조회 결과 없음
        }

        if (currentFollowees == null || currentFollowees.isEmpty()) {
            // 팔로우 목록이 없으면 바로 추가
            sqlSession.update("com.tech.whale.login.dao.UserDao.insertFollowUser",
                    Map.of("followerId", followerId, "followeeId", followeeId));
        } else if (!currentFollowees.contains(followeeId)) {
            // 팔로우 목록에 해당 ID가 없으면 추가
            String updatedFollowees = currentFollowees + "," + followeeId;
            sqlSession.update("com.tech.whale.login.dao.UserDao.updateFollowUserIds",
                    Map.of("followerId", followerId, "updatedFollowees", updatedFollowees));
        }
    }

    // 새 유저가 WHALE을 팔로우
    public void followAdmin(String followerId, String followeeId) {
        addFollow(followerId, followeeId); // 공통 메서드 호출
    }

    // WHALE 계정이 새 유저를 팔로우
    public void followUser(String followerId, String followeeId) {
        addFollow(followerId, followeeId); // 공통 메서드 호출
    }
}
