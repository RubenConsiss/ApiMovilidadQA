
const express = require("express");
const checkAuth = require("./../../middleware/authorize");
const apiLogs = require("./../../middleware/api_logs");

const method_get = require("./indicadores.get");
const method_post = require("./indicadores.post");
const method_put = require("./indicadores.put");
const calendario_checklists = require("./../calendario/calendario.checklists");

let router = express.Router();

router.get("/tipo/:tipo_consulta",
     checkAuth,
     apiLogs,
     //Get current checklist id and active checklists
     calendario_checklists.checklists,
     method_get.indicadores_get
);

router.get("/tipo/:tipo_consulta/ver/:checklist_id",
     checkAuth,
     apiLogs,
     //Get current checklist id and active checklists
     calendario_checklists.checklists,
     method_get.indicadores_get
);

router.get("/tipo/:tipo_consulta/valor/:valor",
     checkAuth,
     apiLogs,
     //Get current checklist id and active checklists
     calendario_checklists.checklists,
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

router.get("/ayuda/std/:std",
     checkAuth,
     apiLogs,
     method_get.indicadores_ayuda_get
);

module.exports = router;
