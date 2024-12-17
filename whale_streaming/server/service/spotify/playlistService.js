// 플레이리스트 정보를 요청하는 서비스
const playlist = require('../../models/spotify/users/getPlaylist');

async function playlistService(req,res) {
    const results = await playlist.getPlaylist(req,res);
    return results;
}

async function followPlaylistService(req,res) {
    await playlist.followPlaylist(req,res);
}

async function unfollowPlaylistService(req,res) {
    await playlist.unfollowPlaylist(req,res);
}

module.exports = {
    playlistService,
    followPlaylistService,
    unfollowPlaylistService
}