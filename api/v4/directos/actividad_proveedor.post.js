const db = require("../../../db")
const moment = require("moment");

const table = "xxbdo_directos_actividad_proveedor";

exports.directos_actividad_proveedor = async (req, res, next) => {
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

  const { startTime, endTime, recordTime, idProveedor, nombreProveedor, idPedido, escenario, totalTasaFis, totalArticulos, totalGeneralVenta, totalCosto } = input;

  if (!startTime || !endTime || !recordTime || !idProveedor || !nombreProveedor || !idPedido || !escenario || !totalTasaFis || !totalArticulos || !totalGeneralVenta, !totalCosto) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Campos extraviados para la petición" })
  }

  const start = moment(startTime)
  const end = moment(endTime)
  const diff = moment.duration(end.diff(start));
  const minutes = diff.asMinutes()

  let qryInsert = `INSERT INTO ${table} (fecha_inicio, fecha_fin, crplaza, crtienda, fecha_registro, id_proveedor, nombre_proveedor, id_pedido, tipo_operacion, total_tasa_fis, total_articulos, total_general_venta, total_costo, diff) VALUES(?)`
  let queryData = [startTime, endTime, crplaza, crtienda, recordTime, idProveedor, nombreProveedor, idPedido, escenario, totalTasaFis, totalArticulos, totalGeneralVenta, totalCosto, minutes]

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