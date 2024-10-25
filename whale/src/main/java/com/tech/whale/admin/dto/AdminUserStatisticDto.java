package com.tech.whale.admin.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminUserStatisticDto {
	private String USER_ID;
	private String USER_PASSWORD;
	private String USER_NICKNAME;
	private String USER_EMAIL;
	private String USER_IMAGE_URL;
	private int USER_ACCESS_ID;
	private String USER_SPOTIFY_ID;
	
}
