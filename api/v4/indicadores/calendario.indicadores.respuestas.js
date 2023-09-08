
const db = require("./../../../db");
const bdoDates = require("./../../helpers/bdo-dates");
const dbg = false;

exports.indicadores_respuestas = (req, res, next) => {
    if(dbg) console.log("[CIR:9] Start calendario.indicadores_respuestas ...");
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
    let valor = req.params.valor || null;
    if(valor) {
        isGreather = bdoDates.isDateGreatherThanCurrent(valor);
        if(isGreather) {
            valor = bdoDates.getEndOfMonth(fecha_token);
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
      valor =  bdoDates.getEndOfMonth(req.tokenData.fecha);
    }

    errors = req.validationErrors();
    if (errors) {
        error = new Error('Datos de entrada invalidos!');
        error.status = 400;
        return next(error);
    }
    if(dbg) console.log("[CI:64] plaza, tienda, valor, fecha_consulta = ", crplaza, crtienda, valor, fecha_consulta);
    
    let results = null;
    let sql_checklist = "";

    if(ver_checklist_id) {
      sql_checklist = "AND `xxbdo_respuestas_indicadores`.`xxbdo_checklists_id` = '"+ver_checklist_id+"'"; 
    }

    sql="SELECT COUNT(*) as respuestas \
    FROM `xxbdo_respuestas_indicadores`, \
    `xxbdo_areas_estandares`, \
    `xxbdo_areas_estandares_indicadores`, \
    `xxbdo_areas` \
    WHERE `xxbdo_respuestas_indicadores`.`cr_plaza`='"+crplaza+"' \
    AND `xxbdo_respuestas_indicadores`.`cr_tienda`='"+crtienda+"' \
    "+sql_checklist+" \
    AND DATE_FORMAT(`xxbdo_respuestas_indicadores`.`fecha_respuesta`, \"%Y%m\") = DATE_FORMAT('"+fecha_consulta+"', \"%Y%m\") \
    AND `xxbdo_respuestas_indicadores`.`xxbdo_areas_estandares_indicadores_id`= `xxbdo_areas_estandares_indicadores`.`id` \
    AND `xxbdo_areas_estandares_indicadores`.`xxbdo_areas_estandares_id`= `xxbdo_areas_estandares`.`id` \
    AND `xxbdo_areas_estandares`.`xxbdo_areas_id`=`xxbdo_areas`.`id`";
    entries = null;
    qry = db.query(sql, entries, (err, result) => {
     if(dbg) console.log("[CIR:86] ", qry.sql);
    if (err) {
      err.status = 500;
      return next(err);
    }
    
    sql_checklist = "";
    if(ver_checklist_id) {
      sql_checklist = "AND `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`='"+ver_checklist_id+"'";
    }
    if(result[0].respuestas>0) {
      //answers already exists, get from xxbdo_respuestas_indicadores
      if(dbg) console.log("[CI:102] Respuestas found: ", qry.sql);
    
        es_current = "IF(DATE_FORMAT(`xxbdo_respuestas_indicadores`.`fecha_respuesta`, '%Y%m')=DATE_FORMAT('"+fecha_token+"', '%Y%m'), true, false)";

        sql = "SELECT `xxbdo_respuestas_indicadores`.`id` AS `xxbdo_respuestas_indicadores_id`, \
      `xxbdo_respuestas_indicadores`.`xxbdo_checklists_id`, \
      `xxbdo_checklists_tiendas`.`titulo`, \
      `xxbdo_checklists_tiendas`.`titulo_indicadores_app`, \
      `xxbdo_respuestas_indicadores`.`xxbdo_areas_estandares_indicadores_id`, \
      `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
      `xxbdo_areas`.`titulo` AS `area_titulo`, \
      `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
      `xxbdo_estandares`.`estandar` AS `estandar`, \
      `xxbdo_estandares`.`titulo` AS `std_titulo`, \
      `xxbdo_estandares`.`detalle`, \
      `xxbdo_respuestas_indicadores`.`meta`, \
      `xxbdo_respuestas_indicadores`.`respuesta`, \
      `xxbdo_indicadores`.`id` AS `xxbdo_indicadores_id`, \
      `xxbdo_indicadores`.`titulo` AS `indicadores_titulo`, \
      `xxbdo_indicadores`.`xxbdo_indicadores_frecuencias_id`, \
      `xxbdo_indicadores`.`tipo`, \
      `xxbdo_indicadores`.`tipo_dato`, \
      `xxbdo_indicadores`.`default`, \
      "+es_current+" AS is_current \
      FROM `xxbdo_respuestas_indicadores`, \
      `xxbdo_areas_estandares`, \
      `xxbdo_areas_estandares_indicadores`, \
      `xxbdo_areas`, \
      `xxbdo_estandares`, \
      `xxbdo_checklists_tiendas`, \
      `xxbdo_indicadores` \
      WHERE `xxbdo_respuestas_indicadores`.`cr_plaza`='"+crplaza+"' \
      AND `xxbdo_respuestas_indicadores`.`cr_tienda`='"+crtienda+"' \
      AND DATE_FORMAT(`xxbdo_respuestas_indicadores`.`fecha_respuesta`, \"%Y%m\")=DATE_FORMAT('"+fecha_consulta+"', \"%Y%m\") \
      AND `xxbdo_respuestas_indicadores`.`xxbdo_areas_estandares_indicadores_id`=`xxbdo_areas_estandares_indicadores`.`id` \
      AND `xxbdo_areas_estandares_indicadores`.`xxbdo_areas_estandares_id`=`xxbdo_areas_estandares`.`id` \
      AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
      AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
      "+sql_checklist+"  \
      AND `xxbdo_checklists_tiendas`.`cr_plaza`='"+crplaza+"' \
      AND `xxbdo_checklists_tiendas`.`cr_tienda`='"+crtienda+"' \
      AND `xxbdo_respuestas_indicadores`.`xxbdo_checklists_id`=`xxbdo_checklists_tiendas`.`xxbdo_checklists_id` \
      AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists_tiendas`.`xxbdo_version_estandares_id` \
      AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists_tiendas`.`xxbdo_version_estandares_id` \
      AND `xxbdo_areas_estandares_indicadores`.`xxbdo_indicadores_id` = `xxbdo_indicadores`.`id` \
      AND `xxbdo_areas`.`activo`=1 \
      AND `xxbdo_estandares`.`activo`=1 \
      AND `xxbdo_estandares`.`es_visible`=1 \
      AND `xxbdo_checklists_tiendas`.`activo`=1 \
      ORDER BY `xxbdo_areas`.`orden`, \
      `xxbdo_areas_estandares_indicadores`.`orden`";
    }
    
    qry = db.query(sql, null, (err, rows) => {
      if(dbg) console.log("[CIR:152] ", qry.sql);
      if(err) {
          err.status = 500;
          return next(err);
      }
      
      results = formatResults(rows);
      req.resIndicadoresRespuestas = results;
      next();
    });
    });
}
    
function formatResults(rows) {
  if(rows) {
    let respuestas = {};
    if(rows.length>0) {
        rows.forEach(row => {
          if(!respuestas[row.xxbdo_areas_estandares_indicadores_id]) {
              respuestas[row.xxbdo_areas_estandares_indicadores_id] = {
                  "rid":row.xxbdo_respuestas_indicadores_id, 
                  "res":row.respuesta
              };
            }
        });
    }
    return respuestas;
  }
  return;
}
