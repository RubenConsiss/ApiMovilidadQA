
const app_configuration = require('config'),
db                = require("./../../../db"),
bdoDates          = require("./../../helpers/bdo-dates"),
util              = require('util'),
dbg               = false;

  exports.indicadores_get = (req, res, next) => {
    if(!db) {
      const error  = new Error('Conexion a BD no encontrada!');
      error.status = 500;
      return next(error);
    }
    //
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
    const error  = new Error('crplaza o crtienda invalidos!');
    error.status = 400;
    return next(error);
    }
    //
    let crplaza    = req.tokenData.crplaza,
    crtienda       = req.tokenData.crtienda,
    tipo_consulta  = req.params.tipo_consulta || null,
    valor          = req.params.valor || null,
    fecha_actual   = req.tokenData.fecha,
    fecha_consulta = valor || fecha_actual,
    year           = null,
    sql            = null, 
    entries        = null,
    titulo         = null,
    subtitulo      = null;
    //
    req.checkParams('tipo_consulta')
    .matches(/^$|^[S|M]/)//S:Ind. Semanal, M:Ind.Mensual
    .withMessage('Tipo de consulta invalido!')
    .trim();
    //
    errors = req.validationErrors();
    if (errors) {
      const error = new Error('Tipo de consulta invalido!');
      error.status=400;
      return next(error);
    }
    //
    if(valor) {
      req.checkParams('valor')
      .withMessage('valor Invalido!')
      .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)
      .trim();
      errors = req.validationErrors();
      if (errors) {
          error  = new Error('Valor de fecha invalido! '+valor);
          error.status = 400;
          return next(error);
      }
    } else {
      valor = req.tokenData.fecha;
    }
    if(dbg) console.log("valor = " + valor);
    //
    if(bdoDates.isDateGreatherThanCurrent(valor)) {
      const error  = new Error('Fecha de respuesta ' + 
                     valor +
                     ' es mayor que la fecha actual!');
      error.status = 400;
      return next(error);
    }
    //
    switch(tipo_consulta) {
    case "S"://Ind.Semanal
      [num_week, year] = bdoDates.getWeekAndYearFromDate(valor);
      fmt_valor = num_week;
      if(dbg) console.log("Num week = "+num_week+" , year = "+year);
      isGreather = bdoDates.isWeekGreatherThanCurrent(num_week, year);
      if(isGreather) {
        error  = new Error('Valor de semana es mayor que la actual!');
        error.status = 400;
        return next(error);
      }
      entries   = [crplaza, crtienda, tipo_consulta, num_week, year];
      date_array = bdoDates.formatWeekStartEndDays(num_week, year, 1);
      titulo    = date_array[0];
      subtitulo = date_array[1];
    break;
    case "M"://Ind.Mensual
      num_month = 
          bdoDates.getBDOFormattedDate(
              valor, 
              "es", 
              "M",
              true
          );
          fmt_valor = num_month;
          //
          year = 
          bdoDates.getBDOFormattedDate(
              valor, 
              "es", 
              "YYYY",
              true
          );
          if(dbg) console.log("Num month = "+num_month+" , year = "+year);
          isGreather = bdoDates.isMonthGreatherThanCurrent(num_month, year);
          if(isGreather) {
              error  = new Error('Valor del mes es mayor que el actual!');
              error.status = 400;
              return next(error);
          }
      entries   = [crplaza, crtienda, tipo_consulta, num_month, year];
      var date_array = bdoDates.formatMonthStartEndDays(num_month, year);
      titulo = date_array[1];
      subtitulo = date_array[2];
    break;
    }
    //
    let existe_dia  = false,
     results        = null;
    //1. Buscar si existen respuestas de la fecha/semana/mes seleccionada
    tipo_respuesta = (tipo_consulta=='S' ? "AND semana=?" : "AND mes=?");
    sql="SELECT COUNT(*) as respuestas \
    FROM `xxbdo_respuestas_indicadores`, \
    `xxbdo_areas_estandares`, \
    `xxbdo_areas_estandares_indicadores`, \
    `xxbdo_areas`, \
    `xxbdo_indicadores_frecuencias` \
    WHERE `xxbdo_respuestas_indicadores`.`cr_plaza`=? \
    AND `xxbdo_respuestas_indicadores`.`cr_tienda`=? \
    AND `xxbdo_respuestas_indicadores`.`xxbdo_indicadores_frecuencias_id`=? \
    AND `xxbdo_indicadores_frecuencias`.`id` = `xxbdo_respuestas_indicadores`.`xxbdo_indicadores_frecuencias_id` \
    "+tipo_respuesta+" \
    AND `xxbdo_respuestas_indicadores`.`año`=? \
    AND `xxbdo_respuestas_indicadores`.`xxbdo_areas_estandares_indicadores_id`= `xxbdo_areas_estandares_indicadores`.`id` \
    AND `xxbdo_areas_estandares_indicadores`.`xxbdo_areas_estandares_id`= `xxbdo_areas_estandares`.`id` \
    AND `xxbdo_areas_estandares`.`xxbdo_areas_id`=`xxbdo_areas`.`id`";
    //
    qry=db.query(sql, entries, (err, result) => {
     if(dbg) console.log("[140] "+qry.sql);
    if (err) {
      err.status = 500;
      return next(err);
    }
    //
    if(result[0].respuestas>0) {
      //answers already exists, get from xxbdo_respuestas_indicadores
      existe_dia = true;
      tipo_respuesta = (tipo_consulta=='S' ? "AND `xxbdo_respuestas_indicadores`.`semana`=?" : "AND `xxbdo_respuestas_indicadores`.`mes`=?");
      es_current = (tipo_consulta=='S' ? 
        "IF(YEARWEEK(`xxbdo_respuestas_indicadores`.`fecha_respuesta`, 3)=YEARWEEK(DATE(NOW()), 3), true, false)" : 
        "IF(DATE_FORMAT(`xxbdo_respuestas_indicadores`.`fecha_respuesta`, '%Y%m')=DATE_FORMAT(DATE(NOW()), '%Y%m'), true, false)");
      sql = "SELECT `xxbdo_respuestas_indicadores`.`id` AS `bdo_id`, \
      `xxbdo_checklists`.`titulo`, \
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
      `xxbdo_indicadores`.`tipo`, \
      `xxbdo_indicadores`.`tipo_dato`, \
      `xxbdo_indicadores`.`default`, \
      "+es_current+" AS is_current \
      FROM `xxbdo_respuestas_indicadores`, \
      `xxbdo_areas_estandares`, \
      `xxbdo_areas_estandares_indicadores`, \
      `xxbdo_areas`, \
      `xxbdo_estandares`, \
      `xxbdo_checklists`, \
      `xxbdo_indicadores` \
      WHERE `xxbdo_respuestas_indicadores`.`cr_plaza`=? \
      AND `xxbdo_respuestas_indicadores`.`cr_tienda`=? \
      AND `xxbdo_respuestas_indicadores`.`xxbdo_indicadores_frecuencias_id`=? "+tipo_respuesta+" \
      AND `xxbdo_respuestas_indicadores`.`año`=? \
      AND `xxbdo_respuestas_indicadores`.`xxbdo_areas_estandares_indicadores_id`=`xxbdo_areas_estandares_indicadores`.`id` \
      AND `xxbdo_areas_estandares_indicadores`.`xxbdo_areas_estandares_id`=`xxbdo_areas_estandares`.`id` \
      AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
      AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
      AND `xxbdo_checklists`.`id`=`xxbdo_respuestas_indicadores`.`xxbdo_checklists_id` \
      AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_areas_estandares_indicadores`.`xxbdo_indicadores_id` = `xxbdo_indicadores`.`id` \
      AND `xxbdo_indicadores`.`xxbdo_indicadores_frecuencias_id` = '"+tipo_consulta+"' \
      AND `xxbdo_areas`.`activo`=1 \
      AND `xxbdo_estandares`.`activo`=1 \
      AND `xxbdo_estandares`.`es_visible`=1 \
      AND `xxbdo_checklists`.`activo`=1 \
      ORDER BY `xxbdo_areas`.`orden`, \
      `xxbdo_areas_estandares_indicadores`.`orden`";
    } else {
      //answers does not exists, get indicadores 
      //from xxbdo_areas_estandares_indicadores
      es_current = (tipo_consulta=='S' ? 
      "IF(YEARWEEK(?, 3)=YEARWEEK(DATE(NOW()), 3), true, false)" : 
      "IF(DATE_FORMAT(?, '%Y%m')=DATE_FORMAT(DATE(NOW()), '%Y%m'), true, false)");
      sql_stds = "SELECT `xxbdo_areas_estandares_indicadores`.`id` AS `bdo_id`, \
      `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
      `xxbdo_areas`.`titulo` AS `area_titulo`, \
      `xxbdo_estandares`.`estandar` AS `estandar`, \
      `xxbdo_estandares`.`titulo` AS `std_titulo`, \
      `xxbdo_indicadores`.`titulo` AS `indicadores_titulo`, \
      `xxbdo_indicadores`.`tipo`, \
      `xxbdo_indicadores`.`tipo_dato`, \
      `xxbdo_indicadores`.`default`, \
      `xxbdo_areas`.`orden` AS areas_orden, \
      `xxbdo_areas_estandares_indicadores`.`orden` AS indicadores_orden, \
      '' AS `meta`, \
      '' AS `respuesta`, \
      "+es_current+" AS is_current \
      FROM `xxbdo_checklists`, \
      `xxbdo_areas_estandares`, \
      `xxbdo_areas_estandares_indicadores`, \
      `xxbdo_areas`, \
      `xxbdo_estandares`, \
      `xxbdo_indicadores` \
      WHERE `xxbdo_checklists`.`id` = ( \
          SELECT `id` \
          FROM `xxbdo_checklists` \
          WHERE ? \
          BETWEEN `fecha_inicio` \
          AND IFNULL(`fecha_fin`, DATE(NOW())) \
          LIMIT 1 \
      ) \
      AND `xxbdo_areas_estandares`.`id` IN( \
          SELECT `xxbdo_tiendas_has_areas_estandares`.`xxbdo_areas_estandares_id` \
          FROM `xxbdo_tiendas_has_areas_estandares` \
          WHERE `xxbdo_tiendas_has_areas_estandares`.`cr_plaza`=? \
          AND `xxbdo_tiendas_has_areas_estandares`.`cr_tienda`=? \
          AND `xxbdo_tiendas_has_areas_estandares`.`xxbdo_checklists_id`= `xxbdo_checklists`.`id` \
          AND `xxbdo_tiendas_has_areas_estandares`.`es_visible`=1 \
          AND `xxbdo_tiendas_has_areas_estandares`.`activo`=1 \
      )\
      AND `xxbdo_areas_estandares_indicadores`.`xxbdo_areas_estandares_id` = `xxbdo_areas_estandares`.`id` \
      AND `xxbdo_areas_estandares_indicadores`.`xxbdo_indicadores_id` = `xxbdo_indicadores`.`id` \
      AND `xxbdo_indicadores`.`xxbdo_indicadores_frecuencias_id`=? \
      AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
      AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
      AND FIND_IN_SET((WEEKDAY(?)+1), `xxbdo_areas_estandares`.`dias_activos`)>0 \
      AND `xxbdo_areas_estandares_indicadores`.`activo` = 1 \
      AND `xxbdo_areas`.`activo`=1 \
      AND `xxbdo_estandares`.`activo`=1 \
      AND `xxbdo_estandares`.`es_visible`=1 \
      AND `xxbdo_checklists`.`activo`=1 \
      AND `xxbdo_indicadores`.`activo`=1";
      //Select indicadores stds and libres
      sql="SELECT * FROM (\
        "+sql_stds+" \
        AND `xxbdo_indicadores`.`tipo`='I' \
        UNION \
        "+sql_stds+" \
        AND `xxbdo_indicadores`.`cr_plaza`=? \
        AND `xxbdo_indicadores`.`cr_tienda`=? \
        AND `xxbdo_indicadores`.`tipo`='L' \
        ) tbl_respuestas \
        ORDER BY `tbl_respuestas`.`areas_orden`, \
        `tbl_respuestas`.`indicadores_orden`";
      entries = [fecha_consulta, fecha_actual, crplaza, crtienda, tipo_consulta, fecha_actual, 
        fecha_consulta, fecha_actual, crplaza, crtienda, tipo_consulta, fecha_actual, crplaza, crtienda];
    }
    //
    qry=db.query(sql, entries, (err, rows) => {
      if(dbg) console.log("[261] "+qry.sql);
      if(err) {
          err.status=500;
          return next(err);
      }
      //
      results = formatResults(rows, 
          tipo_consulta, 
          existe_dia, 
          fecha_consulta,
          titulo,
          subtitulo);
      //
      if(!results) {
          error  = new Error('No hay indicadores para '+fecha_consulta+'!');
          error.status = 400;
          return next(error);
      }
      res.status(200).json(results);
    });
    });
    };
    
    function formatResults(rows, tipo_consulta, existe_dia, fecha_consulta, titulo, subtitulo) {
        if(rows) {
          let results = [], plantilla = null, is_current = null;
          if(rows.length>0) {
              let areas=[], nrow=0;
              rows.forEach(row => {
                  if(!areas.includes(row.xxbdo_areas_id)) {
                      //is new 
                      version_plantilla = row.titulo;
                      areas.push(row.xxbdo_areas_id);
                      results.push(
                          {
                           "area":row.area_titulo, 
                           "indcs":[]
                          }
                      );
                  }
                  //
                  aindx = areas.indexOf(row.xxbdo_areas_id),
                  nrow++;
                  nrow = (nrow.toString().length<2) ? "0"+nrow : nrow;
                  res={
                    "id": row.bdo_id,
                    "ord": nrow,
                    "stl": row.std_titulo,
                    "itl":row.indicadores_titulo,
                    "tp":row.tipo,
                    "res":row.respuesta,
                    "tdd":row.tipo_dato,
                    "dfl":row.default
                  };
                  if(!existe_dia) {
                    results[aindx].indcs.push();
                  }
                  results[aindx].indcs.push(res);
                  is_current = (row.is_current ? true : false);
              });
              //
              plantilla = {
                "fecha":fecha_consulta,
                "existe":existe_dia, 
                "crnt":is_current,
                "frec":tipo_consulta,
                "tl":titulo,
                "stl":subtitulo,
                "resp":results
            };
              //
          }
          return plantilla;
        }
        return;
        }
