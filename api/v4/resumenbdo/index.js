
const express = require("express"),
checkAuth = require("./../../middleware/authorize"),
apiLogs = require("./../../middleware/api_logs");

const checklists = require("./checklists");
const configuracion = require("./configuracion");
const pevop = require("./pevop");
const calendario = require("./calendario");
const calendario_alertas= require("./calendario_fallas");
const respuestas = require("./respuestas");
const matriz = require("./matriz");
const tiendas = require("./tiendas");
const method_post = require("./resumenbdo.post");
const alertas= require("./alertas");
const pendientes = require("./pendientes");
const dashboard = require("./dashboard");
let router = express.Router();

router.post (
    "/", 
    checkAuth, 
    apiLogs,
    checklists.info,
    configuracion.reporte,
    calendario.matriz_tiendas,
    calendario_alertas.matriz_tiendas,
    tiendas.lista_nombres,
    respuestas.historial,
    matriz.formato_final,
    alertas.recolectar_alertas,
    pevop.matriz_pevop,
    pendientes.buscar_pendientes,
    dashboard.formato_final,
    method_post.resumenbdo_post
);

module.exports = router;