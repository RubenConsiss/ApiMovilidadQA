const db = require("../../../db");
const fastcsv = require("fast-csv");
const fs = require("fs");
const moment = require("moment");
const createCsv= require("./write_csv");

function RunQueryGetData(variables) {
  return new Promise((resolve, reject) => {
  //  console.log("YA ESTA EN RUN QERY  2DO----");
    const { semana } = variables;
    const { year } = variables;
    const { plaza } = variables;
    if (!db) {
      const error = new Error("Conexion a BD no encontrada!");
      error.status = 500;
      reject("ERROR en conexxion");
    }
    let vars = [variables.fecha_ini, variables.fecha_fin];
    const stmt = `CALL SP_XXBDO_GET_RPT_BDO_SEMANAL_POR_PLAZA("${plaza}", "${semana}", "${year}")`;
    var options = { sql: stmt, nestTables: false };
    const qry = db.query(options, (err, result) => {
      if (err) {
        err.status = 500;
        console.log(err);
        reject("ERROR EN 2do stored procedure");
      }
      if (result.length == 0) {
        reject("ERROR no hay registros en db length = 0");
      } else {
       // console.log("l 28");
        let arreReport = [];
        result[0].forEach((res) => {
          arreReport.push({
            version_bdo: res.version_bdo,
            cr_plaza: res.cr_plaza,
            cr_tienda: res.cr_tienda,
            area_titulo: res.area_titulo,
            estandar: res.estandar,
            estandar_titulo: res.estandar_titulo,
            tipo_estandar: res.tipo_estandar,
            respuesta_lider: res.respuesta_lider,
            fecha_respuesta: res.fecha_respuesta,
            respuesta_año: res["respuesta_año"],
            respuesta_semana: res.respuesta_semana,
            respuesta_mes: res.respuesta_mes,
            observacion_descripcion: res.observacion_descripcion,
            observacion_causa: res.observacion_causa,
            observacion_accion: res.observacion_accion,
            observacion_accion_responsable: res.observacion_accion_responsable,
            observacion_accion_fecha: res.observacion_accion_fecha,
            observacion_requiere_ajuste_ata:
              res.observacion_requiere_ajuste_ata,
            observacion_realizaron_plan_accion:
              res.observacion_realizaron_plan_accion,
            observacion_se_resolvio_problema:
              res.observacion_se_resolvio_problema,
            observacion_nota_asesor: res.observacion_nota_asesor,
            observacion_folio: res.observacion_folio,
            observacion_turno_mañana: res["observacion_turno_mañana"],
            observacion_turno_tarde: res.observacion_turno_tarde,
            observacion_turno_noche: res.observacion_turno_noche,
            circulo_de_congruencia_fecha: res.circulo_de_congruencia_fecha,
            circulo_de_congruencia_comentario:
              res.circulo_de_congruencia_comentario,
            fecha_creacion: res.fecha_creacion,
            usuario: res.usuario,
            ip_address: res.ip_address,
          });
        });
        resolve(arreReport);
      }
    });
  });
}
function RunQuery(variables) {
  return new Promise((resolve, reject) => {
    const { semana } = variables;
    const { year } = variables;
    const { plaza } = variables;
    const { fecha_ini } = variables;
    const { fecha_fin } = variables;
  //  console.log("YA ESTA EN RUN QERY");
    if (!db) {
      const error = new Error("Conexion a BD no encontrada!");
      error.status = 500;
      reject("ERROR en conexxion");
    }
    let vars = [variables.fecha_ini, variables.fecha_fin];
    let stmt = `CALL SP_XXBDO_CREATE_TBL_RPT_BDO_SEMANAL_POR_PLAZA("${plaza}", "${semana}", "${year}", "${fecha_ini}", "${fecha_fin}")`;
    var options = { sql: stmt, nestTables: false };
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
       // console.log(result);
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
      const plaza = variables[3];
      const semana = moment(fecha_ini).format("WW");
      const year = moment(fecha_ini).format("YYYY");
      const nombre = `Reporte_BDO_Plaza_${plaza}_Semana_${semana}_${year}`;
      let SeCreoTabla = await RunQuery({
        fecha_ini,
        fecha_fin,
        plaza,
        semana,
        year,
      });
      let result = await RunQueryGetData({
        fecha_ini,
        fecha_fin,
        plaza,
        semana,
        year,
      });
     // console.log("Lineas para el csv", result.length);
      //*Aqui se debe llamar a la creacion del archivo
      await createCsv.createCsv(result,nombre);
 
      resolve(true);
    } catch (err) {
      console.log("lvl reportechecklist: ",err);
      reject(err);
    }
  });
};
