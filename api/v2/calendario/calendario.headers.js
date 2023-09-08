const db       = require ("../../../db");
const bdoDates = require ("../../helpers/bdo-dates");
const util     = require ('util');
const dbg      = false;

exports.update_headers = (req, res, next) => {
    if(dbg) console.log("[7] Start update_headers...");
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

    if(dbg) console.log("CH:26] Call getHeadersChecklists....");
    let fecha_token = req.tokenData.fecha;
    getHeadersChecklists (req.resData[2], fecha_token, (results) => {
        if(!results) {
            const error = new Error('Error al reasignar array de headers!');
            error.status = 400;
            return next(error);
        }
        
        if(dbg) console.log("[CH:34] call next...");
        req.resHeaders = results;
        next ();
        //res.status(200).json(results);
    });
    if(dbg) console.log("[CH:39] End update_headers.");
};

//callback function to run update queries in sync mode
//reference: https://www.codexpedia.com/javascript/nodejs-sync-nested-mysql-queries/
function getHeadersChecklists (items, fecha_token, cb) {
    if(dbg) console.log("CH:45] Start getHeadersChecklists....");
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
            if(dbg) console.log("[CH: 56] Date = "+item.dt);
            stmt="SELECT `id` FROM `xxbdo_checklists` where DATE(?) between fecha_inicio and IFNULL(fecha_fin, '"+fecha_token+"')";
            //
            data = [item.dt];
            qry=db.query(stmt, data, (err, result) => {
                if(dbg) console.log("[CH:61] "+qry.sql);
                if(err) {
                    err.status = 500;
                    next(err);
                }
                if(dbg) console.log("[CH:66] "+item.dt+" = "+result[0].id);
                item.ck = result[0].id;
                dt_detalles.push(item);
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