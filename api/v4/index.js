
const express = require("express");
const apiAuthorizeV4 = require("./authorize");
const apiCalendarioV4 = require("./calendario");
const apiChecklistV4 = require("./checklist");
const apiDetallesV4 = require("./detalles");
const apiEstandaresV4 = require("./estandares");
const apiIndicadoresV4 = require("./indicadores");
const apiPendientesV4 = require("./pendientes");
const apiUtensiliosV4 = require("./utensilios");
const apiResumenBdoV4 = require("./resumenbdo");
const apiReportesV4 = require("./reportes");
const apiTarjetasV4 = require("./tarjetas");
const apiBalancerV4 = require("./balancer"); // for demo balancer
const apiMermaCafeV4 = require("./mermacafe");
const simplex = require("./simplex");
const cedis = require("./cedis");
const directos = require("./directos");

const cronJobs = require("../v4/cronJobs");

//load cron jobs
cronJobs.initCrons()

let app = express();
//Load Api components
app.use("/authorize", apiAuthorizeV4);

app.use("/checklist", apiChecklistV4);

app.use("/detalles", apiDetallesV4);

app.use("/estandares", apiEstandaresV4);

app.use("/indicadores", apiIndicadoresV4);

app.use("/calendario", apiCalendarioV4);

app.use("/pendientes", apiPendientesV4);

app.use("/utensilios", apiUtensiliosV4);

app.use("/resumenbdo", apiResumenBdoV4);

app.use("/reportes", apiReportesV4);

app.use("/tarjetas", apiTarjetasV4);

app.use("/balancer", apiBalancerV4); //for demo balancer changeurl

app.use("/mermacafe", apiMermaCafeV4);

app.use("/simplex", simplex);

app.use("/cedis", cedis);

app.use("/directos", directos);

module.exports = app;
