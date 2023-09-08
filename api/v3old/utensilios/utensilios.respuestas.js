
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
    let fecha_checklist = req.tokenData.checklist;
    let tipo_cliente = req.params.tipo_cliente || null;
    let tipo_consulta = "M";//monthly calendar
    let valor = req.params.valor || 
                bdoDates.getBDOFormat(fecha_token, 'YYYY-MM-DD');
    let fecha_consulta = req.params.fecha_consulta || valor;
    let year = req.params.year || 
               bdoDates.getBDOFormat(fecha_token, 'YYYY');
    let entries = null;
    //let fmt_valor = null;
    let num_interval = 6; //months
    let req_inicio = null;
    let req_fin = null;
    let tipo_headers = null;
    let errors = null;
    
    req.checkParams('tipo_cliente')
    .withMessage('Tipo de cliente invalido!')
    .matches(/^$|^[1-3|{1}]/) //1=handheld | 2=tablet | 3=web
    .trim();

    errors = req.validationErrors();
    if (errors) {
        error = new Error('Tipo de consulta invalido!');
        error.status = 400;
        return next(error);
    }

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
        valor = fecha_token;
      }

      isGreather = bdoDates.isDateGreatherThanCurrent(valor);
      if(isGreather) {
          const error  = new Error('Fecha seleccionada es mayor que la actual!');
          error.status = 400;
          return next(error);
      }
      
      num_interval = req.num_meses_vista_inicial_tablet_checklists_de_utensilios;
      if(tipo_cliente=='3') {
          num_interval = req.num_meses_vista_inicial_web_checklists_de_utensilios;
      }
      
    num_month = 
            bdoDates.getBDOFormattedDate(
                valor, 
                "es", 
                "M",
                true
            );
            //fmt_valor = num_month;
            
    year = 
            bdoDates.getBDOFormattedDate(
                valor, 
                "es", 
                "YYYY",
                true
            );

    if(dbg) console.log("[CR:163] Num month = "+num_month+" , year = "+year);
    isGreather = bdoDates.isMonthGreatherThanCurrent(num_month, year);
    if(isGreather) {
        error  = new Error('Valor del mes es mayor que el actual!');
        error.status = 400;
        return next(error);
    }

    let date_array = bdoDates.formatMonthStartEndDays(num_month, year);
    formattedDate = date_array[2]+" "+date_array[1];
    fecha_fin_mes = date_array[4];
    
    [req_inicio, 
        req_fin,
        bitacora_dias, 
        bitacora_semanas, 
        bitacora_meses] = 
            bdoDates.getReportData(fecha_checklist,
                                    fecha_consulta, 
                                    tipo_consulta, 
                                    tipo_cliente, 
                                    num_interval,
                                    {},
                                    "es",
                                    "utensilios");
    if(dbg) console.log("[CR::114] Fecha Inicio/Fin = " + req_inicio, req_fin); 
    if(dbg) console.log("[CR::115] Bitacora meses = " + JSON.stringify(bitacora_meses)); 
    
    let results  = null;
    
    entries = [
        valor,
        valor,
        crplaza, 
        crtienda,
        req_inicio,
        req_fin
    ];
    tipo_headers = bitacora_meses;
    stmt="SELECT `xxbdo_respuestas_utensilios`.`id` AS rid, \
    `xxbdo_respuestas_utensilios`.`fecha_respuesta`, \
    `xxbdo_respuestas_utensilios`.`mes` AS mes_respuesta, \
    `xxbdo_respuestas_utensilios`.`año` AS año_respuesta, \
    IF(CONCAT(YEAR(`xxbdo_respuestas_utensilios`.`fecha_respuesta`), `xxbdo_respuestas_utensilios`.`mes`)=DATE_FORMAT(?, \"%Y%c\"), true, false) AS is_current, \
    DATE_SUB(LAST_DAY(NOW()),INTERVAL DAY(LAST_DAY(NOW())) - 1 DAY) AS fecha_inicial_mes_actual, \
    IF((DATE(NOW()) BETWEEN DATE_SUB(LAST_DAY(NOW()), INTERVAL DAY(LAST_DAY(NOW())) - 1 DAY) AND ?), 1, 0) AS es_editable, \
    `xxbdo_utensilios_categorias`.`id` AS `xxbdo_utensilios_categorias_id`, \
    `xxbdo_utensilios_categorias`.`nombre` AS nombre_categoria, \
    `xxbdo_respuestas_utensilios`.`cr_plaza`, \
    `xxbdo_respuestas_utensilios`.`cr_tienda`, \
    `xxbdo_utensilios`.`tipo`, \
    `xxbdo_utensilios`.`id` AS uid, \
    `xxbdo_utensilios`.`nombre` AS nombre_utensilio, \
    `xxbdo_utensilios`.`descripcion`, \
    `xxbdo_utensilios`.`uso`, \
    `xxbdo_respuestas_utensilios`.`respuesta`, \
    null AS titulo_respuesta, \
    `xxbdo_respuestas_utensilios`.`folio`, \
    `xxbdo_respuestas_utensilios`.`folio_color`, \
    DATE(`xxbdo_respuestas_utensilios`.`fecha_creacion`) AS `fecha_creacion`, \
    `xxbdo_respuestas_utensilios`.`recibido`, \
    `xxbdo_respuestas_utensilios`.`agregado_por` AS `agregado_por_rol`, \
    IF(`xxbdo_respuestas_utensilios`.`agregado_por`, \
     (SELECT `xxbdo_roles_en_tienda`.`nombre` \
      FROM `xxbdo_roles_en_tienda` \
      WHERE `xxbdo_roles_en_tienda`.`id`=`xxbdo_respuestas_utensilios`.`agregado_por` \
      LIMIT 1), \
      NULL) AS nombre_rol, \
    `xxbdo_utensilios_categorias`.`orden` AS orden_categoria, \
    `xxbdo_utensilios`.`orden` AS `orden_utensilio`, \
    `xxbdo_utensilios`.`seleccionable`, \
    `xxbdo_utensilios`.`foto`, \
    `xxbdo_utensilios`.`codigo`, \
    `xxbdo_utensilios`.`via_de_solicitud` \
    FROM `xxbdo_respuestas_utensilios`, \
    `xxbdo_utensilios`, \
    `xxbdo_utensilios_categorias` \
    WHERE `xxbdo_respuestas_utensilios`.`cr_plaza`=? \
    AND `xxbdo_respuestas_utensilios`.`cr_tienda`=? \
    AND `xxbdo_respuestas_utensilios`.`fecha_respuesta` BETWEEN ? AND ? \
    AND `xxbdo_respuestas_utensilios`.`xxbdo_utensilios_id`= `xxbdo_utensilios`.`id` \
    AND `xxbdo_respuestas_utensilios`.`agregado_por` IS NOT NULL \
    AND  `xxbdo_utensilios`.`xxbdo_utensilios_categorias_id`=`xxbdo_utensilios_categorias`.`id` \
    AND `xxbdo_respuestas_utensilios`.`activo`=1 \
    ORDER BY orden_categoria, \
    orden_utensilio, \
    año_respuesta, \
    mes_respuesta, \
    fecha_respuesta";
    qry=db.query(stmt, entries, (err, result) => {
    if(dbg) console.log("[UR:179] "+qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }
        
        if(dbg) console.log("[UR:185] Call getResultsData(result, valor):", valor);        
        results = getResultsData(
            result, 
            valor, 
            tipo_headers, 
            req.paleta_de_colores_hexadecimal_utensilios
        );

        req.resData = results;
        req.calendario_utensilios_inicio = req_inicio;
        req.calendario_utensilios_fin = req_fin;
        next();
    });
};

