
const express = require("express");
const checkAuth = require("./../../middleware/authorize");
const apiLogs = require("./../../middleware/api_logs");

const pendientes = require("./pendientes.roles.en.tienda");
const method_get = require("./pendientes.get");
const method_post = require("./pendientes.post");
const method_put = require("./pendientes.put");

let router = express.Router();

router.get("/",
     checkAuth,
     apiLogs,
     pendientes.roles_en_tienda,
     method_get.pendientes_get
     
);

router.get("/valor/:valor",
     checkAuth,
     apiLogs,
     pendientes.roles_en_tienda,
     method_get.pendientes_get
);

router.post("/", 
            checkAuth, 
            apiLogs,
            method_post.pendientes_post);

router.put("/", 
           checkAuth, 
           apiLogs,
           method_put.pendientes_put);

module.exports = router;
