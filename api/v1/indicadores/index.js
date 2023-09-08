
const express = require("express"),
checkAuth     = require("./../../middleware/authorize"),
apiLogs = require("./../../middleware/api_logs");

const method_get = require("./indicadores.get"),
method_post      = require("./indicadores.post"),
method_put       = require("./indicadores.put");

let router = express.Router();

router.get("/tipo/:tipo_consulta",
     checkAuth,
     apiLogs,
     method_get.indicadores_get
);

router.get("/tipo/:tipo_consulta/valor/:valor",
     checkAuth,
     apiLogs,
     method_get.indicadores_get
);

router.post("/", 
            checkAuth, 
            apiLogs,
            method_post.indicadores_post);

router.put("/", 
           checkAuth, 
           apiLogs,
           method_put.indicadores_put);

module.exports = router;
