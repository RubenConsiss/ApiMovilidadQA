
const app_configuration = require('config');
const db = require("./../../../db");
const fs = require("fs");
const admZip = require("adm-zip");
const bdoDates = require("./../../helpers/bdo-dates");
const dbg = false;

exports.reporte_descargar_get = (req, res, next) => {
  req.checkParams('id')
  .isUUID(4)
  .withMessage('ID Inválido!')
  .trim();

  errors = req.validationErrors();
  if (errors) {
      error = new Error('Reporte ID es inválido!');
      error.status = 400;
      return next(error);
  }

  let archivo_id = req.params.id || null;

  stmt="SELECT `xxbdo_reportes_monitor`.`reporte_nombre`, \
  `xxbdo_reportes`.`tipo` \
  FROM `xxbdo_reportes_monitor`, \
  `xxbdo_reportes` \
  WHERE `xxbdo_reportes_monitor`.`id`=? \
  AND `xxbdo_reportes_monitor`.`xxbdo_reportes_id` = `xxbdo_reportes`.`id` \
  AND `xxbdo_reportes_monitor`.`activo` = 1 \
  AND `xxbdo_reportes`.`es_activo` = 1 \
  AND `xxbdo_reportes`.`activo` = 1";

  entries = [archivo_id];

qry = db.query(stmt, entries, (err, rst) => {
    if(dbg) console.log("[36] ", qry.sql);
    if (err) {
    err.status = 500;
    return next(err);
    }

    let nombre_reporte = rst[0].reporte_nombre;
    let reporte_tipo = rst[0].tipo;
    let nombre_archivo = nombre_reporte + "." + reporte_tipo;
    const reportes_path = app_configuration.get('application.api_reportes_folder');
    let reporte = reportes_path + nombre_archivo;
    let download_name = nombre_reporte + ".zip";
  
    fs.access(reporte, (err) => {
      if (err) {
        error = new Error('Reporte no existe!');
        error.status = 400;
        return next(error);
      } else {

        const zip = new admZip();

        zip.addLocalFile(reporte);
        
        // save file zip in root directory
        zip.writeZip(reportes_path + download_name);

        // code to download zip file 
        res.writeHead(200, {
          "Content-Type": "application/octet-stream",
          "Content-Disposition": "attachment; filename=" + download_name
        });
        fs.createReadStream(reportes_path + download_name).pipe(res);
      }
    });

});
  
};

exports.reportes_get = (req, res, next) => {
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

  stmt="SELECT `id`, \
    `nombre`, \
    `codigo`, \
    `descripcion` \
    FROM `xxbdo_reportes` \
    WHERE `es_activo`=1 \
    AND `activo`=1 \
    ORDER BY `xxbdo_reportes`.`orden` ASC";

  qry = db.query(stmt, null, (err, reportes) => {
      if(dbg) console.log("[66] ", qry.sql);
      if (err) {
      err.status = 500;
      return next(err);
      }

      stmt = "SELECT `id`, \
      `xxbdo_reportes_id` AS `reportes_id`, \
      `reporte_inicio`, \
      DATE_FORMAT(`reporte_inicio`, \"%d/%m/%Y\") AS reporte_fecha_inicio, \
      DATE_FORMAT(`reporte_inicio`, \"%k:%i:%s\") AS reporte_hora_inicio, \
      `reporte_fin`, \
      DATE_FORMAT(`reporte_fin`, \"%d/%m/%Y\") AS reporte_fecha_fin, \
      DATE_FORMAT(`reporte_fin`, \"%k:%i:%s\") AS reporte_hora_fin, \
      `reporte_status`, \
      `reporte_nombre` \
      FROM `xxbdo_reportes_monitor` \
      WHERE `reporte_fin` IS NOT NULL \
      UNION \
      SELECT `id`, \
      `xxbdo_reportes_id` AS `reportes_id`, \
      `reporte_inicio`, \
      DATE_FORMAT(`reporte_inicio`, \"%d/%m/%Y\") AS reporte_fecha_inicio, \
      DATE_FORMAT(`reporte_inicio`, \"%k:%i:%s\") AS reporte_hora_inicio, \
      `reporte_fin`, \
      DATE_FORMAT(`reporte_fin`, \"%d/%m/%Y\") AS reporte_fecha_fin, \
      DATE_FORMAT(`reporte_fin`, \"%k:%i:%s\") AS reporte_hora_fin, \
      `reporte_status`, \
      `reporte_nombre` \
      FROM `xxbdo_reportes_monitor` \
      WHERE `reporte_fin` IS NULL \
      ORDER BY `reporte_status`, \
      `reporte_inicio` DESC, \
      `reporte_fin` DESC";

      qry = db.query(stmt, null, (err, monitor) => {
          if(dbg) console.log("[100] ", qry.sql);
          if (err) {
          err.status = 500;
          return next(err);
          }

          data = formatMonitor(reportes, monitor);

          res.status(200).json(data);
      });
  });
};

function formatReportes(reportes) {
  if(dbg) console.log("Start formatReportes ... ");
    if(reportes) {
      let reportes_data = {};

      if(reportes.length>0) {
          reportes.forEach(row => {
              res = {
                "id":row.id,
                "nombre":row.nombre,
                "codigo":row.codigo,
                "descripcion":row.descripcion,
                "reportes":[]
                };
                reportes_data[row.id] = res;
          });

        return reportes_data;
        };
      }

      return;
    }

function formatRegistros(reportes, monitor) {
  if(dbg) console.log("Start formatRegistros... ", reportes, monitor);
  reportes_data = formatReportes(reportes);
  if(dbg) console.log("reportes_data = ", reportes_data);
  if(reportes_data) {
    if(dbg) console.log("monitor.length = ", monitor.length);
    if(monitor.length>0) {
        monitor.forEach(row => {
          reporte_status = row.reporte_status;
          reporte_status = reporte_status.replace(/_/g, " ");
          data = {
            "id":row.id,
            "fecha_inicio":row.reporte_fecha_inicio,
            "hora_inicio":row.reporte_hora_inicio,
            "fecha_fin":row.reporte_fecha_fin,
            "hora_fin":row.reporte_hora_fin,
            "status":reporte_status,
            "nombre":row.reporte_nombre
          };

          if(dbg) console.log("row.reportes_id = ", row.reportes_id);
          if(reportes_data[row.reportes_id]) {
            reportes_data[row.reportes_id].reportes.push(data);
          }
        });
      }

      return reportes_data;
    }

    return;
}

function formatMonitor(reportes, monitor) {
  if(dbg) console.log("Start formatRegistros... ", reportes, monitor);
  let registros_data = formatRegistros(reportes, monitor);
  if(dbg) console.log("registros_data = ", registros_data);
  let monitor_data = [];
  if(registros_data) {
    cont=0;
    for(row in registros_data) {
      monitor_data.push(registros_data[row]);
      cont++;
    };
  }
  return monitor_data;
}
