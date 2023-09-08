/**
 * 
 GET /detalles 

1) servicio para llenar detalle de observacion y circulo en modo asesor
1.1) GET /bdo/v4/detalles

-- Ejemplo de JSON response sin objetos de 
-- observacion y/o circulo de congruencia:
{
    "id":"<uuid4>", //xxbdo_respuestas.id
    "info":{
        "obs":null,
        "cc":null
    }
}

-- Ejemplo de JSON response con objetos de 
-- observacion y/o circulo de congruencia:
{
    "id":"<uuid4>", //xxbdo_respuestas.id
    "info":{
        "obs":{
            "id":row.id,
            "uri":"<uri_foto_obs>",
            "desc":row.descripcion,
            "folio":row.folio,
            "turnom":row.turno_mañana,
            "turnot":row.turno_tarde,
            "turnon":row.turno_noche,
            "causa":row.causa,
            "accion":row.accion,
            "acresp":row.accion_responsable,
            "acfecha":row.accion_fecha,
            "ata":row.requiere_ajuste_ata,
            "rpa":row.realizaron_plan_accion,
            "rep":row.resolvio_problema,
            "alp":row.pendiente_agregado,
            "obs":row.observacion
        },
        "cc":{
            "id":xxbdo_cc_id,
            "fc":"<YYYY-MM-DD>",
            "desc":"comentario_cc",
            "uri":"<uri_foto_cc>",
            "resa":"<respuesta_asesor>"--------->>falta
            "accion":row.accion,----------------------->>faltan en el response
            "acresp":row.accion_responsable,
            "acfecha":row.accion_fecha,
            "ata":row.requiere_ajuste_ata,
            "alp":row.pendiente_agregado,
        }
    }
}
*/
 
const app_configuration = require('config');
bdoDates = require("./../../helpers/bdo-dates");
const azureSasToken = require("./../../helpers/azure-sas-tokens");
const db = require("./../../../db");
util = require('util');
const dbg = false;

