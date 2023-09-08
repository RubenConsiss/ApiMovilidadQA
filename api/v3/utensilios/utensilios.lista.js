
const db       = require ("../../../db");
const bdoDates = require ("../../helpers/bdo-dates");
const util     = require ('util');
const dbg      = false;

exports.catalogo = (req, res, next) => {
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
    let valor = req.params.valor || 
                bdoDates.getBDOFormat(req.tokenData.fecha, 'YYYY-MM-DD');
    let year = req.params.year || 
            bdoDates.getBDOFormat(req.tokenData.fecha, 'YYYY');
    let fecha_actual = req.tokenData.fecha;
    let sql = null;

    num_month = bdoDates.getBDOFormattedDate(
            valor, 
            "es", 
            "M",
            true
        );
        fmt_valor = num_month;

    mes = bdoDates.getBDOFormattedDate(
            valor, 
            "es", 
            "MMMM",
            true
        ),
        
    year = bdoDates.getBDOFormattedDate(
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

    let results = null;

    entries = [
        crplaza, 
        crtienda,
        fecha_actual,
        fecha_actual,
        fecha_actual,
        req.num_maximo_de_folios_por_utensilio,
        crplaza, 
        crtienda,
        fecha_actual,
        fecha_actual,
        fecha_actual,
        req.num_maximo_de_folios_por_utensilio,
        crplaza, 
        crtienda,
        fecha_actual,
        fecha_actual,
        fecha_actual,
        req.num_maximo_de_folios_por_utensilio,
        crplaza, 
        crtienda
    ];

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
    `xxbdo_utensilios_categorias`.`visible` AS `categoria_visible`, \
    IF((SELECT COUNT(*) \
    FROM `xxbdo_respuestas_utensilios` \
    WHERE `xxbdo_respuestas_utensilios`.`cr_plaza`=? \
    AND `xxbdo_respuestas_utensilios`.`cr_tienda`=? \
    AND `xxbdo_respuestas_utensilios`.`xxbdo_utensilios_id`=`xxbdo_utensilios`.`id` \
    AND `xxbdo_respuestas_utensilios`.`respuesta` NOT IN('OK','NA')  \
    AND DATE(`xxbdo_respuestas_utensilios`.`fecha_respuesta`) \
    BETWEEN DATE_SUB(LAST_DAY(?), INTERVAL DAY(LAST_DAY(?))- 1 DAY) \
    AND LAST_DAY(?) \
    )>(?-1),0,1) AS agregar_folio \
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
    `xxbdo_utensilios_categorias`.`visible` AS `categoria_visible`, \
    IF((SELECT COUNT(*) \
    FROM `xxbdo_respuestas_utensilios` \
    where `xxbdo_respuestas_utensilios`.`cr_plaza`=? \
    AND `xxbdo_respuestas_utensilios`.`cr_tienda`=? \
    AND `xxbdo_respuestas_utensilios`.`xxbdo_utensilios_id`=`xxbdo_utensilios`.`id` \
    AND `xxbdo_respuestas_utensilios`.`respuesta` NOT IN('OK','NA')  \
    AND DATE(`xxbdo_respuestas_utensilios`.`fecha_respuesta`) \
    BETWEEN DATE_SUB(LAST_DAY(?), INTERVAL DAY(LAST_DAY(?))- 1 DAY) \
    AND LAST_DAY(?) \
    )>(?-1),0,1) AS agregar_folio \
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
    `xxbdo_utensilios_categorias`.`visible` AS `categoria_visible`, \
    IF((SELECT COUNT(*) \
    FROM `xxbdo_respuestas_utensilios` \
    WHERE `xxbdo_respuestas_utensilios`.`cr_plaza`=? \
    AND `xxbdo_respuestas_utensilios`.`cr_tienda`=? \
    AND `xxbdo_respuestas_utensilios`.`xxbdo_utensilios_id`=`xxbdo_utensilios`.`id` \
    AND `xxbdo_respuestas_utensilios`.`respuesta` NOT IN('OK','NA')  \
    AND DATE(`xxbdo_respuestas_utensilios`.`fecha_respuesta`) \
    BETWEEN DATE_SUB(LAST_DAY(?), INTERVAL DAY(LAST_DAY(?))- 1 DAY) \
    AND LAST_DAY(?) \
    )>(?-1),0,1) AS agregar_folio \
    FROM `xxbdo_utensilios_categorias`, \
    `xxbdo_utensilios` \
    WHERE `xxbdo_utensilios`.`xxbdo_utensilios_categorias_id`=`xxbdo_utensilios_categorias`.`id` \
    AND `xxbdo_utensilios`.`tipo`='V' \
    AND `xxbdo_utensilios`.`cr_plaza`=? \
    AND `xxbdo_utensilios`.`cr_tienda`=? \
    AND `xxbdo_utensilios`.`activo`=1 \
    AND `xxbdo_utensilios_categorias`.`activo`=1 \
    ) AS tbl_varios \
    ORDER BY `tbl_varios`.`categoria_orden`, \
    `tbl_varios`.`utensilio_orden`";

qry=db.query(sql, entries, (err, rows) => {
    if(dbg) console.log("[UL:189] "+qry.sql);
    if(err) {
        err.status=500;
        return next(err);
    }
    
    results = formatResults (
        fecha_actual,
        year,
        mes,
        rows, 
        req.permitir_creacion_checklist_utensilios_del_mes_actual,
        req.permitir_nuevo_utensilio_mes_actual,
        req.utensilios_roles_en_tienda,
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

function formatResults(
    fecha_actual,
    year,
    mes,
    rows, 
    permitir_creacion_checklist_utensilios_del_mes_actual,
    permitir_nuevo_utensilio_mes_actual,
    roles_en_tienda,
    utensilios_categorias,
    utensilios_categoria_varios_id,
    utensilios_categoria_varios_nombre
    ) {
if(rows) {
  let results = [];
  let plantilla = null;
  let categorias = [];
  let areas = [];

  if(rows.length>0) {

    categorias.push({"id":"", "nm":"TODAS"});

    rows.forEach(row => {
        if(!areas.includes(row.categoria_id)) {
            areas.push(row.categoria_id);
            results.push({"ctg":row.categoria, "tp":row.categoria_tipo, "utns":[]});
            categorias.push({"id":row.categoria_id, "nm":row.categoria});
        }
          
        aindx = areas.indexOf(row.categoria_id);
        rsps_array = [], nelem=0;
        agregar_folio = (
            permitir_creacion_checklist_utensilios_del_mes_actual 
            ? 
            (row.agregar_folio ? true : false) 
            : 
            false 
        );

        res = {
            //"cid":row.categoria_id,
            "id":row.utensilio_id,
            "ctg":row.categoria,
            "ttl":row.utensilio,
            "usl":(row.utensilio_seleccionable ? true : false),
            "afl":agregar_folio,
            "tp":row.categoria_tipo
        };

        results[aindx].utns.push();
        results[aindx].utns.push(res);
    });

    if(!areas.includes(utensilios_categoria_varios_id)) {
        results.push({"ctg":utensilios_categoria_varios_nombre, "utns":[]});
    }

      let crear_nuevo_utensilio = (
        permitir_creacion_checklist_utensilios_del_mes_actual 
        ? 
        (permitir_nuevo_utensilio_mes_actual ? true : false) 
        : false
      );
      plantilla = {
        "yr":year,
        "nm":mes,
        "dt":fecha_actual,
        "ccu":(permitir_creacion_checklist_utensilios_del_mes_actual? true : false),
        "cnu":crear_nuevo_utensilio,
        "ctgs":(utensilios_categorias ? utensilios_categorias : categorias),
        "roles":roles_en_tienda,
        "checklist":results
    };
  }
  return plantilla;
}
return;
}
