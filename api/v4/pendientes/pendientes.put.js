const db = require("./../../../db");
const bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

exports.pendientes_put = (req, res, next) => {
    if(!db) {
        const error  = new Error('Conexion a BD no encontrada!');
        error.status = 500;
        return next(error);
    }

    //Validation chain
    req.checkBody('id')
       .isUUID(4)
       .withMessage('Formato de id(UUID4) inválido!')
       .trim();

    req.checkBody('st')
        .matches(/^$|^[^]/)
        .withMessage('Descripción del pendiente es requerido!')
        .trim();
    
    const errors = req.validationErrors();
    if (errors) {
      if(dbg) console.log(util.inspect(errors, {depth: null}));
      const error  = new Error('Información en body inválida!');
      error.status = 400;
      return next(error);
    }
    
    let pendientes_id = req.body.id;
    let status = req.body.st;
    let usuario = req.tokenData.usuario;
    let ip = req.app_client_ip_address;
    
    if(dbg) console.log("[37] Call putPendientes....");
    putPendientes(pendientes_id, status, usuario, ip, function(results) {
        if(!results) {
            const error = new Error('Error al ejecutar actualización de pendiente!');
            error.status = 400;
            return next(error);
        }
        res.status(200).json();
    });
    if(dbg) console.log("[46] End PUT pendientes method.");
};

//callback function to run update queries in sync mode
//reference: https://www.codexpedia.com/javascript/nodejs-sync-nested-mysql-queries/
function putPendientes(id, status, usuario, ip, cb) {
    try {
        let bdo_pendientes = [];
        let stmt = null;
        let pending = 1;
        let timestamp = bdoDates.getBDOCurrentTimestamp();
        let entries = [
            (status ? timestamp : null), 
            usuario, 
            ip, 
            timestamp, 
            id
        ];
        //items.forEach(function(item) {
            stmt = "UPDATE xxbdo_pendientes \
            SET fecha_terminacion=?, \
            usuario=?, \
            ip_address=?, \
            fecha_modificacion=? \
            WHERE id=?";
            qry=db.query(stmt, entries, 
                function(err, result) {
                    if(dbg) console.log("[73] "+qry.sql);
                    if(err) {
                        err.status = 500;
                        next(err);
                    }
                    bdo_pendientes.push(result);
                    if( 0 === --pending ) {
                        //callback if all queries are processed
                        cb(bdo_pendientes);
                    }
                }
            );
        //});
    } catch(error) {
        error.status = 500;
        throw error;
    }
}