exports.detalles_get = (req, res, next) => {
  if(!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }
  
  if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
    const error = new Error('crplaza o crtienda invalidos!');
    error.status = 400;
    return next(error);
  }
  
  req.checkParams('respuesta_id')
  .isUUID(4)
  .withMessage('Formato de id(UUID4) invalido!')
  .trim();
    
  var errors = req.validationErrors();
  if (errors) {
        if(dbg) console.log(util.inspect(errors, {depth: null}));
        const error = new Error('Formato de respuesta ID inválido!');
        error.status = 400;
        return next(error);
  }
  
  let respuesta_id = req.params.respuesta_id || null;

  if(!respuesta_id) {
    const error = new Error('Respuesta ID es requerido!');
    error.status = 400;
    return next(error);
  }

  entries = [respuesta_id, respuesta_id, respuesta_id];
  stmt = "SELECT * FROM ( \
    SELECT `xxbdo_respuestas`.`id`, \
    `xxbdo_areas_estandares`.`xxbdo_estandares_id` AS `eid`, \
    'res' AS `tipo_detalle`, \
    `fecha_respuesta` AS `fecha_detalle`, \
    NULL AS `texto_detalle`, \
    CONCAT(IFNULL(`xxbdo_respuestas`.`respuesta`,''), \
        ',', \
        IFNULL(`xxbdo_respuestas`.`respuesta_asesor`,'') \
    ) AS `respuestas`, \
    NULL AS `causa`, \
    NULL AS `accion`, \
    NULL AS `accion_responsable`, \
    NULL AS `accion_fecha`, \
    NULL AS `requiere_ajuste_ata`, \
    NULL AS `realizaron_plan_accion`, \
    NULL AS `resolvio_problema`, \
    NULL AS `pendiente_agregado`, \
    NULL AS `observacion`, \
    NULL AS `foto_detalle`, \
    NULL AS `folio`, \
    NULL AS `turno_mañana`, \
    NULL AS `turno_tarde`, \
    NULL AS `turno_noche` \
    FROM `xxbdo_respuestas`, \
    `xxbdo_areas_estandares` \
    WHERE `xxbdo_respuestas`.`id`=? \
    AND `xxbdo_respuestas`.`xxbdo_areas_estandares_id`= `xxbdo_areas_estandares`.`id` \
    UNION \
    SELECT `xxbdo_observaciones`.`id`, \
    `xxbdo_areas_estandares`.`xxbdo_estandares_id` AS `eid`, \
    'obs' AS tipo_detalle, \
    `fecha_observacion` AS fecha_detalle, \
    `descripcion` AS texto_detalle, \
    NULL AS `respuestas`,\
    `causa`, \
    `accion`, \
    `accion_responsable`, \
    `accion_fecha`, \
    `requiere_ajuste_ata`, \
    `realizaron_plan_accion`, \
    `resolvio_problema`, \
    `pendiente_agregado`, \
    `observacion`, \
    `foto` AS foto_detalle, \
    `folio`, \
    `turno_mañana`, \
    `turno_tarde`, \
    `turno_noche` \
    FROM `xxbdo_observaciones`, \
    `xxbdo_respuestas`, \
    `xxbdo_areas_estandares` \
    WHERE `xxbdo_observaciones`.`xxbdo_respuestas_id`=? \
    AND `xxbdo_respuestas`.`id`=`xxbdo_observaciones`.`xxbdo_respuestas_id` \
    AND `xxbdo_respuestas`.`xxbdo_areas_estandares_id`= `xxbdo_areas_estandares`.`id` \
    AND `xxbdo_observaciones`.`activo`=1 \
    UNION \
    SELECT `xxbdo_circulo_de_congruencia`.`id`, \
    `xxbdo_areas_estandares`.`xxbdo_estandares_id` AS `eid`, \
    'cc' AS tipo_detalle, \
    fecha AS fecha_detalle, \
    comentario AS texto_detalle, \
    CONCAT(IFNULL(`xxbdo_respuestas`.`respuesta`,''), \
        ',', \
        IFNULL(`xxbdo_respuestas`.`respuesta_asesor`,'') \
    ) AS `respuestas`, \
    NULL AS `causa`, \
    `accion`, \
    `accion_responsable`, \
    `accion_fecha`, \
    `requiere_ajuste_ata`, \
    NULL AS `realizaron_plan_accion`, \
    NULL AS `resolvio_problema`, \
    `pendiente_agregado`, \
    NULL AS `observacion`, \
    foto AS foto_detalle, \
    NULL AS `folio`, \
    NULL AS `turno_mañana`, \
    NULL AS `turno_tarde`, \
    NULL AS `turno_noche` \
    FROM `xxbdo_circulo_de_congruencia`, \
    `xxbdo_respuestas`, \
    `xxbdo_areas_estandares` \
    WHERE `xxbdo_circulo_de_congruencia`.`xxbdo_respuestas_id`=? \
    AND `xxbdo_respuestas`.`id`=`xxbdo_circulo_de_congruencia`.`xxbdo_respuestas_id` \
    AND `xxbdo_respuestas`.`xxbdo_areas_estandares_id`= `xxbdo_areas_estandares`.`id` \
    AND `xxbdo_circulo_de_congruencia`.activo=1 \
    ) tbl_detalles";
  
  qry = db.query(stmt, entries, (err, result) => {
        if(dbg) console.log("[DG:187] ", qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }
        
        results = formatResults(result, req.calendario_roles_en_tienda, req.tokenData.fecha);
        
        if(!results) {
            const error = new Error('No hay registros de obs o cc!');
            error.status = 400;
            return next(error);
        }

        res.status(200).json(results);
    });
}

