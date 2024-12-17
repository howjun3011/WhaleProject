// 유저의 라이브러리 정보를 요청하는 함수
const fetchSpotify = require('../dao/fetchSpotify');

async function getUserLibraries(req,res) {
    return (await fetchSpotify.fetchWebApi(
        req, `v1/me/playlists`, 'GET'
    ));
}

module.exports = {
    getUserLibraries
}