
const express = require("express");
const apiAuthorizeV2 = require("./authorize");
const apiChecklistV2 = require("./checklist");
const apiBitacoraV2 = require("./bitacora");
const apiObservacionesV2 = require("./observaciones");
const apiIndicadoresV2 = require("./indicadores");
const apiCalendarioV2 = require("./calendario");

let app = express();

//Load Api components
app.use("/authorize", apiAuthorizeV2);
//
app.use("/checklist", apiChecklistV2);
//
app.use("/observaciones", apiObservacionesV2);
//
app.use("/bitacora", apiBitacoraV2);

app.use("/indicadores", apiIndicadoresV2);

app.use("/calendario", apiCalendarioV2);

module.exports = app;
