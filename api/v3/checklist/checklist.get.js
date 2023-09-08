
const app_configuration = require('config'),
      db                = require("./../../../db"),
      bdoDates          = require("./../../helpers/bdo-dates"),
      azureSasToken     = require("./../../helpers/azure-sas-tokens"),
      util              = require('util'),
      dbg               = false;

exports.checklist_get = (req, res, next) => {
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
    //num_week = 
    //bdoDates.getBDOFormattedDate(
    //    valor, 
    //    "es", 
    //    "w",
    //    true
    //);
    //
    //year = 
    //bdoDates.getBDOFormattedDate(
    //    valor, 
    //    "es", 
    //    "YYYY",
    //    true
    //);
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
                AND IFNULL(`fecha_fin`, '"+fecha_actual+"') \
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
                AND IFNULL(`fecha_fin`, '"+fecha_actual+"') \
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
                AND IFNULL(`fecha_fin`, '"+fecha_actual+"') \
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

exports.checklist_get_incidencias = (req, res, next) => {
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
    let consulta_fecha = false,
        tipo_consulta  = req.params.tipo_consulta || null,
        valor         = req.params.valor || 
        ((tipo_consulta=='S') ? 
            bdoDates.getBDOFormat(req.tokenData.fecha, 'w') : 
            ((tipo_consulta=='D') ? req.tokenData.fecha : 
            bdoDates.getBDOFormat(req.tokenData.fecha, 'MM'))
        ),
        fecha_consulta = req.params.fecha_consulta || valor,
        year           = req.params.year || 
        bdoDates.getBDOFormat(req.tokenData.fecha, 'YYYY');
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
           const errors = req.validationErrors();
           if (errors) {
             console.log(util.inspect(errors, {depth: null}));
             const error  = new Error('fecha de consulta invalida!');
             error.status = 400;
             return next(error);
           }
        }
        if(fecha_consulta) {
           consulta_fecha = true;
         }
        break;
        case "S"://Semanal
        case "M"://Mensual
            req.checkParams('valor')
            .withMessage('valor Invalido!')
            .matches(/^$|^(5[0-3]|[1-4][0-9]|[1-9])$/)//1 to 53 weeks
            .trim();
            const errors = req.validationErrors();
            check_num = (tipo_consulta=='M') ? 
                ((valor>12) ? true : false) : 
                ((valor>52) ? true : false);
            if (errors || check_num) {
            const error  = new Error('Valor de semana/mes invalido! '+valor);
            error.status = 400;
            return next(error);
            }
        break;
    }
    //
    let crplaza          = req.tokenData.crplaza,
        crtienda         = req.tokenData.crtienda,
        fecha_respuesta  = req.tokenData.fecha,
        tienda_checklist = req.tokenData.checklist,
        formattedDate    = null, 
        formattedDateName=null, 
        results          = null, 
        stmt             = null, 
        condition        = "", 
        entries          = null;
    //
    switch(tipo_consulta) {
        case "D":
            if(consulta_fecha) {
                formattedDate = 
                    bdoDates.getBDOFormattedDate(
                        fecha_consulta, 
                        "es", 
                        "D [de] MMMM [de] YYYY",
                        true
                    );
                formattedDateName = 
                    bdoDates.getBDOFormattedDate(
                        fecha_consulta, 
                        "es", 
                        "dddd",
                        true
                    );
                entries = [crplaza, crtienda, tipo_consulta, fecha_consulta];
            } else {
                formattedDate = 
                    bdoDates.getBDOFormattedDate(
                        fecha_respuesta, 
                        "es", 
                        "D [de] MMMM [de] YYYY",
                        true
                    );
                formattedDateName = 
                    bdoDates.getBDOFormattedDate(
                        fecha_respuesta, 
                        "es", 
                        "dddd",
                        true
                    );
                condition = " AND `xxbdo_respuestas`.`xxbdo_checklists_id`=?";
                entries   = [crplaza, crtienda, tipo_consulta, fecha_respuesta, tienda_checklist];
            }
            stmt="SELECT COUNT(*) AS `observaciones` \
            FROM `xxbdo_respuestas`, \
            `xxbdo_observaciones` \
            WHERE `xxbdo_respuestas`.`cr_plaza`=? \
            AND `xxbdo_respuestas`.`cr_tienda`=? \
            AND `xxbdo_respuestas`.`tipo`=? \
            AND `xxbdo_respuestas`.`fecha_respuesta`=? "+condition+" \
            AND `xxbdo_observaciones`.`xxbdo_respuestas_id`=`xxbdo_respuestas`.`id` \
            AND `xxbdo_respuestas`.`respuesta` IN ('T','P','A')";
        break;
        case "S":
        case "M":
        formattedDate = 
            bdoDates.getBDOFormattedDate(
                fecha_respuesta, 
                "es", 
                "D [de] MMMM [de] YYYY",
                true
            );
        formattedDateName = 
            bdoDates.getBDOFormattedDate(
                fecha_respuesta, 
                "es", 
                "dddd",
                true
            );
            tipo_respuesta = (tipo_consulta=='S' ? 
                "AND `xxbdo_respuestas`.`semana`=?" : 
                "AND `xxbdo_respuestas`.`mes`=?");
            stmt="SELECT COUNT(*) AS `observaciones` \
            FROM `xxbdo_respuestas`, \
            `xxbdo_observaciones` \
            WHERE `xxbdo_respuestas`.`cr_plaza`=? \
            AND `xxbdo_respuestas`.`cr_tienda`=? \
            AND `xxbdo_respuestas`.`tipo`=? "+tipo_respuesta+" \
            AND `xxbdo_respuestas`.`año`=? \
            AND `xxbdo_observaciones`.`xxbdo_respuestas_id`=`xxbdo_respuestas`.`id` \
            AND `xxbdo_respuestas`.`respuesta` IN ('T','P','A')";
            entries   = [crplaza, crtienda, tipo_consulta, valor, year];
        break;
    }
    //
    qry=db.query(stmt, entries, (err, result) => {
        if (err) {
            err.status = 500;
            return next(err);
        }
        //
        sql_fecha_respuesta="";
        switch(tipo_consulta) {
            case "D":
            if(consulta_fecha) {
                entries = [crplaza, crtienda, tipo_consulta, fecha_consulta, year];
            } else {
                entries   = [crplaza, crtienda, tipo_consulta, fecha_respuesta, tienda_checklist, year];
            }
            tipo_respuesta = " AND `xxbdo_respuestas`.`fecha_respuesta`=? "+condition;
            sql_fecha_respuesta="AND `xxbdo_observaciones`.`fecha_observacion`=`xxbdo_respuestas`.`fecha_respuesta` ";
            break;
            case "S":
            case "M":
            tipo_respuesta = (tipo_consulta=='S' ? "AND semana=?" : "AND mes=?");
            entries = [crplaza, crtienda, tipo_consulta, valor, year];
            break;
        }
        //
        stmt = "SELECT `xxbdo_respuestas`.`id` AS `id`, \
        `xxbdo_checklists`.`titulo` AS `version`, \
        `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
        `xxbdo_areas`.`titulo` AS `area_titulo`, \
        `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
        `xxbdo_estandares`.`estandar` AS `estandar`, \
        `xxbdo_estandares`.`titulo` AS `std_titulo`, \
        `xxbdo_estandares`.`detalle`, \
        `xxbdo_respuestas`.`respuesta_asesor`, \
        `xxbdo_respuestas`.`respuesta`, \
        `xxbdo_respuestas`.`valor_ata`, \
        `xxbdo_observaciones`.`id` AS `xxbdo_observaciones_id`, \
  	    `xxbdo_observaciones`.`descripcion`, \
	    `xxbdo_observaciones`.`foto`, \
        `xxbdo_observaciones`.`folio` AS `folio`, \
        `xxbdo_observaciones`.`turno` AS `turno`, \
        `xxbdo_observaciones`.`causa` AS `causa`, \
        `xxbdo_observaciones`.`accion_responsable_fecha`, \
        `xxbdo_observaciones`.`ajuste_ata` AS `ajuste_ata`, \
        `xxbdo_observaciones`.`hay_seguimiento` AS `hay_seguimiento`, \
        `xxbdo_observaciones`.`es_cierre_efectiva` AS `es_cierre_efectiva` \
        FROM (`xxbdo_respuestas`, \
        `xxbdo_areas_estandares`, \
        `xxbdo_estandares`, \
        `xxbdo_areas`, \
        `xxbdo_checklists`) \
	    LEFT OUTER JOIN `xxbdo_observaciones` \
        ON (`xxbdo_observaciones`.`xxbdo_respuestas_id` = `xxbdo_respuestas`.`id` "+sql_fecha_respuesta+") \
        WHERE  `xxbdo_respuestas`.`cr_plaza`=? \
        AND `xxbdo_respuestas`.`cr_tienda`=? \
        AND `xxbdo_respuestas`.`tipo`=? "+tipo_respuesta+" \
        AND `xxbdo_respuestas`.`año`=? \
        AND `xxbdo_checklists`.`id`=`xxbdo_respuestas`.`xxbdo_checklists_id` \
        AND `xxbdo_respuestas`.`respuesta` IN('T','P','A') \
        AND `xxbdo_areas_estandares`.`id`=`xxbdo_respuestas`.`xxbdo_areas_estandares_id` \
        AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
        AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
        AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
        AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
        ORDER BY `xxbdo_areas`.`orden`, \
        `xxbdo_areas_estandares`.`orden`";
        qry=db.query(stmt, entries, (err, result) => {
            if (err) {
                err.status = 500;
                return next(err);
            }
            //
            results = formatIncidencias(
                tipo_consulta,
                result, 
                formattedDate, 
                formattedDateName
            );
            //
            if(!results) {
                const error  = new Error('No hay Incidencias!');
                error.status = 400;
                return next(error);
            }
            res.status(200).json(results);
        });
    });
    };
    
    function formatIncidencias(tipo_consulta,
        rows, 
        fecha_respuesta, 
        formattedDateName) {
    if(rows) {
      let results = [], plantilla = null, 
      version_plantilla = null, observacion = null, uri = null;
      if(rows.length>0) {
          let areas = [];
          rows.forEach(row => {
              if(!areas.includes(row.xxbdo_areas_id)) {
                  //is new 
                  version_plantilla = row.version;
                  areas.push(row.xxbdo_areas_id);
                  results.push(
                      {
                       "area":row.area_titulo, 
                       "estandares":[]
                      }
                  );
              } 
              //add std to area
              observacion={
                "id":null,
                "desc":"",
                "uri":"",
                "folio":"",
                "turno":"",
                "causa":"",
                "acrsf":"",
                "ata":null,
                "seg":null,
                "cefec":null
              };
              if(row.xxbdo_observaciones_id) {
                  if(row.foto) {
                    //get foro url from azure storage service
                    token = azureSasToken.generateSasToken(
                        app_configuration.get('azure.sas.blob.containers.observaciones.name'), 
                        row.foto, 
                        app_configuration.get('azure.sas.blob.containers.observaciones.sharedAccessPolicy'));
                    if(!token) {
                        uri = "";
                    } else {
                        uri = token.uri;
                    }
                  }
                //
                observacion = {
                    "id":row.xxbdo_observaciones_id,
                    "desc":row.descripcion,
                    "uri":uri,
                    "folio":row.folio,
                    "turno":row.turno,
                    "causa":row.causa,
                    "acrsf":row.accion_responsable_fecha,
                    "ata":(row.ajuste_ata==0 ? false : (row.ajuste_ata==1 ? true : null)),
                    "seg":(row.hay_seguimiento==0 ? false : (row.hay_seguimiento==1 ? true : null)),
                    "cefec":(row.es_cierre_efectiva==0 ? false : (row.es_cierre_efectiva==1 ? true : null))
                };
                uri="";
              }
              aindx = areas.indexOf(row.xxbdo_areas_id);
              switch(tipo_consulta) {
                  case "D":
                  res = {
                    "id": row.id,
                    "std": row.estandar,
                    "titulo": row.std_titulo,
                    "detalle": row.detalle,
                    "res":row.respuesta,
                    "ata":formatValorATA(row.valor_ata),
                    "obs":observacion
                };
                  break;
                  case "S":
                  case "M":
                  res = {
                    "id": row.id,
                    "std": row.estandar,
                    "titulo": row.std_titulo,
                    "detalle": row.detalle,
                    "res":row.respuesta,
                    "resa":row.respuesta_asesor,
                    "ata":formatValorATA(row.valor_ata),
                    "obs":observacion
                };
                  break;
              }
                  results[aindx].estandares.push(res);
          });
          //
          plantilla = {
              "dia":formattedDateName,
              "fecha":fecha_respuesta,
              "incidencias":results
          };
      }
      return plantilla;
    }
    return;
    }
    
    exports.checklist_get_ayuda = (req, res, next) => {
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
           stmt= "( \
        SELECT `xxbdo_estandares`.`id`, \
        `xxbdo_estandares`.`estandar`, \
        `xxbdo_estandares`.`titulo`, \
        `xxbdo_estandares`.`detalle`, \
        (SELECT GROUP_CONCAT(`xxbdo_estandares_fotos`.`foto`) \
         FROM `xxbdo_estandares_fotos` \
         WHERE `xxbdo_estandares_fotos`.`xxbdo_estandares_id`=`xxbdo_estandares`.`id` \
        ) AS `fotos`, \
        `xxbdo_estandares`.`descripcion` \
        FROM \
        `xxbdo_respuestas`, \
        `xxbdo_areas_estandares`, \
        `xxbdo_estandares` \
        WHERE `xxbdo_respuestas`.`id`=? \
        AND `xxbdo_respuestas`.`xxbdo_areas_estandares_id`= `xxbdo_areas_estandares`.`id`              AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
        ) UNION ( \
        SELECT `xxbdo_estandares`.`id`, \
        `xxbdo_estandares`.`estandar`, \
        `xxbdo_estandares`.`titulo`, \
        `xxbdo_estandares`.`detalle`, \
        (SELECT GROUP_CONCAT(`xxbdo_estandares_fotos`.`foto`) \
         FROM `xxbdo_estandares_fotos` \
         WHERE `xxbdo_estandares_fotos`.`xxbdo_estandares_id`=`xxbdo_estandares`.`id` \
        ) AS `fotos`, \
        `xxbdo_estandares`.`descripcion` \
        FROM `xxbdo_areas_estandares`, \
        `xxbdo_estandares` \
        WHERE `xxbdo_areas_estandares`.`id`=? \
        AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
        )";
       qry = db.query(stmt, entries, (err, rows) => {
            if(dbg) console.log("[977] "+qry.sql);
            if (err) {
                err.status = 500;
                return next(err);
            }
            results = formatResultAyuda(rows);
            if(!results) {
                const error = 
                    new Error('No hay registro de ayuda para estandar!');
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
                    "std":row.estandar, 
                    "titulo":row.titulo, 
                    "detalle":row.detalle, 
                    "fotos":fotos, 
                    "desc":row.descripcion
                  };
                });
            }
            return ayuda;
        }
        return;
    }

    function formatValorATA(ata) {
        if(ata) {
            let title_ata = '';
            switch(ata) {
                case "1": 
                    title_ata = "Tarea NO asignada";
                break;
                case "2":
                    title_ata="Tarea Asignada pero NO realizada";
                break;
                case "3":
                    title_ata="Frecuencia incorrecta";
                break;
                case "4":
                    title_ata="No aplica";
                break;
                default:
                    title_ata="";
            }
            return title_ata;
        }
        return "";
    }
