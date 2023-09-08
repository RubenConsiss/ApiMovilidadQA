const express = require("express");
const operativa_get = require("./operativa.get")
const operativa_post = require("./operativa.post")
const lider_nuevo_get = require("./lider_nuevo.get")
const lider_nuevo_post = require("./lider_nuevo.post")
const pendiente_asesor_get = require("./pendiente_asesor.get")
const pendiente_lider_get = require("./pendiente_lider.get")
const pendiente_asesor_post = require("./pendiente_asesor.post")
const pendiente_lider_post = require("./pendiente_lider.post")
const enfoque_mensual_get = require("./enfoque_mensual.get")
const enfoque_mensual_post = require("./enfoque_mensual.post")
const enfoque_mensual_update = require("./enfoque_mensual.update")
const enfoque_mensual_delete = require("./enfoque_mensual.delete")
const utensilios = require("./utensilios.get")
const utensilios_post = require("./utensilios.post")
const checkAuth = require("../../middleware/authorize")
const bdoDates = require("../../helpers/bdo-dates");
const apiLogs = require("./../../middleware/api_logs");

let router = express.Router();

router.get("/", function (req, res) {
  return res.send({ fecha_actual: bdoDates.getBDOCurrentTimestamp() })
});

/* GET DATA */
router.get("/responsabilidad-operativa/:anio/:mes",
  checkAuth,
  apiLogs,
  operativa_get.simplex_operativa_get
);

router.get("/lider-nuevo/:anio/:semana",
  checkAuth,
  apiLogs,
  lider_nuevo_get.simplex_lider_nuevo_get
);

router.get("/pendiente-asesor/:anio/:semana",
  checkAuth,
  apiLogs,
  pendiente_asesor_get.simplex_pendiente_asesor_get
);

router.get("/pendiente-lider/:anio/:semana",
  checkAuth,
  apiLogs,
  pendiente_lider_get.simplex_pendiente_lider_get
);

router.get("/enfoque-mensual/:anio/:mes",
  checkAuth,
  apiLogs,
  enfoque_mensual_get.simplex_enfoque_mensual_get
);

router.get("/utensilios/:anio/:mes",
  checkAuth,
  apiLogs,
  utensilios.simplex_utensilios_get
);

/* STORE DATA */
router.post("/responsabilidad-operativa/",
  checkAuth,
  apiLogs,
  operativa_post.simplex_operativa_post
);

router.post("/lider-nuevo/",
  checkAuth,
  apiLogs,
  lider_nuevo_post.simplex_lider_nuevo_post
);

router.post("/pendiente-asesor/",
  checkAuth,
  apiLogs,
  pendiente_asesor_post.simplex_pendiente_asesor_post
);

router.post("/pendiente-lider/",
  checkAuth,
  apiLogs,
  pendiente_lider_post.simplex_pendiente_lider_post
);

router.post("/enfoque-mensual/store/",
  checkAuth,
  apiLogs,
  enfoque_mensual_post.simplex_enfoque_mensual_post
);

router.post("/enfoque-mensual/update/",
  checkAuth,
  apiLogs,
  enfoque_mensual_update.simplex_enfoque_mensual_update
);

router.post("/enfoque-mensual/delete/",
  checkAuth,
  apiLogs,
  enfoque_mensual_delete.simplex_enfoque_mensual_delete
);

router.post("/utensilios/",
  checkAuth,
  apiLogs,
  utensilios_post.simplex_utensilios_post
);

module.exports = router;