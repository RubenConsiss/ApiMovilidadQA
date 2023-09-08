const db       = require("./../../../db"),
      bdoDates = require("./../../helpers/bdo-dates"),
      util     = require('util'),
      dbg      = false;

exports.indicadores_put = (req, res, next) => {
    if(!db) {
        const error  = new Error('Conexion a BD no encontrada!');
        error.status = 500;
        return next(error);
    }
    //Validation chain
    req.checkBody('resp.*.id')
       .isUUID(4)
       .withMessage('Formato de id(UUID4) inválido!')
       .trim();
    req.checkBody('resp.*.res')
        .matches(/^$|^[^]/)
        .withMessage('Respuesta de indicador inválida!')
        .trim();
    
    const errors = req.validationErrors();
    if (errors) {
      if(dbg) console.log(util.inspect(errors, {depth: null}));
      const error  = new Error('Información en body inválida!');
      error.status = 400;
      return next(error);
    }
    //
    let respuestas = req.body.resp,
        usuario    = req.tokenData.usuario,
        ip         = req.app_client_ip_address;
    //
    if(!respuestas || respuestas.length<1) {
        const error  = new Error('Respuestas no recibidas!');
        error.status = 400;
        return next(error);
    }
    //
    if(dbg) console.log("[40] Call putIndicadores....");
    putIndicadores(respuestas, usuario, ip, function(results) {
        if(!results) {
            const error = new Error('Error al ejecutar actualización de respuestas!');
            error.status = 400;
            return next(error);
        }
        res.status(200).json();
    });
    if(dbg) console.log("[49] End PUT indicadores method.");
};

//callback function to run update queries in sync mode
//reference: https://www.codexpedia.com/javascript/nodejs-sync-nested-mysql-queries/
function putIndicadores(items, usuario, ip, cb) {
    if(items.length<1) {
        return;
    }
    //
    try {
        let bdo_indicadores = [], 
        stmt      = null,
        pending   = items.length,
        timestamp = bdoDates.getBDOCurrentTimestamp();
        items.forEach(function(item) {
            stmt = "UPDATE xxbdo_respuestas_indicadores \
            SET respuesta=?, \
            usuario=?, \
            ip_address=?, \
            fecha_modificacion=? \
            WHERE id=?";
            qry=db.query(stmt, [item.res, usuario, ip, timestamp, item.id], 
                function(err, result) {
                    if(dbg) console.log("[73] "+qry.sql);
                    if(err) {
                        err.status = 500;
                        next(err);
                    }
                    bdo_indicadores.push(result);
                    if( 0 === --pending ) {
                        //callback if all queries are processed
                        cb(bdo_indicadores);
                    }
                }
            );
        });
    } catch(error) {
        error.status = 500;
        throw error;
    }
}
