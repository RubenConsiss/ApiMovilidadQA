
const db       = require ("../../../db");
const bdoDates = require ("../../helpers/bdo-dates");
const util     = require ('util');
const dbg      = false;

exports.calendario_get = (req, res, next) => {
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
if (!req.resData) {
    const error  = new Error('Información de respuestas no generada!');
    error.status = 400;
    return next(error);
}

if (!req.resHeaders) {
    const error  = new Error('Información de encabezados no generada!');
    error.status = 400;
    return next(error);
}
//
let crplaza = req.tokenData.crplaza;
let crtienda = req.tokenData.crtienda;
let checklist_id = req.checklist_id;
let checklist_inicio = req.checklist_inicio;
let checklist_fin = req.checklist_fin;
let checklists_data = req.checklists_data;
let ver_checklist_id = req.params.checklist_id || null;
let tipo_cliente = req.params.tipo_cliente || null;
let tipo_consulta = req.params.tipo_consulta || null;
let valor = req.fecha_fin_version ||
            req.params.valor || 
            bdoDates.getBDOFormat(req.tokenData.fecha, 'YYYY-MM-DD');
            //req.checklist_fin ||
let fecha_consulta = req.params.fecha_consulta || valor;
let year = req.params.year || 
           bdoDates.getBDOFormat(req.tokenData.fecha, 'YYYY');
let fecha_checklist = req.tokenData.fecha;
let fecha_actual = req.tokenData.fecha;
//let tienda_checklist = req.tokenData.checklist;
//condition      = '', 
let sql            = null;
let entries        = null;
let fmt_valor      = null;
let num_interval   = 7; //show 7 days by default
//
req.checkParams('tipo_cliente')
.withMessage('Tipo de cliente invalido!')
.matches(/^$|^[1-2|{1}]/)//1=handheld | 2=tablet
.trim();
//
if(ver_checklist_id) {
    req.checkParams('checklist_id')
    .isUUID(4)
    .withMessage('Formato de checklist id invalido!')
    .trim();
}

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
formattedDate = 
bdoDates.getBDOFormattedDate(fecha_actual, "es", "dddd, D MMMM YYYY");
fmt_valor = valor;
if(tipo_cliente=='2') {
    num_interval = 14; //show 14 days
}
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
if(dbg) console.log("valor = "+valor);
fecha_checklist = valor;//2019-05-10 added
//
[num_week, year] = bdoDates.getWeekAndYearFromDate(valor);
fmt_valor = num_week;
if(dbg) console.log("Num week = "+num_week+" , year = "+year);
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
num_interval = 2; //show 2 weeks
if(tipo_cliente=='2') {
    num_interval = 4; //show 4 weeks
}
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
fecha_checklist = valor;//2019-05-10 added
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
  formattedDate = date_array[2]+" "+date_array[1];
  num_interval = 3; //show 3 months
if(tipo_cliente=='2') {
    num_interval = 6; //show 6 months
}
break;
}
//
let existe_dia    = false,
 results          = null;

sql_checklist = "( \
    SELECT `id` \
    FROM `xxbdo_checklists` \
    WHERE '"+fecha_checklist+"' \
    BETWEEN `fecha_inicio` \
    AND IFNULL(`fecha_fin`, '"+fecha_consulta+"') \
    LIMIT 1)";

if(ver_checklist_id) {
    sql_checklist = "'"+ver_checklist_id+"'";
}

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
    
    sql_stds_libres="SELECT `xxbdo_areas_estandares`.`id` AS `xxbdo_areas_estandares_id`, \
    `xxbdo_checklists`.`titulo_app` as `titulo`, \
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
    WHERE `xxbdo_checklists`.`id` = "+sql_checklist+" \
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
    sql_stds = "SELECT `xxbdo_areas_estandares`.`id` AS `xxbdo_areas_estandares_id`, \
    `xxbdo_checklists`.`titulo_app` AS `titulo`, \
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
    WHERE `xxbdo_checklists`.`id` = " + sql_checklist + "\
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
    AND FIND_IN_SET((WEEKDAY('"+fecha_checklist+"')+1), `xxbdo_areas_estandares`.`dias_activos`)>0 \
    AND `xxbdo_areas`.`activo`=1 \
    AND `xxbdo_estandares`.`activo`=1 \
    AND `xxbdo_estandares`.`es_visible`=1 \
    AND `xxbdo_checklists`.`activo`=1 "+tipo_condition;
    /*  
    WHERE `xxbdo_checklists`.`id` = ( \
        SELECT `id` \
        FROM `xxbdo_checklists` \
        WHERE '"+fecha_checklist+"' \
        BETWEEN `fecha_inicio` \
        AND IFNULL(`fecha_fin`, '"+fecha_consulta+"') \
        LIMIT 1 \
    ) \
    */
    //entries = [fecha_checklist];
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
    sql = "SELECT `xxbdo_areas_estandares`.`id` AS `xxbdo_areas_estandares_id`, \
    `xxbdo_checklists`.`titulo_app` as `titulo`, \
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
    WHERE `xxbdo_checklists`.`id` = " + sql_checklist + "\
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
    AND FIND_IN_SET((WEEKDAY('"+fecha_checklist+"')+1), `xxbdo_areas_estandares`.`dias_activos`)>0 \
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
    /*
    WHERE `xxbdo_checklists`.`id` = ( \
        SELECT `id` \
        FROM `xxbdo_checklists` \
        WHERE ? \
        BETWEEN `fecha_inicio` \
        AND IFNULL(`fecha_fin`, ?) \
        LIMIT 1 \
    ) \
    */
    ////entries = [fecha_actual, fecha_consulta, fecha_actual];
    //entries = [fecha_checklist, fecha_consulta, fecha_checklist];
    break;
}
//
qry=db.query(sql, (err, rows) => { //entries
    if(dbg) console.log("[CE:360] "+qry.sql);
    if(err) {
        err.status=500;
        return next(err);
    }
    //
    results = formatResults (
        req.date_checklist,
        req.resData,
        //req.resHeaders,
        checklist_id,
        checklist_inicio,
        checklist_fin,
        checklists_data,
        fecha_consulta,
        num_interval,
        rows, 
        tipo_consulta, 
        tipo_cliente,
        existe_dia
        //fmt_valor,
        //year,
        //formattedDate
    );
    //
    if(!results) {
        error  = new Error('No hay resultados del checklist('+fecha_actual+')!');
        error.status = 400;
        return next(error);
    }
    
    //res.api_response_body =JSON.stringify(results);
    
    res.status(200).json(results);
});
};

