const db = require("../../../db");
const dbg = false;

exports.formato_final = (req, res, next) => {
  if (dbg) console.log("[CR:6] Start dashboard: formato_final ...");
  if (!db) {
    error = new Error("Conexion a BD no encontrada!");
    error.status = 500;
    return next(error);
  }

  if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
    error = new Error("crplaza o crtienda invalidos!");
    error.status = 400;
    return next(error);
  }

  let matriz_de_alertas = req.matriz_de_alertas;
  let matriz_de_pendientes = req.pendientes_para_dashbaord;
  let matriz_final_tiendas = req.resumenbdo_matriz_tiendas_final;
  let matriz_pevop_tiendas = req.matriz_pevop_tiendas;
  let reporte_cr_plaza = req.reporte_cr_plaza;

  let arreFinal = formatoFinal (
    reporte_cr_plaza,
    matriz_final_tiendas, 
    matriz_de_alertas, 
    matriz_de_pendientes,
    matriz_pevop_tiendas
  );

  req.arreFinal = arreFinal;
  if(dbg) console.log(matriz_final_tiendas);

  next();
};

function formatoFinal ( 
    reporte_cr_plaza, 
    matriz_tiendas, 
    matriz_alertas, 
    matriz_pendientes, 
    matriz_pevop_tiendas
  ) {

  let copy_matriz_tiendas = [... matriz_tiendas];
  
  copy_matriz_tiendas.map( data_tienda => {
      let tiendas_key = data_tienda.crtienda;

      data_tienda.alertas = [];
      if(matriz_alertas[tiendas_key]) {
          data_tienda.alertas = matriz_alertas[tiendas_key];
          data_tienda.total_alertas= matriz_alertas[tiendas_key].length;
      }
    

      data_tienda.pendientes = [];
      if(matriz_pendientes[tiendas_key]) {
          data_tienda.pendientes = matriz_pendientes[tiendas_key];
          data_tienda.total_alertas +=  matriz_pendientes[tiendas_key].length;
      }

      data_tienda.pevop = null;
      tiendas_key = reporte_cr_plaza + "*" + tiendas_key;
      if(matriz_pevop_tiendas[tiendas_key]) {
          data_tienda.pevop = matriz_pevop_tiendas[tiendas_key];
      }
  });

  return copy_matriz_tiendas;
}