
const db = require("../../../db");
const dbg = false;

exports.categorias = (req, res, next) => {
    if(dbg) console.log("[CR:8] Start utensilios categorias ...");
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

    stmt="SELECT id, nombre, tipo FROM `xxbdo_utensilios_categorias` WHERE `visible`=1 AND `activo`=1 ORDER BY `orden`";
    
    qry=db.query(stmt, null, (err, rst) => {
        if(dbg) console.log("[22] Get categorias de utensilios: ", qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }

        let [
            utensilios_categorias, 
            utensilios_categoria_varios_id,
            utensilios_categoria_varios_nombre
        ] = formatResults(rst);
        req.utensilios_categorias = utensilios_categorias;
        req.utensilios_categoria_varios_id = utensilios_categoria_varios_id;
        req.utensilios_categoria_varios_nombre = utensilios_categoria_varios_nombre;
        next();
      });
};

function formatResults(rows) {
    let categorias = [];
    let utensilios_categoria_varios_id = null;
    let utensilios_categoria_varios_nombre = null;

    categorias.push({"id":"", "nm":"TODAS", "tp":null});

      if(rows) {
        if(rows.length>0) {
            rows.forEach(row => {
                categorias.push(
                    {"id":row.id, "nm":row.nombre, "tp":row.tipo},
                );
                if(row.tipo=="V") {
                    utensilios_categoria_varios_id = row.id;
                    utensilios_categoria_varios_nombre = row.nombre;
                }
            });
        }
        return [
            categorias, 
            utensilios_categoria_varios_id,
            utensilios_categoria_varios_nombre
        ];
      }
      return;
      }