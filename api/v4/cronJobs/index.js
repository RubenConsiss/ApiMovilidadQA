var cron = require("node-cron");
const db = require("../../../db");
const process_controller = require("../process/index");
const moment = require("moment-timezone");
const app_configuration = require("config");
/* 
TODO  
*1.- Se debe obtener la lista de crons de la base de datos de OK
*2.- Se se debe iterar la lista para inicializar los jobs en los procesos correspondientes  OK
*/

//TODO Funcion que obtiene el listado de jobs desde la db
function getCrons() {
  return new Promise((resolve, reject) => {
    if (!db) {
      const error = new Error("Conexion a BD no encontrada!");
      error.status = 500;
      reject("ERROR en conexxion");
    }

    let stmt = "SELECT * FROM `xxbdo_cron_jobs` WHERE is_active=1 AND active=1";
    const qry = db.query(stmt, null, (err, result) => {
      if (err) {
        err.status = 500;
        console.log(err);
        reject("ERROR EN QUERY");
      }

      if (result.length == 0) {
        reject("No hay Jobs asignados en DB");
      } else {
        let arreCrons = [];
        result.forEach((cron) => {
          arreCrons.push({
            id: cron.id,
            job_name: cron.job_name,
            job_second: cron.job_second,
            job_minute: cron.job_minute,
            job_hour: cron.job_hour,
            job_day_of_month: cron.job_day_of_month,
            job_month: cron.job_month,
            job_day_of_week: cron.job_day_of_week,
            activo: cron.activo,
          });
        });

        resolve(arreCrons);
      }
    });
  });
}

// TODO Ejecuta los procesos correspondientes segun el cron de

function cronsSwitch(job) {
  const app = app_configuration.get("application");
  const tz = app.tz;

  let processString = "";
  let plaza = "10VCZ";
  let fechaIni = moment()
    .tz(tz)
    .subtract(7, "days")
    .set({ hour: 0, minute: 0, second: 0 })
    .format("YYYY-MM-DD HH:mm:ss"); //"2020-10-12 00:00:00"
  let fechaFin = moment()
    .tz(tz)
    .subtract(1, "days")
    .set({ hour: 23, minute: 59, second: 59 })
    .format("YYYY-MM-DD HH:mm:ss"); //"2020-10-18 23:59:59"

  switch (job) {
    case "REPORTE DE USO MOVILIDAD EN TIENDA":
      processString = `INICIAR_REPORTE_DE_USO*${fechaIni}*${fechaFin}`;
      process_controller.initProcess("INICIAR_REPORTE_DE_USO", processString);
      break;
    case "REPORTE DE CAPTURA DE CHECKLIST BDO PLAZA":
      processString = `INICIAR_REPORTE_CHECKLIST*${fechaIni}*${fechaFin}*${plaza}`;
      process_controller.initProcess(
        "INICIAR_REPORTE_CHECKLIST",
        processString
      );
      break;
    default:
      console.log("Job Case no encontrado, acción sin ejecutar ...");
      break;
  }
}

//TODO Funcion principal del modulo de cron jobs
exports.initCrons = async function () {
  try {
    let jobsCrons = await getCrons();
    jobsCrons.map((job, index) => {
      const job_freq = `${job.job_second} ${job.job_minute} ${job.job_hour} ${job.job_day_of_month} ${job.job_month} ${job.job_day_of_week}`;
      console.log(job_freq, job.job_name);
      //TODO Se inicializa CRON JOB  en la frecuencia establecida
      cron.schedule(
        job_freq,
        () => {
          console.log(
            `Corriendo job: ${job.job_name} id: ${job.id} con freq: ${job_freq}`
          );
          cronsSwitch(job.job_name);
        },
        { timezone: "America/Monterrey" }
      );
    });
  } catch (e) {
    console.log(e);
  }
};
