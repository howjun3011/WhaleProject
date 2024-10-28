package com.tech.whale.admin.dto;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminAdInfoDto {
	private int post_id;
	private String user_id;
	
	private int ADVERTISER_ID;
	private String USER_ID;
	private Date ADVERTISER_ACCESS_DATE;
	private String ADVERTISER_NAME;
	private int ACCESS_ID;
	
	private int AD_ID;
	private int AD_GROUP_ID;
	private String AD_NAME;
	private String AD_CONTENT;
	private String AD_IMAGE_URL;
	private String AD_LINK;
	private String AD_STATE;
	private Date AD_START;
	private Date AD_END;
	private Date AD_UPDATE;
	private Date AD_REQUEST;
	private int AD_BID;
	private Date AD_PAY_DATE;
	private String AD_PAY_CONDITION;
}
