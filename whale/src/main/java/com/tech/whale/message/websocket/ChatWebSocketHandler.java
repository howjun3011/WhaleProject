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
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.Date;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    private final List<WebSocketSession> sessions = new CopyOnWriteArrayList<>();
    private final MessageDao messageDao;

    @Autowired
    public ChatWebSocketHandler(MessageDao messageDao) {
        this.messageDao = messageDao;
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session);
        System.out.println("WebSocket 연결 성공: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
    	System.out.println("메시지 수신: " + message.getPayload());
    	String payload = message.getPayload();
        String[] parts = payload.split(":", 3);
        String roomId = parts[0];
        String userId = parts[1];
        String messageText = parts[2];

        MessageDto messageDto = new MessageDto();
        messageDto.setMessage_room_id(roomId);
        messageDto.setUser_id(userId);
        messageDto.setMessage_text(messageText);
        messageDto.setMessage_create_date(new Date());
        messageDao.saveMessage(messageDto);

        TextMessage broadcastMessage = new TextMessage(payload);
        for (WebSocketSession sess : sessions) {
            sess.sendMessage(broadcastMessage);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        sessions.remove(session);
    }
}