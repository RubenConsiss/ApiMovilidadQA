/*

DELETE /estandares

10) servicio DELETE para borrar estándares libres(1 o más), 
    sus indicadores, respuestas de indicadores y respuestas de estándares.
10.1) DELETE /bdo/v4/estandares

-- Pasos a seguir para borrado lógico de estándar/indicadores/respuestas/obs/cc:

-- Pasos a seguir para "borrado lógico(activo=0)" de estandar:
-- 1) Borrar registros de xxbdo_observaciones:
      UPDATE `xxbdo_observaciones` 
      SET `xxbdo_observaciones`.`activo`=0 
      WHERE `xxbdo_observaciones`.`xxbdo_respuestas_id` 
      IN (
          SELECT `xxbdo_respuestas`.`id` 
          FROM `xxbdo_respuestas` 
          WHERE `cr_plaza`='10MDA' 
          AND `cr_tienda`='50JAI' 
          AND `xxbdo_areas_estandares_id` IN ("bc37070e-525d-4900-8732-c5b90c60f5b3")
      );

-- 2) Borrar registros de xxbdo_circulo_de_congruencia:
      UPDATE `xxbdo_circulo_de_congruencia` 
      SET `xxbdo_circulo_de_congruencia`.`activo`=0 
      WHERE `xxbdo_respuestas_id` 
      IN (
           SELECT `xxbdo_respuestas`.`id` 
           FROM `xxbdo_respuestas` 
           WHERE `cr_plaza`='10MDA' 
           AND `cr_tienda`='50JAI' 
           AND `xxbdo_areas_estandares_id` IN ("bc37070e-525d-4900-8732-c5b90c60f5b3")
      );

-- 3) Borrar registros de xxbdo_respuestas:
      UPDATE `xxbdo_respuestas` 
      SET `xxbdo_respuestas`.`activo`=0 
      WHERE `cr_plaza`="10MDA" 
      AND `cr_tienda`="50JAI" 
      AND `xxbdo_areas_estandares_id` 
      IN ("bc37070e-525d-4900-8732-c5b90c60f5b3");

-- 4) Borrar registros de xxbdo_respuestas_indicadores:
      UPDATE `xxbdo_respuestas_indicadores` 
      SET `xxbdo_respuestas_indicadores`.`activo`=0 
      WHERE `cr_plaza`="10MDA" 
      AND `cr_tienda`="50JAI" 
      AND `xxbdo_areas_estandares_indicadores_id` 
      IN (
          SELECT `xxbdo_areas_estandares_indicadores`.`id`  
          FROM `xxbdo_areas_estandares_indicadores` 
          WHERE `xxbdo_areas_estandares_id` IN ("bc37070e-525d-4900-8732-c5b90c60f5b3") 
      );

-- 7) Borrar registros de xxbdo_tiendas_has_areas_estandares_indicadores:
      UPDATE `xxbdo_tiendas_has_areas_estandares_indicadores` 
      SET `xxbdo_tiendas_has_areas_estandares_indicadores`.`activo`=0 
      WHERE cr_plaza="10MDA" 
      AND cr_tienda="50JAI" 
      AND `xxbdo_areas_estandares_indicadores_id` 
      IN (
          SELECT `xxbdo_areas_estandares_indicadores`.`id` 
          FROM `xxbdo_areas_estandares_indicadores` 
          WHERE `xxbdo_areas_estandares_id` 
          IN ("bc37070e-525d-4900-8732-c5b90c60f5b3") 
      );

-- 8) Borrar registros de xxbdo_checklists_has_areas_estandares_indicadores:
      UPDATE `xxbdo_checklists_has_areas_estandares_indicadores` 
      SET `xxbdo_checklists_has_areas_estandares_indicadores`.`activo`=0 
      WHERE `xxbdo_areas_estandares_indicadores_id` 
      IN ( 
          SELECT `xxbdo_areas_estandares_indicadores`.`id`  
          FROM `xxbdo_areas_estandares_indicadores` 
          WHERE `xxbdo_areas_estandares_id` IN ("bc37070e-525d-4900-8732-c5b90c60f5b3") 
      );

-- 7) Borrar registros de xxbdo_tiendas_has_areas_estandares:
      UPDATE `xxbdo_tiendas_has_areas_estandares`
      SET `xxbdo_tiendas_has_areas_estandares`.`activo`=0 
      WHERE `cr_plaza`="10MDA" 
      AND `cr_tienda`="50JAI" 
      AND `xxbdo_areas_estandares_id` IN ("bc37070e-525d-4900-8732-c5b90c60f5b3");

-- 8) Borrar registros de xxbdo_checklists_has_areas_estandares:
      UPDATE `xxbdo_checklists_has_areas_estandares` 
      SET `xxbdo_checklists_has_areas_estandares`.`activo`=0 
      WHERE xxbdo_areas_estandares_id IN ("bc37070e-525d-4900-8732-c5b90c60f5b3");

-- 6) Borrar registros de xxbdo_areas_estandares_indicadores:
      UPDATE `xxbdo_areas_estandares_indicadores` 
      SET `xxbdo_areas_estandares_indicadores`.`activo`=0 
      WHERE `xxbdo_areas_estandares_id` 
      IN ("bc37070e-525d-4900-8732-c5b90c60f5b3") ;

-- 6) Borrar registros de xxbdo_areas_estandares:
      UPDATE `xxbdo_areas_estandares` 
      SET `xxbdo_areas_estandares`.`activo`=0 
      WHERE `xxbdo_areas_estandares`.`id` IN ("bc37070e-525d-4900-8732-c5b90c60f5b3") ;

-- 5) Borrar registros de xxbdo_indicadores:
      UPDATE `xxbdo_indicadores` 
      SET `xxbdo_indicadores`.`activo`=0 
      WHERE `xxbdo_indicadores`.`id` 
      IN(
         SELECT `xxbdo_areas_estandares_indicadores`.`xxbdo_indicadores_id` 
         FROM `xxbdo_areas_estandares_indicadores` 
         WHERE xxbdo_areas_estandares_id 
         IN ("bc37070e-525d-4900-8732-c5b90c60f5b3")
      );

-- 7) Borrar registros de xxbdo_estandares:
      UPDATE `xxbdo_estandares` 
      SET `xxbdo_estandares`.`activo`=0 
      WHERE `xxbdo_estandares`.`id` IN(
        SELECT `xxbdo_estandares_id` 
        FROM `xxbdo_areas_estandares` 
        WHERE `xxbdo_areas_estandares`.`id` IN ("bc37070e-525d-4900-8732-c5b90c60f5b3") 
      );

*/

