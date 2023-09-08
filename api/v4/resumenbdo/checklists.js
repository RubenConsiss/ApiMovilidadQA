
const db = require("../../../db");
const bdoDates = require("../../helpers/bdo-dates");
const util = require ('util');
const dbg = false;

exports.info = (req, res, next) => {
    if(dbg) console.log("[8] Start resumenbdo checklists ...");
    if(!db) {
        const error = new Error('Conexion a BD no encontrada!');
        error.status = 500;
        return next(error);
    }
    let fecha_token = req.tokenData.fecha;
    let cr_plaza = req.tokenData.crplaza || null;
    let cr_tienda = req.tokenData.crtienda || null;
    let fecha_consulta = req.body.fecha || 
                bdoDates.getBDOFormat(fecha_token, 'YYYY-MM-DD');
    let checklist_id = req.body.chk || null;
    let num_dias_consulta = null;
    let mes_consulta = null;
    let año_consulta = null;
    let fecha_consulta_inicio = null;
    let fecha_consulta_fin = null;
    let num_total_dias = null;

    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        const error  = new Error('crplaza o crtienda invalidos!');
        error.status = 400;
        return next(error);
    }

    req.checkBody('cliente')
    .matches(/^[1|2|3]/)//1:Handheld, 2:Tablet, 3:Web
    .withMessage('Tipo de cliente inválido!')
    .trim();

    req.checkBody('tipo')
        .matches(/^[D]/) //D:Diario, TO-DO: S:Semanal, M:Mensual
        .withMessage('Tipo de consulta inválido!')
        .trim();

    req.checkBody('fecha')
        .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)
        .withMessage('Formato de fecha inválido!')
        .trim();
    
    if(checklist_id) {
        req.checkBody('chk')
        .isUUID(4)
        .withMessage('Formato de checklist id inválido!')
        .trim();
    }

    errors = req.validationErrors();
    if (errors) {
        console.log(util.inspect(errors, {depth: null}));
        error = new Error('Datos de entrada invalido!');
        error.status = 400;
        return next(error);
    }

    isGreather = bdoDates.isDateGreatherThanCurrent(fecha_consulta);
      if(isGreather) {
        fecha_consulta = fecha_token;
      }

    sqlWhere = "DATE(?) BETWEEN `fecha_inicio` AND IFNULL(`fecha_fin`, ?)";
    data = [fecha_token, fecha_consulta, fecha_token, cr_plaza, cr_tienda];

    if(checklist_id) {
        data = [fecha_token, checklist_id, cr_plaza, cr_tienda];
        sqlWhere = "`xxbdo_checklists_id`=?";
    }
    
    //query para obtener checklist de fecha o id seleccionado
    stmt="SELECT `xxbdo_checklists_id` AS `id`, \
    `xxbdo_version_estandares_id` AS `veid`, \
    `fecha_inicio`, \
    `titulo_app`, \
    `titulo_indicadores_app`, \
    IFNULL(`fecha_fin`, ?) AS `fecha_limite` \
    FROM `xxbdo_checklists_tiendas` \
    WHERE "+sqlWhere+" \
    AND cr_plaza=? \
    AND cr_tienda=? \
    AND `activo`='1' \
    LIMIT 1";
    
    qry = db.query(stmt, data, (err, rst) => {
        if(dbg) console.log("[69] Get checklist from current date: ", qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }
        
        if(rst) {

            if(checklist_id) {
                fecha_consulta = rst[0].fecha_limite; 
            }

            num_dias_consulta = 
            bdoDates.getBDOFormattedDate(
                fecha_consulta, 
                "es", 
                "D",
                true
            );
      
          mes_consulta = 
          bdoDates.getBDOFormattedDate(
              fecha_consulta, 
              "es", 
              "M",
              true
          );
      
          año_consulta = 
          bdoDates.getBDOFormattedDate(
              fecha_consulta, 
              "es", 
              "YYYY",
              true
          );
      
          let fecha_info = bdoDates.formatMonthStartEndDays(mes_consulta, año_consulta);
      
          fecha_consulta_inicio = fecha_info[3];
          fecha_consulta_fin = fecha_info[4];
          num_total_dias = 
            bdoDates.getBDOFormattedDate(
              fecha_consulta_fin, 
                "es", 
                "D",
                true
            );

            req.checklist_id = rst[0].id;
            req.checklist_inicio = rst[0].fecha_inicio;
            req.checklist_fin = rst[0].fecha_limite;
            req.fecha_consulta = fecha_consulta;
            req.fecha_consulta_inicio = fecha_consulta_inicio;
            req.fecha_consulta_fin = fecha_consulta_fin;
            req.num_dias_consulta = num_dias_consulta;
            req.num_total_dias = num_total_dias;

            data = [cr_plaza, cr_tienda];
            stmt= "SELECT `xxbdo_checklists_tiendas`.`xxbdo_checklists_id` AS `id`, \
            `xxbdo_version_estandares`.`titulo_app` AS `ttl`, \
            `xxbdo_checklists_tiendas`.`es_default` AS `icr` \
            FROM `xxbdo_checklists_tiendas`, \
            `xxbdo_version_estandares` \
            WHERE `xxbdo_checklists_tiendas`.`cr_plaza`=? \
            AND `xxbdo_checklists_tiendas`.`cr_tienda`=? \
            AND `xxbdo_checklists_tiendas`.`xxbdo_version_estandares_id` \
            IN ( SELECT `id` FROM `xxbdo_version_estandares` WHERE `activo`='1' ) \
            AND `xxbdo_checklists_tiendas`.`xxbdo_version_estandares_id`=`xxbdo_version_estandares`.`id` \
            AND `xxbdo_checklists_tiendas`.`activo`='1' \
            AND `xxbdo_version_estandares`.`activo`='1' \
            ORDER BY `xxbdo_checklists_tiendas`.`fecha_inicio` DESC \
            LIMIT 2";
            qry = db.query(stmt, data, (err, result) => {
                if(dbg) console.log("[141] ", qry.sql);
                if (err) {
                    err.status = 500;
                    return next(err);
                }

                req.checklists_data = formatResults(result);
                next();
            });
        } else {
            error  = new Error('Checklist default no encontrado!');
            error.status = 400;
            return next(error);
        }
      });
};

function formatResults(results) {
    let fmtResults = [];
    if(results) {
        results.forEach(row => {
            fmtResults.push({
                "id": row.id,
                "ttl": row.ttl,
                "icr": (row.icr ? true : false),
            });
        });
        return fmtResults;
    }
    return;
}