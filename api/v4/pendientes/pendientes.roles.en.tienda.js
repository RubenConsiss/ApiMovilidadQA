
const db = require("../../../db");
const dbg = false;

exports.roles_en_tienda = (req, res, next) => {
    if(dbg) console.log("[CR:6] Start roles_en_tienda ...");
    if(!db) {
        error = new Error('Conexion a BD no encontrada!');
        error.status = 500;
        return next(error);
    }
    //
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        error = new Error('crplaza o crtienda invalidos!');
        error.status = 400;
        return next(error);
    }

    let pendientes_rango_listado_en_dias = null; //days
    let pendientes_roles_en_tienda = null;

    stmt="SELECT ( \
            SELECT valor \
            FROM `xxbdo_configuracion` \
            WHERE modulo='pendientes' \
            AND parametro='numero_dias_visibles_hacia_atras_fecha_seleccionada' \
        ) AS numero_dias_visibles_hacia_atras_fecha_seleccionada";
    
    qry=db.query(stmt, null, (err, rst) => {
        if(dbg) console.log("[37] Get pendientes.numero_dias_visibles_hacia_atras_fecha_seleccionada = ", qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }

        pendientes_rango_listado_en_dias = rst[0].numero_dias_visibles_hacia_atras_fecha_seleccionada || 0;
        if(dbg) console.log("[34] Get pendientes_rango_listado_en_dias = ", pendientes_rango_listado_en_dias);

        req.pendientes_rango_listado_en_dias = pendientes_rango_listado_en_dias;

        if(pendientes_rango_listado_en_dias) {

            stmt = "SELECT id, nombre FROM `xxbdo_roles_en_tienda` where visible=1 and activo=1 ORDER BY `xxbdo_roles_en_tienda`.`orden`";

            qry = db.query(stmt, null, (err, rows) => {
                if(dbg) console.log("[55] Get roles_en_tienda = ", qry.sql);
                if (err) {
                    err.status = 500;
                    return next(err);
                }
    
                pendientes_roles_en_tienda = formatResults(rows);
                req.pendientes_roles_en_tienda = pendientes_roles_en_tienda;
                next();
                //res.status(200).json(pendientes_roles_en_tienda);
            });
        }
      });
};

function formatResults(rows) {
      if(rows) {
        let roles_en_tienda = [];
        if(rows.length>0) {
            let areas=[], nrow=0;
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