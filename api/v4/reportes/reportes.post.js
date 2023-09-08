
const db = require("./../../../db");
const uuidv4 = require('uuid/v4');
bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

exports.reportes_inicio_post = (req, res, next) => {
    if(dbg) console.log("[9] Start reportes_post...");
    if(!db) {
        const error = new Error('Conexión a BD no encontrada!');
        error.status = 500;
        return next(error);
    }

    req.checkBody('id')
       .isUUID(4)
       .withMessage('Formato de id(UUID4) invalido!')
       .trim();
    
    const errors = req.validationErrors();
    if (errors) {
      if(dbg) console.log(util.inspect(errors, {depth: null}));
      const error = new Error('ID de reporte es inválido!');
      error.status = 400;
      return next(error);
    }
    
    let crplaza = req.tokenData.crplaza;
    let crtienda = req.tokenData.crtienda;
    let xxbdo_reportes_id = req.body.id || null;
    let reporte_parametros = req.body.params || null;
    let ip_address = req.app_client_ip_address;
    let usuario = req.tokenData.usuario;
    let timestamp = bdoDates.getBDOCurrentTimestamp();
    let stmt = null;

    if(!crplaza || !crtienda) {
        const error  = 
            new Error("Información de token inválido!");
        error.status = 400;
        return next(error);
    }
    
    if(xxbdo_reportes_id) {
      entries = [xxbdo_reportes_id];
      stmt = "SELECT COUNT(*) AS `num_processes` \
        FROM `xxbdo_reportes_monitor` \
        WHERE xxbdo_reportes_id=? \
        AND reporte_fin IS NULL";
      qry = db.query(stmt, entries, (err, rst) => {
          if(dbg) console.log("[52] Check if report process is still running: ", qry.sql);
          if (err) {
              err.status = 500;
              return next(err);
          }

          num_processes = rst[0].num_processes;
          if(num_processes>0) {
            const error  = 
            new Error("Reporte en proceso, intenta más tarde.");
            error.status = 400;
            return next(error);
          } else {
              let process_id = uuidv4();
              reporte_parametros = (
                  reporte_parametros ? 
                  JSON.stringify(reporte_parametros) : 
                  null
              );
              stmt = "INSERT INTO `xxbdo_reportes_monitor` VALUES (?)";
              entries = [
                  process_id, 
                  xxbdo_reportes_id,
                  reporte_parametros,
                  timestamp, //reporte_inicio,
                  null, // reporte_fin,
                  "EN_PROCESO", // reporte_status,
                  1,
                  usuario,
                  ip_address,
                  timestamp,
                  timestamp
              ];
              qry=db.query(stmt, [entries], (err2, rst2) => {
                  if(dbg) console.log("[88] Insert requested process: ", qry.sql);
                  if (err2) {
                      err2.status = 500;
                      return next(err2);
                  }

                  //TO-DO: Ejecutar aquí módulo para ejecutar reporte en child_process

                  res.status(201).json({"id":process_id});
              });
          }
      });
    } else {
        const error  = 
            new Error("Parámetros incompletos para iniciar reporte!");
        error.status = 400;
        return next(error);
    }
};