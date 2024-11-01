package com.tech.whale.streaming.models;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface StreamingDao {
	public String selectTrackId(String trackSpotifyId);
	public Integer selectTrackLikeId(String userId, String trackSpotifyId);
	public TrackDto selectTrackDto(String trackSpotifyId);
	public void insertTrack(String track_spotify_id, String track_artist, String track_name, String track_album, String track_cover);
	public void insertTrackLike(String trackSpotifyId, String userId);
	public void insertTrackCnt(String trackSpotifyId, String userId);
	public void deleteTrackLike(Integer trackLikeId);
}
