
const express = require("express"),
      method_post  = require("./authorize.post"),
      apiLogs = require("./../../middleware/api_logs");

let router = express.Router();

router.post("/", 
method_post.authorize_post_login_attempt, 
apiLogs,
method_post.authorize_post_store_validation, 
method_post.authorize_post);

module.exports = router;
