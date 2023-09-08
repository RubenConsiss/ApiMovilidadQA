
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
    
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
    const error  = new Error('crplaza o crtienda invalidos!');
    error.status = 400;
    return next(error);
    }
    
    let crplaza = req.tokenData.crplaza;
    let crtienda = req.tokenData.crtienda;
    let fecha_token = req.tokenData.fecha;
    let ver_checklist_id = req.params.checklist_id || null;
    let tipo_consulta = req.params.tipo_consulta || null;
    let valor = req.params.valor || null;
    let fecha_actual = req.tokenData.fecha;
    let fecha_consulta = valor || fecha_actual;
    let year = null;
    let sql = null; 
    let entries = null;
    let titulo = null;
    let subtitulo = null;
    
    if(ver_checklist_id) {
      req.checkParams('checklist_id')
      .isUUID(4)
      .withMessage('Formato de checklist id invalido!')
      .trim();
  }

    req.checkParams('tipo_consulta')
    .matches(/^$|^[S|M]/)//S:Ind. Semanal, M:Ind.Mensual
    .withMessage('Tipo de consulta invalido!')
    .trim();
    
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
    if(dbg) console.log("[IG:64] valor = " + valor);
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
      if(dbg) console.log("[IG:78] Num week = "+num_week+" , year = "+year);
      isGreather = bdoDates.isWeekGreatherThanCurrent(num_week, year);
      if(isGreather) {
        error = new Error('Valor de semana es mayor que la actual!');
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
          if(dbg) console.log("[IG:107] Num month = "+num_month+" , year = "+year);
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
    let existe_dia = false;
    let results = null;
    let sql_checklist = "";

    //1. Buscar si existen respuestas de la fecha/semana/mes seleccionada
    tipo_respuesta = (tipo_consulta=='S' ? "AND semana=?" : "AND mes=?");
    if(ver_checklist_id) {
      sql_checklist = "AND `xxbdo_respuestas_indicadores`.`xxbdo_checklists_id` = '"+ver_checklist_id+"'"; 
    }

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
    "+sql_checklist+" \
    "+tipo_respuesta+" \
    AND `xxbdo_respuestas_indicadores`.`año`=? \
    AND `xxbdo_respuestas_indicadores`.`xxbdo_areas_estandares_indicadores_id`= `xxbdo_areas_estandares_indicadores`.`id` \
    AND `xxbdo_areas_estandares_indicadores`.`xxbdo_areas_estandares_id`= `xxbdo_areas_estandares`.`id` \
    AND `xxbdo_areas_estandares`.`xxbdo_areas_id`=`xxbdo_areas`.`id`";
    //
    qry=db.query(sql, entries, (err, result) => {
     if(dbg) console.log("[152] "+qry.sql);
    if (err) {
      err.status = 500;
      return next(err);
    }
    //
    sql_checklist = "";
    if(ver_checklist_id) {
      sql_checklist = "AND `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`='"+ver_checklist_id+"'";
    }
    if(result[0].respuestas>0) {
      //answers already exists, get from xxbdo_respuestas_indicadores
      if(dbg) console.log("[IG:161] Respuestas found: ", qry.sql);
      existe_dia = true;
      tipo_respuesta = (tipo_consulta=='S' ? "AND `xxbdo_respuestas_indicadores`.`semana`=?" : "AND `xxbdo_respuestas_indicadores`.`mes`=?");
      es_current = (tipo_consulta=='S' ? 
        "IF(YEARWEEK(`xxbdo_respuestas_indicadores`.`fecha_respuesta`, 3)=YEARWEEK('"+fecha_token+"', 3), true, false)" : 
        "IF(DATE_FORMAT(`xxbdo_respuestas_indicadores`.`fecha_respuesta`, '%Y%m')=DATE_FORMAT('"+fecha_token+"', '%Y%m'), true, false)");
      sql = "SELECT `xxbdo_respuestas_indicadores`.`id` AS `bdo_id`, \
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
      WHERE `xxbdo_respuestas_indicadores`.`cr_plaza`=? \
      AND `xxbdo_respuestas_indicadores`.`cr_tienda`=? \
      AND `xxbdo_respuestas_indicadores`.`xxbdo_indicadores_frecuencias_id`=? "+tipo_respuesta+" \
      AND `xxbdo_respuestas_indicadores`.`año`=? \
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
      AND `xxbdo_indicadores`.`xxbdo_indicadores_frecuencias_id` = '"+tipo_consulta+"' \
      AND `xxbdo_areas`.`activo`=1 \
      AND `xxbdo_estandares`.`activo`=1 \
      AND `xxbdo_estandares`.`es_visible`=1 \
      AND `xxbdo_checklists_tiendas`.`activo`=1 \
      ORDER BY `xxbdo_areas`.`orden`, \
      `xxbdo_areas_estandares_indicadores`.`orden`";
    } else {
      //answers does not exists, get indicadores 
      //from xxbdo_areas_estandares_indicadores
      if(dbg) console.log("[IG:215] Respuestas not found!");
      if(ver_checklist_id) {
        if(dbg) console.log("IG:[217] Search for checklist_id: ", ver_checklist_id);
        sql_checklist="`xxbdo_checklists_tiendas`.`xxbdo_checklists_id` =?";
        entries = [fecha_consulta, ver_checklist_id, crplaza, crtienda, tipo_consulta, fecha_actual, 
          fecha_consulta, fecha_actual, crplaza, crtienda, tipo_consulta, fecha_actual, crplaza, crtienda];
      } else {
        sql_checklist = "`xxbdo_checklists_tiendas`.`xxbdo_checklists_id` = ( \
          SELECT `xxbdo_checklists_id` AS `id` \
          FROM `xxbdo_checklists_tiendas` \
          WHERE `cr_plaza`='"+crplaza+"' \
          AND `cr_tienda`='"+crtienda+"' \
          AND ? \
          BETWEEN `fecha_inicio` \
          AND IFNULL(`fecha_fin`, '"+fecha_token+"') \
          LIMIT 1 \
      )";
        entries = [fecha_consulta, fecha_actual, crplaza, crtienda, tipo_consulta, fecha_actual, 
          fecha_consulta, fecha_actual, crplaza, crtienda, tipo_consulta, fecha_actual, crplaza, crtienda];
      }
      es_current = (tipo_consulta=='S' ? 
      "IF(YEARWEEK(?, 3)=YEARWEEK('"+fecha_token+"', 3), true, false)" : 
      "IF(DATE_FORMAT(?, '%Y%m')=DATE_FORMAT('"+fecha_token+"', '%Y%m'), true, false)");
      sql_stds = "SELECT `xxbdo_areas_estandares_indicadores`.`id` AS `bdo_id`, \
      `xxbdo_checklists_tiendas`.`titulo_indicadores_app`, \
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
          WHERE `xxbdo_tiendas_has_areas_estandares`.`cr_plaza`=? \
          AND `xxbdo_tiendas_has_areas_estandares`.`cr_tienda`=? \
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
      AND `xxbdo_indicadores`.`xxbdo_indicadores_frecuencias_id`=? \
      AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists_tiendas`.`xxbdo_version_estandares_id` \
      AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists_tiendas`.`xxbdo_version_estandares_id` \
      AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
      AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
      AND FIND_IN_SET((WEEKDAY(?)+1), `xxbdo_areas_estandares`.`dias_activos`)>0 \
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
        AND `xxbdo_indicadores`.`cr_plaza`=? \
        AND `xxbdo_indicadores`.`cr_tienda`=? \
        AND `xxbdo_indicadores`.`tipo`='L' \
        ) tbl_respuestas \
        ORDER BY `tbl_respuestas`.`areas_orden`, \
        `tbl_respuestas`.`indicadores_orden`";
      
    }
    
    qry=db.query(sql, entries, (err, rows) => {
      if(dbg) console.log("[IG:298] ", qry.sql);
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
          subtitulo, 
          req.checklist_id,
          req.titulo_indicadores_app,
          req.checklist_inicio,
          req.checklist_fin,
          req.checklists_data);
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
    
    function formatResults(rows, 
      tipo_consulta, 
      existe_dia, 
      fecha_consulta, 
      titulo, 
      subtitulo,
      checklist_id,
      checklist_titulo_indicadores_app,
      checklist_fecha_inicio,
      checklist_fecha_fin,
      checklists_data
      ) {
        if(rows) {
          let results = [];
          let plantilla = null;
          let is_current = null;
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
                  nrow = (nrow.toString().length<2) ? "0"+nrow : ""+nrow;
                  res={
                    "area":row.area_titulo,
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
              
              plantilla = {
                "ver":checklist_titulo_indicadores_app,
                "fecha":fecha_consulta,
                "existe":existe_dia, 
                "crnt":is_current,
                "frec":tipo_consulta,
                "tl":titulo,
                "stl":subtitulo,
                "chkid":checklist_id,
                "fi":checklist_fecha_inicio,
                "ff":checklist_fecha_fin,
                "chks":checklists_data,
                "resp":results
            };
              //
          }
          return plantilla;
        }
        return;
        }

  exports.indicadores_ayuda_get = (req, res, next) => {
          if(!db) {
              const error = new Error('Conexion a BD no encontrada!');
              error.status=500;
              return next(error);
          }
          //
        if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
          const error  = new Error('crplaza o crtienda invalidos!');
          error.status = 400;
          return next(error);
        }
      //Validation chain
      req.checkParams('std')
      .isUUID(4)
      .withMessage('Formato de std id invalido!')
      .trim();
      const errors = req.validationErrors();
      if (errors) {
          if(dbg) console.log(util.inspect(errors, {depth: null}));
          const error = new Error('Formato de estandar id invalido!');
          error.status= 400;
          return next(error);
      }
         //
         let std_id  = req.params.std,
             results = null,
             entries = [std_id, std_id];
             stmt= "(SELECT `xxbdo_indicadores`.`id`, \
             `xxbdo_indicadores`.`titulo`, \
             `xxbdo_indicadores`.`descripcion`, \
             `xxbdo_indicadores`.`foto`, \
             `xxbdo_indicadores`.`detalle` \
             FROM `xxbdo_indicadores`, \
             `xxbdo_areas_estandares_indicadores` \
             WHERE `xxbdo_areas_estandares_indicadores`.`id`=? \
             AND `xxbdo_areas_estandares_indicadores`.`activo`=1 \
             AND `xxbdo_indicadores`.`id`=`xxbdo_areas_estandares_indicadores`.`xxbdo_indicadores_id` \
             AND `xxbdo_indicadores`.`activo`=1) \
             UNION \
             (SELECT `xxbdo_indicadores`.`id`, \
             `xxbdo_indicadores`.`titulo`, \
             `xxbdo_indicadores`.`descripcion`, \
             `xxbdo_indicadores`.`foto`, \
             `xxbdo_indicadores`.`detalle` \
             FROM `xxbdo_indicadores`, \
             `xxbdo_respuestas_indicadores`, \
             `xxbdo_areas_estandares_indicadores` \
             WHERE `xxbdo_respuestas_indicadores`.`id` =? \
             AND `xxbdo_respuestas_indicadores`.`xxbdo_areas_estandares_indicadores_id`=`xxbdo_areas_estandares_indicadores`.`id` \
             AND `xxbdo_indicadores`.`id`=`xxbdo_areas_estandares_indicadores`.`xxbdo_indicadores_id` \
             AND `xxbdo_respuestas_indicadores`.`activo`=1 \
             AND `xxbdo_indicadores`.`activo`=1 \
             AND `xxbdo_areas_estandares_indicadores`.`activo`=1)";
         qry = db.query(stmt, entries, (err, rows) => {
              if(dbg) console.log("[398] "+qry.sql);
              if (err) {
                  err.status = 500;
                  return next(err);
              }
              results = formatResultAyuda(rows);
              if(!results) {
                  const error = 
                      new Error('No hay registro de ayuda para indicador!');
                  error.status = 400;
                  return next(error);
              }
              res.status(200).json(results);
         });
      };
      
      function formatResultAyuda(rows) {
          if(rows) {
              let ayuda=null;
              if(rows.length>0) {
                  rows.forEach(row => {
                  //get fotos
                  let fotos=[];
                  if(row.fotos) {
                      row.fotos.split(',').forEach(function(entry) {
                          //get foto uri from azure storage service
                          token = azureSasToken.generateSasToken(
                              app_configuration.get('azure.sas.blob.containers.catalogos.name'),
                              entry, 
                              app_configuration.get('azure.sas.blob.containers.catalogos.sharedAccessPolicy'));
                          if(token) {
                              fotos.push(token.uri);
                          }
                      });
                  }
                  //
                  ayuda = {
                      //"std":row.estandar, 
                      "ttl":row.titulo, 
                      "desc":row.descripcion,
                      "det":row.detalle || "", 
                      "img":fotos
                    };
                  });
              }
              return ayuda;
          }
          return;
      }