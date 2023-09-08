
const app_configuration = require('config');
const db = require("./../../../db");
const bdoDates = require("./../../helpers/bdo-dates");
const azureSasToken = require("./../../helpers/azure-sas-tokens");
const util = require('util');
const dbg = false;

exports.utensilios_ayuda = (req, res, next) => {
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
req.checkParams('id')
.isUUID(4)
.withMessage('Formato de ayuda id invalido!')
.trim();
const errors = req.validationErrors();
if (errors) {
    if(dbg) console.log(util.inspect(errors, {depth: null}));
    const error = new Error('Formato de estandar id invalido!');
    error.status= 400;
    return next(error);
}
   //
   let utl_id  = req.params.id;
   let results = null;
   let entries = [utl_id];
   let stmt= "SELECT `xxbdo_utensilios`.`id`, \
   `xxbdo_utensilios`.`nombre` AS `utensilio_nombre`, \
   `xxbdo_utensilios_categorias`.`nombre` AS `tipo`, \
   `xxbdo_utensilios`.`descripcion`, \
   `xxbdo_utensilios`.`uso`, \
   `xxbdo_utensilios`.`foto`, \
   `xxbdo_utensilios`.`codigo`, \
   `xxbdo_utensilios`.`via_de_solicitud` \
   FROM `xxbdo_utensilios`, \
   `xxbdo_utensilios_categorias` \
   WHERE `xxbdo_utensilios`.`id`=? \
   AND xxbdo_utensilios_categorias_id = xxbdo_utensilios_categorias.id";
   qry = db.query(stmt, entries, (err, rows) => {
        if(dbg) console.log("[47] "+qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }
        results = formatResultAyuda(rows);
        if(!results) {
            const error = 
                new Error('No hay registro de ayuda para utensilio!');
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
            let foto_uri=null; //fotos=[];
            if(row.foto) {
                //row.fotos.split(',').forEach(function(entry) {
                    // //get foto uri from azure storage service
                    token = azureSasToken.generateSasToken(
                        app_configuration.get('azure.sas.blob.containers.catalogos.name'),
                        row.foto, //entry, 
                        app_configuration.get('azure.sas.blob.containers.catalogos.sharedAccessPolicy'));
                    if(token) {
                        foto_uri = token.uri; //fotos.push(token.uri);
                    }
                //});
            }
            //
            ayuda = {
                "id":row.id, 
                "nm":row.utensilio_nombre, 
                "tp":row.tipo,
                "dsc":row.descripcion, 
                "uso":row.uso,
                "cdg":row.codigo,
                "vds":row.via_de_solicitud,
                "foto":foto_uri
              };
            });
        }
        return ayuda;
    }
    return;
}