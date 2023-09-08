const moment = require("moment");
const db = require("../../../db")
const bdoDates = require("../../helpers/bdo-dates");

const table = "xxbdo_checklist_pendiente_asesor";

exports.simplex_pendiente_asesor_post = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  const input = req.body?.input || null;

  if (!input) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Campo input es requerido" })
  }

  const today = moment();
  const year = today.format("YYYY")
  const todayParsed = today.format("YYYY-MM-DD");
  const ranges = bdoDates.getWeekAndYearFromDate(todayParsed);

  let qryUpdate = `UPDATE ${table} SET checks=? WHERE id=?`
  let qrySelect = `SELECT anio, semana_del_anio, checks FROM ${table} WHERE id=?`

  if (!input?.id) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Se ha perdido el campo id" })
  }

  if (!input?.checks || input?.checks.length == 0) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "No hay checks por actualizar" })
  }

  const { id, checks } = input;
  let results = await executeQuery(qrySelect, [id])
  if (results.length) {
    const currentWeek = Number(String(ranges[0]).padStart(2, '0'));
    const incomingWeek = Number(results[0].semana_del_anio);
    const operation = currentWeek - incomingWeek;
    if (operation <= 4 && year == results[0].anio) {
      results = JSON.parse(results[0].checks)
      const checkAux = checks.map((check, idx) => {
        let pendientes = []
        if (check.fecha == todayParsed) {
          pendientes = check.pendientes
        } else {
          pendientes = check.pendientes.map((p, idxChild) => {
            return {
              ...results[idx].pendientes[idxChild],
              status: p.status
            }
          })
        }

        //const pendientes = check.fecha == todayParsed ? check.pendientes : results[idx].pendientes

        return {
          "fecha": results[idx].fecha,
          "pendientes": pendientes,
        }
      })

      await executeQuery(qryUpdate, [JSON.stringify(checkAux), id])
    }
  }

  return res.status(200).send({
    status: true,
    statusMessange: "Ok",
    data: null
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