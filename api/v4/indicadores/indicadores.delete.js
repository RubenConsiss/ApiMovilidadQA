/**
 * 
 /indicadores

-- Servicios para vista de indicadores
1) servicio DELETE para borrar indicadores libres 
   (1 o más) y respuestas del indicador
1.1) DELETE /bdo/v4/indicadores
*/

const db = require("./../../../db");
const bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

exports.indicadores_delete = (req, res, next) => {
      if(dbg) console.log("[ID:17] Start Delete indicadores ....");
    if(!db) {
        const error  = new Error('Conexion a BD no encontrada!');
        error.status = 500;
        return next(error);
    }

    //Validation chain
    //req.checkBody('id')
    //   .isUUID(4)
    //   .withMessage('Formato de estándar id(UUID4) inválido!')
    //   .trim();

    //req.checkBody('res')
    //    .matches(/^$|^[^]/)
    //    .withMessage('Descripción del indicador es requerido!')
    //    .trim();
    
    //const errors = req.validationErrors();
    //if (errors) {
    //  if(dbg) console.log(util.inspect(errors, {depth: null}));
    //  const error  = new Error('Información en body inválida!');
    //  error.status = 400;
    //  return next(error);
    //}
    
    let areas_estandares_indicadores_id = req.body.ids || null;
    let cr_plaza = req.tokenData.crplaza; 
    let cr_tienda = req.tokenData.crtienda;
    let usuario = req.tokenData.usuario;
    let ip_address = req.app_client_ip_address;
    let fecha_modificacion = bdoDates.getBDOCurrentTimestamp();

    if(!areas_estandares_indicadores_id) {
        const error  = new Error('Información incompleta para borrar indicadores!');
        error.status = 400;
        return next(error);
    }

    let areas_estandares_indicadores = 
        areas_estandares_indicadores_id.map((it) => {return `'${it}'`});

    var queries = [
      //1) Borrar registros de xxbdo_respuestas_indicadores:
      "UPDATE `xxbdo_respuestas_indicadores` \
      SET `xxbdo_respuestas_indicadores`.`activo`=0, \
      `xxbdo_respuestas_indicadores`.`usuario`='"+usuario+"', \
      `xxbdo_respuestas_indicadores`.`ip_address`='"+ip_address+"', \
      `xxbdo_respuestas_indicadores`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `cr_plaza`='"+cr_plaza+"' \
      AND `cr_tienda`='"+cr_tienda+"' \
      AND `xxbdo_areas_estandares_indicadores_id` \
      IN ("+areas_estandares_indicadores+")",
      //2) Borrar registros de xxbdo_tiendas_has_areas_estandares_indicadores:
      "UPDATE `xxbdo_tiendas_has_areas_estandares_indicadores` \
      SET `xxbdo_tiendas_has_areas_estandares_indicadores`.`activo`=0, \
      `xxbdo_tiendas_has_areas_estandares_indicadores`.`usuario`='"+usuario+"', \
      `xxbdo_tiendas_has_areas_estandares_indicadores`.`ip_address`='"+ip_address+"', \
      `xxbdo_tiendas_has_areas_estandares_indicadores`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE cr_plaza='"+cr_plaza+"'  \
      AND cr_tienda='"+cr_tienda+"' \
      AND `xxbdo_areas_estandares_indicadores_id` \
      IN ("+areas_estandares_indicadores+")",
      //3) Borrar registros de xxbdo_checklists_has_areas_estandares_indicadores:
      "UPDATE `xxbdo_checklists_has_areas_estandares_indicadores` \
      SET `xxbdo_checklists_has_areas_estandares_indicadores`.`activo`=0, \
      `xxbdo_checklists_has_areas_estandares_indicadores`.`usuario`='"+usuario+"', \
      `xxbdo_checklists_has_areas_estandares_indicadores`.`ip_address`='"+ip_address+"', \
      `xxbdo_checklists_has_areas_estandares_indicadores`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `xxbdo_areas_estandares_indicadores_id` \
      IN ("+areas_estandares_indicadores+")",      
      //4) Borrar registros de xxbdo_areas_estandares_indicadores:
      "UPDATE `xxbdo_areas_estandares_indicadores` \
      SET `xxbdo_areas_estandares_indicadores`.`activo`=0, \
      `xxbdo_areas_estandares_indicadores`.`usuario`='"+usuario+"', \
      `xxbdo_areas_estandares_indicadores`.`ip_address`='"+ip_address+"', \
      `xxbdo_areas_estandares_indicadores`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `id` IN ("+areas_estandares_indicadores+")",
      //5) Borrar registros de xxbdo_indicadores:
      "UPDATE `xxbdo_indicadores` \
      SET `xxbdo_indicadores`.`activo`=0, \
      `xxbdo_indicadores`.`usuario`='"+usuario+"', \
      `xxbdo_indicadores`.`ip_address`='"+ip_address+"', \
      `xxbdo_indicadores`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `xxbdo_indicadores`.`id` \
      IN ( \
         SELECT `xxbdo_areas_estandares_indicadores`.`xxbdo_indicadores_id` \
         FROM `xxbdo_areas_estandares_indicadores` \
         WHERE `xxbdo_areas_estandares_indicadores`.`id` \
         IN ("+areas_estandares_indicadores+") \
      )"
    ];
    
    if(!areas_estandares_indicadores_id) {
        const error  = new Error('Información incompleta para borrar indicadores!');
      error.status = 400;
      return next(error);
    } else {
          if(dbg) console.log("[ID:108] Call deleteIndicadores....");
        deleteIndicadores(queries,
            function(results) {
            if(!results) {
                const error = new Error('Error al ejecutar borrado de estándares!');
                error.status = 400;
                return next(error);
            }
            res.status(200).json();
        },
        next);
    }
    if(dbg) console.log("[ID:120] End Delete estandares method.");
};

//callback function to run update queries in sync mode
//reference: https://www.codexpedia.com/javascript/nodejs-sync-nested-mysql-queries/
function deleteIndicadores(queries, 
    cb,
    next) {
    //try {
        let bdo_estandares = [];
        let pending = queries.length;
        
      for(var i in queries) {
            if(dbg) console.log("[ID:133] ", queries[i]);
            qry = db.query(queries[i], null, 
                function(err, result) {
                    if(dbg) console.log("[ID:136] ", qry.sql);
                    if(err) {
                        err.status = 500;
                        if(dbg) console.log("[ID:139] Error: ", err);
                        next(err);
                    }
                    bdo_estandares.push(result);
                    if(dbg) console.log("[ID:143] pending = ", pending);
                    if( 0 === --pending ) {
                        if(dbg) console.log("[ID:145] pending = ", pending, " , run callback function, all queries are processed.");
                        //callback if all queries are processed
                        cb(bdo_estandares);
                    }
                }
            );
      } 
    //} catch(error) {
    //    error.status = 500;
    //    throw error;
    //}
}