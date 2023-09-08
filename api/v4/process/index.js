const db = require("../../../db");
const uuidv4 = require("uuid/v4");
const { fork } = require("child_process");
const moment = require("moment-timezone");
const app_configuration = require("config");
//!IMPORTANTE
const TIPOS_STATUS = ["IN_PROGRESS", "CANCELLED", "DONE"];
let child_process = null;
//TODO funcion para terminar un proceso en la db
function terminarProceso() {
  const app = app_configuration.get("application");
  const tz = app.tz;
  const date= moment().tz(tz).format("YYYY-MM-DD HH:mm:ss");

  let opts = [date, "EN_PROCESO"];
  return new Promise((resolve, reject) => {
    const stmt = `UPDATE xxbdo_reportes_monitor SET reporte_status = 'TERMINADO', reporte_fin = ?  WHERE reporte_status = ? `;
    qry = db.query(stmt, opts, (err, result) => {
      if (err) {
        err.status = 500;
        reject(err);
      } else {
        if (result.length == 0) {
          resolve(null);
        } else {
          let finalObj = null;

          resolve(true);
        }
      }
    });
  });
}

//TODO Funcion para cancelar un proceso en la db
function cancelarProceso() {
  return new Promise((resolve, reject) => {

    const app = app_configuration.get("application");
    const tz = app.tz;
    const date= moment().tz(tz).format("YYYY-MM-DD HH:mm:ss");
    let opts = [date];

    let fecha = moment().format("YYYY-MM-DD");
    const stmt = `UPDATE xxbdo_reportes_monitor SET reporte_status = 'CANCELADO', reporte_fin = ?  WHERE reporte_status = 'EN_PROCESO'`;
    qry = db.query(stmt, opts, (err, result) => {
      if (err) {
        err.status = 500;
        reject(err);
      } else {
        if (result.length == 0) {
          resolve(null);
        } else {
          let finalObj = null;

          resolve(true);
        }
      }
    });
  });
}

//TODO Traer catalogo para reporte_status
function traerCatalogoReportes(codigo) {
  return new Promise((resolve, reject) => {
    stmt = "SELECT * FROM xxbdo_reportes  WHERE ? ";
    data = {
      codigo: codigo,
    };
    qry = db.query(stmt, data, (err, result) => {
      if (err) {
        err.status = 500;
        reject(err);
      } else {
        if (result.length == 0) {
          resolve(null);
        } else {
          let finalObj = null;
          result.forEach((reporte) => {
            finalObj = {
              id: reporte.id,
              nombre: reporte.nombre,
              codigo: reporte.codigo,
            };
          });
          resolve(finalObj);
        }
      }
    });
  });
}

//TODO function que valida sino existen procesos en progreso...
function existeOtroProcesoCorriendo() {
  return new Promise((resolve, reject) => {
    stmt =
      "SELECT * FROM xxbdo_reportes_monitor  WHERE reporte_status = 'EN_PROCESO' ";
    qry = db.query(stmt, null, (err, result) => {
      if (err) {
        err.status = 500;
        reject(err);
      } else {
        if (result.length == 0) {
          resolve(false);
        } else {
          resolve(true);
        }
      }
    });
  });
}

//TODO Funcion que crea un nuevo proceso en la db
async function createInDB(nombre, params, idReporteCatalogo) {
  const app = app_configuration.get("application");
  const tz = app.tz;
  const date= moment().tz(tz).format("YYYY-MM-DD HH:mm:ss");
  let parametros = params.split("*");
  parametros.splice(0, 1);

  return new Promise((resolve, reject) => {
    stmt = "INSERT INTO xxbdo_reportes_monitor SET ?";
    data = {
      id: uuidv4(),
      xxbdo_reportes_id: idReporteCatalogo,
      reporte_parametros: parametros.toString(),
      reporte_inicio: date,
      reporte_fin: null,
      reporte_status: "EN_PROCESO",
      reporte_nombre: nombre,
      activo: 1,
      usuario: null,
      ip_address: null,
      fecha_creacion: date,
      fecha_modificacion: date,
    };
    qry = db.query(stmt, data, (err, results) => {
      if (err) {
        err.status = 500;
        reject(err);
      } else {
        resolve(data.id);
      }
    });
  });
}
//TODO esta funcion corre el proceso de ./process_manager.js como un child process
function initFork(process) {
  child_process = fork(__dirname + "/process_manager");
  child_process.on("message", async (message) => {
    try {
      console.log(message);
      //TODO Si el reporte se genero correctamente entonces se termina el proceso en la db
      if (message == "TERMINADO") {
        await terminarProceso();

        child_process.kill();
        //TODO sino el proceso se actualiza como cancelado
      } else {
        await cancelarProceso();
        console.log(message);
        child_process.kill();
      }
    } catch (err) {
      console.log(err);
    }
  });
  child_process.send(process);
}

/* 
TODO
*1.- Se debe buscar si existe otro porceso corriendo
*2.- Sino existe otro proceso corriendo, se debe insertar en la db con el estatus en progress
*/

//TODO Funcion principal del modulo de procesos
exports.initProcess = async function (process, processString) {
  try {
    const existenProcesosCorriendo = await existeOtroProcesoCorriendo();

    if (existenProcesosCorriendo != false) {
      console.log("YA HAY UN PROCESO CORRIENDO");
      return null;
    } else {
      // console.log("NO HAY PROCESOS CORRIENDO");
      let codigo = "RPT_MET_0001";
      if (process != "INICIAR_REPORTE_DE_USO") {
        codigo = "RPT_MET_0002";
      }
      const reporteCatalogo = await traerCatalogoReportes(codigo);
      const variables = processString.split("*");
      const fecha_ini = variables[1];
      const semana = moment(fecha_ini).week();
      const year = moment(fecha_ini).year();
      if (codigo == "RPT_MET_0001") {
        // console.log(reporteCatalogo);
        const resp = await createInDB(
          `Reporte_Uso_Movilidad_En_Tienda_Semana_${semana}_${year}`,
          processString,
          reporteCatalogo.id
        );
        //    console.log("Se inserto proceso en db proceso_id ->", resp);
        initFork(processString);
      } else {
        const plaza = variables[3];
        //  console.log(reporteCatalogo);
        const resp = await createInDB(
          `Reporte_BDO_Plaza_${plaza}_Semana_${semana}_${year}`,
          processString,
          reporteCatalogo.id
        );
        //   console.log("Se inserto proceso en db proceso_id ->", resp);
        initFork(processString);
        //* Para reporte de checklist ....
      }
    }
  } catch (err) {
    console.log(err);
  }
};
