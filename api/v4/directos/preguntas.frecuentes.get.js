const db = require("../../../db")
const moment = require("moment");

const table = "xxbdo_directos_preguntas_frecuentes";

exports.main = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  if (!req?.tokenData?.crplaza || !req?.tokenData?.crtienda) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "crplaza o crtienda invalidos" })
  }

  let qrySelect = `SELECT id, titulo, info FROM ${table} WHERE estatus = 1`

  try {
    let result = await executeQuery(qrySelect, []);

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