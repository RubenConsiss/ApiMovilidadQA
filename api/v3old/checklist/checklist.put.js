const db = require("./../../../db"),
uuidv4   = require('uuid/v4'),
bdoDates = require("./../../helpers/bdo-dates"),
util     = require('util'),
dbg      = false;

exports.checklist_put = (req, res, next) => {
    if(!db) {
        const error = new Error('Conexion a BD no encontrada!');
        error.status=500;
        return next(error);
    }
    //Validation chain
    req.checkBody('respuestas.*.id')
       .isUUID(4)
       .withMessage('Formato de id(UUID4) invalido!')
       .trim();
    req.checkBody('respuestas.*.res')
        .matches(/^$|^[K|T|A|P]{1}/)
        .withMessage('Respuesta de lider invalida!')
        .trim();
    //
    const errors = req.validationErrors();
    if (errors) {
      console.log(util.inspect(errors, {depth: null}));
      const error  = new Error('Informacion en body invalida!');
      error.status = 400;
      return next(error);
    }
    //
    let respuestas = req.body.respuestas,
        usuario    = req.tokenData.usuario,
        ip         = req.app_client_ip_address,
        data       = null,
        stmt       = null;
    //
    if(!respuestas) {
        const error  = new Error('Respuestas no recibidas!');
        error.status = 400;
        return next(error);
    }
    //
    if(dbg) console.log("[42] Call getRespuestasDetalles....");
    rst_array = getRespuestaDetalles(respuestas, usuario, ip);
    //[update_registros, insert_observaciones, insert_cc, respuesta_registros];
    if(!rst_array) {
        const error  = new Error('Arreglo de respuestas y observaciones está vacío!');
        error.status = 400;
        return next(error);
    }
    //
    if(dbg) console.log("[51] Call putBdoDetalles....");
    putBdoDetalles(rst_array[0], usuario, ip, function(results) {
        if(!results) {
            const error = new Error('Error al ejecutar actualización de respuestas!');
            error.status = 400;
            return next(error);
        }
        //observaciones
        if(rst_array[1].length>0) {
            if(dbg) console.log("[60] Insert Observaciones...");
                stmt = "INSERT INTO xxbdo_observaciones VALUES ?";
                data = [rst_array[1]];
                qry=db.query(stmt, data, (err, rst3) => {
                    if(dbg) console.log("[64] "+qry.sql);
                    if (err) {
                        err.status = 500;
                        return next(err);
                    }
                });
        }
        //circulo de congruencia
        if(rst_array[2].length>0) {
            if(dbg) console.log("[73] Insert Circulos de congruencia...");
                stmt = "INSERT INTO xxbdo_circulo_de_congruencia VALUES ?";
                data = [rst_array[2]];
                qry=db.query(stmt, data, (err, rst3) => {
                    if(dbg) console.log("[77] "+qry.sql);
                    if (err) {
                        err.status = 500;
                        return next(err);
                    }
                });
        }
        if(dbg) console.log("[84] Send response 200 - OK.");

        //res.api_response_body =JSON.stringify(rst_array[3]);

        res.status(200).json(rst_array[3]);
    });
    if(dbg) console.log("[87] End PUT checklist method.");
};

//callback function to run update queries in sync mode
//reference: https://www.codexpedia.com/javascript/nodejs-sync-nested-mysql-queries/
function putBdoDetalles(items, usuario, ip, cb) {
    if(items.length<1) {
        return;
    }
    //
    try {
        let bdo_detalles = [], 
        stmt      = null,
        data      = null,
        pending   = items.length,
        timestamp = bdoDates.getBDOCurrentTimestamp();
        items.forEach(function(item) {
            if(dbg) console.log("[104] "+item[1]+" is "+item[0]);
            switch(item[0]) {
                case "respuesta":
                    stmt = "UPDATE xxbdo_respuestas \
                    SET respuesta=?, \
                    respuesta_asesor=?, \
                    usuario=?, \
                    ip_address=?, \
                    fecha_modificacion=? \
                    WHERE id=?";
                    data = [item[2], item[3], usuario, ip, timestamp, item[1]];
                break;
                case "observacion":
                    stmt = "UPDATE xxbdo_observaciones \
                    SET `descripcion`=?, \
                    `causa`=?, \
                    `accion`=?, \
                    `accion_responsable`=?, \
                    `accion_fecha`=?, \
                    `requiere_ajuste_ata`=?, \
                    `realizaron_plan_accion`=?, \
                    `resolvio_problema`=?, \
                    `observacion`=?, \
                    `folio`=?, \
                    `turno_mañana`=?, \
                    `turno_tarde`=?, \
                    `turno_noche`=?, \
                    `usuario`=?, \
                    `ip_address`=?, \
                    fecha_modificacion=? \
                    WHERE id=?";// `foto`=?, \
                    data = [
                        item[2],
                        item[3],
                        item[4],
                        item[5],
                        item[6],
                        item[7],
                        item[8],
                        item[9],
                        item[10],
                        //null, //foto
                        item[11],
                        item[12],
                        item[13],
                        item[14],
                        usuario,
                        ip,
                        timestamp,
                        item[1]
                    ];
                break;
                case "cc":
                    stmt = "UPDATE xxbdo_circulo_de_congruencia \
                    SET fecha=?, \
                    comentario=?, \
                    usuario=?, \
                    ip_address=?, \
                    fecha_modificacion=? \
                    WHERE id=?";
                    data = [ 
                        item[2], 
                        item[3],
                        usuario, 
                        ip, 
                        timestamp, 
                        item[1]
                    ];
                break;
            }
            //
            qry=db.query(stmt, data, 
                function(err, result) {
                    if(dbg) console.log("[176] "+qry.sql);
                    if(err) {
                        err.status = 500;
                        next(err);
                    }
                    bdo_detalles.push(result);
                    if( 0 === --pending ) {
                        //callback if all queries are processed
                        cb(bdo_detalles);
                    }
                }
            );
        });
    } catch(error) {
        error.status = 500;
        throw error;
    }
}

