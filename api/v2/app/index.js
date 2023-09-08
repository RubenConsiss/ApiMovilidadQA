
const express = require("express"),
checkAuth = require("./../../middleware/authorize");

const method_get = require("./app.get");

let router = express.Router();

router.get("/config",
checkAuth,
method_get.app_get
);

module.exports = router;
