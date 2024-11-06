package com.tech.whale.message.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import com.tech.whale.message.dao.MessageDao;
import com.tech.whale.message.dto.MessageDto;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.Date;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    // roomId별로 WebSocketSession 목록을 관리
    private final Map<String, List<WebSocketSession>> roomSessions = new ConcurrentHashMap<>();
    private final MessageDao messageDao;

    @Autowired
    public ChatWebSocketHandler(MessageDao messageDao) {
        this.messageDao = messageDao;
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        // roomId를 세션 URL에서 가져옵니다.
        String roomId = getRoomIdFromSession(session);
        if (roomId != null) {
            session.getAttributes().put("roomId", roomId); // session에 roomId 저장

            // roomId에 해당하는 세션 목록에 추가
            roomSessions.computeIfAbsent(roomId, k -> new CopyOnWriteArrayList<>()).add(session);
            System.out.println("WebSocket 연결 성공: " + session.getId() + " | Room ID: " + roomId);
        } else {
            System.out.println("Room ID 없음으로 세션 거부: " + session.getId());
            session.close(CloseStatus.BAD_DATA);
        }
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        try {
            System.out.println("메시지 수신: " + message.getPayload());
            String payload = message.getPayload();
            String[] parts = payload.split(":", 3);
            if (parts.length < 3) {
                System.err.println("Invalid message format: " + payload);
                return;
            }
            String roomId = parts[0];
            String userId = parts[1];
            String messageText = parts[2];

            if (messageText == null || messageText.isEmpty()) {
                System.err.println("Message text is null or empty.");
                return;
            }

            // 메시지 저장
            MessageDto messageDto = new MessageDto();
            messageDto.setMessage_room_id(roomId);
            messageDto.setUser_id(userId);
            messageDto.setMessage_text(messageText);
            messageDto.setMessage_create_date(new Date());
            messageDao.saveMessage(messageDto);

            // 같은 roomId의 세션에만 메시지 브로드캐스트
            TextMessage broadcastMessage = new TextMessage(payload);
            List<WebSocketSession> sessions = roomSessions.get(roomId);
            if (sessions != null) {
                for (WebSocketSession sess : sessions) {
                    if (sess.isOpen()) {
                        sess.sendMessage(broadcastMessage);
                        System.out.println("메시지 전송: " + sess.getId());
                    } else {
                        System.out.println("세션이 닫혀 있습니다: " + sess.getId());
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("메시지 처리 중 에러 발생: " + e.getMessage());
            e.printStackTrace();
            session.sendMessage(new TextMessage("Error: " + e.getMessage()));
            session.close(CloseStatus.SERVER_ERROR);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        // 세션을 종료할 때 roomId에 해당하는 세션 목록에서 제거
        String roomId = (String) session.getAttributes().get("roomId");
        if (roomId != null) {
            List<WebSocketSession> sessions = roomSessions.get(roomId);
            if (sessions != null) {
                sessions.remove(session);
                if (sessions.isEmpty()) {
                    roomSessions.remove(roomId);
                }
            }
        }
        System.out.println("WebSocket 연결 종료: " + session.getId() + " | Room ID: " + roomId);
    }

    private String getRoomIdFromSession(WebSocketSession session) {
        // 쿼리에서 roomId 추출 예: /chat?roomId=1 형태일 경우 사용
        String query = session.getUri().getQuery();
        if (query != null && query.startsWith("roomId=")) {
            return query.split("=")[1];
        }
        return null;
    }
}