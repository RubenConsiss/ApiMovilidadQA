const express = require("express");
const checkAuth = require("./../../middleware/authorize");
const apiLogs = require("./../../middleware/api_logs");

const method_get = require("./tarjetas.get");
const method_post= require("./tarjetas.post");
let router = express.Router();

router.get("/lista", checkAuth, apiLogs, method_get.tarjetas_get);
router.get("/lista/:fecha_consulta", checkAuth, apiLogs, method_get.tarjetas_get);
router.get("/guardar", checkAuth, apiLogs, method_get.tarjetasGuardar_get)
router.post("/guardar", checkAuth, apiLogs, method_post.tarjetasGuardar_post);
router.get("/entregar", checkAuth, apiLogs, method_get.tarjetasEntregar_get);
router.post("/entregar", checkAuth, apiLogs, method_post.tarjetasEntregar_post)
module.exports = router;
