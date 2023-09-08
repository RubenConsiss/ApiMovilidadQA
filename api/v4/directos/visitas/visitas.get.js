const db = require("../../../../db")
const { READ_QUERY } = require('./queries')

exports.main = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  if (!req?.tokenData?.crplaza || !req?.tokenData?.crtienda) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "crplaza o crtienda invalidos" })
  }

  try {
    let result = await executeQuery(READ_QUERY, []);

    return res.status(200).send({
      status: true,
      statusMessange: "Ok",
      count: result.length,
      data: result
    })

  } catch (err) {
    err.status = 500;
    return next(err);
  }
}

async function executeQuery(stament, query) {
  return new Promise((resolve, reject) => {
    db.query(stament, query, (err, rows) => {
      if (err) {
        reject(err);
      }
      resolve(rows);
    })
  })
}