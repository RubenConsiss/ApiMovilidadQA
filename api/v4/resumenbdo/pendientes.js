
const db = require("../../../db");
const dbg = false;

exports.buscar_pendientes = (req, res, next) => {
  if (dbg) console.log("[CR:6] Start pendientes buscar_reporte ...");
  if (!db) {
    error = new Error("Conexion a BD no encontrada!");
    error.status = 500;
    return next(error);
  }

  if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
    error = new Error("crplaza o crtienda invalidos!");
    error.status = 400;
    return next(error);
  }

  let entries = [
    req.resumenbdo_plaza,
    req.resumenbdo_tiendas,
    req.fecha_antes,
    req.resumenbdo_fecha_fin,
  ];

  const pendientes_string = "SELECT `xxbdo_pendientes`.`cr_plaza`, \
    `xxbdo_pendientes`.`cr_tienda`, \
    `xxbdo_pendientes`.`id` AS `pendiente_id`, \
    `xxbdo_roles_en_tienda`.`id` AS `encargado_id`, \
    `xxbdo_roles_en_tienda`.`nombre` \
    FROM `xxbdo_pendientes` \
    INNER JOIN `xxbdo_roles_en_tienda` \
    ON `xxbdo_pendientes`.`responsable`= `xxbdo_roles_en_tienda`.`id` \
    WHERE `xxbdo_pendientes`.`cr_plaza`=? \
    AND `xxbdo_pendientes`.`cr_tienda` IN(?) \
    AND `xxbdo_pendientes`.`fecha_compromiso` \
    BETWEEN ? AND ? \
    AND `xxbdo_pendientes`.`fecha_terminacion` IS NULL \
    ORDER BY `xxbdo_pendientes`.`cr_tienda`, `fecha_compromiso`";

  qry = db.query(pendientes_string, entries, (err, rows) => {
    if (dbg) console.log("[42] Get respuestas: ", qry.sql);
    if (err) {
      err.status = 500;
      return next(err);
    }
    let pendientes = formatPendientes(rows);
    req.pendientes_para_dashbaord = formatForDialog(pendientes);

    next();
  });
};

function formatForDialog(pendientes) {
  let tiendas = {};
  for (tienda_key in pendientes) {
    tiendas[tienda_key] = [];
    let arrePendientes = [];
    let lista_pendientes = pendientes[tienda_key];
    for (pendiente_key in lista_pendientes) {
      let pendiente = lista_pendientes[pendiente_key];
      let primeraParte = `${pendiente.nombre} no ha realizado `;
      if (pendiente.total == 1) {
        pendiente.text = `${primeraParte}${pendiente.total} actividad de la lista de pendientes`;
      } else {
        pendiente.text = `${primeraParte}${pendiente.total} actividades de la lista de pendientes`;
      }

      arrePendientes.push(pendiente);
    }
    tiendas[tienda_key] = arrePendientes;
  }
  return tiendas;
}

function formatPendientes(rows) {
  let pendientesOrdenados = {};
  if (rows) {
    if (rows.length > 0) {
      rows.forEach((row) => {
        if (pendientesOrdenados[row.cr_tienda]) {
          if (pendientesOrdenados[row.cr_tienda][row.encargado_id]) {
            total = pendientesOrdenados[row.cr_tienda][row.encargado_id].total;
            total = total + 1;
            pendientesOrdenados[row.cr_tienda][row.encargado_id] = {
              total,
              nombre: row.nombre,
            };
          } else {
            pendientesOrdenados[row.cr_tienda][row.encargado_id] = {
              total: 1,
              nombre: row.nombre,
            };
          }
        } else {
          pendientesOrdenados[row.cr_tienda] = {};
          pendientesOrdenados[row.cr_tienda][row.encargado_id] = {
            total: 1,
            nombre: row.nombre,
          };
        }
      });
    }
  }
  return pendientesOrdenados;
}
