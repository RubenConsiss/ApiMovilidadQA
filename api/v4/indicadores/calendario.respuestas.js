
const db = require("../../../db");
const bdoDates = require("../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

exports.respuestas_get = (req, res, next) => {
    if(dbg) console.log("[CR:8] Start respuestas_get ...");
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
    
    let crplaza = req.tokenData.crplaza;
    let crtienda = req.tokenData.crtienda;
    let fecha_token = req.tokenData.fecha;
    let ver_checklist_id = req.params.checklist_id || null;
    let tipo_cliente = req.params.tipo_cliente || null;
    let tipo_consulta = req.params.tipo_consulta || null;
    let valor = req.fecha_fin_version ||
                req.params.valor || 
                bdoDates.getBDOFormat(fecha_token, 'YYYY-MM-DD');

    isGreather = bdoDates.isDateGreatherThanCurrent(valor);
    if(isGreather) {
        valor = fecha_token;
    }

    let fecha_consulta = req.params.fecha_consulta || valor;
    let year = req.params.year || 
               bdoDates.getBDOFormat(fecha_token, 'YYYY');

    let entries = null;
    let fmt_valor = null;
    let num_interval = 7; //days
    let req_inicio = null;
    let req_fin = null;
    let tipo_headers = null;
    let errors = null;
    
    req.checkParams('tipo_cliente')
    .withMessage('Tipo de cliente invalido!')
    .matches(/^$|^[1-3|{1}]/)//1=handheld | 2=tablet | 3=web
    .trim();

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
    } else {
        tipo_consulta = "D";//search in daily checklist
    }

    errors = req.validationErrors();
    if (errors) {
        error = new Error('Tipo de consulta invalido!');
        error.status = 400;
        return next(error);
    }

    if(valor) {
        req.checkParams('valor')
        .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)
        .withMessage('Formato de fecha invalido!')
        .trim();
       
       errors = req.validationErrors();
       if (errors) {
         console.log(util.inspect(errors, {depth: null}));
         error  = new Error('fecha de consulta invalida!');
         error.status = 400;
         return next(error);
       }
      }
      
      formattedDate = 
      bdoDates.getBDOFormattedDate(fecha_token, "es", "dddd, D MMMM YYYY");
      fmt_valor = valor;
      if(["2", "3"].includes(tipo_cliente)) {
          num_interval = 7; //days per week
      }

    //query para obtener checklist de fecha seleccionada
    stmt="SELECT `xxbdo_checklists_id` AS `id` \
    FROM `xxbdo_checklists_tiendas` \
    WHERE cr_plaza=? \
    AND cr_tienda=? \
    AND DATE(?) \
    BETWEEN fecha_inicio \
    AND IFNULL(fecha_fin, ?)";
    data = [crplaza, crtienda, valor, fecha_token];
    qry=db.query(stmt, data, (err, rst) => {
        if(dbg) console.log("[CR:206] Get checklist from selected date(", valor, ")=", qry.sql);
        if (err) {
            err.status=500;
            return next(err);
        }
        
        req.date_checklist = date_checklist = rst[0].id;
        if(dbg) console.log("[CR:213] checklist from selected date =", date_checklist);
        if(dbg) console.log("[CR:214] Call getBitacoraData(fecha_consulta, tipo_consulta, num_interval): ", fecha_consulta, tipo_consulta, num_interval);

        if(ver_checklist_id) {
            date_checklist = ver_checklist_id;
            if(dbg) console.log("[CR:218] Use checklist_id from app: ", ver_checklist_id);
        }

        [req_inicio, 
            req_fin,
            bitacora_dias, 
            bitacora_semanas, 
            bitacora_meses] = 
                bdoDates.getBitacoraData(date_checklist,
                                        fecha_consulta, 
                                        tipo_consulta, 
                                        tipo_cliente, 
                                        num_interval);

        if(dbg) console.log("[CR::234] Fecha Inicio/Fin = " + req_inicio, req_fin); 
        if(dbg) console.log("[CR::235] Bitacora dias = " + JSON.stringify(bitacora_dias, null, 4)); 
        if(dbg) console.log("[CR::236] Bitacora semanas = " + JSON.stringify(bitacora_semanas, null, 4)); 
        if(dbg) console.log("[CR::237] Bitacora meses = " + JSON.stringify(bitacora_meses, null, 4)); 
        
        let results  = null;
        let fecha_inicio = req_inicio;
        let [semana_inicio, 
            año_inicio] 
            = bdoDates.getWeekAndYearFromDate(fecha_inicio);
        let [title_sweek, 
            sweek_days_fmt, 
            fecha_inicio_semana_reporte, 
            fecha_fin_semana_inicio] 
            = bdoDates.formatWeekStartEndDays(semana_inicio, año_inicio);
        let [semana_fin, 
            año_actual] 
            = bdoDates.getWeekAndYearFromDate(req_fin);
        let [title_nweek, 
            week_days_fmt, 
            fecha_semana_inicio, 
            fecha_fin]
            = bdoDates.formatWeekStartEndDays(semana_fin, año_actual);
        let mes_fin = bdoDates.getBDOFormattedDate(
            req_fin,
            "es", 
            "MM",
            true
        );

        if(dbg) console.log("[CR:264] Año inicio = " + año_inicio +"\n"+
        "Semana Inicio = " + semana_inicio +"\n" +
        "Fecha semana inicio= "+ fecha_inicio_semana_reporte + "\n" + 
        "Año actual = "+año_actual + "\n" +
        "Semana actual = "+semana_fin + "\n" + 
        "Fecha actual = "+req_fin +"\n" +
        "Fecha inicio semana actual = " + fecha_semana_inicio + "\n"+
        "Fecha fin semana actual = " + fecha_fin
        );
        
        //FR-11, nueva estructura en observaciones
        sql_valor="`xxbdo_respuestas`.`fecha_respuesta` AS `valor`,";
        sql_current="IF(`xxbdo_respuestas`.`fecha_respuesta`='"+fecha_token+"', true, false) as is_current,";
        entries = [
            crplaza, 
            crtienda,
            tipo_consulta,
            fecha_inicio,
            bdoDates.getEndOfMonth(fecha_consulta),
            date_checklist
        ];
        tipo_headers = bitacora_dias;
        
        stmt="SELECT `xxbdo_respuestas`.`xxbdo_checklists_id`, \
            `xxbdo_areas_estandares`.`id` AS `xxbdo_areas_estandares_id`, \
            `xxbdo_respuestas`.`id` AS `rid`, \
            `xxbdo_estandares`.`estandar` AS `estandar`, \
            `xxbdo_estandares`.`titulo` AS `std_titulo`, \
            '1' AS tipo_bitacora, \
            `xxbdo_respuestas`.`fecha_respuesta`, \
            YEAR(`xxbdo_respuestas`.`fecha_respuesta`) AS `año`, \
            "+sql_valor+" \
            "+sql_current+" \
            `xxbdo_respuestas`.`respuesta`, \
            `xxbdo_respuestas`.`respuesta_asesor`, \
            `xxbdo_areas`.`orden` as `areas_orden`, \
            `xxbdo_areas_estandares`.`orden` as `areas_estandares_orden`, \
            `xxbdo_respuestas`.`valor_ata`, \
            `xxbdo_observaciones`.`id` AS `xxbdo_observaciones_id`, \
            DATE_FORMAT(`xxbdo_observaciones`.`fecha_observacion`, '%d/%m/%Y') AS `fecha_observacion_fmt`, \
            `xxbdo_observaciones`.`descripcion`, \
            `xxbdo_observaciones`.`causa`, \
            `xxbdo_observaciones`.`accion`, \
            `xxbdo_observaciones`.`accion_responsable`, \
            `xxbdo_observaciones`.`accion_fecha`, \
            `xxbdo_observaciones`.`requiere_ajuste_ata`, \
            `xxbdo_observaciones`.`realizaron_plan_accion` AS `ejecuto_accionable`, \
            `xxbdo_observaciones`.`resolvio_problema`, \
            `xxbdo_observaciones`.`observacion`, \
            `xxbdo_observaciones`.`foto`, \
            `xxbdo_observaciones`.`folio`, \
            `xxbdo_observaciones`.`turno_mañana`, \
            `xxbdo_observaciones`.`turno_tarde`, \
            `xxbdo_observaciones`.`turno_noche` \
            FROM (`xxbdo_respuestas`, \
            `xxbdo_areas_estandares`, \
            `xxbdo_estandares`, \
            `xxbdo_areas`, \
            `xxbdo_checklists`) \
            LEFT OUTER JOIN `xxbdo_observaciones` \
            ON (`xxbdo_observaciones`.`xxbdo_respuestas_id` = `xxbdo_respuestas`.`id`) \
            WHERE `xxbdo_respuestas`.`cr_plaza`=? \
            AND `xxbdo_respuestas`.`cr_tienda`=? \
            AND `xxbdo_respuestas`.`tipo`=? \
            AND `xxbdo_respuestas`.`fecha_respuesta` BETWEEN ? AND ? \
            AND `xxbdo_respuestas`.`respuesta` IN ('T','P','A','K','') \
            AND `xxbdo_areas_estandares`.`id`=`xxbdo_respuestas`.`xxbdo_areas_estandares_id` \
            AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
            AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
            AND `xxbdo_checklists`.`id`= ? \
            AND `xxbdo_respuestas`.`xxbdo_checklists_id`=`xxbdo_checklists`.`id` \
            AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
            AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
            ORDER BY 13, 14, 9";
        
        qry=db.query(stmt, entries, (err, result) => {
            if(dbg) console.log("[CR:372] "+qry.sql);
            if (err) {
                err.status = 500;
                return next(err);
            }
            
            if(dbg) console.log("[CR:378] Call getResultsData(result, valor):", valor);        
            results = getResultsData(result, valor, tipo_headers);
            req.resData = results;
            next();
        });
      });
};

