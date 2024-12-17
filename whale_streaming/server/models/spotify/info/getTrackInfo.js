// 트랙 정보를 요청하는 함수
const fetchSpotify = require('../dao/fetchSpotify');

async function getTrackInfo(req,res) {
    return (await fetchSpotify.fetchWebApi(
        req, `v1/tracks/${ req.query.id }`, 'GET'
    ));
}

module.exports = {
    getTrackInfo
}