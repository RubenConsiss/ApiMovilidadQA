const db = require("../../../../db")
const { INSERT_QUERY } = require('./queries')
const { validate } = require('./validation')

exports.main = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  if (!req?.tokenData?.crplaza || !req?.tokenData?.crtienda) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "crplaza o crtienda invalidos" })
  }

  if (!req?.body?.input) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Falta la propiedad input" })
  }

  if (!validate(req.body.input)) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Campos perdidos en el body." })
  }

  const { CrPlaza, CrTienda, DateTime, Supplier, SupplierName, RegistroVisita } = req?.body?.input

  try {
    let result = await executeQuery(INSERT_QUERY, [[CrPlaza, CrTienda, DateTime, SupplierName, Supplier, RegistroVisita]]);

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