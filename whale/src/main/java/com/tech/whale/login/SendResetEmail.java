package com.tech.whale.login;

// Spring Framework에서 제공하는 클래스와 어노테이션을 임포트
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

//비밀번호 재설정 이메일을 발송하는 서비스 클래스
@Service // Spring의 Service 어노테이션으로, 이 클래스가 비즈니스 로직을 담당하는 서비스임을 나타냄
public class SendResetEmail {

    // 이메일을 전송하기 위해 JavaMailSender를 주입받음
    @Autowired // Spring의 의존성 주입 어노테이션으로, mailSender를 자동으로 설정
    private JavaMailSender mailSender;

//     비밀번호 재설정 이메일을 발송하는 메서드
//     @param to        수신자의 이메일 주소
//     @param resetLink 비밀번호 재설정을 위한 링크

    public void sendResetEmail(String to, String resetLink) {
        // SimpleMailMessage 객체를 생성하여 이메일의 내용을 구성
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to); // 수신자의 이메일 주소 설정
        message.setSubject("비밀번호 재설정 링크"); // 이메일 제목 설정
        message.setText("비밀번호 재설정을 위해 다음 링크를 클릭하세요: " + resetLink); // 이메일 본문 설정

        // JavaMailSender를 사용하여 이메일 발송
        mailSender.send(message);
    }
}
