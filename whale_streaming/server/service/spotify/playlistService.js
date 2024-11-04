const playlist = require('../../models/spotify/users/getPlaylist');

async function playlistService(req,res) {
    const results = await playlist.getPlaylist(req,res);
    return results;
}

module.exports = {
    playlistService
}