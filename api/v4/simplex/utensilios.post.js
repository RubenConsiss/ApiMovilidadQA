const db = require("../../../db")
const moment = require("moment");
const uuidv4 = require('uuid/v4');
const table = "xxbdo_checklist_respuestas_utensilios";

exports.simplex_utensilios_post = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  if (!req?.tokenData?.crplaza || !req?.tokenData?.crtienda) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "crplaza o crtienda invalidos" })
  }

  const { crplaza, crtienda, usuario } = req.tokenData;
  const input = req.body?.input;

  if (!input) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Campo Input es requerido" })
  }

  const current = moment()
  const day = current.date();

  // if (day > 7) {
  //   return res.status(200).json({ status: false, statusMessange: "Forbidden Request", message: "La fecha actual no permite ingresar nuevos datos" })
  // }

  const currentMonth = current.format("MM")
  const currentYear = current.format("YYYY")

  let qryInsert = `INSERT INTO ${table} (id, mes, año, cr_plaza, cr_tienda, fecha_respuesta, xxbdo_utensilios_id, respuesta, folio, usuario) VALUES(?)`
  let qryUpdate = `UPDATE ${table} SET respuesta=?, folio=? WHERE id=?`
  let qrySelect = `SELECT * FROM ${table} WHERE xxbdo_utensilios_id=? AND cr_plaza=? AND cr_tienda=? AND mes=? AND año=?`
  try {
    for (let index = 0; index < input.length; index++) {
      const { id, respuesta_id, folio, respuesta } = input[index];
      const results = await executeQuery(qrySelect, [id, crplaza, crtienda, currentMonth, currentYear]);
      if (results.length && respuesta_id) {
        if (results[0].año == currentYear && String(results[0].mes).padStart(2, '0') == String(currentMonth).padStart(2, '0')) {
          await executeQuery(qryUpdate, [respuesta, folio, respuesta_id])
        }
      } else {
        const uuid_respuesta = uuidv4();
        await executeQuery(qryInsert, [[uuid_respuesta, currentMonth, currentYear, crplaza, crtienda, current.format("YYYY-MM-DD"), id, respuesta, folio, usuario]])
      }
    }

    return res.status(200).send({
      status: true,
      statusMessange: "Ok",
      data: []
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