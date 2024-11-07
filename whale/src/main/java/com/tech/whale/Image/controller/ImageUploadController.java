package com.tech.whale.Image.controller;

import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
public class ImageUploadController {

    private final Storage storage = StorageOptions.getDefaultInstance().getService();
    private final String BUCKET_NAME = "whale_project";

    @PostMapping("/uploadImageMessage")
    public ResponseEntity<Map<String, String>> uploadImage(@RequestParam("file") MultipartFile file) throws IOException {
        String fileName = "whale/message/" + System.currentTimeMillis() + "_" + file.getOriginalFilename();
        
        BlobInfo blobInfo = BlobInfo.newBuilder(BUCKET_NAME, fileName).build();
        storage.create(blobInfo, file.getBytes());

        String imageUrl = "https://storage.googleapis.com/" + BUCKET_NAME + "/" + fileName;
        Map<String, String> response = new HashMap<>();
        response.put("imageUrl", imageUrl);
        
        return ResponseEntity.ok(response);
    }
}