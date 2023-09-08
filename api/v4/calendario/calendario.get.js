
const db          = require("../../../db"),
bdoDates          = require("../../helpers/bdo-dates"),
//azureSasToken     = require("./../../helpers/azure-sas-tokens"),
util              = require('util'),
dbg               = false;

exports.calendario_checklist_get = (req, res, next) => {
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
fecha_token = req.tokenData.fecha,
consulta_fecha = false,
tipo_consulta  = req.params.tipo_consulta || null,
valor          = req.params.valor || null,
fecha_consulta = req.params.fecha_consulta || valor,
year           = req.params.year || 
bdoDates.getBDOFormat(req.tokenData.fecha, 'YYYY'),
fecha_checklist= req.tokenData.fecha,
fecha_actual     = req.tokenData.fecha,
condition      = '', 
sql            = null, 
entries        = null,
fmt_valor      = null;
//
if(tipo_consulta) {
req.checkParams('tipo_consulta')
.matches(/^$|^[D|S|M]/)//D:Diario, S:Semanal, M:Mensual//{1}
.withMessage('Tipo de consulta invalido!')
.trim();
//
const errors = req.validationErrors();
if (errors) {
 const error = new Error('Tipo de consulta invalido!');
 error.status=400;
 return next(error);
}
} else {
tipo_consulta = 'D';//search in daily checklist
fecha_checklist = req.tokenData.fecha;
}
//
switch(tipo_consulta) {
case "D"://Diario
if(valor) {
  req.checkParams('valor')
  .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)
  .withMessage('Formato de fecha invalido!')
  .trim();
 //
 errors = req.validationErrors();
 if (errors) {
   console.log(util.inspect(errors, {depth: null}));
   error  = new Error('fecha de consulta invalida!');
   error.status = 400;
   return next(error);
 }
 isGreather = bdoDates.isDateGreatherThanCurrent(valor);
  if(isGreather) {
      const error  = new Error('Valor de día es mayor que el actual!');
      error.status = 400;
      return next(error);
  }
  fecha_checklist = valor;
}
//
if(fecha_consulta) {
 consulta_fecha = true;
}
formattedDate = 
bdoDates.getBDOFormattedDate(fecha_actual, "es", "dddd, D MMMM YYYY");
fmt_valor = valor;
break;
case "S"://Semanal
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
if(dbg)console.log("valor = "+valor);
//
[num_week, year] = bdoDates.getWeekAndYearFromDate(valor);
fmt_valor = num_week;
if(dbg)console.log("Num week = "+num_week+" , year = "+year);
//
isGreather = bdoDates.isWeekGreatherThanCurrent(num_week, year);
if(isGreather) {
  error  = new Error('Valor de semana es mayor que la actual!');
  error.status = 400;
  return next(error);
}
entries   = [crplaza, crtienda, tipo_consulta, num_week, year];
var date_array = bdoDates.formatWeekStartEndDays(num_week, year);
formattedDate = date_array[1];
break;
case "M"://Mensual
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
      if(dbg)console.log("Num month = "+num_month+" , year = "+year);
      isGreather = bdoDates.isMonthGreatherThanCurrent(num_month, year);
      if(isGreather) {
          error  = new Error('Valor del mes es mayor que el actual!');
          error.status = 400;
          return next(error);
      }
  entries   = [crplaza, crtienda, tipo_consulta, num_month, year];
  var date_array = bdoDates.formatMonthStartEndDays(num_month, year);
  formattedDate = date_array[2]+" "+date_array[1];
break;
}
//
let existe_dia       = false,
 results          = null;

