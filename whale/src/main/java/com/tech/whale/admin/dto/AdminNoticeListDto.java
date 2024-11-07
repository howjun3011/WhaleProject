package com.tech.whale.admin.dto;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminNoticeListDto {
	private int notice_id;
	private int notice_group;
	private String notice_title;
	private int admin_id;
	private String notice_text;
	private Date notice_date;
	private int notice_status;
	private int notice_cnt;
	private Date notice_update;
	private String notice_name;
}
