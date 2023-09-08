
const express = require("express");
const checkAuth = require("./../../middleware/authorize");
const apiLogs = require("./../../middleware/api_logs");

const method_get = require("./mermacafe.get");

let router = express.Router();

router.get("/test",
     checkAuth,
     apiLogs,
     method_get.merma_cafe
);

module.exports = router;
