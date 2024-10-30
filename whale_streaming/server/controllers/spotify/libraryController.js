const userLibraries = require('../../models/spotify/users/getUserLibraries');

async function libraryController(req,res) {
    const results = await userLibraries.getUserLibraries(req,res);
    return results;
}

module.exports = {
    libraryController
}