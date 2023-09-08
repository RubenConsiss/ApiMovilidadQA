
const db  = require("./../../../db");
const uuidv4 = require('uuid/v4');
const bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

exports.pendientes_post = (req, res, next) => {
  if(!db) {
    const error = new Error('Conexión a BD no encontrada!');
    error.status = 500;
    return next(error);
  }
  //Validation chain
  req.checkBody('fc')
    .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)
    .withMessage('Formato de fecha inválido!')
    .trim();
  req.checkBody('rp')
    .isUUID(4)
    .withMessage('id de persona que asigna pendiente inválido!!')
    .trim();
    req.checkBody('rs')
    .isUUID(4)
    .withMessage('id de persona que realiza pendiente inválido!!')
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
 let crplaza = req.tokenData.crplaza;
 let crtienda = req.tokenData.crtienda;
 let fecha_compromiso = req.body.fc || null;
 let registrado_por = req.body.rp || null;
 let responsable = req.body.rs;
 let descripcion = req.body.ds || "";
 let ip = req.app_client_ip_address;
 let usuario = req.tokenData.usuario;
 let data = null;
 let stmt = null;
 let status = 500;

  if(bdoDates.isDateLessThanCurrent(fecha_compromiso)) {
    const error  = new Error('Fecha compromiso ' + 
                   fecha_compromiso + 
                   ' es menor que la fecha actual!');
    error.status = 400;
    return next(error);
  }

  //TO DO: validar que sea fecha válida, mes 1-12, dia 1-31, año YYYY digitos

  // TO FIX:
  // 1. En el servicio me dejo guardar un pendiente para el mes 13

  rst = formatInsertData(crplaza, 
    crtienda, 
    fecha_compromiso, 
    registrado_por,
    responsable, 
    descripcion,
    usuario, 
    ip);
if(!rst) {
    const error  = new Error('Pendiente no se ha registrado!');
    error.status = 400;
    return next(error);
}
stmt   = 'INSERT INTO xxbdo_pendientes VALUES ?';
status = 201;
data   = [rst[0]];
//run query
qry=db.query(stmt, data, (err, rst2) => {
    if(dbg) console.log("[PP:76] "+qry.sql);
    if (err) {
        err.status = 500;
        return next(err);
    }
    res.status(status).json();
});
};
  
  function formatInsertData(crplaza, 
    crtienda, 
    fecha_compromiso, 
    registrado_por,
    responsable, 
    descripcion,
    usuario, 
    ip) {
  if(!fecha_compromiso) {
    return;
  } else {
    let data = [];
    let uuid = null;
    let timestamp = null;
    //if(respuestas.length>0) {
        //respuestas.forEach(row => {
            uuid      = uuidv4();
            timestamp = bdoDates.getBDOCurrentTimestamp();
            res = [uuid, 
              crplaza,
              crtienda,
              fecha_compromiso,
              null,
              registrado_por, 
              responsable,
              descripcion,
              1,
              usuario,
              ip, 
              timestamp, 
              timestamp];
            //
            data.push(res);
        //});
    //}
    return [data];
  }
  }
