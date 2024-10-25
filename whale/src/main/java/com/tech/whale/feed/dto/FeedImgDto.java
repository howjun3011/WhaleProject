package com.tech.whale.feed.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class FeedImgDto {
    private int feed_img_id;
    private int feed_id;
    private String feed_img_url;
    private String feed_img_type;
    private String feed_img_name;
}
