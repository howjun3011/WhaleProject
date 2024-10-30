package com.tech.whale.admin.dto;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminAdInfoDto {
	private int post_id;
	
	private int advertiser_id;
	private String user_id;
	private String advertiser_name;
	private int access_id;
	
	private int ad_id;
	private int ad_group_id;
	private String ad_name;
	private String ad_content;
	private String ad_image_url;
	private String ad_link;
	private String ad_state;
	private Date ad_start;
	private Date ad_end;
	private Date ad_update;
	private Date ad_request;
	private int ad_bid;
	private Date ad_pay_date;
	private String ad_pay_condition;
	
	private Date access_log_date;
}
