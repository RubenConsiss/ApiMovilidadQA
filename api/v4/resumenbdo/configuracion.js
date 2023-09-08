
const db = require("../../../db");
const dbg = false;

exports.reporte = (req, res, next) => {
    if(dbg) console.log("[6] Start resumenbdo configuracion ...");
    if(!db) {
        error = new Error('Conexion a BD no encontrada!');
        error.status=500;
        return next(error);
    }
    
    let reporte_cr_plaza = req.body.plaza || null;
    let lista_tiendas = req.body.tiendas || null;

    if (!reporte_cr_plaza || !lista_tiendas) {
        error  = new Error('Formato válido de plaza y lista de tiendas son requeridos!');
        error.status = 400;
        return next(error);
    }

    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        error  = new Error('crplaza o crtienda invalidos!');
        error.status = 400;
        return next(error);
    }

    if(!req.checklist_id) {
        error  = new Error('[CONF:29] Checklist ID es requerido!');
        error.status = 400;
        return next(error);
    }

    let reporte_lista_tiendas = Object.keys(lista_tiendas);

    stmt = "SELECT ( \
                SELECT `valor` \
                FROM `xxbdo_configuracion` \
                WHERE `modulo`='reportes' \
                AND `parametro`='resumenbdo_ponderacion_etiqueta_estandar' \
               ) AS `resumenbdo_ponderacion_etiqueta_estandar`, \
               ( \
                SELECT `valor` \
                FROM `xxbdo_configuracion` \
                WHERE `modulo`='reportes' \
                AND `parametro`='resumenbdo_ponderacion_etiqueta_puntos' \
               ) AS `resumenbdo_ponderacion_etiqueta_puntos` \
            ";
    
    qry = db.query(stmt, null, (err, rst) => {
        if(dbg) console.log("[51] Get configuracion reporte resumenbdo: ", qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }

        req.reporte_cr_plaza = reporte_cr_plaza;
        req.reporte_lista_tiendas = reporte_lista_tiendas;
        req.reporte_lista_tiendas_info = lista_tiendas;
        req.resumenbdo_ponderacion_etiqueta_estandar = rst[0].resumenbdo_ponderacion_etiqueta_estandar || "";
        req.resumenbdo_ponderacion_etiqueta_puntos = rst[0].resumenbdo_ponderacion_etiqueta_puntos || "";

        data = [req.checklist_id];

        stmt = "SELECT `id`, `nombre` \
        FROM `xxbdo_evop_drivers` \
        WHERE `xxbdo_checklists_id`=? \
        AND `es_activo`=1 \
        AND `activo`=1 \
        ORDER BY `orden`";

        qry = db.query(stmt, data, (err, rst2) => {
            if(dbg) console.log("[73] Get catalogo de pevop drivers: ", qry.sql);
            if (err) {
                err.status = 500;
                return next(err);
            }

            req.pevop_catalogo_drivers = formatCatalogoDrivers(rst2);
            if(dbg) console.log("Catalogo de drivers: ", req.pevop_catalogo_drivers);

            stmt = "SELECT `id`, `minimo`, `maximo`, \
            IFNULL((SELECT `xxbdo_colores`.`hexadecimal` \
                FROM `xxbdo_colores` \
                WHERE `xxbdo_colores`.`id`=`xxbdo_colores_id` \
                AND `es_activo`=1 \
                AND `activo`=1 \
                LIMIT 1), NULL) \
            AS `color` \
            FROM `xxbdo_evop_configuracion` \
            WHERE xxbdo_checklists_id=? \
            AND opcion='promedios_totales'  \
            AND `es_activo`=1 \
            AND `activo`=1 \
            ORDER BY `orden`";

            qry = db.query(stmt, data, (err, rst3) => {
                if(dbg) console.log("[98] Get catalogo de pevop promedios totales: ", qry.sql);
                if (err) {
                    err.status = 500;
                    return next(err);
                }

                req.pevop_catalogo_promedios_totales = formatCatalogoConfiguracion(rst3);
                if(dbg) console.log("Catalogo promedios totales: ", req.pevop_catalogo_promedios_totales);

                stmt = "SELECT `id`, `minimo`, `maximo`, \
                IFNULL((SELECT `xxbdo_colores`.`hexadecimal` \
                    FROM `xxbdo_colores` \
                    WHERE `xxbdo_colores`.`id`=`xxbdo_colores_id` \
                    AND `es_activo`=1 \
                    AND `activo`=1 \
                    LIMIT 1), NULL) \
                AS `color` \
                FROM `xxbdo_evop_configuracion` \
                WHERE xxbdo_checklists_id=? \
                AND opcion='semaforizacion_fallas'  \
                AND `es_activo`=1 \
                AND `activo`=1 \
                ORDER BY `orden`";

                qry = db.query(stmt, data, (err, rst8) => {
                    if(dbg) console.log("[123] Get catalogo de semaforizacion de fallas: ", qry.sql);
                    if (err) {
                        err.status = 500;
                        return next(err);
                    }
    
                    req.pevop_catalogo_semaforizacion_fallas = formatCatalogoConfiguracion(rst8);
                    if(dbg) console.log("Catalogo semaforizacion fallas: ", req.pevop_catalogo_semaforizacion_fallas);

                    stmt = "SELECT `xxbdo_evop_promedios_drivers`.`id`, \
                    `xxbdo_evop_promedios_drivers`.`xxbdo_evop_drivers_id`, \
                    `xxbdo_evop_drivers`.`nombre` AS `nombre_driver`, \
                    `xxbdo_evop_promedios_drivers`.`minimo`, \
                    IFNULL((SELECT `xxbdo_colores`.`hexadecimal` \
                                    FROM `xxbdo_colores` \
                                    WHERE `xxbdo_colores`.`id`=`xxbdo_evop_promedios_drivers`.`xxbdo_colores_id` \
                                    AND `xxbdo_colores`.`es_activo`=1 \
                                    AND `xxbdo_colores`.`activo`=1 \
                                    LIMIT 1), NULL) \
                                AS `color` \
                    FROM `xxbdo_evop_promedios_drivers`, \
                    `xxbdo_evop_drivers` \
                    WHERE `xxbdo_evop_promedios_drivers`.xxbdo_checklists_id=? \
                    AND `xxbdo_evop_drivers`.`id`=`xxbdo_evop_drivers_id` \
                    AND `xxbdo_evop_promedios_drivers`.es_activo=1 \
                    AND `xxbdo_evop_promedios_drivers`.activo=1 \
                    AND `xxbdo_evop_drivers`.`es_activo`=1 \
                    AND `xxbdo_evop_drivers`.`activo`=1 \
                    ORDER BY `xxbdo_evop_drivers`.`orden`, \
                    `xxbdo_evop_promedios_drivers`.`orden`";

                    qry = db.query(stmt, data, (err, rst4) => {
                        if(dbg) console.log("[155] Get catalogo de pevop promedios drivers: ", qry.sql);
                        if (err) {
                            err.status = 500;
                            return next(err);
                        }

                        req.pevop_catalogo_promedios_drivers = formatCatalogoPromediosDrivers(rst4);
                        if(dbg) console.log("Catalogo promedios drivers: ", req.pevop_catalogo_promedios_drivers);

                        stmt = "SELECT `xxbdo_evop_ponderacion_estandares`.`xxbdo_evop_drivers_id`, \
                        `xxbdo_evop_drivers`.`nombre` AS nombre_driver, \
                        `xxbdo_evop_ponderacion_estandares`.xxbdo_estandares_id, \
                        IFNULL((SELECT estandar FROM xxbdo_estandares \
                            WHERE xxbdo_estandares.id = `xxbdo_evop_ponderacion_estandares`.xxbdo_estandares_id \
                            LIMIT 1), NULL) AS estandar, \
                        `xxbdo_evop_ponderacion_estandares`.ponderacion \
                        FROM `xxbdo_evop_ponderacion_estandares`, \
                        `xxbdo_evop_drivers` \
                        WHERE `xxbdo_evop_ponderacion_estandares`.xxbdo_checklists_id=? \
                        AND `xxbdo_evop_drivers`.`id`=`xxbdo_evop_ponderacion_estandares`.xxbdo_evop_drivers_id \
                        AND `xxbdo_evop_ponderacion_estandares`.es_activo=1 \
                        AND `xxbdo_evop_ponderacion_estandares`.activo=1 \
                        AND `xxbdo_evop_drivers`.es_activo=1 \
                        AND `xxbdo_evop_drivers`.activo=1 \
                        ORDER BY `xxbdo_evop_drivers`.`orden`, `xxbdo_evop_ponderacion_estandares`.orden";
                        qry = db.query(stmt, data, (err, rst5) => {
                            if(dbg) console.log("[181] Get catalogo de ponderacion estandares: ", qry.sql);
                            if (err) {
                                err.status = 500;
                                return next(err);
                            }

                            [
                                req.pevop_catalogo_ponderacion_estandares, 
                                req.pevop_catalogo_estandares
                            ] = formatCatalogoPonderacionEstandares(rst5, req.resumenbdo_ponderacion_etiqueta_estandar);
                            if(dbg) console.log("Catalogo ponderacion y estandares: ", 
                                req.pevop_catalogo_ponderacion_estandares, 
                                req.pevop_catalogo_estandares);

                                queryReglasEstandaresAlertas(next, req, res);
                        });
                    });
                });
            });
        });
      });
};

