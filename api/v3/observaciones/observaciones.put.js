const db       = require("./../../../db"),
      bdoDates = require("./../../helpers/bdo-dates");
      const util = require('util');


exports.observaciones_put = (req, res, next) => {
    if(!db) {
        const error = new Error('Conexion a BD no encontrada!');
        error.status=500;
        return next(error);
    }
    //Validation chain
    req.checkBody('id')
       .isUUID(4)
       .withMessage('Formato de id invalido!')
       .trim();
    req.checkBody('descripcion')
        .trim();
        req.checkBody('causa')
        .trim();
    req.checkBody('accion_resp_fecha')
        .trim();
    req.checkBody('ajuste_ata')
        .matches(/^$|^[0-1|{1}]/)
        .trim();
    req.checkBody('seguimiento')
        .matches(/^$|^[0-1|{1}]/)
        .trim();
    req.checkBody('cierre_efectiva')
        .matches(/^$|^[0-1|{1}]/)
        .trim();
    req.checkBody('folio')
        .trim();
    req.checkBody('turno')
        .matches(/^$|^[N|M|T]{1}/)
        .withMessage('Turno invalido!')
        .trim();
    req.checkBody('bfoto')
        .matches(/^$|^[0-1|{1}]/)
        .trim();
    //
    const errors = req.validationErrors();
    if (errors) {
      //console.log(util.inspect(errors, {depth: null}));
      const error = new Error('Datos de observacion invalidos!');
      error.status=400;
      return next(error);
    }
    //
    let observaciones_id  = req.body.id, 
        descripcion       = req.body.descripcion,
        causa             = req.body.causa || "",
        accion_responsable_fecha = req.body.accion_resp_fecha || "",
        ajuste_ata        = req.body.ajuste_ata || null,
        hay_seguimiento   = req.body.seguimiento || null,
        es_cierre_efectiva = req.body.cierre_efectiva || null,
        folio             = req.body.folio,
        turno             = req.body.turno,
        borrar_foto       = req.body.bfoto,
        ip                = req.app_client_ip_address;
   //
  let usuario = req.tokenData.usuario,
      data    = null,
      stmt    = null,
      foto    = null;
     //
     stmt = "SELECT COUNT(*) AS observacion FROM xxbdo_observaciones WHERE id=?";
    data  = [observaciones_id];
    //
    db.query(stmt, data, (err, rst) => {
        if (err) {
            err.status = 500;
            return next(err);
        }
        //check if observacion already exists
        if(rst.length>0) {
            if(rst[0].observacion<1) {
                //daily record already exists, ignore checklist
                const error  = new Error('Observacion no existe!');
                error.status = 400;
                return next(error);
            }
            //
            //console.log("PUT: Check files array...");
            foto = null;
            if(req.files) {
                if(req.files.length>0) {
                    foto = req.files[0].blobPath;
                }
            }
            //
            let observaciones = [
                {
                    id:observaciones_id, 
                    descripcion:descripcion,
                    causa:causa,
                    accion_responsable_fecha:accion_responsable_fecha,
                    ajuste_ata:ajuste_ata,
                    hay_seguimiento:hay_seguimiento,
                    es_cierre_efectiva:es_cierre_efectiva,
                    folio:folio,
                    foto:foto, 
                    bfoto:borrar_foto,
                    turno:turno,
                    usuario:usuario,
                    ip:ip
                }
            ];
            //
            putBdoObservacion(observaciones, req.tokenData.tz, function(results) {
                if(!results) {
                    const error  = 
                        new Error('Error al ejecutar actualizacion de observacion!');
                    error.status = 500;
                    return next(error);
                }
                res.status(200).json();
            });
        } else {
            const error  = new Error('Registro de observacion no existe!');
            error.status = 400;
            return next(error);
        }
    });
};



//callback function to run update queries in sync mode
//reference: https://www.codexpedia.com/javascript/nodejs-sync-nested-mysql-queries/
function putBdoObservacion(items, tz_tienda, cb) {
    if(items.length<1) {
        return;
    }
    //
    try {
        let bdo_observaciones = [], 
            stmt      = null, 
            data      = null,
            timestamp = bdoDates.getBDOCurrentTimestamp(tz_tienda),
            pending   = items.length;
        items.forEach(function(item) {
            stmt = "UPDATE xxbdo_observaciones SET descripcion=?, "+
            "causa=?, accion_responsable_fecha=?, "+
            "ajuste_ata=?, hay_seguimiento=?, es_cierre_efectiva=?, " +
            "folio=?, turno=?, usuario=?, ip_address=? ";
            data = [
                item.descripcion, 
                item.causa,
                item.accion_responsable_fecha,
                item.ajuste_ata,
                item.hay_seguimiento,
                item.es_cierre_efectiva,
                item.folio, 
                item.turno, 
                item.usuario, 
                item.ip, 
                timestamp, 
                item.id
            ];
            if(item.foto || item.bfoto=="1") {
                stmt += ", foto=? ";
                data = [
                    item.descripcion, 
                    item.causa,
                    item.accion_responsable_fecha,
                    item.ajuste_ata,
                    item.hay_seguimiento,
                    item.es_cierre_efectiva,
                    item.folio, 
                    item.turno, 
                    item.usuario, 
                    item.ip, 
                    (item.bfoto=="1" ? "" : item.foto), 
                    timestamp, 
                    item.id
                ];
            }
            stmt += ", fecha_modificacion=? WHERE id=?";
            //
            db.query(stmt, data, 
                function(err, result) {
                    if(err) {
                        err.status = 500;
                        throw err;
                    }
                    bdo_observaciones.push(result);
                    if( 0 === --pending ) {
                        //callback if all queries are processed
                        cb(bdo_observaciones);
                    }
                }
            );
        });
    } catch(error) {
        error.status = 500;
        throw error;
    }
}
