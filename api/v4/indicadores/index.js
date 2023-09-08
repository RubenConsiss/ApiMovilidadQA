
const express = require("express");
const checkAuth = require("./../../middleware/authorize");
const apiLogs = require("./../../middleware/api_logs");

let router = express.Router();

const calendario_checklists = require("./../calendario/calendario.checklists");
const calendario_indicadores_respuestas = require("./calendario.indicadores.respuestas");
const calendario_indicadores = require("./../calendario/calendario.indicadores");
const calendario_headers = require("./../calendario/calendario.headers");
const calendario_respuestas = require("./calendario.respuestas");
const calendario_estandares = require("./calendario.estandares");

router.get("/cliente/:tipo_cliente",
     checkAuth,
     apiLogs,
     calendario_checklists.checklists,
     calendario_indicadores_respuestas.indicadores_respuestas,
     calendario_indicadores.indicadores,
     calendario_respuestas.respuestas_get,
     calendario_headers.update_headers,
     calendario_estandares.calendario_get
);

router.get("/cliente/:tipo_cliente/valor/:valor",
     checkAuth,
     apiLogs,
     calendario_checklists.checklists,
     calendario_indicadores_respuestas.indicadores_respuestas,
     calendario_indicadores.indicadores,
     calendario_respuestas.respuestas_get,
     calendario_headers.update_headers,
     calendario_estandares.calendario_get
);

router.get("/cliente/:tipo_cliente/ver/:checklist_id",
     checkAuth,
     apiLogs,
     calendario_checklists.checklists,
     calendario_indicadores_respuestas.indicadores_respuestas,
     calendario_indicadores.indicadores,
     calendario_respuestas.respuestas_get,
     calendario_headers.update_headers,
     calendario_estandares.calendario_get
);

let controller = require("./indicadores.get");
router.get("/ayuda/std/:std",
     checkAuth,
     apiLogs,
     controller.indicadores_ayuda_get
);

controller = require("./indicadores.post");
router.post("/", 
            checkAuth, 
            apiLogs,
            calendario_checklists.checklists,
            controller.indicadores_post);

controller = require("./indicadores.put");
router.put("/", 
           checkAuth, 
           apiLogs,
           controller.indicadores_put);

controller = require("./indicadores.delete");
router.delete("/", 
            checkAuth, 
            apiLogs,
            controller.indicadores_delete);

module.exports = router;
