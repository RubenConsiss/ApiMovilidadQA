const db = require("../../../db")
const bdoDates = require("../../helpers/bdo-dates");
const { template } = require("./utils/lider_nuevo.template")
const moment = require("moment");

const table = "xxbdo_checklist_lider_nuevo";

exports.simplex_lider_nuevo_get = async (req, res, next) => {
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

  const errors = req.validationErrors();

  if (errors) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: errors })
  }

  const year = req.params.anio
  const week = String(req.params.semana).padStart(2, '0')
  const current = bdoDates.getWeekAndYearFromDate(moment().format("YYYY-MM-DD"));
  const weekRange = bdoDates.formatWeekStartEndDays(week, year)
  const month = moment(weekRange[2]).format("MM")

  const weekDaysRange = bdoDates.getBDOWeekDaysArray(weekRange[2]);

  let qrySelect = `SELECT * FROM ${table} WHERE anio=? AND semana_del_anio=? AND crplaza=? AND crtienda=?`
  let queryFilter = [year, week, crplaza, crtienda]

  try {
    let result = await executeQuery(qrySelect, queryFilter);

    if (!result.length) {
      let checks = weekDaysRange.map((day) => {
        return {
          "fecha": day,
          "estatus": null
        }
      })

      let qryInsert = `INSERT INTO ${table} (elemento, checks, anio, mes, semana_del_anio, descripcion, crplaza, crtienda) VALUES ?`

      /*if (String(current[0]).padStart(2, '0') != week) {
        const inputValues = template(checks).map(row => {
          return {
            id: null,
            elemento: row.elemento,
            checks: row.checks,
            descripcion: row.descripcion
          }
        })

        return res.status(200).send({
          status: true,
          statusMessange: "Ok",
          rangos: weekRange,
          data: inputValues
        })
      }*/

      const inputValues = template(checks).map(row => {
        return [
          row.elemento,
          JSON.stringify(row.checks),
          year,
          month,
          week,
          row.descripcion,
          crplaza,
          crtienda
        ]
      })

      result = await executeQuery(qryInsert, [inputValues])

      if (result?.affectedRows) {
        result = await executeQuery(qrySelect, queryFilter);
      }
    }

    return res.status(200).send({
      status: true,
      statusMessange: "Ok",
      rangos: weekRange,
      data: formatResponse(result)
    })

  } catch (err) {
    err.status = 500;
    return next(err);
  }
}

function formatResponse(rows) {
  let rowsParsed = []
  if (rows.length) {
    rowsParsed = rows.map(row => {
      return {
        id: row.id,
        elemento: row.elemento,
        checks: JSON.parse(row.checks).map(check => {
          let newCheck = {
            ...check,
            valores_del_check: check.valores_del_check.map(valor => {
              return {
                ...valor,
                isChecked: valor.estatus === null ? false : true
              }
            })
          }

          if (check.nombre == "enfoque") {
            newCheck = {
              ...newCheck,
              textFieldIsFilled: (check?.indicaciones !== null && check?.indicaciones !== "")
            }
          }

          return newCheck;
        }),
        descripcion: row.descripcion,
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