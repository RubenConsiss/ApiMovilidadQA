const db = require("../../../db")
const moment = require("moment");

const table = "xxbdo_directos_actividad_proveedor";

exports.directos_actividad_proveedor_get = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  if (!req?.tokenData?.crplaza || !req?.tokenData?.crtienda) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "crplaza o crtienda invalidos" })
  }

  const { crplaza, crtienda } = req.tokenData;

  let qrySelect = `SELECT * FROM ${table} WHERE crplaza=? AND crtienda=?`
  let queryData = [crplaza, crtienda]

  if (req.params?.idProveedor) {
    qrySelect += ' AND id_proveedor=?'
    queryData.push(req.params?.idProveedor)
  }

  try {
    let result = await executeQuery(qrySelect, queryData);

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