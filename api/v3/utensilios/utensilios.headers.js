const db       = require ("../../../db");
const bdoDates = require ("../../helpers/bdo-dates");
const util     = require ('util');
const dbg      = false;

exports.update_headers = (req, res, next) => {
    if(dbg) console.log("[UH:7] Start utensilios update_headers...");
    if (!db) {
        const error  = new Error ('Conexion a BD no encontrada!');
        error.status = 500;
        return next (error);
    }
    //
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        const error  = new Error ('crplaza o crtienda inválidos!');
        error.status = 400;
        return next (error);
    }
    //
    if (!req.resData) {
        const error  = new Error ('Información de respuestas no generada!');
        error.status = 400;
        return next (error);
    }

    if(dbg) console.log("UH:26] Call getHeadersChecklists....");
    let fecha_token = req.tokenData.fecha;
    let crplaza = req.tokenData.crplaza;
    let crtienda = req.tokenData.crtienda;
    getHeadersChecklists (req.resData[2], fecha_token, crplaza, crtienda, (results) => {
        if(!results) {
            const error = new Error('Error al reasignar array de headers!');
            error.status = 400;
            return next(error);
        }
        
        if(dbg) console.log("[UH:37] call next...");
        req.resHeaders = results;
        next ();
        //res.status(200).json(results);
    });
    if(dbg) console.log("[UH:42] End update_headers.");
};

//callback function to run update queries in sync mode
//reference: https://www.codexpedia.com/javascript/nodejs-sync-nested-mysql-queries/
function getHeadersChecklists (items, fecha_token, cr_plaza, cr_tienda, cb) {
    if(dbg) console.log("UH:48] Start getHeadersChecklists....");
    if(items.length<1) {
        return;
    }
    //
    try {
        let dt_detalles = [], 
        stmt      = null,
        data      = null,
        pending   = items.length;
        items.forEach ((item) => {
            if(dbg) console.log("[UH: 56] Date = "+item.dt);
            stmt="SELECT `xxbdo_checklists_id` \
            FROM `xxbdo_checklists_tiendas` \
            WHERE cr_plaza=? \
            AND cr_tienda=? \
            AND DATE(?) \
            BETWEEN fecha_inicio \
            AND IFNULL(fecha_fin, '"+fecha_token+"')";
            //
            data = [cr_plaza, cr_tienda, item.dt];
            qry=db.query(stmt, data, (err, result) => {
                if(dbg) console.log("[UH:70] "+qry.sql);
                if(err) {
                    err.status = 500;
                    next(err);
                }
                if(result.length>0) {
                    if(dbg) console.log("[UH:76] "+item.dt+" = "+result[0].id);
                    item.ck = result[0].id;
                    dt_detalles.push(item);
                } else {
                    if(dbg) console.log("[UH:80] "+item.dt+" not found.");
                }
                
                if( 0 === --pending ) {
                    //callback if all queries are processed
                    cb(dt_detalles);
                }
                }
            );
        });
    } catch(error) {
        error.status = 500;
        throw error;
    }
}