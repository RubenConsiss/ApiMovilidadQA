
const express = require("express"),
      checkAuth = require("./../../middleware/authorize"),
      uploadMulter = require("./../../helpers/multer-azure");

const method_get = require("./observaciones.get"),
      method_post  = require("./observaciones.post");
      method_put   = require("./observaciones.put"),
      apiLogs = require("./../../middleware/api_logs");

let router = express.Router();

//router.get("/fecha/:ofecha",
//     checkAuth,
//     method_get.observaciones_get
//);

//router.post("/", 
//      checkAuth, 
//      uploadMulter.any(),
//      method_post.observaciones_post);

//router.put("/", 
//     checkAuth, 
//     uploadMulter.any(),
//     method_put.observaciones_put);

router.post("/foto", 
     checkAuth, 
     uploadMulter.any(),
     apiLogs,
     method_post.observaciones_foto_post);

module.exports = router;
