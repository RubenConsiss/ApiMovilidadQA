
const express = require("express");
const checkAuth = require("./../../middleware/authorize");
const apiLogs = require("./../../middleware/api_logs");

const utensilios_ayuda = require("./utensilios.get.ayuda");
const utensilios_respuestas = require("./utensilios.respuestas");
//const utensilios_headers    = require("./utensilios.headers");
const utensilios = require("./utensilios");
//const utensilios_checklists = require("./utensilios.checklists");
const utensilios_conf = require("./utensilios.configuracion");
const utensilios_historial = require("./utensilios.historial");
const utensilios_lista = require("./utensilios.lista");
const utensilios_categorias = require("./utensilios.categorias");
const method_post = require("./utensilios.post");
const method_put = require("./utensilios.put");

let router = express.Router();

router.get("/cliente/:tipo_cliente",
     checkAuth,
     apiLogs,
     //utensilios_checklists.checklists,
     utensilios_conf.configuracion,
     utensilios_categorias.categorias,
     utensilios_respuestas.respuestas_get,
     //utensilios_headers.update_headers,
     utensilios_historial.detalle_utensilios,
     utensilios.utensilios_get
);

router.get("/cliente/:tipo_cliente/valor/:valor",
     checkAuth,
     apiLogs,
     //Get current checklist id and active checklists
     //utensilios_checklists.checklists,
     utensilios_conf.configuracion,
     utensilios_categorias.categorias,
     utensilios_respuestas.respuestas_get,
     //utensilios_headers.update_headers,
     utensilios_historial.detalle_utensilios,
     utensilios.utensilios_get
);

router.get("/lista",
     checkAuth,
     apiLogs,
     utensilios_conf.configuracion,
     utensilios_categorias.categorias,
     utensilios_lista.catalogo
);

router.get("/ayuda/id/:id",
           checkAuth,
           apiLogs,
           utensilios_ayuda.utensilios_ayuda
);

router.post (
     "/", 
     checkAuth, 
     apiLogs,
     utensilios_conf.configuracion,
     method_post.utensilios_post
);

router.put(
     "/", 
     checkAuth, 
     apiLogs,
     method_put.utensilios_put
);

module.exports = router;