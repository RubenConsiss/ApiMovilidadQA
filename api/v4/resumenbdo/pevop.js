
const db = require("./../../../db");
bdoDates = require("./../../helpers/bdo-dates");
const dbg = false;

exports.matriz_pevop = (req, res, next) => {
    if(dbg) console.log("[PEVOP:7] Start matriz_pevop...");
    if(!db) {
        const error = new Error('Conexión a BD no encontrada!');
        error.status = 500;
        return next(error);
    }
    
    let request_continue = true;
    let error_message = "";

    if(!req.reporte_cr_plaza || !req.resumenbdo_nombre_tiendas) {
        request_continue = false;
        error_message = "Plaza y Lista de tiendas es requerido.";
    }
    
    if(request_continue) {

        pevop_data = getPEVOPData(
            req.reporte_cr_plaza,
            req.resumenbdo_nombre_tiendas,
            req.num_total_dias,
            req.resumenbdo_ponderacion_etiqueta_puntos,
            req.pevop_catalogo_drivers,
            req.pevop_catalogo_estandares,
            req.pevop_catalogo_ponderacion_estandares,
            req.matriz_de_ponderacion,
            req.pevop_catalogo_promedios_totales,
            req.pevop_catalogo_promedios_drivers
        );

        if(pevop_data) {

            req.matriz_pevop_tiendas = pevop_data;

            next();

        } else {
            const error  = 
            new Error("Parámetros para generar matriz de ponderación de estándares son requeridos.");
            error.status = 400;
            return next(error);
        }

    } else {
        const error = new Error(error_message);
        error.status = 400;
        return next(error);
    }
    
};

function getPEVOPData(
    crplaza, 
    tiendas,
    num_total_dias,
    ponderacion_etiqueta_puntos,
    catalogo_drivers,
    catalogo_estandares,
    matriz_ponderacion_estandares,
    matriz_de_ponderacion,
    catalogo_promedios_totales,
    catalogo_promedios_drivers) {
    if(tiendas && matriz_ponderacion_estandares) {

        let matriz_pevop_tiendas = {};

        for(crtienda in tiendas) {
            total_pevop_tienda = 0;
            color_pevop_tienda = null;            

            drivers_de_tienda = [];

            for(driver in matriz_ponderacion_estandares) {
                ponderacion = matriz_ponderacion_estandares[driver];
                total_driver = 0;
                estandares = [];
                total_ponderacion = 0;
                total_promedio = 0;
                for(estandar_id in ponderacion) {
                    valor = (ponderacion[estandar_id]) * 1.0;
                    estandar = catalogo_estandares[estandar_id];
                    dias_sin_falla = 0;
                    fkey = crplaza+"*"+crtienda+"*"+estandar_id;
                    if(matriz_de_ponderacion[fkey]) {
                        dias_con_falla = matriz_de_ponderacion[fkey];
                        dias_sin_falla = num_total_dias - dias_con_falla;
                    }

                    total_driver += valor * 1.0;
                    total_ponderacion += (valor * 1.0 * dias_sin_falla);
                    if(valor>0) {
                        estandares.push({
                            "std":estandar, 
                            "pts":valor+" "+ponderacion_etiqueta_puntos
                        });
                    }
                }

                total_promedio = (total_ponderacion*1.0) / num_total_dias;
                total_promedio = total_promedio.toFixed(2);

                porcentaje = 0;
                if(total_driver>0) {
                    porcentaje = (total_promedio * 1.0 * 100) / total_driver;
                    porcentaje = porcentaje.toFixed(2);
                }

                color_driver = getColor(total_promedio, catalogo_promedios_drivers, driver);

                drivers_de_tienda.push({
                    "nombre":catalogo_drivers[driver],
                    "total":total_promedio+" "+ponderacion_etiqueta_puntos,
                    "color":color_driver,
                    "ponderacion":total_driver+" "+ponderacion_etiqueta_puntos,
                    "ayuda":estandares
                });

                total_pevop_tienda += total_promedio * 1.0;
                total_pevop_tienda_fmt = total_pevop_tienda.toFixed(2);

                color_pevop_tienda = getColor(porcentaje, catalogo_promedios_totales);

                matriz_pevop_tiendas[crplaza+"*"+crtienda] = {
                    "total":total_pevop_tienda_fmt,
                    "total_fmt":total_pevop_tienda_fmt + " " + ponderacion_etiqueta_puntos,
                    "color":color_pevop_tienda,
                    "drivers":drivers_de_tienda
                };
            }
          }

        return matriz_pevop_tiendas;
    }
    return;
}

function getColor(valor, catalogo, driver = null) {
    if(!isNaN(valor) && data) {
        data = catalogo;
        color = null;

        if(driver) {
            data = catalogo[driver];
        }

        keys = Object.keys(data);
        color = data[keys[0]];

        if(valor>0) {
            for(n = keys.length; n>0; n--) {
                limite = keys[n-1];
                if(valor>=limite) {
                    color = data[limite];
                    break;
                }
            }
        }
        
        return color;
    }

    return;
}