function getResultsData(rows, valor=null, tipo_headers=null) {
   let info=null, data_array={}, data_map={};
   if(dbg) console.log("[CR:391] Start getResultsData...", valor);
   if(rows) {
       if(rows.length>0) {
            rows.forEach(row => {
                dmId = row.xxbdo_checklists_id+"-"+row.valor;
                if(dbg) console.log("[CR:396] Existe para checklist:", dmId);
                data_map[dmId]=true;//data_map[row.valor]=true;
                key = row.xxbdo_areas_estandares_id + "-" + row.valor;//row.estandar
                if(dbg) console.log("[CR:399] key("+row.fecha_respuesta+") =", key);
                v_nm = (row.fecha_respuesta > valor ? valor : row.fecha_respuesta);
                info = {
                    //"area-estandar-id-o-respuesta-id",
                    "id":""+row.rid,
                    //Número de estándar
                    "std":""+row.estandar,
                    //fecha de respuesta o fecha actual
                    "nm":""+v_nm, // row.valor,
                    //es fecha/semana/mes seleccionado
                    "sl":(v_nm==valor ? true : false), //(row.valor==valor ? true : false),
                    //es fecha/semana/mes actual
                    "cr":(row.is_current ? true : false),
                    //respuesta del lider
                    "res":""+row.respuesta,
                    //existe observacion
                    "eobs":(row.xxbdo_observaciones_id ? true : false),
                    //existe circulo de congruencia
                    "ecc":(row.respuesta_asesor ? true : false),
                    //existen respuestas de estandar en esta fecha
                    "sf":true
                };
                data_array[key] = info;
            });
       }
   }
   if(dbg) console.log("[CR:400] End getResultsData.");
   return [data_array, data_map, tipo_headers];
}
