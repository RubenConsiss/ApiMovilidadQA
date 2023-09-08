const express = require("express");
const checkAuth = require("../../middleware/authorize")
const bdoDates = require("../../helpers/bdo-dates");
const apiLogs = require("./../../middleware/api_logs");
const uploadMulter = require("../../helpers/multer-azure-directos");
const cargar_evidencia_post = require("./media.post");
const cargar_evidencia_get = require("./media.get");
const enviar_evidencia = require("./send-email");
const enviar_evidencia_v1 = require("./send-email-v1");
const actividad_proveedor = require("./actividad_proveedor.post");
const actividad_proveedor_get = require("./actividad_proveedor.get");
const preguntas_frecuentes = require("./preguntas.frecuentes.get");
const VisitaProveedorServicePost = require('./visitas/visitas.post')
const VisitaProveedorServiceGet = require('./visitas/visitas.get')

let router = express.Router();

router.get("/", function (req, res) {
  return res.send({ fecha_actual: bdoDates.getBDOCurrentTimestamp() })
});

router.get("/read-media/:transaccion/:file",
  checkAuth,
  apiLogs,
  cargar_evidencia_get.directos_media_get
);

router.get("/log-activity/:idProveedor?",
  checkAuth,
  apiLogs,
  actividad_proveedor_get.directos_actividad_proveedor_get
);

router.get("/preguntas-frecuentes",
  checkAuth,
  apiLogs,
  preguntas_frecuentes.main
);

router.get("/log-visit/",
  checkAuth,
  apiLogs,
  VisitaProveedorServiceGet.main
);

router.post("/upload-media/:transaccion",
  checkAuth,
  apiLogs,
  uploadMulter.any(),
  cargar_evidencia_post.directos_media_post
);

router.post("/send-email/",
  checkAuth,
  apiLogs,
  enviar_evidencia.send_email
);


router.post("/send-email/v1",
  checkAuth,
  apiLogs,
  enviar_evidencia_v1.send_email
);

router.post("/log-activity/",
  checkAuth,
  apiLogs,
  actividad_proveedor.directos_actividad_proveedor
);

router.post("/log-visit/",
  checkAuth,
  apiLogs,
  VisitaProveedorServicePost.main
);

module.exports = router;