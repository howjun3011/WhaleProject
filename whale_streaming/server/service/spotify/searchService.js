// 검색 정보를 요청하는 서비스
const search = require('../../models/spotify/search/search');

async function searchService(req,res) {
    const results = await search.search(req,res);
    return results;
}

module.exports = {
    searchService
}