const db = require("./../../../db");
const bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

exports.utensilios_put = (req, res, next) => {
    if(!db) {
        const error  = new Error('Conexion a BD no encontrada!');
        error.status = 500;
        return next(error);
    }

    //Validation chain
    req.checkBody('id')
       .isUUID(4)
       .withMessage('Formato de id(UUID4) inválido!')
       .trim();

    req.checkBody('st')
        .matches(/^$|^[^]/)
        .withMessage('Status de recibido es requerido!')
        .trim();

    req.checkBody('org')
        .matches(/^[1|2|3]{1}/)
        .withMessage('Origen de datos inválido!')
        .trim();
    
    const errors = req.validationErrors();
    if (errors) {
      if(dbg) console.log(util.inspect(errors, {depth: null}));
      const error  = new Error('Información en body inválida!');
      error.status = 400;
      return next(error);
    }
    
    let utensilios_id = req.body.id;
    let folio = req.body.fl;
    let status = req.body.st;
    let origen = req.body.org || null;
    let usuario = req.tokenData.usuario;
    let ip = req.app_client_ip_address;
    
    if(dbg) console.log("[37] Call putUtensilios....");
    putUtensilios(folio, status, usuario, ip, origen, function(results) {
        if(!results) {
            const error = new Error('Error al ejecutar actualización de utensilio recibido');
            error.status = 400;
            return next(error);
        }

        let fecha_recibido = bdoDates.getBDOFormattedDate(bdoDates.getBDOCurrentTimestamp(), "es", "dddd[,] D MMMM YYYY", false, true);

        res.status(200).json({"ffr":fecha_recibido});
    });

    if(dbg) console.log("[56] End PUT utensilios method.");
};

//callback function to run update queries in sync mode
//reference: https://www.codexpedia.com/javascript/nodejs-sync-nested-mysql-queries/
function putUtensilios(folio, status, usuario, ip, origen, cb) {
    try {
        let bdo_utensilios = [];
        let stmt = null;
        let pending = 1;
        let timestamp = bdoDates.getBDOCurrentTimestamp();
        let entries = [
            (status ? timestamp : null), 
            origen,
            usuario, 
            ip, 
            timestamp, 
            folio
        ];
        ////items.forEach(function(item) {
            //stmt = "UPDATE xxbdo_respuestas_utensilios \
            //SET recibido=?, \
            //origen=?, \
            //usuario=?, \
            //ip_address=?, \
            //fecha_modificacion=? \
            //WHERE id=?";
            //query to update all folios with the same number
            stmt = "UPDATE `xxbdo_respuestas_utensilios` \
            SET recibido=?, \
            origen=?, \
            usuario=?, \
            ip_address=?, \
            fecha_modificacion=? \
            WHERE `folio`=? \
            AND `recibido` IS NULL";
            qry=db.query(stmt, entries, 
                function(err, result) {
                    if(dbg) console.log("[85] "+qry.sql);
                    if(err) {
                        err.status = 500;
                        return next(err);
                    }
                    bdo_utensilios.push(result);
                    if( 0 === --pending ) {
                        //callback if all queries are processed
                        cb(bdo_utensilios);
                    }
                }
            );
        //});
    } catch(error) {
        error.status = 500;
        throw error;
    }
}
