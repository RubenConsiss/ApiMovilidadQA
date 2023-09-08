const db = require("../../../db")
const bdoDates = require("../../helpers/bdo-dates");
const moment = require("moment");

const table = "xxbdo_checklist_enfoque_mensual";

exports.simplex_enfoque_mensual_delete = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  if (!req?.tokenData?.crplaza || !req?.tokenData?.crtienda) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "crplaza o crtienda invalidos" })
  }

  const body = req.body || null;
  const id = body?.id || null;

  if (!body || !id) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Campos perdidos" })
  }

  const current = moment()
  const day = current.date();

  // if (day > 7) {
  //   return res.status(200).json({ status: false, statusMessange: "Forbidden Request", message: "La fecha actual no permite ingresar nuevos datos" })
  // }

  const currentMonth = current.format("MM")
  const currentYear = current.format("YYYY")

  try {
    let qrySelect = `SELECT mes, anio FROM ${table} WHERE id=?`
    let [result] = await executeQuery(qrySelect, [id]);

    if (!result) return res.status(200).json({ status: false, statusMessange: "Not Found", message: "No hay registros con ese ID" })

    if (result.mes != currentMonth || result.anio != currentYear) {
      return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Fuera de rango para eliminar" })
    }

    let qryUpdate = `DELETE FROM ${table} WHERE id=?`
    let queryData = [id]

    result = await executeQuery(qryUpdate, queryData);

    return res.status(200).send({
      status: true,
      statusMessange: "Ok",
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