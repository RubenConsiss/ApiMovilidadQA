
const db = require("../../../db");
const dbg = false;

exports.roles_en_tienda = (req, res, next) => {
    if(dbg) console.log("[CRET:6] Start roles_en_tienda ...");
    if(!db) {
        error = new Error('Conexion a BD no encontrada!');
        error.status=500;
        return next(error);
    }
    
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        error  = new Error('crplaza o crtienda invalidos!');
        error.status = 400;
        return next(error);
    }

    stmt="SELECT id, nombre \
    FROM `xxbdo_roles_en_tienda` \
    WHERE `visible`=1 AND `activo`=1 \
    ORDER BY `xxbdo_roles_en_tienda`.`orden`";

    qry=db.query(stmt, null, (err, rows) => {
        if(dbg) console.log("[CRET:25] Get roles_en_tienda = ", qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }

        let roles_en_tienda = formatResults(rows);
        req.calendario_roles_en_tienda = roles_en_tienda;
        next();
    });
};

function formatResults(rows) {
      if(rows) {
        let roles_en_tienda = [];
        if(rows.length>0) {
            rows.forEach(row => {
                roles_en_tienda.push(
                    {"id":row.id, "nm":row.nombre},
                );
            });
        }
        return roles_en_tienda;
      }
      return;
      }