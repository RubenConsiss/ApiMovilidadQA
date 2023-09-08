
const express = require("express");
const checkAuth = require("./../../middleware/authorize");
const uploadMulter = require("./../../helpers/multer-azure");
const apiLogs = require("./../../middleware/api_logs");

const calendario_roles = require("./calendario.roles.en.tienda");
const calendario_indicadores_respuestas = require("./calendario.indicadores.respuestas");
const calendario_indicadores = require("./calendario.indicadores");
const calendario_respuestas = require("./calendario.respuestas");
const calendario_headers = require("./calendario.headers");
const calendario_estandares = require("./calendario.estandares");
const calendario_checklists = require("./calendario.checklists");
const calendario_detalles = require("./calendario.detalles.get");
const calendario_fotos = require("./calendario.foto.post");

let router = express.Router();

router.get("/cliente/:tipo_cliente/tipo/:tipo_consulta",
     checkAuth,
     apiLogs,
     //Get current checklist id and active checklists
     calendario_checklists.checklists,
     calendario_indicadores_respuestas.indicadores_respuestas,
     calendario_indicadores.indicadores,
     //Generate respuestas array
     calendario_respuestas.respuestas_get,
     //generar un middleware aqui para recorrer el array de headers
     //y asignarle en la propiedad "ck" el checklist al que pertenecen
     //en base a la fecha del día/semana/mes que tienen en la propiedad "dt"
     calendario_headers.update_headers,
     //Generate estandares template and fix celdas con respuestas array
     calendario_estandares.calendario_get
);

router.get("/cliente/:tipo_cliente/tipo/:tipo_consulta/ver/:checklist_id",
     checkAuth,
     apiLogs,
     //Get current checklist id and active checklists
     calendario_checklists.checklists,
     calendario_indicadores_respuestas.indicadores_respuestas,
     calendario_indicadores.indicadores,
     //Generate respuestas array
     calendario_respuestas.respuestas_get,
     //generar un middleware aqui para recorrer el array de headers
     //y asignarle en la propiedad "ck" el checklist al que pertenecen
     //en base a la fecha del día/semana/mes que tienen en la propiedad "dt"
     calendario_headers.update_headers,
     //Generate estandares template and fix celdas con respuestas array
     calendario_estandares.calendario_get
);

router.get("/cliente/:tipo_cliente/tipo/:tipo_consulta/valor/:valor",
     checkAuth,
     apiLogs,
     //Get current checklist id and active checklists
     calendario_checklists.checklists,
     calendario_indicadores_respuestas.indicadores_respuestas,
     calendario_indicadores.indicadores,
     calendario_respuestas.respuestas_get,
     calendario_headers.update_headers,
     calendario_estandares.calendario_get
);

router.get("/detalles/tipo/:tipo_consulta/valor/:valor",
     checkAuth,
     apiLogs,
     calendario_roles.roles_en_tienda,
     calendario_detalles.detalles_get
);

router.post("/foto", 
     checkAuth, 
     uploadMulter.any(),
     apiLogs,
     calendario_fotos.foto_post);

module.exports = router;
