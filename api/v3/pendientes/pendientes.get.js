
const app_configuration = require('config');
const db = require("./../../../db");
const bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

  exports.pendientes_get = (req, res, next) => {
    if(!db) {
      const error = new Error('Conexion a BD no encontrada!');
      error.status = 500;
      return next(error);
    }
    
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
    const error = new Error('crplaza o crtienda invalidos!');
    error.status = 400;
    return next(error);
    }
    
    let crplaza = req.tokenData.crplaza;
    let crtienda = req.tokenData.crtienda;
    let valor = req.params.valor || null; //req.tokenData.fecha;
    let sql = null; 
    let entries = null;
    let results = null;
    let pendientes_rango_listado_en_dias = req.pendientes_rango_listado_en_dias || 0;
    let roles_en_tienda = req.pendientes_roles_en_tienda || null;
    let fecha_actual = req.tokenData.fecha;
    let historico = false;
    
    if(valor) {
      req.checkParams('valor')
      .withMessage('valor Invalido!')
      .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)
      .trim();
      historico = true;
      if(valor==req.tokenData.fecha) {
        historico = false;
      }
    } else {
      valor = req.tokenData.fecha;
    }

    errors = req.validationErrors();
    if (errors) {
        error = new Error('Datos de entrada invalidos!');
        error.status = 400;
        return next(error);
    }
    if(dbg) console.log("[44] valor = " + valor);
    
    if(bdoDates.isDateGreatherThanCurrent(valor)) {
      const error  = new Error('Fecha de respuesta ' + 
                     valor +
                     ' es mayor que la fecha actual!');
      error.status = 400;
      return next(error);
    }

  // TO DO:

  // TO FIX:
  // 1. Al obtener pendientes se deben mostrar pendientes 
  //    de la fecha en curso a 7 dias atras y tambien los pendientes 
  //    de fechas posteriores a la fecha en curso. 
  //
  // 2. De los 7 dias anteriores se deben mostrar los pendientes 
  //    y los que esten en Done
  if(historico) {
    entries = [crplaza, crtienda, valor, pendientes_rango_listado_en_dias, valor];
    sql="SELECT `xxbdo_pendientes`.id, \
    DATE(`xxbdo_pendientes`.fecha_creacion) as fecha_registro, \
    (SELECT `xxbdo_roles_en_tienda`.nombre FROM `xxbdo_roles_en_tienda` WHERE `xxbdo_pendientes`.registrado_por=`xxbdo_roles_en_tienda`.id) AS asignado_por, \
    (SELECT `xxbdo_roles_en_tienda`.nombre FROM `xxbdo_roles_en_tienda` WHERE `xxbdo_pendientes`.responsable=`xxbdo_roles_en_tienda`.id) AS asignado_a, \
    `xxbdo_pendientes`.fecha_compromiso, \
    IF(`xxbdo_pendientes`.fecha_terminacion, DATE(`xxbdo_pendientes`.fecha_terminacion), NULL) AS fecha_terminacion, \
    IF(`xxbdo_pendientes`.fecha_terminacion, DATE_FORMAT(`xxbdo_pendientes`.fecha_terminacion, '%H:%i'), NULL) AS hora_terminacion, \
    `xxbdo_pendientes`.descripcion as pendiente, \
    IF(`xxbdo_pendientes`.fecha_terminacion, true, false) AS completado \
    FROM `xxbdo_pendientes` \
    WHERE `xxbdo_pendientes`.cr_plaza=? \
    AND `xxbdo_pendientes`.cr_tienda=? \
    AND DATE(`xxbdo_pendientes`.`fecha_terminacion`) \
    BETWEEN DATE_SUB(?, INTERVAL ? DAY ) AND ? \
    AND `xxbdo_pendientes`.`fecha_terminacion` IS NOT NULL \
    AND `xxbdo_pendientes`.activo=1 \
    ORDER BY xxbdo_pendientes.fecha_terminacion DESC, \
    xxbdo_pendientes.fecha_compromiso DESC";
  } else {
    entries = [crplaza, crtienda, crplaza, crtienda, valor, pendientes_rango_listado_en_dias, valor];
    sql="SELECT * FROM \
    (SELECT `xxbdo_pendientes`.id, \
    DATE(`xxbdo_pendientes`.fecha_creacion) as fecha_registro, \
    (SELECT `xxbdo_roles_en_tienda`.nombre FROM `xxbdo_roles_en_tienda` WHERE `xxbdo_pendientes`.registrado_por=`xxbdo_roles_en_tienda`.id) AS asignado_por, \
    (SELECT `xxbdo_roles_en_tienda`.nombre FROM `xxbdo_roles_en_tienda` WHERE `xxbdo_pendientes`.responsable=`xxbdo_roles_en_tienda`.id) AS asignado_a, \
    `xxbdo_pendientes`.fecha_compromiso, \
    IF(`xxbdo_pendientes`.fecha_terminacion, DATE(`xxbdo_pendientes`.fecha_terminacion), NULL) AS fecha_terminacion, \
    IF(`xxbdo_pendientes`.fecha_terminacion, DATE_FORMAT(`xxbdo_pendientes`.fecha_terminacion, '%H:%i'), NULL) AS hora_terminacion, \
    `xxbdo_pendientes`.descripcion as pendiente, \
    IF(`xxbdo_pendientes`.fecha_terminacion, true, false) AS completado \
    FROM `xxbdo_pendientes` \
    WHERE `xxbdo_pendientes`.cr_plaza=? \
    AND `xxbdo_pendientes`.cr_tienda=? \
    AND `xxbdo_pendientes`.`fecha_terminacion` IS NULL \
    AND `xxbdo_pendientes`.activo=1 \
    UNION \
    SELECT `xxbdo_pendientes`.id, \
    DATE(`xxbdo_pendientes`.fecha_creacion) as fecha_registro, \
    (SELECT `xxbdo_roles_en_tienda`.nombre FROM `xxbdo_roles_en_tienda` WHERE `xxbdo_pendientes`.registrado_por=`xxbdo_roles_en_tienda`.id) AS asignado_por, \
    (SELECT `xxbdo_roles_en_tienda`.nombre FROM `xxbdo_roles_en_tienda` WHERE `xxbdo_pendientes`.responsable=`xxbdo_roles_en_tienda`.id) AS asignado_a, \
    `xxbdo_pendientes`.fecha_compromiso, \
    IF(`xxbdo_pendientes`.fecha_terminacion, DATE(`xxbdo_pendientes`.fecha_terminacion), NULL) AS fecha_terminacion, \
    IF(`xxbdo_pendientes`.fecha_terminacion, DATE_FORMAT(`xxbdo_pendientes`.fecha_terminacion, '%H:%i'), NULL) AS hora_terminacion, \
    `xxbdo_pendientes`.descripcion as pendiente, \
    IF(`xxbdo_pendientes`.fecha_terminacion, true, false) AS completado \
    FROM `xxbdo_pendientes` \
    WHERE `xxbdo_pendientes`.cr_plaza=? \
    AND `xxbdo_pendientes`.cr_tienda=? \
    AND DATE(`xxbdo_pendientes`.`fecha_terminacion`) \
    BETWEEN DATE_SUB(?, INTERVAL ? DAY ) AND ? \
    AND `xxbdo_pendientes`.`fecha_terminacion` IS NOT NULL \
    AND `xxbdo_pendientes`.activo=1 \
    ) AS tbl_pendientes \
    ORDER BY tbl_pendientes.completado ASC, \
    tbl_pendientes.fecha_terminacion DESC, \
    tbl_pendientes.fecha_compromiso DESC";
  }

    qry = db.query(sql, entries, (err, result) => {
        if(dbg) console.log("[126] " + qry.sql);
        if (err) {
        err.status = 500;
        return next(err);
        }

        results = formatResults(result, fecha_actual, valor, roles_en_tienda);

        if(!results) {

          let fecha_consulta_formateada = bdoDates.getBDOFormattedDate(valor, "es", "dddd[,] D MMMM YYYY");

          results = {
            "dt":fecha_actual,
            "sl":valor,
            "fsl":fecha_consulta_formateada,
            "roles":req.pendientes_roles_en_tienda,
            "pdts":null
           };
        }

        res.status(200).json(results);
    });
};
    
    function formatResults(rows, fecha_actual, fecha_consulta, roles_en_tienda) {
        if(rows) {
          let results = null;
          let fecha_compromiso = null;
          let fecha_terminacion = null;
          let fecha_registro = null;
          if(rows.length>0) {
              let pendientes=[];
              rows.forEach(row => {
                fecha_compromiso = bdoDates.getBDOFormattedDate(row.fecha_compromiso, "es", "D MMM YYYY");
                fecha_terminacion = bdoDates.getBDOFormattedDate(row.fecha_terminacion, "es", "D MMM YYYY");
                fecha_registro = bdoDates.getBDOFormattedDate(row.fecha_compromiso, "es", "dddd[,] D MMMM YYYY");
                  res = {
                    "id":row.id,
                    "idn":(row.completado ? true : false),
                    "asga":row.asignado_a,
                    "accn":row.pendiente,
                    "fcc":fecha_compromiso,
                    "fct":(row.completado ? fecha_terminacion+' - '+row.hora_terminacion+' Hrs' : "-"),
                    "fcr":fecha_registro,
                    "pap":row.asignado_por
                   },

                  pendientes.push(res);
              });

              let fecha_consulta_formateada = bdoDates.getBDOFormattedDate(fecha_consulta, "es", "dddd[,] D MMMM YYYY");
              results = {
                "dt":fecha_actual,
                 "sl":fecha_consulta,
                 "fsl":fecha_consulta_formateada,
                 "roles":roles_en_tienda,
                 "pdts":pendientes
                };

            return results;
            };
          }

          return;
        }