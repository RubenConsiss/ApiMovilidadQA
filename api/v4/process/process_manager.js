const reporte_uso = require("./reporte_uso");
const reporte_checklist = require("./reporte_checklist");
/* 
  !TERMINOLOGIA PARA MENSAJES
  *PARA REPORTE CHECKLIST
  TODO accion*plaza*año*fecha_ini*fecha_fin
  *PARA REPORTE SEMANALES
  TODO accion*fecha_ini*fecha_fin

  !TIPOS DE STATUS -> EN_PROCESO / TERMINADO / CANCELADO 
  */
process.on("message", (message) => {
  const variables = message.split("*");
  console.log(variables);
  const action = variables[0];
  switch (action) {
    case "INICIAR_REPORTE_DE_USO":
      console.log("Child process received REPORTE DE USO message");
      reporte_uso
        .createReport(variables)
        .then((resp) => {
        //  console.log("YA SE TERMINO");
          process.send("TERMINADO");
        })
        .catch((err) => {
         process.send("CANCELADO");
        });

      break;

    case "INICIAR_REPORTE_CHECKLIST":
      console.log("Child process received REPORTE DE CHECKLIST message");
      reporte_checklist
        .createReport(variables)
        .then((resp) => {
      //    console.log("YA SE TERMINO");
          process.send("TERMINADO");
        })
        .catch((err) => {
           process.send("CANCELADO");
        });

      //process.send(message);
      break;

    default:
      console.log("NO EXISTE CASO EN LISTA DE PROCESOS DISPONIBLES");
      break;
  }
});
