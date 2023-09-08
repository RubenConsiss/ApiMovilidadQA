const db = require("../../../db_logs");
const fastcsv = require("fast-csv");
const fs = require("fs");
const moment = require("moment");
const createCsv= require("./write_csv");

function RunQuery(variables) {
  return new Promise((resolve, reject) => {
   // console.log("YA ESTA EN RUN QERY");
    if (!db) {
      const error = new Error("Conexion a BD no encontrada!");
      error.status = 500;
      reject("ERROR en conexxion");
    }
    let vars = [variables.fecha_ini, variables.fecha_fin];
    let stmt = `CALL SP_XXMET_RPT_USO_SEMANAL_APP("${variables.fecha_ini}", "${variables.fecha_fin}")`;
    var   options = { sql : stmt ,  nestTables : false } 
    const qry = db.query(options, (err, result) => {
      if (err) {
        err.status = 500;
        console.log(err);
        reject("ERROR EN QUERY");
      }
      if (result.length == 0) {
        reject("ERROR no hay registros en db length = 0");
      } else {
   
        let arreReport = [];
     
        result[0].forEach((res) => {
          arreReport.push({
            PLAZA: res.PLAZA,
            TIENDA: res.TIENDA,
            DISPOSITIVO: res.DISPOSITIVO,
            TIPO: res.TIPO,
            IP_ADDRESS: res.IP_ADDRESS,
            MODULO: res.MODULO,
            PANTALLA: res.PANTALLA,
            ACCION: res.ACCION,
            METODO: res.METODO,
            USUARIO: res.USUARIO,
            FECHA: res.FECHA,
            HORA: res.HORA,
            APP_VERSION: res.APP_VERSION,
          });
        });
        resolve(arreReport);
      }
    });
  });
}

exports.createReport = function (variables) {
  return new Promise(async (resolve, reject) => {
    try {
      const fecha_ini = variables[1];
      const fecha_fin = variables[2];
      let result = await RunQuery({ fecha_ini, fecha_fin });
      const semana = moment(fecha_ini).format("WW");
      const year = moment(fecha_ini).format("YYYY");
      const nombre = `Reporte_Uso_Movilidad_En_Tienda_Semana_${semana}_${year}`;
      //console.log(result);
      //Aqui se debe llamar a la creacion del archivo
     // console.log("Lineas para el csv", result.length);
      await createCsv.createCsv(result,nombre);
      resolve(true);
    } catch (err) {
        console.log("lvl reporteUso: ",err);
      reject(err);
    }
  });
};
