/**
 * 
 /indicadores 

3) servicio para actualizar respuesta del indicador
3.1) PUT /bdo/v4/indicadores
3.2) Ejemplo JSON:
{
 "rid":"<uuid4>",
 "res":"respuesta"
}

11) servicio PUT para actualizar detalle de indicador libre
11.1) PUT /bdo/v4/indicadores
11.2) Ejemplo JSON:
{
    "id":"<uuid4>",
    "tl":"titulo indicador",
    "dsc":"descripcion indicador",
    "tdd":"int"
}
 */

const db = require("./../../../db");
const bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

exports.indicadores_put = (req, res, next) => {
    if(!db) {
        const error  = new Error('Conexion a BD no encontrada!');
        error.status = 500;
        return next(error);
    }

    //Validation chain
    req.checkBody('id')
    .optional({"nullable":true})
    .isUUID(4)
    .withMessage('Formato de indicadores id(UUID4) inválido!')
    .trim();

    req.checkBody('rid')
    .optional({"nullable":true})
    .isUUID(4)
    .withMessage('Formato de respuesta de indicadores id(UUID4) inválido!')
    .trim();

    req.checkBody('tdd')
    .optional({"nullable":true})
    .matches(/^[int|pct|pnt|money]{1}/)
    .withMessage('Tipo de dato para indicador inválido!!')
    .trim();

    const errors = req.validationErrors();
    if (errors) {
      if(dbg) console.log(util.inspect(errors, {depth: null}));
      const error  = new Error('Información en body inválida!');
      error.status = 400;
      return next(error);
    }
    
    let respuestas_indicadores_id = req.body.rid || null;
    let indicadores_id = req.body.id || null;
    let respuesta = req.body.res || "";
    let titulo = req.body.tl || "Indicador";
    let tipo_dato = req.body.tdd || "int";
    let descripcion = req.body.dsc || "Descripción del indicador";
    let usuario = req.tokenData.usuario;
    let ip = req.app_client_ip_address;
    
    if(dbg) console.log("[IPT:72] Call putIndicadores....");
    if(respuestas_indicadores_id || indicadores_id) {
        putIndicadores(respuestas_indicadores_id, 
            indicadores_id, 
            respuesta,
            titulo,
            tipo_dato,
            descripcion,
            usuario, 
            ip, 
            function(results) {
            if(!results) {
                const error = new Error('Error al ejecutar actualización de indicador!');
                error.status = 400;
                return next(error);
            }
            res.status(200).json();
        });
    } else {
        const error  = new Error('Información incompleta para procesar indicador!');
        error.status = 400;
        return next(error);
    }
    if(dbg) console.log("[IPT:95] End PUT indicadores method.");
};

//callback function to run update queries in sync mode
//reference: https://www.codexpedia.com/javascript/nodejs-sync-nested-mysql-queries/
function putIndicadores(respuestas_indicadores_id, 
    indicadores_id, 
    respuesta,
    titulo,
    tipo_dato,
    descripcion,
    usuario, 
    ip, 
    cb) {
    try {
        let bdo_indicadores = [];
        let stmt = null;
        let pending = 1;
        let timestamp = bdoDates.getBDOCurrentTimestamp();
        let entries = null;
        
        if(respuestas_indicadores_id) {
                entries = [
                    respuesta, 
                    usuario, 
                    ip, 
                    timestamp, 
                    respuestas_indicadores_id
                ]
                stmt = "UPDATE xxbdo_respuestas_indicadores \
                SET respuesta=?, \
                usuario=?, \
                ip_address=?, \
                fecha_modificacion=? \
                WHERE id=?";
            } else {
                entries = [
                    titulo, 
                    tipo_dato, 
                    descripcion,
                    usuario,
                    ip, 
                    timestamp, 
                    indicadores_id
                ];

                stmt = "UPDATE `xxbdo_indicadores`, \
                `xxbdo_areas_estandares_indicadores` \
                SET `xxbdo_indicadores`.`titulo`=?, \
                `xxbdo_indicadores`.`tipo_dato`=?, \
                `xxbdo_indicadores`.`descripcion`=?, \
                `xxbdo_indicadores`.`usuario`=?, \
                `xxbdo_indicadores`.`ip_address`=?, \
                `xxbdo_indicadores`.`fecha_modificacion`=? \
                WHERE `xxbdo_areas_estandares_indicadores`.`id`=? \
                AND `xxbdo_indicadores`.`id`=`xxbdo_areas_estandares_indicadores`.`xxbdo_indicadores_id`";
            }
            
            qry=db.query(stmt, entries, 
                function(err, result) {
                    if(dbg) console.log("[IPT:152] ", qry.sql);
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
    } catch(error) {
        error.status = 500;
        throw error;
    }
}