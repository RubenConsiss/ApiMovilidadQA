const moment = require("moment");
const db = require("../../../db")
const bdoDates = require("../../helpers/bdo-dates");

const table = "xxbdo_checklist_pendiente_lider";

exports.simplex_pendiente_lider_get = async (req, res, next) => {
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

  req.checkParams("semana")
    .trim()
    .isNumeric()
    .withMessage('Tipo de dato inválido para el parámetro :semana. Debe representar un valor numérico')

  const year = req.params.anio
  const week = String(req.params.semana).padStart(2, '0')
  const weekRange = bdoDates.formatWeekStartEndDays(week, year)
  const month = moment(weekRange[2]).format("MM")
  const weekDaysRange = bdoDates.getBDOWeekDaysArray(weekRange[2]);

  let qrySelect = `SELECT * FROM ${table} WHERE anio=? AND semana_del_anio=? AND crplaza=? AND crtienda=?`
  let results = await executeQuery(qrySelect, [year, week, crplaza, crtienda]);

  if (!results.length) {
    const qryInsert = `INSERT INTO ${table} (anio, mes, momento_wow, semana_del_anio, checks, crplaza, crtienda) VALUES(?)`
    let checks = weekDaysRange.map((day) => {
      return {
        "fecha": day,
        "pendientes": []
      }
    })

    const query = [year, month, "", week, JSON.stringify(checks), crplaza, crtienda]
    results = await executeQuery(qryInsert, [query]);
    if (results?.affectedRows) {
      results = await executeQuery(qrySelect, [year, week, crplaza, crtienda]);
    }
  }

  return res.status(200).send({
    status: true,
    statusMessange: "Ok",
    rangos: weekRange,
    data: formatResponse(results)
  })
}

function formatResponse(rows) {
  let rowsParsed = []
  let count = 0
  if (rows.length) {
    rowsParsed = rows.map(row => {
      return {
        ...row,
        checks: JSON.parse(row.checks).map(check => {
          let pendientes = []

          for (let index = 0; index < check.pendientes.length; index++) {
            if ('lider' in check.pendientes[index] &&
              'comentarios' in check.pendientes[index] &&
              'estatus' in check.pendientes[index] &&
              'responsable' in check.pendientes[index] &&
              'solicitante' in check.pendientes[index]
            ) {
              pendientes.push({
                ...check.pendientes[index],
                id: count += 1
              })
            } else {
              pendientes = []
              break;
            }
          }

          return {
            ...check,
            pendientes: pendientes
          }
        })
      }
    })
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