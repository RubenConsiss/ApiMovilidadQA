
const db = require("../../../db");
const dbg = false;
const moment = require("moment");

exports.recolectar_alertas = (req, res, next) => {
  let alertas = conteoNoLLenoBDO(req);
  let alertasFinales = conteoAlertas(req, alertas);

  let { matriz_final, matriz_de_ponderacion } = barridoDeReglas(
    req.reglas_estandares_alertas,
    alertasFinales,
    req.resumenbdo_plaza
  );

  req.matriz_de_ponderacion = matriz_de_ponderacion;
  req.matriz_de_alertas = format_alertas_dashboard(matriz_final);
  next();
};

function format_alertas_dashboard(alertas) {

  let obj = {};
  for (tienda_key in alertas) {
    obj[tienda_key]={};
    let alertas_array = [];
    let data = alertas[tienda_key];
    for (estandar_key in data.alertas) {
      data_alerta = data.alertas[estandar_key];

      if(data_alerta.alerta){
        alertas_array.push({
          alerta: data_alerta.alerta,
          total: data_alerta.total_alertas,
          consecutivos: data_alerta.consecutivos,
        });
      }
    }

    obj[tienda_key] = alertas_array;
  }

  return obj;
}

function barridoDeReglas(reglas, alertasFinales, plaza) {

  // * cada item es una tienda
  let matriz_final = {};
  let matriz_de_ponderacion = {};

  for (tienda_key in alertasFinales) {
    matriz_final[tienda_key] = {};
    let alertas_de_tienda = alertasFinales[tienda_key];
    
    // * cada item es un estandar
    for (estandar_key in alertas_de_tienda.alertas) {
      let clave = `${plaza}*${tienda_key}*${estandar_key}`;

      matriz_de_ponderacion[clave] =
        alertas_de_tienda.alertas[estandar_key].total;

      if (reglas[estandar_key]) {
        let regla = reglas[estandar_key];
        if (regla.es_consecutivo == 1) {
          if (
            alertas_de_tienda.alertas[estandar_key].consecutivos >=
            regla.minimo_fallas
          ) {
            let expresion = `${alertas_de_tienda.alertas[estandar_key].consecutivos} dias seguidos con falla en ${regla.titulo}.`;

            alertas_de_tienda.alertas[estandar_key].alerta = expresion;
          }
        } else {
          if (
            alertas_de_tienda.alertas[estandar_key].total_alertas >=
            regla.minimo_fallas
          ) {
            let expresion = `${alertas_de_tienda.alertas[estandar_key].total_alertas} dias con falla en ${regla.titulo}.`;

            alertas_de_tienda.alertas[estandar_key].alerta = expresion;
          }
        }
      }
    }

    matriz_final[tienda_key] = alertas_de_tienda;
  }

  return { matriz_final, matriz_de_ponderacion };
}

function conteoAlertas(req, lista_alertas) {
  let alertas = {};
  let reglas = req.reglas_estandares_alertas;
  const matriz = req.resumenbdo_matriz_tiendas_final;
  let matriz_tiendas = req.resumenbdo_matriz_tiendas;
  let fecha_max = moment(req.fecha_body);
  let fecha_min = moment(req.fecha_antes);
  let historial_alertas = req.resumenbdo_historial_alertas;

  // * cada item es una tienda
  for (lista_key in lista_alertas) {
    let alertas_de_tienda = lista_alertas[lista_key].alertas;

    // * cada item es un estandar
    for (estandar_key in alertas_de_tienda) {
      // *cada item es estandar
      // if (reglas[estandar_key]) {
      // * cada item un registro de respuesta
      let consecutivos = 0;
      for (historial_key in historial_alertas) {
        let fecha = moment(historial_alertas[historial_key].fecha_respuesta);
        let dia_valido = false;
        if (fecha > fecha_min && fecha <= fecha_max) {
          dia_valido = true;
        }
        let clave = `${lista_key}*${historial_alertas[historial_key].fecha_respuesta}*${estandar_key}`;
        if (
          String(historial_key).includes(clave) &&
          historial_alertas[historial_key].es_falla != 0
        ) {
          if (dia_valido) {
            consecutivos++;
            alertas_de_tienda[estandar_key].total_alertas +=
              historial_alertas[historial_key].es_falla;
          }

          alertas_de_tienda[estandar_key].total +=
            historial_alertas[historial_key].es_falla;
          if (alertas_de_tienda[estandar_key].consecutivos < consecutivos) {
            alertas_de_tienda[estandar_key].consecutivos = consecutivos;
          }
        } else {
          consecutivos = 0;
        }
      }
      // }
    }
    
    lista_alertas[lista_key].alertas = alertas_de_tienda;
  }

  return lista_alertas;
}

function conteoNoLLenoBDO(req) {
  let reglas = req.reglas_estandares_alertas;
  const matriz = req.resumenbdo_matriz_tiendas_final;
  let matriz_tiendas = req.resumenbdo_matriz_tiendas_alertas;
  let lista_tiendas = {};
  let solo_estandares = get_solo_estandares(req.resumenbdo_historial_alertas);

  let fecha_max = moment(req.fecha_body);
  let fecha_min = moment(req.fecha_antes);

  for (tienda_key in matriz_tiendas) {
    lista_tiendas[tienda_key] = {};
    let alertas = {};
    let dias_sin_llenar_bdo = [];
    let data_tienda = matriz_tiendas[tienda_key];

    let consecutivos = 0;
    let total_alerta = 0;
    for (dia_key in data_tienda) {
      if (data_tienda[dia_key].tl === "-") {
        let fecha = moment(dia_key);
        let dia_valido = false;
        if (fecha > fecha_min && fecha <= fecha_max) {
          dia_valido = true;
          consecutivos = consecutivos + 1;
          total_alerta = total_alerta + 1;
          if (dias_sin_llenar_bdo.includes(dia_key) == false) {
            dias_sin_llenar_bdo.push(dia_key);
          }
        }
        solo_estandares.map((estandar) => {
          if (!alertas[estandar]) {
            alertas[estandar] = {
              total: 1,
              consecutivos: consecutivos,
            };
            alertas[estandar].total_alertas = total_alerta;
          } else {
            if (consecutivos > alertas[estandar].consecutivos) {
              alertas[estandar].consecutivos = consecutivos;
            }
            alertas[estandar].total += 1;
            alertas[estandar].total_alertas = total_alerta;
          }
        });
      } else {
        consecutivos = 0;
      }
    }
    lista_tiendas[tienda_key] = {
      dias_sin_llenar_bdo: dias_sin_llenar_bdo,
      alertas: alertas,
    };
  }

  return lista_tiendas;
}

function get_solo_estandares(historial) {
  let estandares = [];

  for (historial_index in historial) {
    if (!estandares.includes(historial[historial_index].estandar_id)) {
      estandares.push(historial[historial_index].estandar_id);
    }
  }

  return estandares;
}
