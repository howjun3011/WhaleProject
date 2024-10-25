package com.tech.whale.feed.service;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.tech.whale.feed.dao.FeedDao;
import com.tech.whale.feed.dto.FeedDto;
import com.tech.whale.feed.dto.FeedImgDto;

@Service
public class FeedWriteService {
	
	@Autowired
	private FeedDao feedDao;
	
	
	public void registerFeed(FeedDto feedDto, MultipartFile file) throws IOException {
		// TODO Auto-generated method stub
		int feedId = feedDao.getNextFeedId();
		feedDto.setFeed_id(feedId);
		feedDao.insertFeed(feedDto);
		
    	String workPath = System.getProperty("user.dir");

        String uploadDir = workPath + "/src/main/resources/static/images/feed";
        File uploadPath = new File(uploadDir);
        
        if (!uploadPath.exists()) {
            uploadPath.mkdirs();  // 경로가 없으면 생성
        }
		
            if (!file.isEmpty()) {
                // 파일을 서버에 저장
                File saveFile = new File(uploadPath, file.getOriginalFilename());
                file.transferTo(saveFile);  // 파일 저장

                
                FeedImgDto feedImgDto = new FeedImgDto();
                feedImgDto.setFeed_id(feedId);  // 게시물 ID 설정
                feedImgDto.setFeed_img_url(saveFile.getAbsolutePath());  // 파일 절대 경로 설정
                feedImgDto.setFeed_img_type(file.getContentType());  // 파일 MIME 타입 설정
                feedImgDto.setFeed_img_name(file.getOriginalFilename());  // 파일명 설정
                feedDao.insertImage(feedImgDto);  // 이미지 정보 DB에 저장
            }
        
	}

}
