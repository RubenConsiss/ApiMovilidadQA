/*
// Proceso de activación de módulos:
// 1. Obtener configuración de xxbdo_modulos, xxbdo_modulos_por_plaza 
//    y xxbdo_modulos_por_tienda.
// 2. Verificar si existe configuración a nivel de módulo, plaza o tienda, 
//    se sobreescriben en el siguiente órden:
//    Tienda > Plaza > Módulo
// 3. Parsear resultados del query de configuración para generar JSON de appconfig
// 4. Retornar JSON response de appconfig
*/

const db = require("../../../db");
const bdoDates = require("../../helpers/bdo-dates");
const dbg = false;

exports.app_get = (req, res, next) => {
    if(dbg) console.log("[AC:57] Start appconfig ...");
    if(!db) {
        error = new Error('[appconfig:19] Conexión a BD no encontrada!');
        error.status = 500;
        return next(error);
    }
    
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        error = new Error('[appconfig:25] crplaza o crtienda inválidos!');
        error.status = 400;
        return next(error);
    }

    let cr_plaza = req.tokenData.crplaza;
    let cr_tienda = req.tokenData.crtienda;
    let response_code = 400;
    let entries = [
        cr_plaza, 
        cr_plaza,
        cr_tienda
    ];

    stmt="SELECT 1 AS `tipo`, \
    `xxbdo_modulos`.`nombre`, \
    `xxbdo_modulos`.`codigo`, \
    `xxbdo_modulos`.`descripcion`, \
    `xxbdo_modulos`.`es_activo`, \
    `xxbdo_modulos`.`es_visible`, \
    `xxbdo_modulos`.`orden` \
    FROM `xxbdo_modulos` \
    WHERE `xxbdo_modulos`.`activo`=1 \
    UNION \
    SELECT 2 AS `tipo`, \
    `vista_xxbdo_modulos_por_plaza`.`nombre_modulo`, \
    `vista_xxbdo_modulos_por_plaza`.`codigo`, \
    '' AS `descripcion`, \
    `vista_xxbdo_modulos_por_plaza`.`es_activo`, \
    `vista_xxbdo_modulos_por_plaza`.`es_visible`, \
    `vista_xxbdo_modulos_por_plaza`.`orden` \
    FROM `vista_xxbdo_modulos_por_plaza` \
    WHERE `vista_xxbdo_modulos_por_plaza`.`cr_plaza`=? \
    AND `vista_xxbdo_modulos_por_plaza`.`activo`=1 \
    UNION \
    SELECT 3 AS `tipo`, \
    `vista_xxbdo_modulos_por_tienda`.`nombre_modulo`, \
    `vista_xxbdo_modulos_por_tienda`.`codigo`, \
    '' AS `descripcion`, \
    `vista_xxbdo_modulos_por_tienda`.`es_activo`, \
    `vista_xxbdo_modulos_por_tienda`.`es_visible`, \
    `vista_xxbdo_modulos_por_tienda`.`orden` \
    FROM `vista_xxbdo_modulos_por_tienda` \
    WHERE `vista_xxbdo_modulos_por_tienda`.`cr_plaza`=? \
    AND `vista_xxbdo_modulos_por_tienda`.`cr_tienda`=? \
    AND `vista_xxbdo_modulos_por_tienda`.`activo`=1 \
    ORDER BY 1, 7";
    
    qry=db.query(stmt, entries, (err, rst) => {
        if(dbg) console.log("[74] Get configuracion de módulos: ", qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }

        config_modulos = formatResults(rst);
        if(config_modulos) {
            response_code = 200;
        }
        res.status(response_code).json(config_modulos);
      });
}

function formatResults(rows) {
    let configuracion = {};
    if(rows) {
        let configuracion_modulo = [];
        let configuracion_plaza = [];
        let configuracion_tienda = [];
        let modulos = null;
        let var_name = null;
        if(rows.length>0) {
            rows.forEach(row => {
                var_name = row.codigo;
                configuracion[var_name] = (row.es_visible ? true : false);

                switch(row.tipo) {
                    case 1:
                        if(dbg) console.log("[AC:103] tipo 1: ", row.codigo);
                        configuracion_modulo.push(
                            {
                                "nombre":row.codigo, 
                                "visible":(row.es_visible ? true : false), 
                                "activo":(row.es_activo ? true : false)
                            }
                        );
                    break;
                    case 2:
                        if(dbg) console.log("[AC:113] tipo 2: ", row.codigo);
                        configuracion_plaza.push(
                            {
                                "nombre":row.codigo, 
                                "visible":(row.es_visible ? true : false), 
                                "activo":(row.es_activo ? true : false)
                            }
                        );
                    break;
                    case 3:
                        if(dbg) console.log("[AC:123] tipo 3: ", row.codigo);
                        configuracion_tienda.push(
                            {
                                "nombre":row.codigo, 
                                "visible":(row.es_visible ? true : false), 
                                "activo":(row.es_activo ? true : false)
                            }
                        );
                    break;
                }
            });

            modulos = configuracion_modulo;
            if(configuracion_tienda.length>0) {
                modulos = configuracion_tienda;
            } else if(configuracion_plaza.length>0) {
                modulos = configuracion_plaza;
            } 

            configuracion["modulos"] = modulos;
        }
        return configuracion;
    }
    return;
}