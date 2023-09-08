
const express = require("express");
const checkAuth = require("./../../middleware/authorize");
const apiLogs = require("./../../middleware/api_logs");

let router = express.Router();

const calendario_roles = require("./../calendario/calendario.roles.en.tienda");
let controller = require("./detalles.get");
router.get("/:respuesta_id",
     checkAuth,
     apiLogs,
     calendario_roles.roles_en_tienda,
     controller.detalles_get
);

controller = require("./detalles.post");
router.post("/", 
      checkAuth, 
      apiLogs,
      controller.detalles_post
);

module.exports = router;