function formatCatalogoDrivers(results) {
    let fmtResults = {};
    if(results) {
        results.forEach(row => {
            fmtResults[row.id] = row.nombre;
        });
        return fmtResults;
    }
    return;
}

function formatCatalogoConfiguracion(results) {
    let fmtResults = {};
    if(results) {
        results.forEach(row => {
            fmtResults[row.minimo] = row.color;
        });
        return fmtResults;
    }
    return;
}

function formatCatalogoPromediosDrivers(results) {
    let fmtResults = {};
    if(results) {
        results.forEach(row => {
            if(!fmtResults[row.xxbdo_evop_drivers_id]) {
                fmtResults[row.xxbdo_evop_drivers_id] = {};
            }
            fmtResults[row.xxbdo_evop_drivers_id][row.minimo] = row.color;
        });
        return fmtResults;
    }
    return;
}

function formatCatalogoPonderacionEstandares(results, etiqueta_estandar) {
    let fmtResults = {};
    let estandares = {};
    if(results) {
        results.forEach(row => {
            if(!fmtResults[row.xxbdo_evop_drivers_id]) {
                fmtResults[row.xxbdo_evop_drivers_id] = {};
            }
            fmtResults[row.xxbdo_evop_drivers_id][row.xxbdo_estandares_id] = row.ponderacion;

            if(!estandares[row.xxbdo_estandares_id]) {
                estandares[row.xxbdo_estandares_id] = etiqueta_estandar +" "+ row.estandar;
            }
        });
        return [fmtResults, estandares];
    }
    return;
}

