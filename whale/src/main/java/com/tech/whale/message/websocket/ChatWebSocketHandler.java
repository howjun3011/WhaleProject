package com.tech.whale.message.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.tech.whale.Image.controller.LinkPreviewUtils;
import com.tech.whale.message.dao.MessageDao;
import com.tech.whale.message.dto.MessageDto;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.io.IOException;
import java.text.SimpleDateFormat;
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

    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        try {
            String payload = message.getPayload();
            String[] parts = payload.split(":", 4);
            if (parts.length < 4) {
                System.err.println("Invalid message format: " + payload);
                return;
            }

            String roomId = parts[0];
            String userId = parts[1];
            String messageType = parts[2];
            String messageContent = parts[3];

            MessageDto messageDto = new MessageDto();
            messageDto.setMessage_room_id(roomId);
            messageDto.setUser_id(userId);
            messageDto.setMessage_create_date(new Date());
            messageDto.setMessage_type(messageType);

            if ("TEXT".equals(messageType) && containsUrl(messageContent)) {
                messageType = "LINK";
                String url = extractUrl(messageContent);
                
                if (url.contains("youtube.com") || url.contains("youtu.be")) {
                    String embedHtml = fetchYouTubeEmbedHtml(url);
                    messageDto.setMessage_text(embedHtml);
                    System.out.println("YouTube embed HTML created: " + embedHtml);
                } else {
                    Map<String, String> previewData = LinkPreviewUtils.fetchOpenGraphData(url);
                    
                    // 미리보기 데이터 확인
                    if (previewData != null && !previewData.isEmpty()) {
                        ObjectMapper mapper = new ObjectMapper();
                        String previewJson = mapper.writeValueAsString(previewData);
                        messageDto.setMessage_text(messageContent + "#preview=" + previewJson);
                        System.out.println("Preview data created for URL " + url + ": " + previewJson);
                    } else {
                        System.out.println("No preview data available for URL: " + url);
                    }
                }
            } else if ("IMAGE".equals(messageType)) {
                messageDto.setMessage_text(messageContent);
            } else {
                messageDto.setMessage_text(messageContent);
            }

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String formattedDate = dateFormat.format(new Date());

            String formattedMessage = String.format("%s#%s#%s#%s#%d#%s",
                    roomId, userId, messageType, messageDto.getMessage_text(), messageDto.getMessage_read(), formattedDate);

            broadcastToRoom(roomId, new TextMessage(formattedMessage));
            messageDao.saveMessage(messageDto);

        } catch (Exception e) {
            e.printStackTrace();
            session.sendMessage(new TextMessage("Error: " + e.getMessage()));
            session.close(CloseStatus.SERVER_ERROR);
        }
    }

    private boolean containsUrl(String text) {
        return text.contains("http://") || text.contains("https://");
    }

    private String extractUrl(String text) {
        String urlRegex = "(https?://[\\w\\-]+(\\.[\\w\\-]+)+[/#?]?.*)";
        Pattern pattern = Pattern.compile(urlRegex);
        Matcher matcher = pattern.matcher(text);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }

    private String fetchYouTubeEmbedHtml(String url) {
        return "<iframe src=\"https://www.youtube.com/embed/" + extractYouTubeId(url) +
               "\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>";
    }

    private String extractYouTubeId(String url) {
        String pattern = "(?<=watch\\?v=|/videos/|embed/|youtu.be/|/v/|/e/|watch\\?v%3D|watch\\?feature=player_embedded&v=|%2Fvideos%2F|embed%2F|youtu.be%2F|%2Fv%2F)[^#&?\\n]*";
        Pattern compiledPattern = Pattern.compile(pattern);
        Matcher matcher = compiledPattern.matcher(url);
        return matcher.find() ? matcher.group() : "";
    }
    
    private void broadcastToRoom(String roomId, TextMessage message) throws IOException {
        List<WebSocketSession> sessions = roomSessions.get(roomId);
        for (WebSocketSession sess : sessions) {
            if (sess.isOpen()) {
                sess.sendMessage(message);
            }
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