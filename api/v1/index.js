
const express = require("express"),
      apiAuthorizeV1 = require("./authorize"),
      apiChecklistV1 = require("./checklist"),
      apiBitacoraV1 = require("./bitacora"),
      apiObservacionesV1 = require("./observaciones"),
      apiIndicadoresV1 = require("./indicadores");

let app = express();

//Load Api components
app.use("/authorize", apiAuthorizeV1);
//
app.use("/checklist", apiChecklistV1);
//
app.use("/observaciones", apiObservacionesV1);
//
app.use("/bitacora", apiBitacoraV1);

app.use("/indicadores", apiIndicadoresV1);

module.exports = app;
