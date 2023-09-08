const db = require("../../../db")
const moment = require("moment");

const table = "xxbdo_checklist_enfoque_mensual";

exports.simplex_enfoque_mensual_post = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  if (!req?.tokenData?.crplaza || !req?.tokenData?.crtienda) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "crplaza o crtienda invalidos" })
  }

  const { crplaza, crtienda } = req.tokenData;
  const input = req.body?.input;

  if (!input) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Campo Input es requerido" })
  }

  const { enfoque, actividad_en_tienda, responsable, indicador_de_medicion, actual, objetivo, status } = input;

  if (!enfoque || !actividad_en_tienda || !responsable || !indicador_de_medicion || !actual || !objetivo) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Campos extraviados para la petición" })
  }

  const current = moment()
  const day = current.date();

  // if (day > 7) {
  //   return res.status(200).json({ status: false, statusMessange: "Forbidden Request", message: "La fecha actual no permite ingresar nuevos datos" })
  // }

  const currentMonth = current.format("MM")
  const currentYear = current.format("YYYY")

  let qryInsert = `INSERT INTO ${table} (mes, anio, crplaza, crtienda, enfoque, actividad_en_tienda, responsable, indicador_de_medicion, actual, objetivo, status) VALUES(?)`
  let queryData = [currentMonth, currentYear, crplaza, crtienda, enfoque, actividad_en_tienda, responsable, indicador_de_medicion, actual, objetivo, status]

  try {

    let result = await executeQuery(qryInsert, [queryData]);

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