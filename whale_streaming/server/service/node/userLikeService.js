const userLike = require('../../models/db/node/userLike');

async function userLikeCntService(req,res) {
    const results = await userLike.getLikeCountInfo(req,res);
    return results;
}

async function userLikeService(req,res) {
    const results = await userLike.getLikeInfo(req,res);
    return results;
}

async function userLikeTrackService(req,res) {
    const results = await userLike.getLikeTrackInfo(req,res);
    return results;
}

async function userDeleteLikeService(req,res) {
    await userLike.deleteLikeInfo(req,res);
}

async function userInsertLikeService(req,res) {
    await userLike.insertLikeInfo(req,res);
}

module.exports = {
    userLikeCntService,
    userLikeService,
    userLikeTrackService,
    userDeleteLikeService,
    userInsertLikeService
}