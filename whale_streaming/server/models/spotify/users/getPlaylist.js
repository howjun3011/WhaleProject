const fetchSpotify = require('../dao/fetchSpotify');

async function getPlaylist(req,res) {
    return (await fetchSpotify.fetchWebApi(
        req, `v1/playlists/${ req.query.id }`, 'GET'
    ));
}

module.exports = {
    getPlaylist
}