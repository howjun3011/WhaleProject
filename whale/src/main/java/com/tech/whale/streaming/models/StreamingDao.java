package com.tech.whale.streaming.models;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface StreamingDao {
	public Integer selectTrackId(String trackSpotifyId);
	public Integer selectTrackLikeId(String userId, Integer trackId);
	public TrackDto selectTrackDto(String trackId);
	public void insertTrack(String track_artist, String track_name, String track_album, String track_cover, String track_spotify_id);
	public void insertTrackLike(Integer trackId, String userId);
	public void insertTrackCnt(Integer trackId, String userId);
	public void deleteTrackLike(Integer trackLikeId);
}
