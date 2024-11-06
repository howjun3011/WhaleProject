package com.tech.whale.message.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class ChatListDto {
    private String user_nickname;
    private String user_image_url;
    private Integer unread_message_count;
    private Integer minutes_since_last_message;
    private String last_message_text;
    private String time_difference;


}
