const db = require("../../../db");
const dbg = false;

exports.historial = (req, res, next) => {
   console.log("[5] Start resumenbdo respuestas ...");
    if(!db) {
        error = new Error('Conexion a BD no encontrada!');
        error.status = 500;
        return next(error);
    }
    
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        error = new Error('crplaza o crtienda invalidos!');
        error.status = 400;
        return next(error);
    }

    if (!req.resumenbdo_plaza || !req.resumenbdo_tiendas) {
        error = new Error('Plaza y lista de tiendas es requerido!');
        error.status = 400;
        return next(error);
    }

    if (!req.resumenbdo_fecha_inicio || !req.resumenbdo_fecha_fin) {
        error = new Error('Fecha de inicio y fin de resumen semanal BDO es requerido!');
        error.status = 400;
        return next(error);
    }

    if (!req.resumenbdo_matriz_tiendas) {
        error = new Error('Matriz de resumen semanal BDO es requerida!');
        error.status = 400;
        return next(error);
    }

    let entries = [
        req.resumenbdo_plaza,
        req.resumenbdo_tiendas,
        req.checklist_id,
        req.fecha_consulta_inicio,
        req.fecha_consulta_fin,
        "D" // TODO - Get this from global config variable
    ];

    stmt = "SELECT `xxbdo_respuestas`.`cr_plaza`, \
    `xxbdo_respuestas`.`cr_tienda`, \
    `xxbdo_respuestas`.`xxbdo_areas_estandares_id`, \
    `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
    `xxbdo_respuestas`.`fecha_respuesta`, \
    `xxbdo_estandares`.`id` AS  'estandar_id', \
    `xxbdo_estandares`.`titulo`, \
    IF(`xxbdo_respuestas`.`respuesta` IN('T','P','A'), \
     1, \
     IF(`xxbdo_respuestas`.`respuesta`='K', \
     IFNULL((SELECT 1 \
        FROM `xxbdo_circulo_de_congruencia` \
        WHERE `xxbdo_respuestas_id`= `xxbdo_respuestas`.`id` \
        LIMIT 1),0), \
     0) \
    ) AS es_falla \
    FROM `xxbdo_respuestas` \
    INNER JOIN  `xxbdo_areas_estandares` ON  `xxbdo_respuestas`.`xxbdo_areas_estandares_id` = `xxbdo_areas_estandares`.id \
    INNER JOIN  `xxbdo_estandares` ON  `xxbdo_areas_estandares`.`xxbdo_estandares_id` = `xxbdo_estandares`.id \
    WHERE `xxbdo_respuestas`.`cr_plaza`=? \
    AND `xxbdo_respuestas`.`cr_tienda` IN(?) \
    AND xxbdo_checklists_id=? \
    AND `xxbdo_respuestas`.`fecha_respuesta` \
    BETWEEN '2021-09-01' AND '2021-12-06' \
    AND `xxbdo_respuestas`.`tipo`='D' \
    AND `xxbdo_respuestas`.`activo`=1 \
    ORDER BY `xxbdo_respuestas`.`cr_tienda`, `xxbdo_respuestas`.`fecha_respuesta` limit 100";
    
    qry = db.query(stmt, entries, (err, rows) => {
         console.log("[74] Get respuestas: ", qry.sql);
        if (err) {
          err.status = 500;
          return next(err);
        }
    
        const {
          historial_fallas,
          historial_alertas,
        } = getFallasPorPlazaTiendaFecha(rows);
      
        req.resumenbdo_historial_fallas = historial_fallas;
        req.resumenbdo_historial_alertas = historial_alertas;
        req.reglas_estandares_alertas = purgarReglas(
          req.reglas_estandares_alertas,
          historial_alertas
        );
        next();
      });
};

function getFallasPorPlazaTiendaFecha(rows) {
    let historial_fallas = {};
    let historial_alertas = {};
  
    if (rows) {
      if (rows.length > 0) {
        let mapa_fallas = {};
        let index = 0;
        rows.forEach((row, index, arre) => {

          
          es_falla = row.es_falla;
          rkey = row.cr_plaza + "*" + row.cr_tienda + "*" + row.fecha_respuesta;
          alertasKey =
            row.cr_plaza +
            "*" +
            row.cr_tienda +
            "*" +
            row.fecha_respuesta +
            "*" +
            row.estandar_id;
  
          if (!historial_alertas[alertasKey]) {
            historial_alertas[alertasKey] = {
              cr_plaza:row.cr_plaza,
              cr_tienda:row.cr_tienda,
              xxbdo_areas_estandares_id:row.xxbdo_areas_estandares_id,
              fecha_respuesta:row.fecha_respuesta,
              estandar_id:row.estandar_id,
              titulo:row.titulo,
              es_falla:row.es_falla,
            };
          }
  
          if (!historial_fallas[rkey]) {
            historial_fallas[rkey] = es_falla;
          } else {
            historial_fallas[rkey] += es_falla;
          }
        });
      }
    }
    return { historial_fallas, historial_alertas };
  }
  
  function purgarReglas(reglas, historialAlertas) {
    let newReglas = {};
    for (regla_key in reglas) {
      for (historial_key in historialAlertas) {
        if (String(historial_key).includes(regla_key)) {
          if (!newReglas[regla_key]) {
            newReglas[regla_key] = reglas[regla_key];
          }
        }
      }
    }
  
    return newReglas;
  }
