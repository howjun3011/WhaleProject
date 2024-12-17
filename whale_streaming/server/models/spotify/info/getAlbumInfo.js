// 앨범 정보를 요청하는 함수
const fetchSpotify = require('../dao/fetchSpotify');

async function getAlbumInfo(req,res) {
    return (await fetchSpotify.fetchWebApi(
        req, `v1/albums/${ req.query.id }`, 'GET'
    ));
}

module.exports = {
    getAlbumInfo
}