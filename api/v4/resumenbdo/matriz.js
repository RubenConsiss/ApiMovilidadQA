
const db = require("../../../db");
const dbg = false;

exports.formato_final = (req, res, next) => {
    if(dbg) console.log("[6] Start resumenbdo construcción matriz final ...");
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

    if (!req.resumenbdo_plaza || !req.resumenbdo_matriz_tiendas) {
        error  = new Error('Plaza y Matriz de resumen semanal BDO es requerida!');
        error.status = 400;
        return next(error);
    }

    matriz_final = getMatrizFinal(
        req.resumenbdo_plaza,
        req.resumenbdo_matriz_tiendas, 
        req.resumenbdo_nombre_tiendas,
        req.resumenbdo_historial_fallas,
        req.pevop_catalogo_semaforizacion_fallas
    );

    matriz_alertas = getMatrizFinal(
        req.resumenbdo_plaza,
        req.resumenbdo_matriz_tiendas_alertas, 
        req.resumenbdo_nombre_tiendas,
        req.resumenbdo_historial_fallas,
        req.pevop_catalogo_semaforizacion_fallas
    );

    req.resumenbdo_matriz_tiendas_final = matriz_final;
    req.resumenbdo_matriz_tiendas_final_alertas= matriz_alertas;

    next();
};

function getMatrizFinal(plaza, 
    matriz_tiendas, 
    nombre_tiendas,
    historial_fallas, 
    catalogo_semaforizacion_fallas) {
      if(plaza && matriz_tiendas) {
        let tiendas_array = [];
        let rsp_array = null;
           
            for(tienda in matriz_tiendas) {
            
                if (matriz_tiendas.hasOwnProperty(tienda)) {
                    tienda_data = matriz_tiendas[tienda];
                    
                    rsp_array = [];
                    for(fecha in tienda_data) {
                        if (tienda_data.hasOwnProperty(fecha)) {
                            fecha_data = tienda_data[fecha];
                            rsp = fecha_data;
                            rkey = plaza+"*"+tienda+"*"+fecha;
                            
                            if(historial_fallas) {
                                if(historial_fallas[rkey]) {
                                    rsp.tl = historial_fallas[rkey];
                                    rsp.clr = 
                                        getColor(
                                            historial_fallas[rkey], 
                                            catalogo_semaforizacion_fallas
                                        );
                                }
                            } 
                            
                            rsp_array.push(rsp);
                        }
                    }

                    rsp = {
                        "rsps":rsp_array
                    };

                    nombre_tienda = tienda;
                    if(nombre_tiendas) {
                        if(nombre_tiendas[tienda]) {
                            nombre_tienda = nombre_tiendas[tienda];
                        }
                    }

                    tiendas_array.push({
                        crtienda:tienda,
                        nombre:nombre_tienda,
                        "rsps":rsp
                    });
                }
            }                           
            return tiendas_array;
      }
    }


    function getColor(valor, catalogo) {
        if(!isNaN(valor) && data) {
            data = catalogo;
            color = null;
    
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