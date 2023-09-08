
const db = require("../../../db");
const util = require ('util');
const dbg = false;

exports.checklists = (req, res, next) => {
    if(dbg) console.log("[CC:7] Start calendario_checklists ...");
    if(!db) {
        const error = new Error('Conexion a BD no encontrada!');
        error.status=500;
        return next(error);
    }
    let fecha_token = req.tokenData.fecha;
    let valor = req.params.valor || 
                bdoDates.getBDOFormat(fecha_token, 'YYYY-MM-DD');
    let checklist_id = req.params.checklist_id || null;
    let cr_plaza = req.tokenData.crplaza || null;
    let cr_tienda = req.tokenData.crtienda || null;

    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        const error  = new Error('crplaza o crtienda invalidos!');
        error.status = 400;
        return next(error);
    }

    sqlWhere = "DATE(?) BETWEEN `fecha_inicio` AND IFNULL(`fecha_fin`, ?)";

    if(checklist_id) {
        req.checkParams('checklist_id')
        .isUUID(4)
        .withMessage('Formato de checklist id invalido!')
        .trim();
        valor = null;
        data = [fecha_token, checklist_id, fecha_token, cr_plaza, cr_tienda];
        sqlWhere = "`id`=?";
    }

    if(valor) {
        req.checkParams('valor')
        .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)
        .withMessage('Formato de fecha invalido!')
        .trim();
       data = [fecha_token, valor, fecha_token, cr_plaza, cr_tienda];
    }

    errors = req.validationErrors();
    if (errors) {
      console.log(util.inspect(errors, {depth: null}));
      error = new Error('Datos de entrada invalido!');
      error.status = 400;
      return next(error);
    }
    
    //query para obtener checklist de fecha o id seleccionado
    stmt="SELECT `xxbdo_checklists_id` AS `id`, \
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
        if(dbg) console.log("[CC:62] Get checklist from current date: ", qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }
        
        if(rst) {
            req.checklist_id = rst[0].id;
            req.titulo_app = rst[0].titulo_app;
            req.titulo_indicadores_app = rst[0].titulo_indicadores_app;
            req.checklist_inicio = rst[0].fecha_inicio;
            req.checklist_fin = rst[0].fecha_limite;
            if(dbg) console.log("[CC:72] checklist from current date =", req.checklist_id, req.checklist_inicio, req.checklist_fin);

            if(checklist_id) {
                req.fecha_fin_version = req.checklist_fin;
            }

            stmt= "SELECT `xxbdo_checklists`.`id`, \
            `xxbdo_version_estandares`.`titulo_app` AS `ttl`, \
            `xxbdo_checklists`.`es_default` AS `icr` \
            FROM `xxbdo_checklists`, \
            `xxbdo_version_estandares` \
            WHERE `xxbdo_checklists`.`xxbdo_version_estandares_id` \
            IN ( SELECT `id` FROM `xxbdo_version_estandares` WHERE `activo`='1' ) \
            AND `xxbdo_checklists`.`xxbdo_version_estandares_id`=`xxbdo_version_estandares`.`id` \
            AND `xxbdo_checklists`.`activo`='1' \
            AND `xxbdo_version_estandares`.`activo`='1' \
            ORDER BY `xxbdo_checklists`.`fecha_inicio` \
            LIMIT 2";
            qry = db.query(stmt, (err, result) => {
                if(dbg) console.log("[CC:84] ", qry.sql);
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
                //"tti": row.tti,
                "icr": (row.icr ? true : false),
            });
        });
        return fmtResults;
    }
    return;
}