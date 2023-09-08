
const express = require("express");
const app = express();
const helmet = require("helmet");
const morgan = require("morgan");
const bodyParser = require("body-parser");
const validator = require("express-validator");
const moment = require("moment-timezone");
const requestIp = require("request-ip");
const winston = require("./config/winston");
const uuidv4 = require('uuid/v4');
bdoDates = require("./api/helpers/bdo-dates");
const logResponses = require("./api/middleware/api_responses_logs");

//Define global moment timezone
moment.tz.setDefault(process.env.TZ);

//Require Api module
const api = require("./api");

app.use(helmet()); //https://helmetjs.github.io/
app.use(helmet.hidePoweredBy({ setTo: '' }));

if (process.env.NODE_ENV !== 'production') {
  app.use(morgan("dev"));
  app.use(morgan('combined', { stream: winston.stream }));
}

// for parsing application/json
//app.use(bodyParser.json()); 
// for parsing application/x-www-form-urlencoded
//app.use(bodyParser.urlencoded({ extended: false })); 
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true, parameterLimit: 50000 }));
// keep this after bodyParser
app.use(validator());

app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  );
  if (req.method === "OPTIONS") {
    res.header("Access-Control-Allow-Methods", "PUT, POST, GET");
    return res.status(200).json();
  }
  
  req.app_full_url = req.protocol + "://" + req.headers.host;

  req.app_client_ip_address = requestIp.getClientIp(req);

  req.app_request_id = uuidv4();
  //to view json request body 
  //console.log("["+req.app_request_id+"] Request body: "+JSON.stringify(req.body));

  //temp solution to log responses body, debug purposes only:
  res.on('finish', () => {
    if(res.api_response_body) {
      logResponses.logApiResponseInfo(req.app_request_id, res.statusCode, res.api_response_body);
    }
  });

  next();
});

// Routes which should handle requests
app.get("/", (req, res, next) => {
  var dt = bdoDates.getBDOUTCCurrentTimestamp() + " (UTC)";//Date.now();
  var nenv = process.env.NODE_ENV || 'development';
  var last_activity = "2018-11-02 21:49:39 (UTC)";//Development
  if(nenv=='production') {
    last_activity = "2018-10-18 20:19:22 (UTC)"; 
  }
  res.status(200).json({"now":dt, "api":nenv, "last_activity":last_activity});
});

//Load Api BDO module
app.use("/bdo", api);

//Route for App configuration
const checkAuth = require("./api/middleware/authorize"),
method_get = require("./api/v4/app/app.get");
app.use("/appconfig", checkAuth, method_get.app_get);

method_post = require("./api/v4/logs/logs.post");
app.use("/logs", checkAuth, method_post.logs_post);

//Grab anything that isn't routed elsewhere and throw a generic '404' error.
//app.use((req, res, next) => {
//  const error = new Error('Not Found');
//  error.status = 404;
//  next(error);
//});

//Error-handling middleware
app.use((error, req, res, next) => {
  if (!error.status) {
    // Sets a generic server error status code if none is part of the error
    error.status = 500;
  }

  let sql = null;
  if(error.sql) {
    sql = error.sql;
    sql = sql.replace( /[\r\n]+/gm, "").replace(/\s+/g," ");
  }
  // add this line to include winston logging, move error level after timestamp
    winston.error(
      (new Date()).toISOString() + 
      ` - ${req.app_request_id} - ` +
      ` - ${req.app_client_ip_address} - ${req.method} - ${error.status || 500}`+
      ` - ${req.originalUrl} - ${error.message}` +
      (sql ? ` - ${sql}` : "") + 
      ` - ${error.stack}`
    );
  //
  res.status(error.status || 500).json();
  //next(error);
});

module.exports = app;
