
const db = require("../../../db");
const dbg = false;

exports.lista_nombres = (req, res, next) => {
    if(dbg) console.log("[6] Start resumenbdo configuracion ...");
    if(!db) {
        error = new Error('Conexion a BD no encontrada!');
        error.status = 500;
        return next(error);
    }
    
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        error = new Error('crplaza o crtienda invalidos!');
        error.status = 400;
        return next(error);
    }

    if (!req.resumenbdo_plaza || !req.resumenbdo_tiendas) {
        error = new Error('Plaza y lista de tiendas es requerido!');
        error.status = 400;
        return next(error);
    }

    let entries = [
        req.resumenbdo_plaza,
        req.resumenbdo_tiendas
    ];

    stmt = "SELECT cr_tienda, \
    IFNULL(`nombre_tienda`,`cr_tienda`) AS `nombre` \
    FROM `xxbdo_tiendas` \
    WHERE `cr_plaza`=? \
    AND `cr_tienda` IN(?)";
    
    qry = db.query(stmt, entries, (err, rst) => {
        if(dbg) console.log("[37] Get nombre de tiendas: ", qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }

        let nombre_tiendas = fmtNombreTiendas(rst, req.reporte_lista_tiendas_info);
        req.resumenbdo_nombre_tiendas = nombre_tiendas || null;

        next();
      });
};


function fmtNombreTiendas(rows, reporte_lista_tiendas_info) {
    if(rows) {
      let lista_tiendas = null;
      if(rows.length>0) {
          let lista_tiendas = {};
          rows.forEach(row => {
            lista_tiendas[row.cr_tienda] = row.nombre || null;
            if(reporte_lista_tiendas_info) {
                if(reporte_lista_tiendas_info[row.cr_tienda]) {
                    lista_tiendas[row.cr_tienda] = 
                        reporte_lista_tiendas_info[row.cr_tienda];
                }
            }
          });
          return lista_tiendas;
      }
    }
  }