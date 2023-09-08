
const db  = require("./../../../db_logs"),
uuidv4    = require('uuid/v4'),
bdoDates  = require("./../../helpers/bdo-dates"),
util      = require('util'),
dbg       = false;
const dbCopy = require("./../../../db_logs_copy");

exports.logs_post = (req, res, next) => {
  if(!db) {
    const error = new Error('Conexión a BD no encontrada!');
    error.status = 500;
    return next(error);
  }
  //Validation chain
  req.checkBody('app')
    .matches(/^$|^[^]/)
    .withMessage('Nombre de aplicacion invalida!')
    .trim();
    req.checkBody('appv')
    .matches(/^$|^[^]/)
    .withMessage('Version de aplicacion invalida!')
    .trim();
    req.checkBody('mdl')
    .matches(/^$|^[^]/)
    .withMessage('Nombre de módulo inválido!')
    .trim();
    req.checkBody('atv')
    .matches(/^$|^[^]/)
    .withMessage('Nombre de activity inválido!')
    .trim();
    req.checkBody('atn')
    .matches(/^$|^[^]/)
    .withMessage('Nombre de action inválido!')
    .trim();
    req.checkBody('mtd')
    .matches(/^$|^[^]/)
    .withMessage('Valor de método inválido!')
    .trim();
    req.checkBody('usr')
    .matches(/^$|^[^]/)
    .withMessage('Nombre de usuario inválido!')
    .trim();
    req.checkBody('dvc')
    .matches(/^$|^[^]/)
    .withMessage('Nombre de dispositivo inválido!')
    .trim();
    req.checkBody('dvt')
    .matches(/^$|^[^]/)
    .withMessage('Tipo de dispositivo inválido!')
    .trim();
    req.checkBody('ptr')
    .matches(/^$|^[^]/)
    .withMessage('Nombre de impresora inválido!')
    .trim();
  //
  const errors = req.validationErrors();
  if (errors) {
    if(dbg) console.log(util.inspect(errors, {depth: null}));
    const error  = new Error('Informacion en body inválida!');
    error.status = 400;
    return next(error);
  }
  //
  let crplaza   = req.tokenData.crplaza,
    crtienda    = req.tokenData.crtienda,
    device_name = req.body.dvc || null,
    device_type = req.body.dvt || null,
    printer_name= req.body.ptr || null,
    aplicacion  = req.body.app || null,
    app_version = req.body.appv || null,
    modulo      = req.body.mdl || null,
    activity    = req.body.atv || null,
    action      = req.body.atn || null,
    method      = req.body.mtd || null,
    ip          = req.app_client_ip_address,
    usuario     = req.body.usr || null,
    data        = null;
  //
  rst = formatInsertData(crplaza, 
    crtienda, 
    aplicacion,
    app_version,
    modulo,
    activity,
    action,
    method,
    ip,
    device_name,
    device_type,
    printer_name,
    usuario);
if(!rst) {
    const error  = new Error('Formato de respuestas no generado!');
    error.status = 400;
    return next(error);
}
stmt   = 'INSERT INTO xxmet_logs VALUES ?';
status = 201;
data   = [rst[0]];
//run query
qry=db.query(stmt, data, (err, rst2) => {
    if(dbg) console.log("[96] "+qry.sql);
    if (err) {
        err.status = 500;
        return next(err);
    }
    res.status(status).json();
});
 dbCopy.query(stmt, data, (err, rst2) => {
    if (err) {
    }
  });
  //replication
};
  
  function formatInsertData(crplaza, 
    crtienda, 
    aplicacion,
    app_version,
    modulo,
    activity,
    action,
    method,
    ip,
    device_name,
    device_type,
    printer_name,
    usuario) {
        if(!crplaza || !crtienda) {
            return;
        } else {
            let data      = [],
                uuid      = uuidv4();
                timestamp = bdoDates.getBDOCurrentTimestamp();
                res = [uuid,
                    ip,
                crplaza,
                crtienda,
                device_name,
                device_type,
                printer_name,
                aplicacion, 
                app_version,
                modulo,
                activity,
                action,
                method,
                usuario,
                timestamp];
                //
                data.push(res);
            return [data];
        }
  }
