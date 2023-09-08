const db       = require ("../../../db");
const bdoDates = require ("../../helpers/bdo-dates");
const util     = require ('util');
const dbg      = false;

let dt_detalles = [];
let stmt = null;
let data = null;
let chkid = null;
let nitem = 0;

exports.update_headers = (req, res, next) => {
    if(dbg) console.log("[CH:13] Start update_headers...");
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
    
    let cr_plaza = req.tokenData.crplaza || null;
    let cr_tienda = req.tokenData.crtienda || null; 

    if (!req.resData) {
        const error  = new Error ('Información de respuestas no generada!');
        error.status = 400;
        return next (error);
    }

    if(dbg) console.log("CH:35] Call getHeadersChecklists....");
    let fecha_token = req.tokenData.fecha;
    getHeadersChecklists (cr_plaza, cr_tienda, fecha_token, req.resData[2], (headers_data) => {
        if(!headers_data) {
            const error = new Error('Error al reasignar array de headers!');
            error.status = 400;
            return next(error);
        }
        
        if(dbg) console.log("[CH:44] headers_data = ", headers_data);
        req.resHeaders = headers_data;
        if(dbg) console.log("[CH:46] call next...");
        next();
        //res.status(200).json(results);
    });
    if(dbg) console.log("[CH:50] End update_headers.");
};

//callback function to run update queries in sync mode
//reference: https://www.codexpedia.com/javascript/nodejs-sync-nested-mysql-queries/
function getHeadersChecklists (cr_plaza, cr_tienda, fecha_token, items, cb) {
    if(dbg) console.log("CH:56] Start getHeadersChecklists....");
    if(items.length<1) {
        return;
    }
    //
    //try {
        //let dt_detalles = [];
        //let stmt = null;
        //let data = null;
        //let chkid = null;
        let pending = items.length;
        //let nitem = 0;

        //
        /*for(var i in items) {
            if(dbg) console.log("[CH:71] nitem= ",nitem,": i= ",i," : pending= ",pending," : date= "+items[i].dt);
            stmt="SELECT `xxbdo_checklists_id` AS `id` \
            FROM `xxbdo_checklists_tiendas` \
            WHERE cr_plaza='"+cr_plaza+"' \
            AND cr_tienda='"+cr_tienda+"' \
            AND DATE('"+items[nitem].dt+"') \
            BETWEEN fecha_inicio \
            AND IFNULL(fecha_fin, '"+fecha_token+"')";
            //
            //if(dbg) console.log("[CH:80] stmt= ", stmt);
            data = [cr_plaza, cr_tienda, items[i].dt, fecha_token];
            qry=db.query("SELECT `xxbdo_checklists_id` AS `id` \
            FROM `xxbdo_checklists_tiendas` \
            WHERE cr_plaza=? \
            AND cr_tienda=? \
            AND DATE(?) \
            BETWEEN fecha_inicio \
            AND IFNULL(fecha_fin, ?) \
            LIMIT 1", data, (err, result) => {//data
                if(err) {
                    err.status = 500;
                    next(err);
                }
                chkid = result[0].id;// (result.length>1 ? result[0].id : result.id);
                if(dbg) console.log("[CH:95] nitem= ", nitem," : i= ", i,": pending= ", pending," | chkid= ",chkid," : dt= (",items[nitem].dt,') = ', qry.sql);
                //if(dbg) console.log("[CH:81] result = (", result);
                
                //if(dbg) console.log("[CH:83] ("+result.length+")"+items[pending-1].dt+" = "+chkid);
                //if(dbg) console.log("[CH:85] pending = ", pending, " : pending-1= ", (pending-1));
                //if(dbg) console.log("[CH:88] item = ", items[pending-1]);
                items[nitem].ck = chkid; //result[0].id;
                items[nitem].test = chkid; //result[0].id;
                dt_detalles.push(items[nitem]);
                nitem++;
                if( 0 === --pending ) {
                    cb(dt_detalles); //callback if all queries are processed
                }
            });
            if(dbg) console.log("[CH:109] End nitem= ", nitem,": ", items[i].dt);
        } */
        //
        items.forEach ((item) => {
            if(dbg) console.log("[CH:60] Date = "+item.dt);
            stmt="SELECT `xxbdo_checklists_id` AS `id` \
            FROM `xxbdo_checklists_tiendas` \
            WHERE cr_plaza=? \
            AND cr_tienda=? \
            AND DATE(?) \
            BETWEEN fecha_inicio \
            AND IFNULL(fecha_fin, ?)";
            //
            data = [cr_plaza, cr_tienda, item.dt, fecha_token];
            qry=db.query(stmt, data, (err, result) => {
                if(dbg) console.log("[CH:73] "+qry.sql);
                if(err) {
                    err.status = 500;
                    next(err);
                }
                chkid = (result.length>1 ? result[0].id : result.id);
                if(dbg) console.log("[CH:79] ("+result.length+")"+item.dt+" = "+chkid);
                item.ck = chkid; //result[0].id;
                dt_detalles.push(item);
                if( 0 === --pending ) {
                    //callback if all queries are processed
                    cb(dt_detalles);
                }
                }
            );
        });
    //} catch(error) {
    //    error.status = 500;
    //    throw error;
    //}
}