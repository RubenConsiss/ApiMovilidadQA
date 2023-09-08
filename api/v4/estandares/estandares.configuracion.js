
const db = require("../../../db");
const dbg = false;

exports.configuracion = (req, res, next) => {
    if(dbg) console.log("[EC:6] Start estandares configuracion ...");
    if(!db) {
        error = new Error('Conexion a BD no encontrada!');
        error.status = 500;
        return next(error);
    }
    
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        error = new Error('Error: token inválido, crplaza o crtienda requeridos!');
        error.status = 400;
        return next(error);
    }

    let areas_grupos_id_estandares_libres = null;

    stmt="SELECT ( \
                SELECT `valor` \
                FROM `xxbdo_configuracion` \
                WHERE `modulo`='estandares' \
                AND `parametro`='areas_grupos_id_estandares_libres' \
               ) AS areas_grupos_id_estandares_libres";
    
    qry = db.query(stmt, null, (err, rst) => {
        if(dbg) console.log("[EC:29] Get xxbdo_areas_grupos_id fom configuration table: ", qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }

        areas_grupos_id_estandares_libres = 
            (
                rst[0].areas_grupos_id_estandares_libres ? 
                rst[0].areas_grupos_id_estandares_libres : null
            );

        if(areas_grupos_id_estandares_libres) {

            data = [req.version_estandares_id, areas_grupos_id_estandares_libres];

            stmt="SELECT `xxbdo_areas`.`id` FROM `xxbdo_areas` \
            WHERE `xxbdo_areas`.`xxbdo_version_estandares_id`=? \
            AND `xxbdo_areas`.`xxbdo_areas_grupos_id`=?";

            qry=db.query(stmt, data, (err, row) => {
                if(dbg) console.log("[EC:46] Get `xxbdo_areas`.`id` = ", qry.sql);
                if (err) {
                    err.status = 500;
                    return next(err);
                }

                req.xxbdo_areas_grupos_id_estandares_libres = areas_grupos_id_estandares_libres;
                req.xxbdo_areas_id_estandares_libres = row[0].id;

                if(dbg) console.log("[EC:55] `xxbdo_areas`.`id` = ", req.xxbdo_areas_id);
                next();
            });
        } else {
            const error  = new Error('Error en configuración: areas_grupos_id_estandares_libres es requerido!');
            error.status = 400;
            return next(error);
        }
      });
};