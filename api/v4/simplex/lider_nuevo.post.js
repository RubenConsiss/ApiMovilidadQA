const db = require("./../../../db")
const moment = require("moment");
const table = "xxbdo_checklist_lider_nuevo";

exports.simplex_lider_nuevo_post = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  const input = req.body?.input || null;

  if (!input || !input.length > 0) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Campo input es requerido" })
  }

  const today = moment();
  const year = today.format("YYYY")
  const todayParsed = today.format("YYYY-MM-DD");
  const ranges = bdoDates.getWeekAndYearFromDate(todayParsed);
  let qryUpdate = `UPDATE ${table} SET checks=? WHERE id=?`
  let qrySelect = `SELECT anio, semana_del_anio, checks FROM ${table} WHERE id=?`
  let results;

  for (let i = 0; i < input.length; i++) {
    if (!input[i]?.id) {
      return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Se ha perdido el campo id" })
    }

    if (!input[i]?.checks || input[i]?.checks.length == 0) {
      return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "No hay checks por actualizar" })
    }

    results = await executeQuery(qrySelect, [input[i]?.id])

    if (results.length) {
      if (String(ranges[0]).padStart(2, '0') == results[0].semana_del_anio && year == results[0].anio) {
        results = JSON.parse(results[0].checks)
        const checkAux = input[i]?.checks.map((check, idx) => {
          return {
            ...check,
            indicaciones: check?.nombre == "enfoque" ? check?.indicaciones : null,
            valores_del_check: check.valores_del_check.map((valorCheck, idxAux) => {
              return {
                "fecha": results[idx].valores_del_check[idxAux].fecha,
                "estatus": valorCheck.fecha == todayParsed ? valorCheck?.estatus : results[idx].valores_del_check[idxAux]?.estatus
              }
            })
          }
        })

        results = await executeQuery(qryUpdate, [JSON.stringify(checkAux), input[i]?.id])
      }
    }
  }

  return res.status(200).send({
    status: true,
    statusMessange: "Ok",
    data: []
  })
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