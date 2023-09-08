/*

/estandares

9) servicio PUT para actualizar detalle de estándar libre
9.1) PUT bdo/v4/estandares

*/

const db = require("./../../../db");
const bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

exports.estandares_put = (req, res, next) => {
    if(!db) {
        const error  = new Error('Conexion a BD no encontrada!');
        error.status = 500;
        return next(error);
    }

    //Validation chain
    req.checkBody('id')
       .isUUID(4)
       .withMessage('Formato de estándar id(UUID4) inválido!')
       .trim();

    //req.checkBody('res')
    //    .matches(/^$|^[^]/)
    //    .withMessage('Descripción del indicador es requerido!')
    //    .trim();
    
    const errors = req.validationErrors();
    if (errors) {
      if(dbg) console.log(util.inspect(errors, {depth: null}));
      const error  = new Error('Información en body inválida!');
      error.status = 400;
      return next(error);
    }
    
    let estandares_id = req.body.id || null;
    let titulo = req.body.tl || "";
    let detalle = req.body.dtl || "";
    let descripcion = req.body.dsc || "";
    let usuario = req.tokenData.usuario;
    let ip = req.app_client_ip_address;
    
    if(dbg) console.log("[EP:48] Call putEstandares....");
    if(!estandares_id) {
        const error  = new Error('Información incompleta para guardar estándar!');
      error.status = 400;
      return next(error);
    } else {
        putEstandares(estandares_id, 
            titulo,
            detalle,
            descripcion,
            usuario, 
            ip, 
            function(results) {
            if(!results) {
                const error = new Error('Error al ejecutar actualización de estándar!');
                error.status = 400;
                return next(error);
            }
            res.status(200).json();
        });
    }
    if(dbg) console.log("[EP:69] End PUT estandares method.");
};

//callback function to run update queries in sync mode
//reference: https://www.codexpedia.com/javascript/nodejs-sync-nested-mysql-queries/
function putEstandares(estandares_id, 
    titulo,
    detalle,
    descripcion,
    usuario, 
    ip, 
    cb) {
    try {
        let bdo_estandares = [];
        let stmt = null;
        let pending = 1;
        let timestamp = bdoDates.getBDOCurrentTimestamp();
        let entries = null;
        //items.forEach(function(item) {
            if(estandares_id) {
                entries = [
                    titulo, 
                    detalle, 
                    descripcion,
                    usuario,
                    ip, 
                    timestamp, 
                    estandares_id
                ]
                stmt = "UPDATE xxbdo_estandares \
                SET titulo=?, \
                detalle=?, \
                descripcion=?, \
                usuario=?, \
                ip_address=?, \
                fecha_modificacion=? \
                WHERE id=?";
            }
            
            qry = db.query(stmt, entries, 
                function(err, result) {
                    if(dbg) console.log("[EP:110] ", qry.sql);
                    if(err) {
                        err.status = 500;
                        next(err);
                    }
                    bdo_estandares.push(result);
                    if( 0 === --pending ) {
                        //callback if all queries are processed
                        cb(bdo_estandares);
                    }
                }
            );
        //});
    } catch(error) {
        error.status = 500;
        throw error;
    }
}