
const db = require("./../../db_logs");
const dbg = false;

function logApiResponseInfo(app_request_id, res_status_code, res_body) {
if(!db) {
    const error = new Error('Conexión a BD Logs no encontrada!');
    error.status = 500;
    return next(error);
}

let stmt = 'UPDATE xxbdo_api_logs SET r_status=?, res_body=? WHERE id=?',
data   = [res_status_code, res_body, app_request_id];
//run query
qry=db.query(stmt, data, (err, rst2) => {
    if(dbg) console.log("[19] "+qry.sql);
    if (err) {
        err.status = 500;
        return next(err);
    }
    });
};

module.exports.logApiResponseInfo = logApiResponseInfo;
