// 라이브러리 정보를 요청하는 서비스
const userLibraries = require('../../models/spotify/users/getUserLibraries');

async function libraryService(req,res) {
    const results = await userLibraries.getUserLibraries(req,res);
    return results;
}

module.exports = {
    libraryService
}