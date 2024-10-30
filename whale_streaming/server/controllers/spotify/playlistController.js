const playlist = require('../../models/spotify/users/getPlaylist');

async function playlistController(req,res) {
    const results = await playlist.getPlaylist(req,res);
    return results;
}

module.exports = {
    playlistController
}