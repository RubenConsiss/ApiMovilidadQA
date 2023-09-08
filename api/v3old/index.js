
const express = require("express");
const apiAuthorizeV3 = require("./authorize");
const apiChecklistV3 = require("./checklist");
const apiBitacoraV3 = require("./bitacora");
const apiObservacionesV3 = require("./observaciones");
const apiIndicadoresV3 = require("./indicadores");
const apiCalendarioV3 = require("./calendario");
const apiPendientesV3 = require("./pendientes");
const apiUtensiliosV3 = require("./utensilios");

let app = express();

//Load Api components
app.use("/authorize", apiAuthorizeV3);

app.use("/checklist", apiChecklistV3);

app.use("/observaciones", apiObservacionesV3);

app.use("/bitacora", apiBitacoraV3);

app.use("/indicadores", apiIndicadoresV3);

app.use("/calendario", apiCalendarioV3);

app.use("/pendientes", apiPendientesV3);

app.use("/utensilios", apiUtensiliosV3);

module.exports = app;
