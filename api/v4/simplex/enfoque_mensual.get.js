const db = require("../../../db")
const bdoDates = require("../../helpers/bdo-dates");
const moment = require("moment");

const table = "xxbdo_checklist_enfoque_mensual";

exports.simplex_enfoque_mensual_get = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  if (!req?.tokenData?.crplaza || !req?.tokenData?.crtienda) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "crplaza o crtienda invalidos" })
  }

  const { crplaza, crtienda } = req.tokenData;

  req.checkParams("anio")
    .trim()
    .isNumeric()
    .withMessage('Tipo de dato inválido para el parámetro :anio. Debe representar un valor numérico.')
    .isLength({ min: 4, max: 4 })
    .withMessage('Longitudad inválida para el parámetro :anio. Debe ser longitud de 4.')

  req.checkParams("mes")
    .trim()
    .isNumeric()
    .withMessage('Tipo de dato inválido para el parámetro :mes. Debe representar un valor numérico')
    .isLength({ min: 2, max: 2 })
    .withMessage('Longitudad inválida para el parámetro :mes. Debe ser longitud de 2.')

  const { anio, mes } = req.params;

  let qrySelect = `SELECT * FROM ${table} WHERE mes=? AND anio=? AND crplaza=? AND crtienda=?`
  try {

    const results = await executeQuery(qrySelect, [mes, anio, crplaza, crtienda]);

    return res.status(200).send({
      status: true,
      statusMessange: "Ok",
      data: {
        current: {
          mes: mes,
          anio: anio,
          results
        }
      }
    })
  } catch (err) {
    err.status = 500;
    return next(err);
  }
}

function formatResponse(rows) {
  let rowsParsed = []
  for (let i = 0; i < rows.length; i++) {
    rowsParsed = [...rowsParsed, {
      id: rows[i].id,
      elemento: rows[i].elemento,
      descripcion: rows[i].descripcion,
      mes: rows[i].mes,
      anio: rows[i].anio,
      checks: rows[i].checks
    }]
  }

  return rowsParsed;
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