function formatResults(rows, roles_en_tienda, fecha_token) {
    if(rows) {
        if(rows.length>0) {
            let observacion = null;
            let uri_obs = null;
            let circulo_de_congruencia = null;
            let uri_cc = null;
            let respuesta_lider = null;
            let respuesta_asesor = null;
            let estandar_id = null;

            rows.forEach(row => {
                estandar_id = row.eid;
                switch(row.tipo_detalle) {
                    case "res":
                        if(row.respuestas) {
                            [respuesta_lider, respuesta_asesor] = 
                            row.respuestas.split(",");
                        }
                    break;
                    case "obs":
                        if(row.id) {
                            if(row.foto_detalle) {
                                //get foto url from azure storage service
                                token = 
                                    azureSasToken.generateSasToken(
                                        app_configuration.
                                            get('azure.sas.blob.containers.observaciones.name'), 
                                        row.foto_detalle, 
                                        app_configuration.
                                            get('azure.sas.blob.containers.observaciones.sharedAccessPolicy')
                                    );
                                
                                if(!token) {
                                    uri_obs = "";
                                } else {
                                    uri_obs = token.uri;
                                }
                            }
              
                            observacion = {
                                "id":row.id,
                                "eid":row.eid,
                                "cmt":row.texto_detalle || "", //desc
                                "uri":uri_obs,
                                "folio":row.folio || "",
                                "turnom":(row.turno_mañana ? true : false),
                                "turnot":(row.turno_tarde ? true : false),
                                "turnon":(row.turno_noche ? true : false),
                                "causa":row.causa || "",
                                "accion":row.accion || "",
                                "acresp":row.accion_responsable || "",
                                "acfecha":row.accion_fecha,
                                "ata":(row.requiere_ajuste_ata ? true : (row.requiere_ajuste_ata==0 ? false : null)),
                                "rpa":(row.realizaron_plan_accion ? true : (row.realizaron_plan_accion==0 ? false : null)),
                                "rep":(row.resolvio_problema ? true : (row.resolvio_problema==0 ? false : null)),
                                "alp":(row.pendiente_agregado ? true : (row.pendiente_agregado==0 ? false : null)),
                                "obs":row.observacion
                            };
                            uri="";
                        }
                    break;
                    case "cc":
                        if(row.id) {
                            if(row.respuestas) {
                                [respuesta_lider, respuesta_asesor] = 
                                row.respuestas.split(",");
                            }

                            if(row.foto_detalle) {
                                //get foto url from azure storage service
                                tokencc = 
                                    azureSasToken.generateSasToken(
                                        app_configuration.
                                            get('azure.sas.blob.containers.observaciones.name'), 
                                        row.foto_detalle, 
                                        app_configuration.
                                            get('azure.sas.blob.containers.observaciones.sharedAccessPolicy')
                                    );
                                
                                if(!tokencc) {
                                    uri_cc = "";
                                } else {
                                    uri_cc = tokencc.uri;
                                }
                            }
              
                            circulo_de_congruencia = {
                                "id":row.id,
                                "eid":row.eid,
                                "fc":row.fecha_detalle,
                                "cmt":row.texto_detalle,
                                "resa":respuesta_asesor,
                                "accion":row.accion || "",
                                "acresp":row.accion_responsable || "",
                                "acfecha":row.accion_fecha,
                                "ata":(row.requiere_ajuste_ata ? true : (row.requiere_ajuste_ata==0 ? false : null)),
                                "alp":(row.pendiente_agregado ? true : (row.pendiente_agregado==0 ? false : null)),
                                "uri":uri_cc
                            };
                            uri_cc="";
                        }
                    break;
                    default:break;
                }
                
                let fecha_actual = bdoDates.getBDOFormattedDate(fecha_token, "es", "YYYY-MM-DD");
                res = {
                    "res":respuesta_lider,
                    "resa":respuesta_asesor,
                    "eid":estandar_id,
                    "fecha":fecha_actual,
                    "obs":observacion,
                    "cc":circulo_de_congruencia,
                    "roles":roles_en_tienda
                };
                
            });
         return res;   
        } else {
            return false;
        }
    }
    return;
}