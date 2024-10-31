const play = require('../../models/spotify/player/play');

async function playerController(req,res) {
    if (req.query.uri.substring(8,12) === 'play') {await play.play(req,res);}
    else {await play.playTrack(req,res);}
}

module.exports = {
    playerController
}