function queryReglasEstandaresAlertas( next, req, res) {

    stmt = "SELECT `xxbdo_estandares`.`titulo`, \
    `xxbdo_estandares`.`id`, \
    `xxbdo_estandares_alertas`.`minimo_fallas`, \
    `xxbdo_estandares_alertas`.`es_consecutivo`, \
    `xxbdo_estandares_alertas`.`orden`, \
    `xxbdo_estandares_alertas`.`es_activa` \
    FROM `xxbdo_estandares_alertas` \
    INNER JOIN `xxbdo_estandares` \
    ON `xxbdo_estandares_alertas`.`xxbdo_estandares_id` = `xxbdo_estandares`.`id`";
  
    qry = db.query(stmt, null, (err, rst) => {
        if(dbg) console.log("[290] Get reglas Estandares_alertas reporte resumenbdo: ", qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }

        let mapa_de_reglas = {};
        
        rst.forEach((regla) => {
            mapa_de_reglas[regla.id] = {
                titulo: regla.titulo, 
                id: regla.id, 
                minimo_fallas: regla.minimo_fallas, 
                es_consecutivo: regla.es_consecutivo, 
                order: regla.orden, 
                es_activa: regla.es_activa
            };
        });
      
        req.reglas_estandares_alertas = mapa_de_reglas;

        next();
      });
}
