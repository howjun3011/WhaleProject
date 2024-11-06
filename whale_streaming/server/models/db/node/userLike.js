// oracleDB 설치
const { oracledb, dbConfig } = require("./oracledb");

async function getLikeCountInfo(req,res) {
    let connection;
    let cnt;
    try {
      connection = await oracledb.getConnection(dbConfig);

      const result = await connection.execute(
        `SELECT COUNT(*) AS CNT FROM TRACK_LIKE WHERE USER_ID = :userId`,
        {
          userId: req.session.user_id,
        },
        { outFormat: oracledb.OUT_FORMAT_OBJECT }
      );

      cnt = await result;
    } catch (err) {
      console.error('오라클 디비 에러 발생:', err);
      res.status(500).send('서버 에러가 발생했습니다.');
    } finally {
      if (connection) {
        try {
          await connection.close();
        } catch (err) {
          console.error(err);
        }
      }
    }
    
    return cnt.rows[0];
}

async function getLikeInfo(req,res) {
    let connection;
    let rst;
    try {
      connection = await oracledb.getConnection(dbConfig);

      const result = await connection.execute(
        `SELECT
            T.TRACK_ID AS TRACKID,
            T.TRACK_ARTIST AS ARTISTNAME,
            T.TRACK_NAME AS TRACKNAME,
            T.TRACK_ALBUM AS ALBUMNAME,
            T.TRACK_COVER AS TRACKCOVER,
            TL.TRACK_LIKE_DATE AS LIKEDATE
         FROM
            TRACK_LIKE TL
                LEFT JOIN TRACK T ON T.TRACK_ID = TL.TRACK_ID
         WHERE TL.USER_ID = :userId
         ORDER BY
            TL.TRACK_LIKE_DATE DESC`,
        {
          userId: req.session.user_id,
        },
        { outFormat: oracledb.OUT_FORMAT_OBJECT }
      );

      rst = await result;
    } catch (err) {
      console.error('오라클 디비 에러 발생:', err);
      res.status(500).send('서버 에러가 발생했습니다.');
    } finally {
      if (connection) {
        try {
          await connection.close();
        } catch (err) {
          console.error(err);
        }
      }
    }
    
    return rst.rows;
}

async function getLikeTrackInfo(req,res) {
  let connection;
  let cnt;
  try {
    connection = await oracledb.getConnection(dbConfig);

    const result = await connection.execute(
      `SELECT COUNT(*) AS CNT FROM TRACK_LIKE WHERE USER_ID = :userId AND TRACK_ID = :trackId`,
      {
        userId: req.session.user_id,
        trackId: req.query.id,
      },
      { outFormat: oracledb.OUT_FORMAT_OBJECT }
    );

    cnt = await result;
  } catch (err) {
    console.error('오라클 디비 에러 발생:', err);
    res.status(500).send('서버 에러가 발생했습니다.');
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (err) {
        console.error(err);
      }
    }
  }
  
  if (cnt.rows[0].CNT > 0) {return true;}
  else {return false;}
}

async function deleteLikeInfo(req,res) {
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);

    await connection.execute(
      `DELETE FROM TRACK_LIKE WHERE USER_ID = :userId AND TRACK_ID = :trackId`,
      {
        userId: req.session.user_id,
        trackId: req.query.id,
      },
      { autoCommit: true }
    );
  } catch (err) {
    console.error('오라클 디비 에러 발생:', err);
    res.status(500).send('서버 에러가 발생했습니다.');
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (err) {
        console.error(err);
      }
    }
  }
}

async function insertLikeInfo(req,res) {
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);

    await connection.execute(
      `INSERT INTO TRACK_LIKE (TRACK_LIKE_ID, TRACK_ID, USER_ID) VALUES
                  (TRACK_LIKE_SEQ.NEXTVAL,
                  :trackId,
                  :userId)`,
      {
        trackId: req.query.id,
        userId: req.session.user_id,
      },
      { autoCommit: true }
    );
  } catch (err) {
    console.error('오라클 디비 에러 발생:', err);
    res.status(500).send('서버 에러가 발생했습니다.');
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (err) {
        console.error(err);
      }
    }
  }
}

module.exports = {
    getLikeCountInfo,
    getLikeInfo,
    getLikeTrackInfo,
    deleteLikeInfo,
    insertLikeInfo
}