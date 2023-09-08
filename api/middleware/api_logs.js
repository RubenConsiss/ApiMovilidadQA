
const db = require("./../../db_logs");
const dbCopy = require("./../../db_logs_copy");
//uuidv4 = require('uuid/v4'),
bdoDates = require("./../helpers/bdo-dates");
//util = require('util');
const dbg = false;

module.exports = (req, res, next) => {
if(!db) {
    const error = new Error('Conexión a BD Logs no encontrada!');
    error.status = 500;
    return next(error);
}
//var log_api = process.env.LOG_BDO_API_REQUESTS || false;
//console.log("log_api? "+log_api);
//
cr_plaza=null, cr_tienda=null;
if(req.tokenData) {
    cr_plaza = req.tokenData.crplaza;
    cr_tienda = req.tokenData.crtienda;
}
log_level='INFO'; //TRACE, DEBUG, INFO, WARN, ERROR and FATAL
operation_type = (res.operation_type ? res.operation_type : 'request');// request or response, fix this
operation_status=(res.operation_status ? res.operation_status : null);
req_token_data = (req.tokenData ? JSON.stringify(req.tokenData) : null);
operation_message=(res.operation_message ? res.operation_message : req_token_data);
req_headers = JSON.stringify(req.headers);
req_body = JSON.stringify(req.body);
full_url = req.app_full_url+req.originalUrl;
req_files = JSON.stringify(req.files);
//console.log("["+req.app_request_id+"] Operation Type: "+operation_type);
rst = formatInsertData(req.app_client_ip_address, 
    operation_type,
    req.app_request_id, 
    cr_plaza,
    cr_tienda,
    log_level,
    operation_message,
    req_headers,
    req.method, 
    full_url,
    req_body,
    req_files,
    operation_status,
    null
    );
if(!rst) {
    const error  = new Error('Error al loguear request!');
    error.status = 400;
    return next(error);
}
//
let stmt   = 'INSERT INTO xxbdo_api_logs VALUES ?',
data   = [rst[0]];
//run query
qry=db.query(stmt, data, (err, rst2) => {
    if(dbg) console.log("[54] "+qry.sql);
    if (err) {
        err.status = 500;
        return next(err);
    }
    //console.log("[log] headers = "+req_headers);
    //console.log('[log] %s %s %s', req.app_request_id, req.method, req.url);
    next();
    });

 //replication
    dbCopy.query(stmt, data, (err, rst2) => {
        if (err) {
        }
    });
};

function formatInsertData(client_ip, 
    operation_type,
    app_request_id, 
    cr_plaza,
    cr_tienda,
    log_level,
    token_data,
    request_headers,
    request_method, 
    request_url, 
    request_body,
    request_files,
    operation_status,
    response_body) {
    let data  = [],
    //uuid      = uuidv4();
    timestamp = bdoDates.getBDOCurrentTimestamp();
    res = [
app_request_id, //uuid,
client_ip,
cr_plaza,
cr_tienda,
app_request_id,
operation_type, // REQUEST or RESPONSE
log_level,
token_data, //message
request_url,
request_method,
request_headers,
request_body,
request_files,
operation_status,
response_body,
timestamp
    ];
    //
    data.push(res);
return [data];
};
