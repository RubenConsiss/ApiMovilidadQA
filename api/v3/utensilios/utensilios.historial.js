
const db = require("../../../db");
const dbg = false;

exports.detalle_utensilios = (req, res, next) => {
    if(dbg) console.log("[CR:6] Start utensilios historial ...");
    if(!db) {
        error = new Error('Conexion a BD no encontrada!');
        error.status=500;
        return next(error);
    }
    
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        error  = new Error('crplaza o crtienda invalidos!');
        error.status = 400;
        return next(error);
    }

    if (!req.calendario_utensilios_inicio || !req.calendario_utensilios_fin) {
        error  = new Error('Rango de fechas para vista de calendario de utensilios no encontrada!');
        error.status = 400;
        return next(error);
    }

    let entries = [
        req.calendario_utensilios_inicio,
        req.calendario_utensilios_fin
    ];

    stmt="SELECT `xxbdo_utensilios_id` AS `uid`, \
    `fecha_inicio`, \
    `fecha_fin` \
    FROM `xxbdo_utensilios_desactivados` \
    WHERE (fecha_inicio BETWEEN ? AND ?) \
    OR (fecha_fin IS NULL) \
    AND `activo`=1 \
    ORDER BY `xxbdo_utensilios_desactivados`.`fecha_inicio` ASC";
    
    qry=db.query(stmt, entries, (err, rows) => {
        if(dbg) console.log("[27] Get historial de utensilios: ", qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }

        utensilios_historial = formatResults(rows);
        req.utensilios_historial = utensilios_historial;

        next();
      });
};

function formatResults(rows) {
      if(rows) {
        let historial_utensilios = {};
        if(rows.length>0) {
            rows.forEach(row => {
                rkey = row.uid+"*"+(row.fecha_fin ? row.fecha_fin : "");
                historial_utensilios[rkey] = (row.fecha_fin ? row.fecha_fin : row.fecha_inicio);
            });
        }
        return historial_utensilios;
      }
      return;
      }