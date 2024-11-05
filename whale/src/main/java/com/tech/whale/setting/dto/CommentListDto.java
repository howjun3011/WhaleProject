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
	private int community_id;
	private int post_id;
	private String post_tag_text;
	private String post_writer_id;
	private String post_writer_img;
	private String post_title;
	private String post_text;
	private String comments_user_img;
	private String comments_user_id;
	private String post_comments_text;
	private String post_img_name;

	private int feed_id;
	private String feed_img_name;
	private String feed_text;
	private String feed_owner_image;
	private String feed_owner_id;
	private int feed_comments_id;
	private Integer parent_comments_id;
	private String commenter_image;
	private String commenter_id;
	private String feed_comments_text;
	private String latest_comment_date;

	private int re_feed_id;
	private int re_feed_comments_id;
	private String re_parent_comments_id;
	private String re_commenter_image;
	private String re_commenter_id;
	private String re_feed_comments_text;
	private String feed_comments_date;
	private String parent_user_image;
	private String parent_user_id;
	private String parent_feed_comments_text;



}
