package com.tech.whale.streaming.models;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface StreamingDao {
	public Integer selectTrackId(String trackSpotifyId);
	public TrackDto selectTrackDto(String trackSpotifyId);
	public void insertTrack(String track_artist, String track_name, String track_album, String track_cover, String track_spotify_id);
}
