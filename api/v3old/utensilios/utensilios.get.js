
const app_configuration = require('config');
const db = require("./../../../db");
bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

  exports.utensilios_get = (req, res, next) => {
    if(!db) {
      const error = new Error('Conexion a BD no encontrada!');
      error.status = 500;
      return next(error);
    }
    
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
    const error = new Error('crplaza o crtienda invalidos!');
    error.status = 400;
    return next(error);
    }
    
    let crplaza = req.tokenData.crplaza;
    let crtienda = req.tokenData.crtienda;
    let fecha_token = req.tokenData.fecha;
    let valor = req.params.valor || fecha_token;
    let year = null;
    let sql = null; 
    let entries = null;
    let results = null;
    let existe = false;
    
    if(valor) {
      req.checkParams('valor')
      .withMessage('valor Invalido!')
      .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)
      .trim();
    } else {
      valor = fecha_token;
    }

    errors = req.validationErrors();
    if (errors) {
        error = new Error('Datos de entrada invalidos!');
        error.status = 400;
        return next(error);
    }
    if(dbg) console.log("[UG:44] valor = " + valor);
    //
    if(bdoDates.isDateGreatherThanCurrent(valor)) {
      const error  = new Error('Fecha de respuesta ' + 
                     valor +
                     ' es mayor que la fecha actual!');
      error.status = 400;
      return next(error);
    }
    
    num_month = 
    bdoDates.getBDOFormattedDate(
        valor, 
        "es", 
        "M",
        true
    );
    
    year = 
    bdoDates.getBDOFormattedDate(
        valor, 
        "es", 
        "YYYY",
        true
    );
    if(dbg)console.log("[UG:70] Num month = "+num_month+" , year = "+year);
    //date_array = bdoDates.formatMonthStartEndDays(num_month, year);
    entries   = [crplaza, crtienda, num_month, year];

    sql="SELECT COUNT(*) AS respuestas \
    FROM `xxbdo_checklist_utensilios` \
    WHERE cr_plaza=? \
    AND cr_tienda=? \
    AND mes=? \
    AND año=? \
    AND activo=1";

    qry = db.query(sql, entries, (err, result) => {
        if(dbg) console.log("[UG:83] "+qry.sql);
    if (err) {
         err.status = 500;
         return next(err);
     }
     if(result[0].respuestas>0) {
        existe = true;
        sql="SELECT `xxbdo_checklist_utensilios`.`id`, \
        `xxbdo_checklist_utensilios`.`fecha_respuesta`, \
        MONTH(`xxbdo_checklist_utensilios`.`fecha_respuesta`) AS mes_respuesta, \
        YEAR(`xxbdo_checklist_utensilios`.`fecha_respuesta`) AS año_respuesta, \
        `xxbdo_utensilios_categorias_id`, \
        `xxbdo_utensilios_categorias`.`nombre` AS nombre_categoria, \
        `xxbdo_utensilios`.`nombre` AS nombre_utensilio, \
        `xxbdo_utensilios_categorias`.`orden` AS orden_categoria, \
        `xxbdo_utensilios`.`orden` AS orden_utensilio, \
        `xxbdo_utensilios`.`seleccionable`, \
        `xxbdo_checklist_utensilios`.`en_existencia`, \
        `xxbdo_checklist_utensilios`.`en_condiciones` \
        FROM `xxbdo_checklist_utensilios`, \
        `xxbdo_utensilios`, \
        `xxbdo_utensilios_categorias` \
        WHERE `xxbdo_checklist_utensilios`.`cr_plaza`=? \
        AND `xxbdo_checklist_utensilios`.`cr_tienda`=? \
        AND `xxbdo_checklist_utensilios`.`mes`=? \
        AND `xxbdo_checklist_utensilios`.`año`=? \
        AND `xxbdo_checklist_utensilios`.`activo`=1 \
        AND `xxbdo_utensilios`.`id` = `xxbdo_checklist_utensilios`.`xxbdo_utensilios_id` \
        AND `xxbdo_utensilios`.`xxbdo_utensilios_categorias_id` = `xxbdo_utensilios_categorias`.`id` \
        AND `xxbdo_utensilios`.`activo`=1 \
        AND `xxbdo_utensilios_categorias`.`activo`=1 \
        ORDER BY `xxbdo_utensilios_categorias`.`orden`, \
        `xxbdo_utensilios`.`orden`";
     } else {
      entries = [fecha_token, fecha_token, fecha_token];
         sql="SELECT `xxbdo_utensilios`.`id`, \
         DATE(?) AS `fecha_respuesta`, \
         MONTH(?) AS mes_respuesta, \
         YEAR(?) AS año_respuesta, \
         `xxbdo_utensilios_categorias_id`, \
         `xxbdo_utensilios_categorias`.`nombre` AS nombre_categoria, \
         `xxbdo_utensilios`.`nombre` AS nombre_utensilio, \
         `xxbdo_utensilios_categorias`.`orden` AS orden_categoria, \
         `xxbdo_utensilios`.`orden` AS orden_utensilio, \
         `xxbdo_utensilios`.`seleccionable`, \
         NULL as `en_existencia`, \
         NULL as `en_condiciones` \
         FROM `xxbdo_utensilios`,`xxbdo_utensilios_categorias` \
         WHERE `xxbdo_utensilios`.`xxbdo_utensilios_categorias_id` = `xxbdo_utensilios_categorias`.`id` \
         AND `xxbdo_utensilios`.`activo`=1 \
         AND `xxbdo_utensilios_categorias`.`activo`=1 \
         ORDER BY `xxbdo_utensilios_categorias`.`orden`, \
         `xxbdo_utensilios`.`orden`";
     }

     qry = db.query(sql, entries, (err, result) => {
      if(dbg) console.log("[UG:134] " + qry.sql);
      if (err) {
      err.status = 500;
      return next(err);
      }

      results = formatResults(result, existe);

      if(!results) {
      error  = new Error('No hay utensilios para '+valor+'!');
      error.status = 400;
      return next(error);
      }

      res.status(200).json(results);
    });
    });
};

function formatResults(rows, existe) {
  if(rows) {
      let results = [];
      let plantilla = null; 
      let fecha_respuesta = null;
      let mes = null;
      let año = null;

      if(rows.length>0) {
          let categorias = [];
          rows.forEach(row => {
              if(!categorias.includes(row.xxbdo_utensilios_categorias_id)) {
                  //is new 
                  categorias.push(row.xxbdo_utensilios_categorias_id);
                  results.push(
                      {
                       "categoria":row.nombre_categoria, 
                       "utensilios":[]
                      }
                  );
              }
              //
              aindx = categorias.indexOf(row.xxbdo_utensilios_categorias_id);

              res = {
                "id":row.id,
                "cat":row.nombre_categoria,
                "utl":row.nombre_utensilio,
                "isel":(row.seleccionable ? true : false),
                "iex":(row.en_existencia ? true : false),
                "iec":(row.en_condiciones ? true : false)
            };

              results[aindx].utensilios.push(res);
              fecha_respuesta = row.fecha_respuesta;
              mes = row.mes_respuesta;
              año = row.año_respuesta;
          });
          //
          plantilla = {
            "dt":fecha_respuesta,
            "mes":mes,
            "año":año,
            "existe":existe, 
            "checklist":results
        };
          //
      }
      return plantilla;
  }
  return;
}