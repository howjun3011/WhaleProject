package com.tech.whale.Image.controller;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class LinkPreviewUtils {
    public static Map<String, String> fetchOpenGraphData(String url) {
        Map<String, String> metaData = new HashMap<>();
        try {
            Document doc = Jsoup.connect(url).get();
            metaData.put("title", doc.select("meta[property=og:title]").attr("content"));
            metaData.put("description", doc.select("meta[property=og:description]").attr("content"));
            metaData.put("image", doc.select("meta[property=og:image]").attr("content"));
            metaData.put("url", url);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return metaData;
    }
    
    public static String fetchYouTubeEmbedHtml(String url) {
        String oEmbedUrl = "https://www.youtube.com/oembed?url=" + url + "&format=json";
        try {
            Document doc = Jsoup.connect(oEmbedUrl).ignoreContentType(true).get();
            String embedHtml = doc.select("html").text();
            return embedHtml;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}