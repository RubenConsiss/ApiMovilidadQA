
const app_configuration = require('config');
const db = require("./../../../db");
const bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

  exports.indicadores_ayuda_get = (req, res, next) => {
          if(!db) {
              const error = new Error('Conexion a BD no encontrada!');
              error.status=500;
              return next(error);
          }
          //
        if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
          const error  = new Error('crplaza o crtienda invalidos!');
          error.status = 400;
          return next(error);
        }
      //Validation chain
      req.checkParams('std')
      .isUUID(4)
      .withMessage('Formato de std id invalido!')
      .trim();
      const errors = req.validationErrors();
      if (errors) {
          if(dbg) console.log(util.inspect(errors, {depth: null}));
          const error = new Error('Formato de estandar id invalido!');
          error.status= 400;
          return next(error);
      }
         //
         let std_id  = req.params.std,
             results = null,
             entries = [std_id, std_id];
             stmt= "(SELECT `xxbdo_indicadores`.`id`, \
             `xxbdo_indicadores`.`titulo`, \
             `xxbdo_indicadores`.`descripcion`, \
             `xxbdo_indicadores`.`foto`, \
             `xxbdo_indicadores`.`detalle` \
             FROM `xxbdo_indicadores`, \
             `xxbdo_areas_estandares_indicadores` \
             WHERE `xxbdo_areas_estandares_indicadores`.`id`=? \
             AND `xxbdo_areas_estandares_indicadores`.`activo`=1 \
             AND `xxbdo_indicadores`.`id`=`xxbdo_areas_estandares_indicadores`.`xxbdo_indicadores_id` \
             AND `xxbdo_indicadores`.`activo`=1) \
             UNION \
             (SELECT `xxbdo_indicadores`.`id`, \
             `xxbdo_indicadores`.`titulo`, \
             `xxbdo_indicadores`.`descripcion`, \
             `xxbdo_indicadores`.`foto`, \
             `xxbdo_indicadores`.`detalle` \
             FROM `xxbdo_indicadores`, \
             `xxbdo_respuestas_indicadores`, \
             `xxbdo_areas_estandares_indicadores` \
             WHERE `xxbdo_respuestas_indicadores`.`id` =? \
             AND `xxbdo_respuestas_indicadores`.`xxbdo_areas_estandares_indicadores_id`=`xxbdo_areas_estandares_indicadores`.`id` \
             AND `xxbdo_indicadores`.`id`=`xxbdo_areas_estandares_indicadores`.`xxbdo_indicadores_id` \
             AND `xxbdo_respuestas_indicadores`.`activo`=1 \
             AND `xxbdo_indicadores`.`activo`=1 \
             AND `xxbdo_areas_estandares_indicadores`.`activo`=1)";
         qry = db.query(stmt, entries, (err, rows) => {
              if(dbg) console.log("[398] "+qry.sql);
              if (err) {
                  err.status = 500;
                  return next(err);
              }
              results = formatResultAyuda(rows);
              if(!results) {
                  const error = 
                      new Error('No hay registro de ayuda para indicador!');
                  error.status = 400;
                  return next(error);
              }
              res.status(200).json(results);
         });
      };
      
      function formatResultAyuda(rows) {
          if(rows) {
              let ayuda=null;
              if(rows.length>0) {
                  rows.forEach(row => {
                  //get fotos
                  let fotos=[];
                  if(row.fotos) {
                      row.fotos.split(',').forEach(function(entry) {
                          //get foto uri from azure storage service
                          token = azureSasToken.generateSasToken(
                              app_configuration.get('azure.sas.blob.containers.catalogos.name'),
                              entry, 
                              app_configuration.get('azure.sas.blob.containers.catalogos.sharedAccessPolicy'));
                          if(token) {
                              fotos.push(token.uri);
                          }
                      });
                  }
                  //
                  ayuda = {
                      //"std":row.estandar, 
                      "ttl":row.titulo, 
                      "desc":row.descripcion,
                      "det":row.detalle || "", 
                      "img":fotos
                    };
                  });
              }
              return ayuda;
          }
          return;
      }