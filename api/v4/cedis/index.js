const express = require("express");
const checkAuth = require("../../middleware/authorize")
const bdoDates = require("../../helpers/bdo-dates");
const apiLogs = require("./../../middleware/api_logs");
const uploadMulter = require("../../helpers/multer-azure-cedis");
const cargar_evidencia_post = require("./media.post");
const cargar_evidencia_get = require("./media.get");
const enviar_evidencia = require("./send-email");
const enviar_devolucion = require("./send-email-devolucion");

let router = express.Router();

router.get("/", function (req, res) {
  return res.send({ fecha_actual: bdoDates.getBDOCurrentTimestamp() })
});

router.get("/read-media/:transaccion/:file",
  checkAuth,
  apiLogs,
  cargar_evidencia_get.cedis_media_get
);

router.post("/upload-media/:transaccion/:type?",
  checkAuth,
  apiLogs,
  uploadMulter.any(),
  cargar_evidencia_post.cedis_media_post
);

router.post("/send-email/",
  checkAuth,
  apiLogs,
  enviar_evidencia.send_email
);

router.post("/send-email/devolucion",
  checkAuth,
  apiLogs,
  enviar_devolucion.send_email
);

module.exports = router;