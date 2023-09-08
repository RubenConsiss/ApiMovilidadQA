
const db = require("./../../../db");
const bdoDates = require("./../../helpers/bdo-dates");
const dbg = false;

  exports.indicadores = (req, res, next) => {
    if(dbg) console.log("[CI:9] Start calendario.indicadores ...");
    if(!db) {
      const error  = new Error('Conexion a BD no encontrada!');
      error.status = 500;
      return next(error);
    }
    
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        const error  = new Error('crplaza o crtienda inválidos!');
        error.status = 400;
        return next(error);
    }
    
    let crplaza = req.tokenData.crplaza;
    let crtienda = req.tokenData.crtienda;
    let fecha_token = req.tokenData.fecha;
    let ver_checklist_id = req.params.checklist_id || null;
    //let tipo_consulta = req.params.tipo_consulta || null;
    let valor = req.params.valor || null;
    if(valor) {
        isGreather = bdoDates.isDateGreatherThanCurrent(valor);
        if(isGreather) {
            valor = fecha_token;
        }
    }
    let fecha_actual = req.tokenData.fecha;
    let fecha_consulta = valor || fecha_actual;
    let sql = null; 
    let entries = null;
    
    if(ver_checklist_id) {
      req.checkParams('checklist_id')
      .isUUID(4)
      .withMessage('Formato de checklist id invalido!')
      .trim();
  }
    
    if(ver_checklist_id) {
      //assign valor to last day of selected version
      valor = req.checklist_fin;
    } else if(valor) {
      req.checkParams('valor')
      .withMessage('valor Invalido!')
      .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)
      .trim();
    } else {
      valor = req.tokenData.fecha;
    }

    errors = req.validationErrors();
    if (errors) {
        error = new Error('Datos de entrada invalidos!');
        error.status = 400;
        return next(error);
    }
    if(dbg) console.log("[CI:62] plaza, tienda, valor, fecha_consulta = ", crplaza, crtienda, valor, fecha_consulta);
    
    let results = null;
    let sql_checklist = "";
    if(ver_checklist_id) {
      sql_checklist = "AND `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`='"+ver_checklist_id+"'";
    }

      //get indicadores from xxbdo_areas_estandares_indicadores
      if(ver_checklist_id) {
        if(dbg) console.log("CI:[72] Search for checklist_id: ", ver_checklist_id);
        sql_checklist = "`xxbdo_checklists_tiendas`.`xxbdo_checklists_id`='"+ver_checklist_id+"'";
        entries = [fecha_consulta, ver_checklist_id, crplaza, crtienda, fecha_actual, 
          fecha_consulta, fecha_actual, crplaza, crtienda, fecha_actual, crplaza, crtienda];
      } else {
        sql_checklist = "`xxbdo_checklists_tiendas`.`xxbdo_checklists_id` = ( \
          SELECT `xxbdo_checklists_id` AS `id` \
          FROM `xxbdo_checklists_tiendas` \
          WHERE `cr_plaza`='"+crplaza+"' \
          AND `cr_tienda`='"+crtienda+"' \
          AND '"+fecha_actual+"' \
          BETWEEN `fecha_inicio` \
          AND IFNULL(`fecha_fin`, '"+fecha_token+"') \
          LIMIT 1 \
      )";
        entries = [fecha_consulta, fecha_actual, crplaza, crtienda, fecha_actual, 
          fecha_consulta, fecha_actual, crplaza, crtienda, fecha_actual, crplaza, crtienda];
      }
      
      es_current = "IF(DATE_FORMAT('"+fecha_consulta+"', '%Y%m')=DATE_FORMAT('"+fecha_token+"', '%Y%m'), true, false)";

      sql_stds = "SELECT NULL AS `xxbdo_respuestas_indicadores_id`, \
      `xxbdo_areas_estandares_indicadores`.`id` AS `xxbdo_areas_estandares_indicadores_id`, \
      `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`, \
      `xxbdo_checklists_tiendas`.`titulo_indicadores_app`, \
      `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
      `xxbdo_areas`.`titulo` AS `area_titulo`, \
      `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
      `xxbdo_estandares`.`estandar` AS `estandar`, \
      `xxbdo_estandares`.`titulo` AS `std_titulo`, \
      `xxbdo_indicadores`.`titulo` AS `indicadores_titulo`, \
      `xxbdo_indicadores`.`descripcion` AS `indicadores_descripcion`, \
      `xxbdo_indicadores`.`xxbdo_indicadores_frecuencias_id`, \
      `xxbdo_indicadores`.`tipo`, \
      `xxbdo_indicadores`.`tipo_dato`, \
      `xxbdo_indicadores`.`default`, \
      `xxbdo_areas`.`orden` AS areas_orden, \
      `xxbdo_areas_estandares_indicadores`.`orden` AS indicadores_orden, \
      '' AS `meta`, \
      '' AS `respuesta`, \
      "+es_current+" AS is_current \
      FROM `xxbdo_checklists_tiendas`, \
      `xxbdo_areas_estandares`, \
      `xxbdo_areas_estandares_indicadores`, \
      `xxbdo_areas`, \
      `xxbdo_estandares`, \
      `xxbdo_indicadores` \
      WHERE "+sql_checklist+" \
      AND `xxbdo_areas_estandares`.`id` IN( \
          SELECT `xxbdo_tiendas_has_areas_estandares`.`xxbdo_areas_estandares_id` \
          FROM `xxbdo_tiendas_has_areas_estandares` \
          WHERE `xxbdo_tiendas_has_areas_estandares`.`cr_plaza`='"+crplaza+"' \
          AND `xxbdo_tiendas_has_areas_estandares`.`cr_tienda`='"+crtienda+"' \
          AND `xxbdo_tiendas_has_areas_estandares`.`xxbdo_checklists_id`= `xxbdo_checklists_tiendas`.`xxbdo_checklists_id` \
          AND `xxbdo_checklists_tiendas`.`cr_plaza`='"+crplaza+"' \
          AND `xxbdo_checklists_tiendas`.`cr_tienda`='"+crtienda+"' \
          AND `xxbdo_tiendas_has_areas_estandares`.`es_visible`=1 \
          AND `xxbdo_tiendas_has_areas_estandares`.`activo`=1 \
      )\
      AND `xxbdo_checklists_tiendas`.`cr_plaza`='"+crplaza+"' \
      AND `xxbdo_checklists_tiendas`.`cr_tienda`='"+crtienda+"' \
      AND `xxbdo_areas_estandares_indicadores`.`xxbdo_areas_estandares_id` = `xxbdo_areas_estandares`.`id` \
      AND `xxbdo_areas_estandares_indicadores`.`xxbdo_indicadores_id` = `xxbdo_indicadores`.`id` \
      AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists_tiendas`.`xxbdo_version_estandares_id` \
      AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists_tiendas`.`xxbdo_version_estandares_id` \
      AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
      AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
      AND FIND_IN_SET((WEEKDAY('"+fecha_consulta+"')+1), `xxbdo_areas_estandares`.`dias_activos`)>0 \
      AND `xxbdo_areas_estandares_indicadores`.`activo` = 1 \
      AND `xxbdo_areas`.`activo`=1 \
      AND `xxbdo_estandares`.`activo`=1 \
      AND `xxbdo_estandares`.`es_visible`=1 \
      AND `xxbdo_checklists_tiendas`.`activo`=1 \
      AND `xxbdo_indicadores`.`activo`=1";
      
      //Select indicadores stds and libres
      sql="SELECT * FROM (\
        "+sql_stds+" \
        AND `xxbdo_indicadores`.`tipo`='I' \
        UNION \
        "+sql_stds+" \
        AND `xxbdo_indicadores`.`cr_plaza`='"+crplaza+"' \
        AND `xxbdo_indicadores`.`cr_tienda`='"+crtienda+"' \
        AND `xxbdo_indicadores`.`tipo`='L' \
        ) tbl_respuestas \
        ORDER BY `tbl_respuestas`.`areas_orden`, \
        `tbl_respuestas`.`indicadores_orden`";
      
    qry = db.query(sql, null, (err, rows) => {
     if(dbg) console.log("[CI:160] ", qry.sql);
    if (err) {
      err.status = 500;
      return next(err);
    }
    
    results = formatResults(rows, req.resIndicadoresRespuestas);
    //res.status(200).json(results);
    req.resIndicadores = results;
    next();
  });
};
    
    function formatResults(rows, respuestas_indicadores) {
        if(rows) {
          let estandares = {};
          if(rows.length>0) {
              let nrow = 0;
              let respuesta_indicador_id = null;
              let respuesta_indicador = null;
              rows.forEach(row => {
                  if(!estandares[row.xxbdo_estandares_id]) {
                    estandares[row.xxbdo_estandares_id] = {"indcs":[]};
                  }

                  nrow++;
                  nrow = (nrow.toString().length<2) ? "0"+nrow : ""+nrow;

                  respuesta_indicador_id = row.xxbdo_respuestas_indicadores_id;
                  respuesta_indicador = row.respuesta;

                  if(respuestas_indicadores) {
                    if(respuestas_indicadores[row.xxbdo_areas_estandares_indicadores_id]) {
                      respuesta_indicador_id = respuestas_indicadores[row.xxbdo_areas_estandares_indicadores_id].rid;
                      respuesta_indicador = respuestas_indicadores[row.xxbdo_areas_estandares_indicadores_id].res;
                    }
                  }

                  res = {
                    //"area":row.area_titulo,
                    "std":row.estandar,
                    "cid":row.xxbdo_checklists_id,
                    "rid":respuesta_indicador_id,
                    "eid":row.xxbdo_estandares_id,
                    "aeid":row.xxbdo_areas_estandares_indicadores_id,
                    "frc":row.xxbdo_indicadores_frecuencias_id,
                    "ord": nrow,
                    "stl": row.std_titulo,
                    "itl":row.indicadores_titulo,
                    "idsc":row.indicadores_descripcion,
                    "tp":row.tipo,
                    "res":respuesta_indicador,
                    "tdd":row.tipo_dato,
                    "dfl":row.default
                  };

                  estandares[row.xxbdo_estandares_id].indcs.push(res);
              });
          }
          return estandares;
        }
        return;
        }
