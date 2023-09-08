
const db       = require ("../../../db");
const bdoDates = require ("../../helpers/bdo-dates");
const util     = require ('util');
const dbg      = false;

exports.utensilios_get = (req, res, next) => {
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

if (!req.resData) {
    const error  = new Error('Información de respuestas no generada!');
    error.status = 400;
    return next(error);
}

let crplaza = req.tokenData.crplaza;
let crtienda = req.tokenData.crtienda;
let token_checklist = req.tokenData.checklist;
let tipo_cliente = req.params.tipo_cliente || null;
let tipo_consulta = "M";
let valor = req.fecha_fin_version ||
            req.params.valor || 
            bdoDates.getBDOFormat(req.tokenData.fecha, 'YYYY-MM-DD');
let fecha_consulta = req.params.fecha_consulta || valor;
let year = req.params.year || 
           bdoDates.getBDOFormat(req.tokenData.fecha, 'YYYY');
let fecha_checklist = req.tokenData.fecha;
let fecha_actual = req.tokenData.fecha;
let sql = null;
let num_interval = 6; //show 6 months by default

req.checkParams('tipo_cliente')
.withMessage('Tipo de cliente invalido!')
.matches(/^$|^[1-3|{1}]/)//1=handheld | 2=tablet | 3=web
.trim();

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

  fecha_checklist = valor;

  num_month = 
        bdoDates.getBDOFormattedDate(
            valor, 
            "es", 
            "M",
            true
        );
        fmt_valor = num_month;
        
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

    num_interval = req.num_meses_vista_inicial_tablet_checklists_de_utensilios;
    if(tipo_cliente=='3') {
        num_interval = req.num_meses_vista_inicial_web_checklists_de_utensilios;
    }

let existe_dia = false;
let results = null;

sql="SELECT * FROM ( \
    SELECT `xxbdo_utensilios_categorias`.`id` AS `categoria_id`, \
    `xxbdo_utensilios_categorias`.`nombre` AS `categoria`, \
    `xxbdo_utensilios_categorias`.`descripcion` AS `categoria_descripcion`, \
    `xxbdo_utensilios_categorias`.`orden` AS `categoria_orden`, \
    `xxbdo_utensilios_categorias`.`tipo` AS `categoria_tipo`, \
    `xxbdo_utensilios`.`id` AS utensilio_id, \
    `xxbdo_utensilios`.`nombre` AS utensilio, \
    `xxbdo_utensilios`.`orden` AS utensilio_orden, \
    `xxbdo_utensilios`.`tipo` AS utensilio_tipo, \
    `xxbdo_utensilios`.`descripcion` AS utensilio_descripcion, \
    `xxbdo_utensilios`.`uso` AS utensilio_uso, \
    `xxbdo_utensilios`.`seleccionable` AS utensilio_seleccionable, \
    `xxbdo_utensilios`.`foto` AS utensilio_foto, \
    `xxbdo_utensilios`.`codigo` AS utensilio_codigo, \
    `xxbdo_utensilios`.`via_de_solicitud` AS utensilio_via_de_solicitud, \
    `xxbdo_utensilios_categorias`.`visible` AS `categoria_visible` \
    FROM `xxbdo_utensilios_categorias`, \
    `xxbdo_utensilios` \
    WHERE `xxbdo_utensilios`.`xxbdo_utensilios_categorias_id`=`xxbdo_utensilios_categorias`.`id` \
    AND `xxbdo_utensilios`.`tipo`='U' \
    AND `xxbdo_utensilios`.`activo`=1 \
    AND `xxbdo_utensilios_categorias`.`activo`=1 \
    UNION \
    SELECT `xxbdo_utensilios_categorias`.`id` AS `categoria_id`, \
    `xxbdo_utensilios_categorias`.`nombre` AS `categoria`, \
    `xxbdo_utensilios_categorias`.`descripcion` AS `categoria_descripcion`, \
    `xxbdo_utensilios_categorias`.`orden` AS `categoria_orden`, \
    `xxbdo_utensilios_categorias`.`tipo` AS `categoria_tipo`, \
    `xxbdo_utensilios`.`id` AS utensilio_id, \
    `xxbdo_utensilios`.`nombre` AS utensilio, \
    `xxbdo_utensilios`.`orden` AS utensilio_orden, \
    `xxbdo_utensilios`.`tipo` AS utensilio_tipo, \
    `xxbdo_utensilios`.`descripcion` AS utensilio_descripcion, \
    `xxbdo_utensilios`.`uso` AS utensilio_uso, \
    `xxbdo_utensilios`.`seleccionable` AS utensilio_seleccionable, \
    `xxbdo_utensilios`.`foto` AS utensilio_foto, \
    `xxbdo_utensilios`.`codigo` AS utensilio_codigo, \
    `xxbdo_utensilios`.`via_de_solicitud` AS utensilio_via_de_solicitud, \
    `xxbdo_utensilios_categorias`.`visible` AS `categoria_visible` \
    FROM `xxbdo_utensilios_categorias`, \
    `xxbdo_utensilios` \
    WHERE `xxbdo_utensilios`.`xxbdo_utensilios_categorias_id`=`xxbdo_utensilios_categorias`.`id` \
    AND `xxbdo_utensilios`.`tipo`='V' \
    AND `xxbdo_utensilios`.`cr_plaza` IS NULL \
    AND `xxbdo_utensilios`.`cr_tienda` IS NULL \
    AND `xxbdo_utensilios`.`activo`=1 \
    AND `xxbdo_utensilios_categorias`.`activo`=1 \
    UNION \
    SELECT `xxbdo_utensilios_categorias`.`id` AS `categoria_id`, \
    `xxbdo_utensilios_categorias`.`nombre` AS `categoria`, \
    `xxbdo_utensilios_categorias`.`descripcion` AS `categoria_descripcion`, \
    `xxbdo_utensilios_categorias`.`orden` AS `categoria_orden`, \
    `xxbdo_utensilios_categorias`.`tipo` AS `categoria_tipo`, \
    `xxbdo_utensilios`.`id` AS utensilio_id, \
    `xxbdo_utensilios`.`nombre` AS utensilio, \
    `xxbdo_utensilios`.`orden` AS utensilio_orden, \
    `xxbdo_utensilios`.`tipo` AS utensilio_tipo, \
    `xxbdo_utensilios`.`descripcion` AS utensilio_descripcion, \
    `xxbdo_utensilios`.`uso` AS utensilio_uso, \
    `xxbdo_utensilios`.`seleccionable` AS utensilio_seleccionable, \
    `xxbdo_utensilios`.`foto` AS utensilio_foto, \
    `xxbdo_utensilios`.`codigo` AS utensilio_codigo, \
    `xxbdo_utensilios`.`via_de_solicitud` AS utensilio_via_de_solicitud, \
    `xxbdo_utensilios_categorias`.`visible` AS `categoria_visible` \
    FROM `xxbdo_utensilios_categorias`, \
    `xxbdo_utensilios` \
    WHERE `xxbdo_utensilios`.`xxbdo_utensilios_categorias_id`=`xxbdo_utensilios_categorias`.`id` \
    AND `xxbdo_utensilios`.`tipo`='V' \
    AND `xxbdo_utensilios`.`cr_plaza`='"+crplaza+"' \
    AND `xxbdo_utensilios`.`cr_tienda`='"+crtienda+"' \
    AND `xxbdo_utensilios`.`activo`=1 \
    AND `xxbdo_utensilios_categorias`.`activo`=1 \
    ) AS tbl_varios \
    ORDER BY `tbl_varios`.`categoria_orden`, \
    `tbl_varios`.`utensilio_orden`";

qry=db.query(sql, (err, rows) => {
    if(dbg) console.log("[UG:179] "+qry.sql);
    if(err) {
        err.status=500;
        return next(err);
    }
    
    results = formatResults (
        token_checklist,
        req.resData,
        fecha_actual,
        fecha_consulta,
        num_interval,
        rows, 
        tipo_consulta, 
        tipo_cliente,
        existe_dia,
        req.utensilios_historial,
        req.permitir_creacion_checklist_utensilios_del_mes_actual,
        req.fecha_inicio_checklist_utensilios,
        req.utensilios_categorias,
        req.utensilios_categoria_varios_id,
        req.utensilios_categoria_varios_nombre
    );
    
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
    fecha_actual,
    fecha_consulta,
    num_interval,
    rows, 
    tipo_consulta, 
    tipo_cliente,
    existe_dia,
    utensilios_historial,
    permitir_creacion_checklist_utensilios_del_mes_actual,
    fecha_inicio_checklist_utensilios,
    utensilios_categorias,
    utensilios_categoria_varios_id,
    utensilios_categoria_varios_nombre
    ) {
if(rows) {
  let results = [];
  let plantilla   = null;
  let categorias = [];
  
  if(rows.length>0) {
      let areas = [];
      let [respuestas, resp_map] = respuestas_array;
      let [req_inicio, 
        req_fin,
        bitacora_dias, 
        bitacora_semanas, 
        bitacora_meses] = 
            bdoDates.getReportData(date_checklist,
                fecha_consulta, 
                tipo_consulta, 
                tipo_cliente,
                num_interval, 
                resp_map, 
                "es",
                "utensilios"
                );

                c_headers = bitacora_meses;

        if(dbg) console.log("[CE:435] respuestas = "+JSON.stringify(respuestas));
        if(dbg) console.log("[CE:436] respuestas-map = "+JSON.stringify(resp_map));
        if(dbg) console.log("[CE:437] headers = "+JSON.stringify(c_headers));
        if(dbg) console.log("[CE:250] utensilios_historial = "+JSON.stringify(utensilios_historial));
        categorias.push({"id":"", "nm":"TODAS", "tp":null});

      rows.forEach(row => {
          if(!areas.includes(row.categoria_id)) {
              areas.push(row.categoria_id);
              results.push({"id":row.categoria_id, "ctg":row.categoria, "utns":[]});
              categorias.push({"id":row.categoria_id, "nm":row.categoria, "tp":row.categoria_tipo});
          }
          
          aindx = areas.indexOf(row.categoria_id);
          if(!existe_dia) {
              rsps_array = [], nelem=0;

                    c_headers.forEach( drow => {
                        ukey = row.utensilio_id+"*";
                        rkey = ukey+(drow.dt ? drow.dt : "");
                        //if(dbg) console.log("[CE:266] key =  "+rkey);
                        utensilio_seleccionable = (row.utensilio_seleccionable ? true : false); 
                        if(utensilios_historial[rkey]) {
                            utensilio_seleccionable = false;
                            if(dbg) console.log("[CE:273] Utensilio desactivado: "+rkey);
                        }
                        if(utensilios_historial[ukey]) {
                            ndate = drow.dt;
                            kdate = utensilios_historial[ukey];
                            if(ndate.replace(/-/g, "") > kdate.replace(/-/g, "")) {
                                utensilio_seleccionable = false;
                                if(dbg) console.log("[CE:273] Utensilio desactivado a partir de: "+utensilios_historial[ukey]);
                            }
                            
                        }
                        prop = {
                            "id":row.utensilio_id,
                            "tp":row.categoria_tipo,
                            "hlp":(row.categoria_tipo=="V" ? false : true),
                            //fecha última del mes
                            "nm":drow.dt, 
                            //es fecha en el mes seleccionado?
                            //"sl":(fecha_consulta==drow.dt ? true : false), 
                            //es mes actual?
                            //"cr":drow.cr,  
                            "usl":utensilio_seleccionable,
                            "res":null
                            };
                        rkey = row.utensilio_id+"-"+drow.yr+drow.nm;
                        if(respuestas[rkey]) {
                            if(dbg) console.log("[CE:273] Existe en respuestas: "+rkey);
                            prop.res = respuestas[rkey];
                        } else {
                            //if(dbg) console.log("[CE:276] No Existe en respuestas: "+rkey);
                        }
                        rsps_array.push(prop);
                        nelem++;
                    });

            res = {
                "id":row.categoria_id,
                "uid":row.utensilio_id,
                "ctg":row.categoria,
                "tp":row.categoria_tipo,
                "hlp":(row.categoria_tipo=="V" ? false : true),
                "ttl":row.utensilio,
                "usl":(row.utensilio_seleccionable ? true : false),
                "rsps":rsps_array 
            };
          results[aindx].utns.push();
      }
          results[aindx].utns.push(res);
      });

      if(!areas.includes(utensilios_categoria_varios_id)) {
        results.push({"ctg":utensilios_categoria_varios_nombre, "utns":[]});
    }

      plantilla = {
        "fi":fecha_inicio_checklist_utensilios,
        "sl":fecha_consulta,
        "dt":fecha_actual,
        "ccu":(permitir_creacion_checklist_utensilios_del_mes_actual? true : false),
        "ctgs":categorias, //(utensilios_categorias ? utensilios_categorias : categorias),
        "hdrs":c_headers,
        "checklist":results
    };
  }
  return plantilla;
}
return;
}
