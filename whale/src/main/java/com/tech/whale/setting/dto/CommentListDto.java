package com.tech.whale.setting.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class CommentListDto {
	private int post_id;
	private int community_id;
	private String post_title;
	private String post_comments_text;
	private String post_tag_text;
	
	private int feed_id;
	private String feed_img_name;
	private String feed_comments_text;
}
