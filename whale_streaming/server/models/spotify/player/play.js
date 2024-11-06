async function fetchWebApi(req, endpoint, method, body) {
    await fetch(`https://api.spotify.com/${endpoint}`, {
        headers: {
            Authorization: `Bearer ${req.session.accessToken}`,
            'Content-Type': 'application/json',
        },
        method,
        body:JSON.stringify(body)
    });
}

async function play(req,res){
    await fetchWebApi(
        req, `v1/me/player/play?device_id=${ req.query.device_id }`, 'PUT', { "context_uri": `${ req.query.uri }` }
    );
}

async function playTrack(req,res){
    await fetchWebApi(
        req, `v1/me/player/play?device_id=${ req.query.device_id }`, 'PUT', { "uris": [ `${ req.query.uri }` ] }
    );
}

async function playTracks(req,res){
    await fetchWebApi(
        req, `v1/me/player/play?device_id=${ req.body.device_id }`, 'PUT', { "uris": req.body.uri }
    );
}

module.exports = {
    play,
    playTrack,
    playTracks
}