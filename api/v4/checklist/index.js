
const express = require("express");
const checkAuth = require("./../../middleware/authorize");
const apiLogs = require("./../../middleware/api_logs");

const method_get = require("./checklist.get");
const method_post = require("./checklist.post");
const method_put = require("./checklist.put");

let router = express.Router();

router.get("/ayuda/std/:std",
           checkAuth,
           apiLogs,
           method_get.checklist_get_ayuda
);

router.post("/", 
      checkAuth, 
      apiLogs,
      method_post.checklist_post);

router.put("/", 
      checkAuth, 
      apiLogs,
      method_put.checklist_put);

module.exports = router;
