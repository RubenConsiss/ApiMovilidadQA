
const express = require("express");
const checkAuth = require("./../../middleware/authorize");
const apiLogs = require("./../../middleware/api_logs");

let router = express.Router();

let controller = require("./estandares.post");
const calendario_checklists = require("./../calendario/calendario.checklists");
const estandares = require("./estandares.configuracion");

router.post("/", 
            checkAuth, 
            apiLogs,
            calendario_checklists.checklists,
            estandares.configuracion,
            controller.estandares_post);

controller = require("./estandares.put");
router.put("/", 
           checkAuth, 
           apiLogs,
           controller.estandares_put);

controller = require("./estandares.delete");
router.delete("/", 
            checkAuth, 
            apiLogs,
            controller.estandares_delete);

module.exports = router;