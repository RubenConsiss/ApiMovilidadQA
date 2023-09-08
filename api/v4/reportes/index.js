
const express = require("express");
const checkAuth = require("./../../middleware/authorize");
const apiLogs = require("./../../middleware/api_logs");

const method_get = require("./reportes.get");
const method_post = require("./reportes.post");

let router = express.Router();

router.get("/",
     checkAuth,
     apiLogs,
     method_get.reportes_get
);

router.get("/descargar/:id",
     //checkAuth,
     apiLogs,
     method_get.reporte_descargar_get
);

router.post("/inicio", 
            checkAuth, 
            apiLogs,
            method_post.reportes_inicio_post
);

module.exports = router;
