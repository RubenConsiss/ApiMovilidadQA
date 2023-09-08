
const db       = require("./../../../db"),
      uuidv4   = require('uuid/v4'),
      bdoDates = require("./../../helpers/bdo-dates");
      const util = require('util'),
      dbg = false;

exports.observaciones_post = (req, res, next) => {
    if(!db) {
        const error  = new Error('Conexion a BD no encontrada!');
        error.status = 500;
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
    //
    const errors = req.validationErrors();
    if (errors || !req.tokenData.crplaza || !req.tokenData.crtienda) {
      //console.log(util.inspect(errors, {depth: null}));
      const error  = 
        new Error('Datos de observacion invalidos!');
      error.status = 400;
      return next(error);
    }
    //
    let bdo_id            = req.body.id, 
        fecha_observacion = req.tokenData.fecha,
        descripcion       = req.body.descripcion || null,
        causa             = req.body.causa || "",
        accion_responsable_fecha = req.body.accion_resp_fecha || "",
        ajuste_ata        = req.body.ajuste_ata || null,
        hay_seguimiento   = req.body.seguimiento || null,
        es_cierre_efectiva = req.body.cierre_efectiva || null,
        folio             = req.body.folio,
        turno             = req.body.turno,
        ip                = req.app_client_ip_address;
   //
  let usuario = req.tokenData.usuario,
    data = null,
    stmt = null,
    save_observacion = false,
    foto   = null,
    status = 500;
     //
    stmt = "SELECT id \
    FROM xxbdo_observaciones \
    WHERE xxbdo_respuestas_id=? \
    AND fecha_observacion=?";
    data = [bdo_id, fecha_observacion];
    //
    db.query(stmt, data, (err, result) => {
        if (err) {
            err.status=500;
            return next(err);
        }
        //check daily checklist rules:
        if(result.length>0) {
            if(result[0].id) {
                const error  = 
                    new Error('Registro de estandar-fecha ya existe!');
                error.status = 400;
                return next(error);
            }
        } else {
            save_observacion = true;
        }
        //
        if(save_observacion) {
            if(req.files) {
                if(req.files.length>0) {
                    foto = req.files[0].blobPath;
                }
            }
            //
            rst = formatInsertData(
                bdo_id, 
                fecha_observacion, 
                descripcion,
                causa,
                accion_responsable_fecha,
                ajuste_ata,
                hay_seguimiento,
                es_cierre_efectiva,
                foto, 
                folio, 
                turno, 
                usuario, 
                ip, 
                req.tokenData.tz);
            if(!rst) {
                const error  = 
                    new Error('Registro de observacion no generado!');
                error.status = 400;
                return next(error);
            }
            stmt   = 'INSERT INTO xxbdo_observaciones VALUES ?';
            status = 201;
            data   = [rst];
            //run query
            db.query(stmt, data, (err, rst, fields) => {
                if (err) {
                    err.status=500;
                    return next(err);
                }
                res.status(status).json();
            });
        }
    });
};

function formatInsertData(
    bdo_id, 
    fecha_observacion, 
    descripcion,
    causa,
    accion_responsable_fecha,
    ajuste_ata,
    hay_seguimiento,
    es_cierre_efectiva,
    foto, 
    folio, 
    turno, 
    usuario, 
    ip, 
    tz_tienda) {
    if(!bdo_id) {
        return;
    } else {
        let data=[], uuid=null, timestamp=null;
        if(bdo_id.length>0) {
                uuid = uuidv4();
                timestamp = bdoDates.getBDOCurrentTimestamp(tz_tienda);
                data.push([uuid, 
                    bdo_id,
                    fecha_observacion, 
                    descripcion,
                    causa,
                    accion_responsable_fecha,
                    ajuste_ata,
                    hay_seguimiento,
                    es_cierre_efectiva,
                    foto, 
                    folio,
                    turno,
                    1, //activo
                    usuario,
                    ip, 
                    timestamp, 
                    timestamp]
                );
        }
        return data;
    }
}

exports.observaciones_foto_post = (req, res, next) => {
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
    req.checkBody('bfoto')
        .matches(/^$|^[0-1|{1}]/)
        .trim();
    //
    const errors = req.validationErrors();
    if (errors) {
      console.log(util.inspect(errors, {depth: null}));
      const error = new Error('Datos de observación inválidos!');
      error.status=400;
      return next(error);
    }
    //
    let observaciones_id  = req.body.id, 
        borrar_foto       = req.body.bfoto || false,
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
    qry=db.query(stmt, data, (err, rst) => {
        if(dbg) console.log("[216] "+qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }
        //check if observacion already exists
        if(rst.length>0) {
            if(rst[0].observacion<1) {
                //daily record already exists, ignore checklist
                const error  = new Error('Observación no existe!');
                error.status = 400;
                return next(error);
            }
            //
            foto = null;
            if(req.files) {
                if(req.files.length>0) {
                    foto = req.files[0].blobPath;
                    if(dbg) console.log("[234] foto = "+foto);
                }
            }
            //
            let observaciones = [
                {
                    id:observaciones_id, 
                    foto:foto, 
                    bfoto:borrar_foto,
                    usuario:usuario,
                    ip:ip
                }
            ];
            //
            postFotoObservacion(observaciones, function(results) {
                if(!results) {
                    const error  = 
                        new Error('Error al ejecutar actualización de observación!');
                    error.status = 500;
                    return next(error);
                }
                res.status(200).json();
            });
        } else {
            const error  = new Error('Registro de observación no existe!');
            error.status = 400;
            return next(error);
        }
    });
};

function postFotoObservacion(items, cb) {
    if(items.length<1) {
        return;
    }
    //
    try {
        let bdo_observaciones = [], 
            stmt      = null, 
            data      = null,
            timestamp = bdoDates.getBDOCurrentTimestamp(),
            pending   = items.length;
        items.forEach(function(item) {
            stmt = "UPDATE xxbdo_observaciones SET usuario=?, ip_address=? ";
            data = [
                item.usuario, 
                item.ip, 
                timestamp, 
                item.id
            ];
            if(item.foto || item.bfoto=="1") {
                stmt += ", foto=? ";
                data = [
                    item.usuario, 
                    item.ip, 
                    (item.bfoto=="1" ? "" : item.foto), 
                    timestamp, 
                    item.id
                ];
            }
            stmt += ", fecha_modificacion=? WHERE id=?";
            //
            qry=db.query(stmt, data, (err, result) => {
                if(dbg) console.log("[297] "+qry.sql);
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