switch(tipo_consulta) {
case 'D': //Respuestas Diarias
  //new query to count respuestas by tipo area    
  if(consulta_fecha) {
      entries       = [crplaza, crtienda, fecha_consulta];
      formattedDate = 
          bdoDates.getBDOFormattedDate(fecha_consulta, "es", "dddd, D MMMM YYYY");
    } else {
        condition = "";
        entries   = [crplaza, crtienda, fecha_actual];
    }
    //
  sql = "SELECT COUNT(*) as respuestas \
  FROM `xxbdo_respuestas`, \
  `xxbdo_areas_estandares`, \
  `xxbdo_areas` \
  WHERE cr_plaza=? \
  AND cr_tienda=? \
  AND fecha_respuesta=? "+condition+" \
  AND `xxbdo_areas_estandares_id`= `xxbdo_areas_estandares`.`id` \
  AND `xxbdo_areas_estandares`.`xxbdo_areas_id`=`xxbdo_areas`.`id` \
  AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
  IN (SELECT `xxbdo_areas_grupos`.`id` \
  FROM `xxbdo_areas_grupos` WHERE \
  `tipo`='"+tipo_consulta+"')";
  // Incluir estandar libre
  tipo_condition = " AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
      IN (SELECT `xxbdo_areas_grupos`.`id` \
      FROM `xxbdo_areas_grupos` \
      WHERE `tipo` IN('"+tipo_consulta+"', 'L'))";
break;
case 'S': //Respuestas Semanales
case 'M': //Respuestas Mensuales
//1. Buscar si existen respuestas de la semana/mes seleccionada
tipo_respuesta = (tipo_consulta=='S' ? "AND semana=?" : "AND mes=?");
sql = "SELECT COUNT(*) as respuestas \
FROM `xxbdo_respuestas`, \
`xxbdo_areas_estandares`, \
`xxbdo_areas` \
WHERE cr_plaza=? \
AND cr_tienda=? \
AND tipo=? "+tipo_respuesta+" \
AND año=? \
AND `xxbdo_areas_estandares_id`= `xxbdo_areas_estandares`.`id` \
AND `xxbdo_areas_estandares`.`xxbdo_areas_id`=`xxbdo_areas`.`id` \
AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
IN (SELECT `xxbdo_areas_grupos`.`id` \
FROM `xxbdo_areas_grupos` WHERE `tipo` IN('"+tipo_consulta+"'))";
break;
}
//
qry=db.query(sql, entries, (err, result) => {
 if(dbg) console.log("[171] "+qry.sql);
if (err) {
  err.status = 500;
  return next(err);
}
//
if(result[0].respuestas>0) {
  //answers already exists, get from xxbdo_respuestas
  existe_dia = true;
  //
  switch(tipo_consulta) {
      case "D"://Diario
      if(consulta_fecha) {
          entries = [crplaza, crtienda, fecha_consulta];
      } else {
          condition = "";
          entries   = [crplaza, crtienda, fecha_actual];
      }
      //
      sql = "SELECT `xxbdo_respuestas`.`id` AS `bdo_id`, \
      `xxbdo_checklists`.`titulo`, \
      `xxbdo_respuestas`.`xxbdo_areas_estandares_id`, \
      `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
      `xxbdo_areas`.`titulo` AS `area_titulo`, \
      `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
      `xxbdo_estandares`.`estandar` AS `estandar`, \
      `xxbdo_estandares`.`titulo` AS `std_titulo`, \
      `xxbdo_estandares`.`detalle`, \
      `xxbdo_areas_estandares`.`valor`, \
      `xxbdo_respuestas`.`respuesta`, \
      `xxbdo_respuestas`.`respuesta_asesor`, \
      `xxbdo_respuestas`.`valor_ata`, \
      `xxbdo_areas_estandares`.`dias_activos` \
      FROM `xxbdo_respuestas`, \
      `xxbdo_areas_estandares`, \
      `xxbdo_areas`, \
      `xxbdo_estandares`, \
      `xxbdo_checklists` \
      WHERE `xxbdo_respuestas`.`cr_plaza`=? \
      AND `xxbdo_respuestas`.`cr_tienda`=? \
      AND `xxbdo_respuestas`.`fecha_respuesta`=? "+condition+" \
      AND `xxbdo_areas_estandares`.`id`=`xxbdo_respuestas`.`xxbdo_areas_estandares_id` \
      AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
      AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
      AND `xxbdo_checklists`.`id`=`xxbdo_respuestas`.`xxbdo_checklists_id` \
      AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_areas`.`activo`=1 \
      AND `xxbdo_estandares`.`activo`=1 \
      AND `xxbdo_estandares`.`es_visible`=1 \
      AND `xxbdo_checklists`.`activo`=1 "+tipo_condition+" \
      ORDER BY `xxbdo_areas`.`orden`, \
      `xxbdo_areas_estandares`.`orden`";
      break;
      case "S"://Semanal
      case "M"://Mensual
      tipo_respuesta = (tipo_consulta=='S' ? "AND `xxbdo_respuestas`.`semana`=?" : "AND `xxbdo_respuestas`.`mes`=?");
      sql = "SELECT `xxbdo_respuestas`.`id` AS `bdo_id`, \
      `xxbdo_checklists`.`titulo`, \
      `xxbdo_respuestas`.`xxbdo_areas_estandares_id`, \
      `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
      `xxbdo_areas`.`titulo` AS `area_titulo`, \
      `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
      `xxbdo_estandares`.`estandar` AS `estandar`, \
      `xxbdo_estandares`.`titulo` AS `std_titulo`, \
      `xxbdo_estandares`.`detalle`, \
      `xxbdo_areas_estandares`.`valor`, \
      `xxbdo_respuestas`.`respuesta`, \
      `xxbdo_respuestas`.`respuesta_asesor`, \
      `xxbdo_respuestas`.`valor_ata`, \
      `xxbdo_areas_estandares`.`dias_activos` \
      FROM `xxbdo_respuestas`, \
      `xxbdo_areas_estandares`, \
      `xxbdo_areas`, \
      `xxbdo_estandares`, \
      `xxbdo_checklists` \
      WHERE `xxbdo_respuestas`.`cr_plaza`=? \
      AND `xxbdo_respuestas`.`cr_tienda`=? \
      AND `xxbdo_respuestas`.`tipo`=? "+tipo_respuesta+" \
      AND `xxbdo_respuestas`.`año`=? \
      AND `xxbdo_areas_estandares`.`id`=`xxbdo_respuestas`.`xxbdo_areas_estandares_id` \
      AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
      AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
      AND `xxbdo_checklists`.`id`=`xxbdo_respuestas`.`xxbdo_checklists_id` \
      AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_areas`.`activo`=1 \
      AND `xxbdo_estandares`.`activo`=1 \
      AND `xxbdo_estandares`.`es_visible`=1 \
      AND `xxbdo_checklists`.`activo`=1 \
      AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
      IN (SELECT `xxbdo_areas_grupos`.`id` \
      FROM `xxbdo_areas_grupos` \
      WHERE `tipo` IN('"+tipo_consulta+"')) \
      ORDER BY `xxbdo_areas`.`orden`, \
      `xxbdo_areas_estandares`.`orden`";
      break;
  }
} else {
  //answers does not exists, get assigned checklist
  switch(tipo_consulta) {
      case 'D'://Diario
      if(tipo_consulta) {
          tipo_condition = " AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
          IN (SELECT `xxbdo_areas_grupos`.`id` \
          FROM `xxbdo_areas_grupos` \
          WHERE `tipo`='"+tipo_consulta+"')";
      } else {
          //get default areas_grupos type
          tipo_condition = " AND `xxbdo_areas`.`xxbdo_areas_grupos_id` IN \
          (SELECT `xxbdo_areas_grupos`.`id` \
          FROM `xxbdo_areas_grupos` \
          WHERE `es_default`=1)";
      }
      //
      sql_stds_libres="SELECT `xxbdo_areas_estandares`.`id` AS `xxbdo_areas_estandares_id`, \
      `xxbdo_checklists`.`titulo`, \
      `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
      `xxbdo_areas`.`titulo` AS `area_titulo`, \
      `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
      `xxbdo_estandares`.`estandar` AS `estandar`, \
      `xxbdo_estandares`.`titulo` AS `std_titulo`, \
      `xxbdo_estandares`.`detalle`, \
      `xxbdo_areas_estandares`.`valor`, \
      `xxbdo_areas_estandares`.`dias_activos`, \
      `xxbdo_areas`.`orden` AS areas_orden, \
      `xxbdo_areas_estandares`.`orden` AS areas_estandares_orden \
      FROM `xxbdo_checklists`, \
      `xxbdo_areas_estandares`, \
      `xxbdo_areas`, \
      `xxbdo_estandares` \
      WHERE `xxbdo_checklists`.`id` = ( \
          SELECT `id` \
          FROM `xxbdo_checklists` \
          WHERE '"+fecha_checklist+"' \
          BETWEEN `fecha_inicio` \
          AND IFNULL(`fecha_fin`, '"+fecha_token+"') \
          LIMIT 1 \
      ) \
      AND `xxbdo_areas_estandares`.`id` IN( \
          SELECT `xxbdo_tiendas_has_areas_estandares`.`xxbdo_areas_estandares_id` \
          FROM `xxbdo_tiendas_has_areas_estandares` \
          WHERE `xxbdo_tiendas_has_areas_estandares`.`cr_plaza`='"+crplaza+"' \
          AND `xxbdo_tiendas_has_areas_estandares`.`cr_tienda`='"+crtienda+"' \
          AND `xxbdo_tiendas_has_areas_estandares`.`xxbdo_checklists_id`= `xxbdo_checklists`.`id` \
          AND `xxbdo_tiendas_has_areas_estandares`.`es_visible`=1 \
          AND `xxbdo_tiendas_has_areas_estandares`.`activo`=1 \
      )\
      AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_estandares`.`cr_plaza`='"+crplaza+"' \
      AND `xxbdo_estandares`.`cr_tienda`='"+crtienda+"' \
      AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
      AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
      AND FIND_IN_SET((WEEKDAY('"+fecha_checklist+"')+1), `xxbdo_areas_estandares`.`dias_activos`)>0 \
      AND `xxbdo_areas`.`activo`=1 \
      AND `xxbdo_estandares`.`activo`=1 \
      AND `xxbdo_estandares`.`es_visible`=1 \
      AND `xxbdo_checklists`.`activo`=1 \
      AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
      IN(SELECT `xxbdo_areas_grupos`.`id` \
      FROM `xxbdo_areas_grupos` \
      WHERE `tipo`='L')";
      //get records from xxbdo_checklists
      sql_stds = "SELECT `xxbdo_areas_estandares`.`id` \
      AS `xxbdo_areas_estandares_id`, \
      `xxbdo_checklists`.`titulo`, \
      `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
      `xxbdo_areas`.`titulo` AS `area_titulo`, \
      `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
      `xxbdo_estandares`.`estandar` AS `estandar`, \
      `xxbdo_estandares`.`titulo` AS `std_titulo`, \
      `xxbdo_estandares`.`detalle`, \
      `xxbdo_areas_estandares`.`valor`, \
      `xxbdo_areas_estandares`.`dias_activos`, \
      `xxbdo_areas`.`orden` AS areas_orden, \
      `xxbdo_areas_estandares`.`orden` AS areas_estandares_orden \
      FROM `xxbdo_checklists`, \
      `xxbdo_areas_estandares`, \
      `xxbdo_areas`, \
      `xxbdo_estandares` \
      WHERE `xxbdo_checklists`.`id` = ( \
          SELECT `id` \
          FROM `xxbdo_checklists` \
          WHERE '"+fecha_checklist+"' \
          BETWEEN `fecha_inicio` \
          AND IFNULL(`fecha_fin`, '"+fecha_token+"') \
          LIMIT 1 \
      ) \
      AND `xxbdo_areas_estandares`.`id` IN( \
          SELECT `xxbdo_tiendas_has_areas_estandares`.`xxbdo_areas_estandares_id` \
          FROM `xxbdo_tiendas_has_areas_estandares` \
          WHERE `xxbdo_tiendas_has_areas_estandares`.`cr_plaza`='"+crplaza+"' \
          AND `xxbdo_tiendas_has_areas_estandares`.`cr_tienda`='"+crtienda+"' \
          AND `xxbdo_tiendas_has_areas_estandares`.`xxbdo_checklists_id`= `xxbdo_checklists`.`id` \
          AND `xxbdo_tiendas_has_areas_estandares`.`es_visible`=1 \
          AND `xxbdo_tiendas_has_areas_estandares`.`activo`=1 \
      )\
      AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
      AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
      AND FIND_IN_SET((WEEKDAY(?)+1), `xxbdo_areas_estandares`.`dias_activos`)>0 \
      AND `xxbdo_areas`.`activo`=1 \
      AND `xxbdo_estandares`.`activo`=1 \
      AND `xxbdo_estandares`.`es_visible`=1 \
      AND `xxbdo_checklists`.`activo`=1 "+tipo_condition;
      entries = [fecha_checklist];
      sql="SELECT * FROM (\
          "+sql_stds+" \
          UNION \
          "+sql_stds_libres+" \
          ) tbl_respuestas \
          ORDER BY `tbl_respuestas`.`areas_orden`, \
      `tbl_respuestas`.`areas_estandares_orden`";
      break;
      case 'S'://Semanal
      case 'M'://Mensual
      //get records from xxbdo_checklists
      sql = "SELECT `xxbdo_areas_estandares`.`id` \
      AS `xxbdo_areas_estandares_id`, \
      `xxbdo_checklists`.`titulo`, \
      `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
      `xxbdo_areas`.`titulo` AS `area_titulo`, \
      `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
      `xxbdo_estandares`.`estandar` AS `estandar`, \
      `xxbdo_estandares`.`titulo` AS `std_titulo`, \
      `xxbdo_estandares`.`detalle`, \
      `xxbdo_areas_estandares`.`valor`, \
      `xxbdo_areas_estandares`.`dias_activos`, \
      `xxbdo_areas`.`orden` AS areas_orden, \
      `xxbdo_areas_estandares`.`orden` AS areas_estandares_orden \
      FROM `xxbdo_checklists`, \
      `xxbdo_areas_estandares`, \
      `xxbdo_areas`, \
      `xxbdo_estandares` \
      WHERE `xxbdo_checklists`.`id` = ( \
          SELECT `id` \
          FROM `xxbdo_checklists` \
          WHERE ? \
          BETWEEN `fecha_inicio` \
          AND IFNULL(`fecha_fin`, '"+fecha_token+"') \
          LIMIT 1 \
      ) \
      AND `xxbdo_areas_estandares`.`id` IN( \
          SELECT `xxbdo_tiendas_has_areas_estandares`.`xxbdo_areas_estandares_id` \
          FROM `xxbdo_tiendas_has_areas_estandares` \
          WHERE `xxbdo_tiendas_has_areas_estandares`.`cr_plaza`='"+crplaza+"' \
          AND `xxbdo_tiendas_has_areas_estandares`.`cr_tienda`='"+crtienda+"' \
          AND `xxbdo_tiendas_has_areas_estandares`.`xxbdo_checklists_id`= `xxbdo_checklists`.`id` \
          AND `xxbdo_tiendas_has_areas_estandares`.`es_visible`=1 \
          AND `xxbdo_tiendas_has_areas_estandares`.`activo`=1 \
      )\
      AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
      AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
      AND FIND_IN_SET((WEEKDAY(?)+1), `xxbdo_areas_estandares`.`dias_activos`)>0 \
      AND `xxbdo_areas`.`activo`=1 \
      AND `xxbdo_estandares`.`activo`=1 \
      AND `xxbdo_estandares`.`es_visible`=1 \
      AND `xxbdo_checklists`.`activo`=1 \
      AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
      IN (SELECT `xxbdo_areas_grupos`.`id` \
      FROM `xxbdo_areas_grupos` \
      WHERE `tipo`='"+tipo_consulta+"') \
      ORDER BY  `xxbdo_areas`.`orden`, \
      `xxbdo_areas_estandares`.`orden`";
      entries = [fecha_actual, fecha_actual];
      break;
  }
}
//
qry=db.query(sql, entries, (err, rows) => {
if(dbg) console.log("[504] "+qry.sql);
  if(err) {
      err.status=500;
      return next(err);
  }
  //
  results = formatResults(rows, 
      tipo_consulta, 
      existe_dia, 
      fmt_valor,
      year,
      formattedDate);
  //
  if(!results) {
      error  = new Error('No hay resultados del checklist('+fecha_actual+')!');
      error.status = 400;
      return next(error);
  }
  res.status(200).json(results);
});
});
};

function formatResults(rows, tipo_consulta, existe_dia, valor, year, formattedDate) {
if(rows) {
  let results = [], plantilla = null, version_plantilla = null;
  if(rows.length>0) {
      let areas=[];
      rows.forEach(row => {
          if(!areas.includes(row.xxbdo_areas_id)) {
              //is new 
              version_plantilla = row.titulo;
              areas.push(row.xxbdo_areas_id);
              results.push(
                  {
                   "area":row.area_titulo, 
                   "estandares":[]
                  }
              );
          }
          //
          aindx = areas.indexOf(row.xxbdo_areas_id);
          if(existe_dia) {
              switch(tipo_consulta) {
                  case 'D':
                  res = {
                      "id": row.bdo_id,
                      "area":row.area_titulo,
                      "std": row.estandar,
                      "titulo": row.std_titulo,
                      "detalle": row.detalle || "",
                      "res": row.respuesta,
                      "ata": row.valor_ata
                  };
                  break;
                  case 'S':
                  case 'M':
                  res = {
                      "id": row.bdo_id,
                      "area":row.area_titulo,
                      "std": row.estandar,
                      "titulo": row.std_titulo,
                      "detalle": row.detalle || "",
                      "res": row.respuesta,
                      "resa":row.respuesta_asesor,
                      "ata": row.valor_ata
                  };
                  break;
              }
          } else {
              switch(tipo_consulta) {
                  case 'D':
                  res={
                      "id": row.xxbdo_areas_estandares_id,
                      "area":row.area_titulo,
                      "std": row.estandar,
                      "titulo": row.std_titulo,
                      "detalle": row.detalle || "",
                      "res":"",
                      "ata":""
                  };
                  break;
                  case 'S':
                  case 'M':
                  res={
                      "id": row.xxbdo_areas_estandares_id,
                      "area":row.area_titulo,
                      "std": row.estandar,
                      "titulo": row.std_titulo,
                      "detalle": row.detalle || "",
                      "res":"",
                      "resa":"",
                      "ata":""
                  };
                  break;

              }
              results[aindx].estandares.push();
          }
          results[aindx].estandares.push(res);
      });
      //
      switch(tipo_consulta) {
          case 'D':
              plantilla = {
                  "fecha":formattedDate,
                  "existe":existe_dia, 
                  "tipo":tipo_consulta,
                  "checklist":results
              };
          break;
          case 'S':
          case 'M':
              plantilla = {
                  "fecha":formattedDate,
                  "existe":existe_dia, 
                  "tipo":tipo_consulta,
                  "num":valor,
                  "yr":year,
                  "checklist":results
              };
          break;
      }
      //
  }
  return plantilla;
}
return;
}