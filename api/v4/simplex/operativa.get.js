const db = require("./../../../db")
const bdoDates = require("../../helpers/bdo-dates");
const { template } = require("./utils/operativa.template")
const moment = require("moment");

const table = "xxbdo_checklist_operativo";

exports.simplex_operativa_get = async (req, res, next) => {
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

  const elemento = req.query.elemento || null;
  const errors = req.validationErrors();

  if (errors) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: errors })
  }

  const { anio, mes } = req.params;
  let monthWeeksRange = bdoDates.getBDOWeeksRangesForDevice(anio, mes);

  let qrySelect = `SELECT * FROM ${table} WHERE mes=? AND anio=? AND crplaza=? AND crtienda=?`
  let queryFilter = [mes, anio, crplaza, crtienda]

  if (elemento) {
    qrySelect += ` AND elemento IN(?)`
    queryFilter.push(elemento.split(','))
  }

  const currentMonth = moment().format("MM")
  const currentYear = moment().format("YYYY")
  const current = moment()

  // if (anio != currentYear || mes > currentMonth) {
  //   return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Rango no válido" })
  // }

  try {
    let result = await executeQuery(qrySelect, queryFilter);

    if (!result.length) {
      let qryInsert = `INSERT INTO ${table} (elemento, anio, mes, checks, descripcion, crplaza, crtienda) VALUES ?`
      const inputValues = template(monthWeeksRange.semanas).map(row => [row.elemento, anio, mes, JSON.stringify(row.checks), row.descripcion, crplaza, crtienda])

      result = await executeQuery(qryInsert, [inputValues])
      if (result?.affectedRows) {
        result = await executeQuery(qrySelect, queryFilter);
      }
    }

    let loop = 0;

    while (loop < monthWeeksRange.semanas.length) {
      let totalChecksChecked = 0;
      let totalChecks = 0;

      for (let i = 0; i < result.length; i++) {

        const checks = JSON.parse(result[i].checks);

        for (let j = 0; j < checks.length; j++) {
          totalChecksChecked = checks[j].valores_del_check[loop] == true ? totalChecksChecked + 1 : totalChecksChecked + 0;
          totalChecks += 1
        }
      }

      monthWeeksRange.semanas[loop].checkeds = `${totalChecksChecked}/${totalChecks}`

      loop += 1;

    }

    result.push({
      "id": -1,
      "elemento": "todos",
      "descripcion": "",
      "mes": "",
      "anio": "",
      "checks": "[]"
    })

    return res.status(200).send({
      status: true,
      statusMessange: "Ok",
      data: { monthWeeks: monthWeeksRange, data: formatResponse(monthWeeksRange, result) }
    })

  } catch (err) {
    err.status = 500;
    return next(err);
  }
}

function formatResponse(monthWeeksRange, rows) {
  let rowsParsed = []
  for (let i = 0; i < rows.length; i++) {
    rowsParsed = [...rowsParsed, {
      id: rows[i].id,
      elemento: rows[i].elemento,
      descripcion: rows[i].descripcion,
      mes: rows[i].mes,
      anio: rows[i].anio,
      checks: JSON.parse(rows[i].checks).map(check => {
        let newCheck = {
          ...check,
          indicaciones: [],
          valores_del_check: check.valores_del_check.map(valor => {
            return {
              ...valor,
              isChecked: valor.estatus === null ? false : true
            }
          })
        }

        if (check.nombre == "enfoque") {
          let indicaciones = []
          if (check?.indicaciones?.length > 0) {
            if (typeof check?.indicaciones == "string") {
              indicaciones = monthWeeksRange?.semanas?.map((v, i) => {
                return {
                  "nombre_de_la_semana": v?.nombre_de_la_semana,
                  "indicacion": "",
                  "textFieldIsFilled": false
                }
              })
              indicaciones[0].indicacion = check?.indicaciones
              indicaciones[0].textFieldIsFilled = (check?.indicaciones !== null && check?.indicaciones !== "")

            } else {
              indicaciones = check?.indicaciones.map((v, i) => {
                return {
                  ...v,
                  textFieldIsFilled: (v?.indicacion !== null && v?.indicacion !== "")
                }
              })
            }

          } else {
            indicaciones = monthWeeksRange?.semanas?.map((v, i) => {
              return {
                "nombre_de_la_semana": v?.nombre_de_la_semana,
                "indicacion": "",
                "textFieldIsFilled": false
              }
            })
          }

          newCheck = {
            ...newCheck,
            indicaciones
          }
        }

        return newCheck;
      })
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