const db = require("./../../../db");
const bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

exports.estandares_delete = (req, res, next) => {
      if(dbg) console.log("[ED:130] Start Delete estandares ....");
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
    
    let areas_estandares_id = req.body.ids || null;
    let cr_plaza = req.tokenData.crplaza; 
    let cr_tienda = req.tokenData.crtienda;
    let usuario = req.tokenData.usuario;
    let ip_address = req.app_client_ip_address;
    let fecha_modificacion = bdoDates.getBDOCurrentTimestamp();
    let areas_estandares = areas_estandares_id.map((it) => {return `'${it}'`});

    var queries = [
      //-- 1) Borrar registros de xxbdo_observaciones:
      "UPDATE `xxbdo_observaciones` \
      SET `xxbdo_observaciones`.`activo`=0, \
      `xxbdo_observaciones`.`usuario`='"+usuario+"', \
      `xxbdo_observaciones`.`ip_address`='"+ip_address+"', \
      `xxbdo_observaciones`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `xxbdo_observaciones`.`xxbdo_respuestas_id` \
      IN ( \
          SELECT `xxbdo_respuestas`.`id` \
          FROM `xxbdo_respuestas` \
          WHERE `cr_plaza`='"+cr_plaza+"' \
          AND `cr_tienda`='"+cr_tienda+"' \
          AND `xxbdo_areas_estandares_id` IN ("+areas_estandares+") \
      )",       
      //-- 2) Borrar registros de xxbdo_circulo_de_congruencia:
      "UPDATE `xxbdo_circulo_de_congruencia` \
      SET `xxbdo_circulo_de_congruencia`.`activo`=0, \
      `xxbdo_circulo_de_congruencia`.`usuario`='"+usuario+"', \
      `xxbdo_circulo_de_congruencia`.`ip_address`='"+ip_address+"', \
      `xxbdo_circulo_de_congruencia`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `xxbdo_respuestas_id` \
      IN ( \
           SELECT `xxbdo_respuestas`.`id` \
           FROM `xxbdo_respuestas` \
           WHERE `cr_plaza`='"+cr_plaza+"' \
           AND `cr_tienda`='"+cr_tienda+"' \
           AND `xxbdo_areas_estandares_id` IN ("+areas_estandares+") \
      )",
      //-- 3) Borrar registros de xxbdo_respuestas:
      "UPDATE `xxbdo_respuestas` \
      SET `xxbdo_respuestas`.`activo`=0, \
      `xxbdo_respuestas`.`usuario`='"+usuario+"', \
      `xxbdo_respuestas`.`ip_address`='"+ip_address+"', \
      `xxbdo_respuestas`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `cr_plaza`='"+cr_plaza+"' \
      AND `cr_tienda`='"+cr_tienda+"' \
      AND `xxbdo_areas_estandares_id` \
      IN ("+areas_estandares+")",
      //-- 4) Borrar registros de xxbdo_respuestas_indicadores:
      "UPDATE `xxbdo_respuestas_indicadores` \
      SET `xxbdo_respuestas_indicadores`.`activo`=0, \
      `xxbdo_respuestas_indicadores`.`usuario`='"+usuario+"', \
      `xxbdo_respuestas_indicadores`.`ip_address`='"+ip_address+"', \
      `xxbdo_respuestas_indicadores`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `cr_plaza`='"+cr_plaza+"' \
      AND `cr_tienda`='"+cr_tienda+"' \
      AND `xxbdo_areas_estandares_indicadores_id` \
      IN ( \
          SELECT `xxbdo_areas_estandares_indicadores`.`id` \
          FROM `xxbdo_areas_estandares_indicadores` \
          WHERE `xxbdo_areas_estandares_id` IN ("+areas_estandares+") \
      )",
      //-- 5) Borrar registros de xxbdo_tiendas_has_areas_estandares_indicadores:
      "UPDATE `xxbdo_tiendas_has_areas_estandares_indicadores` \
      SET `xxbdo_tiendas_has_areas_estandares_indicadores`.`activo`=0, \
      `xxbdo_tiendas_has_areas_estandares_indicadores`.`usuario`='"+usuario+"', \
      `xxbdo_tiendas_has_areas_estandares_indicadores`.`ip_address`='"+ip_address+"', \
      `xxbdo_tiendas_has_areas_estandares_indicadores`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE cr_plaza='"+cr_plaza+"'  \
      AND cr_tienda='"+cr_tienda+"' \
      AND `xxbdo_areas_estandares_indicadores_id` \
      IN ( \
          SELECT `xxbdo_areas_estandares_indicadores`.`id` \
          FROM `xxbdo_areas_estandares_indicadores` \
          WHERE `xxbdo_areas_estandares_id` \
          IN ("+areas_estandares+") \
      )",
      //-- 6) Borrar registros de xxbdo_checklists_has_areas_estandares_indicadores:
      "UPDATE `xxbdo_checklists_has_areas_estandares_indicadores` \
      SET `xxbdo_checklists_has_areas_estandares_indicadores`.`activo`=0, \
      `xxbdo_checklists_has_areas_estandares_indicadores`.`usuario`='"+usuario+"', \
      `xxbdo_checklists_has_areas_estandares_indicadores`.`ip_address`='"+ip_address+"', \
      `xxbdo_checklists_has_areas_estandares_indicadores`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `xxbdo_areas_estandares_indicadores_id` \
      IN ( \
          SELECT `xxbdo_areas_estandares_indicadores`.`id` \
          FROM `xxbdo_areas_estandares_indicadores` \
          WHERE `xxbdo_areas_estandares_id` IN ("+areas_estandares+") \
      )",      
      //-- 7) Borrar registros de xxbdo_tiendas_has_areas_estandares:
      "UPDATE `xxbdo_tiendas_has_areas_estandares` \
      SET `xxbdo_tiendas_has_areas_estandares`.`activo`=0, \
      `xxbdo_tiendas_has_areas_estandares`.`usuario`='"+usuario+"', \
      `xxbdo_tiendas_has_areas_estandares`.`ip_address`='"+ip_address+"', \
      `xxbdo_tiendas_has_areas_estandares`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `cr_plaza`='"+cr_plaza+"' \
      AND `cr_tienda`='"+cr_tienda+"' \
      AND `xxbdo_areas_estandares_id` IN ("+areas_estandares+")",
      //-- 8) Borrar registros de xxbdo_checklists_has_areas_estandares:
      "UPDATE `xxbdo_checklists_has_areas_estandares` \
      SET `xxbdo_checklists_has_areas_estandares`.`activo`=0, \
      `xxbdo_checklists_has_areas_estandares`.`usuario`='"+usuario+"', \
      `xxbdo_checklists_has_areas_estandares`.`ip_address`='"+ip_address+"', \
      `xxbdo_checklists_has_areas_estandares`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE xxbdo_areas_estandares_id IN ("+areas_estandares+")",
      //-- 9) Borrar registros de xxbdo_areas_estandares_indicadores:
      "UPDATE `xxbdo_areas_estandares_indicadores` \
      SET `xxbdo_areas_estandares_indicadores`.`activo`=0, \
      `xxbdo_areas_estandares_indicadores`.`usuario`='"+usuario+"', \
      `xxbdo_areas_estandares_indicadores`.`ip_address`='"+ip_address+"', \
      `xxbdo_areas_estandares_indicadores`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `xxbdo_areas_estandares_id` \
      IN ("+areas_estandares+")",
      //-- 10) Borrar registros de xxbdo_areas_estandares:
      "UPDATE `xxbdo_areas_estandares` \
      SET `xxbdo_areas_estandares`.`activo`=0, \
      `xxbdo_areas_estandares`.`usuario`='"+usuario+"', \
      `xxbdo_areas_estandares`.`ip_address`='"+ip_address+"', \
      `xxbdo_areas_estandares`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `xxbdo_areas_estandares`.`id` IN ("+areas_estandares+")",
      //-- 11) Borrar registros de xxbdo_indicadores:
      "UPDATE `xxbdo_indicadores` \
      SET `xxbdo_indicadores`.`activo`=0, \
      `xxbdo_indicadores`.`usuario`='"+usuario+"', \
      `xxbdo_indicadores`.`ip_address`='"+ip_address+"', \
      `xxbdo_indicadores`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `xxbdo_indicadores`.`id` \
      IN( \
         SELECT `xxbdo_areas_estandares_indicadores`.`xxbdo_indicadores_id` \
         FROM `xxbdo_areas_estandares_indicadores` \
         WHERE xxbdo_areas_estandares_id \
         IN ("+areas_estandares+") \
      )",
      //-- 12) Borrar registros de xxbdo_estandares:
      "UPDATE `xxbdo_estandares` \
      SET `xxbdo_estandares`.`activo`=0, \
      `xxbdo_estandares`.`usuario`='"+usuario+"', \
      `xxbdo_estandares`.`ip_address`='"+ip_address+"', \
      `xxbdo_estandares`.`fecha_modificacion`='"+fecha_modificacion+"' \
      WHERE `xxbdo_estandares`.`id` IN( \
        SELECT `xxbdo_estandares_id` \
        FROM `xxbdo_areas_estandares` \
        WHERE `xxbdo_areas_estandares`.`id` IN ("+areas_estandares+") \
      )"
    ];

    /*let orden = Math.round(new Date() / 1000);
    queries2 = [
"UPDATE `students` SET `query` = '1 "+orden+"' WHERE `students`.`id` = 1",
"UPDATE `students` SET `query` = '2 "+orden+"' WHERE `students`.`id` = 2",
"UPDATE `students` SET `query` = '3 "+orden+"' WHERE `students`.`id` = 3",
"UPDATE `students` SET `query` = '4 "+orden+"' WHERE `students`.`id` = 4",
"UPDATE `students` SET `query` = '5 "+orden+"' WHERE `students`.`id` = 5"
    ];*/

    
    if(!areas_estandares_id) {
        const error  = new Error('Información incompleta para borrar estándares!');
      error.status = 400;
      return next(error);
    } else {
          if(dbg) console.log("[ED:316] Call deleteEstandares....");
        deleteEstandares(queries,
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
    if(dbg) console.log("[DE:328] End Delete estandares method.");
};

//callback function to run update queries in sync mode
//reference: https://www.codexpedia.com/javascript/nodejs-sync-nested-mysql-queries/
function deleteEstandares(queries, 
    cb,
    next) {
    //try {
        let bdo_estandares = [];
        let pending = queries.length;
        
      for(var i in queries) {
            if(dbg) console.log("[ED:341] ", queries[i]);
            qry = db.query(queries[i], null, 
                function(err, result) {
                    if(dbg) console.log("[ED:344] ", qry.sql);
                    if(err) {
                        err.status = 500;
                        if(dbg) console.log("[ED:347] Error: ", err);
                        next(err);
                    }
                    bdo_estandares.push(result);
                    if(dbg) console.log("[ED:351] pending = ", pending);
                    if( 0 === --pending ) {
                        if(dbg) console.log("[ED:353] pending = ", pending, " , run callback function, all queries are processed.");
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