function getRespuestaDetalles(respuestas, usuario, ip)
{
if(!respuestas)
    return;

    let update_registros  = [],
    insert_observaciones  = [],
    insert_cc             = [],
    respuesta_registros   = [];

    respuestas.forEach(respuesta => {
        res = ['respuesta', 
        respuesta.id,
        (respuesta.res ? respuesta.res : ""),
        (respuesta.resa ? respuesta.resa : "")
        ];
        update_registros.push(res);

        if(respuesta.obs) {
            if(respuesta.obs.id) {
                //update observacion
                res = ['observacion', 
                respuesta.obs.id,
                respuesta.obs.desc,
                respuesta.obs.causa,
                respuesta.obs.accion,
                respuesta.obs.acresp,
                respuesta.obs.acfecha,
                respuesta.obs.ata,
                respuesta.obs.rpa,
                respuesta.obs.rep,
                respuesta.obs.obs,
                respuesta.obs.folio,
                respuesta.obs.turnom,
                respuesta.obs.turnot,
                respuesta.obs.turnon
                ];
                update_registros.push(res);
                rel={"res":respuesta.eid, "obs":respuesta.obs.id};//respuesta.obs.eid
            } else {
                //insert observacion
                uuid_obs  = uuidv4();
                timestamp = bdoDates.getBDOCurrentTimestamp();
                fecha     = bdoDates.getBDOUTCCurrentDate();
                res = [
                        uuid_obs,
                        respuesta.id,
                        fecha,
                        respuesta.obs.desc,
                        respuesta.obs.causa,
                        respuesta.obs.accion,
                        respuesta.obs.acresp,
                        respuesta.obs.acfecha,
                        respuesta.obs.ata,
                        respuesta.obs.rpa,
                        respuesta.obs.rep,
                        null, //pendiente_agregado
                        respuesta.obs.obs,
                        "", //foto
                        respuesta.obs.folio,
                        respuesta.obs.turnom,
                        respuesta.obs.turnot,
                        respuesta.obs.turnon,
                        1,
                        usuario,
                        ip,
                        timestamp,
                        timestamp
                    ];
                    insert_observaciones.push(res);
                    rel={"res":respuesta.eid, "obs":uuid_obs};
            }
            respuesta_registros.push(rel);
        }
        //
        if(respuesta.cc) {
            fecha = bdoDates.getBDOUTCCurrentDate();
            if(respuesta.cc.id) {
                //update cc
                res = ['cc', 
                respuesta.cc.id,
                fecha,
                respuesta.cc.desc
                ];
                update_registros.push(res);
                rel={"res":respuesta.eid, "cc":respuesta.cc.id};
            } else {
                //insert cc
                uuid_cc = uuidv4();
                timestamp = bdoDates.getBDOCurrentTimestamp();
                    res = [
                        uuid_cc,
                        respuesta.id,
                        fecha,
                        respuesta.cc.desc,
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        1,
                        usuario,
                        ip,
                        timestamp,
                        timestamp
                    ];
                    insert_cc.push(res);
                    rel={"res":respuesta.eid, "cc":uuid_cc};
            }
            respuesta_registros.push(rel);
        }
    });
    return [update_registros, 
        insert_observaciones, 
        insert_cc, 
        respuesta_registros];
}
