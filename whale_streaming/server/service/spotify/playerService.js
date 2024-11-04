const play = require('../../models/spotify/player/play');

async function playerService(req,res) {
    console.log(req.query.uri);
    if (req.query.uri.substring(8,13) === 'track') {await play.playTrack(req,res);}
    else {await play.play(req,res);}
}

module.exports = {
    playerService
}