function getResultsData(rows, valor=null, tipo_headers=null, lista_colores='') {
    let info=null;
    let data_array={};
    let data_map={};
    let resp=[];
    let paleta_colores = lista_colores.split(',');
    let lista_folios = [];
    let folios = {};

    if(dbg) console.log("[UR:216] Start getResultsData...", valor);
    if(dbg) console.log("[UR:217] Lista de colores= ", lista_colores);

   if(rows) {
       if(rows.length>0) {
           let num_colores = paleta_colores.length;
           let num_color = 0;
            rows.forEach(row => {
                key = row.uid+"-"+row.año_respuesta+row.mes_respuesta;
                if(data_map[key]) {
                    resp = data_array[key];
                } else {
                    resp = [];
                }
                data_map[key] = true;
                motivo = "";
                folio_color=null;
                detalle_folio_recibido = bdoDates.getBDOFormattedDate(row.fecha_creacion, "es", "dddd[,] D MMMM YYYY") + " - " + row.nombre_rol;
                switch(row.respuesta) {
                    case "E": motivo = "Sin Existencia"; break;
                    case "C": motivo = "Malas Condiciones"; break;
                    default:break;
                }
                if(dbg) console.log("[UR:212] key(", row.fecha_respuesta, ") =", key);

                if((row.folio+"").length>0) {
                    if(lista_folios.includes(row.folio)) {
                        folio_color = folios[row.folio].color;
                        if(dbg) console.log("[UR:243] Folio ya existe: ", row.folio," color: ", folio_color);
                    } else {
                        lista_folios.push(row.folio);
                        folio_color = paleta_colores[num_color];
                        if(num_color < (num_colores - 1)) {
                            num_color++;
                        } else {
                            num_color=0;
                        }
                        folios[row.folio] = {"color":folio_color};
                        if(dbg) console.log("[UR:253] Folio nuevo: ", row.folio," color: ", folio_color);
                    }
                }
                
                info = {
                    "id":""+row.rid, // id de respuesta de checklist
                    "ttl":row.nombre_utensilio, //Nombre del utensilio
                    "flc":folio_color, //(row.folio_color ? row.folio_color : null), //folio color
                    "dfr":detalle_folio_recibido, // detalle de folio recibido
                    "mtv":motivo, //motivo
                    "fl":(row.folio ? row.folio : ""), //# de folio
                    "rcb":(row.recibido ? true : false), // folio marcado como recibido?
                    "fmr":(row.recibido ? bdoDates.getBDOFormattedDate(row.recibido, "es", "dddd[,] D MMMM YYYY", false, true) : null) // fecha de folio marcado como recibido
                };

                resp.push(info);
                data_array[key] = resp;
            });
       }
   }
   if(dbg) console.log("[UR:229] End getResultsData.");
   return [data_array, data_map, tipo_headers];
}
