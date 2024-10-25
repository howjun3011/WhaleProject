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
	private String post_title;
	private String post_comments_text;
}