function formatResults(date_checklist,
    respuestas_array,
    //encabezados_array,
    checklist_id,
    checklist_inicio,
    checklist_fin,
    checklists_data,
    fecha_consulta,
    num_interval,
    rows, 
    tipo_consulta, 
    tipo_cliente,
    existe_dia
    //valor, 
    //year, 
    //formattedDate
    ) {
if(rows) {
  let results = [];
  let plantilla   = null;
  let version_plantilla = null; 
  
  if(rows.length>0) {
      let areas = [],
      [respuestas, resp_map] = respuestas_array,
      [req_inicio, 
        req_fin,
        //dias, 
        bitacora_dias, 
        //semanas, 
        bitacora_semanas, 
        //meses, 
        bitacora_meses] = 
            bdoDates.getReportData(date_checklist, //tienda_checklist,
                fecha_consulta, 
                tipo_consulta, 
                tipo_cliente,
                num_interval, 
                resp_map);
                //
                switch(tipo_consulta) {
                    case 'D':
                      c_headers = bitacora_dias;
                    break;
                    case 'S':
                      c_headers = bitacora_semanas;
                    break;
                    case 'M':
                      c_headers = bitacora_meses;
                    break;
                }
                //c_headers = encabezados_array;
                if(dbg) console.log("[CE:435] respuestas = "+JSON.stringify(respuestas));
                if(dbg) console.log("[CE:436] respuestas-map = "+JSON.stringify(resp_map));
                if(dbg) console.log("[CE:437] headers = "+JSON.stringify(c_headers));
                //
      rows.forEach(row => {
          if(!areas.includes(row.xxbdo_areas_id)) {
              version_plantilla = row.titulo;
              areas.push(row.xxbdo_areas_id);
              results.push(
                  {
                   "area":row.area_titulo, 
                   "stds":[]
                  }
              );
          }
          //
          aindx = areas.indexOf(row.xxbdo_areas_id);
          if(!existe_dia) {
              rsps_array = [], nelem=0;
              //switch(tipo_consulta) {
                  //case "D":
                    c_headers.forEach( drow => { //bitacora_dias
                        //if(nelem==0) {
                        //    req_inicio = drow.dt;
                        //}
                        //20190527-azlara-arreglar aqui para que no se devuelva la respuesta 
                        //si el checklist cambia
                        rkey = row.xxbdo_areas_estandares_id+"-"+(drow.nm ? drow.nm : drow.dt);//row.estandar
                        //if(dbg) console.log("[CE:461] key = "+rkey);
                        if(respuestas[rkey]) {
                            if(dbg) console.log("[CE:465] Existe en respuestas: "+rkey);
                            rsps_array.push(respuestas[rkey]);
                        } else {
                            if(dbg) console.log("[CE:468] No Existe en respuestas: "+rkey);
                            rsps_array.push({
                                //"key":rkey,
                                "id":row.xxbdo_areas_estandares_id,
                                "std":row.estandar,
                                "nm":drow.dt,   //fecha, num de semana o mes
                                "sl":(fecha_consulta==drow.dt ? true : false),
                                "cr":drow.cr,  //es fecha/semana/mes actual
                                "res":"-",   //respuesta del lider
                                "eobs":false,  //existe observacion
                                "ecc":false,  //existe circulo de congruencia
                                "sf":false   //existen respuestas de estandar en esta fecha
                                });
                        }
                        nelem++;
                        //req_fin = drow.dt;
                    });
                  //break;
                  //case "S":break;
                  //case "M":break;
              //}
              //
            res = {
                "id":row.xxbdo_areas_estandares_id,
                "eid":row.xxbdo_estandares_id,
                "area":row.area_titulo,
                "std":row.estandar,
                "titulo":row.std_titulo,
                "detalle":row.detalle || "",
                "rsps":rsps_array 
            };
          results[aindx].stds.push();
      }
          results[aindx].stds.push(res);
      });
      //

      //
      plantilla = {
        //"fecha":formattedDate,
        //"existe":existe_dia, 
        "tipo":tipo_consulta,
        "ver":version_plantilla,
        "chkid":checklist_id,
        "fi":checklist_inicio,
        "ff":checklist_fin,
        "chks":checklists_data,
        //"num":valor,
        //"yr":year,
        "hdrs":c_headers,
        "checklist":results
    };
    //
  }
  return plantilla; // [req_inicio, req_fin, plantilla];
}
return;
}
