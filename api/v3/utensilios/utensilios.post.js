
const db = require("./../../../db");
const uuidv4 = require('uuid/v4');
let bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

exports.utensilios_post = (req, res, next) => {
if(dbg) console.log("[9] Start checklist_post...");
if(!db) {
  const error = new Error('Conexion a BD no encontrada!');
  error.status = 500;
  return next(error);
}

req.checkBody('respuestas.*.id')
 .optional({"nullable":true})
 .isUUID(4)
 .withMessage('Formato de id(UUID4) inválido!')
 .trim();
req.checkBody('respuestas.*.res')
  .matches(/^$|^[OK|E|C|NA]{1}/)
  .withMessage('Respuesta inválida!')
  .trim();
  req.checkBody('origen')
  .matches(/^[1|2|3]{1}/)
  .withMessage('Origen de datos inválido!')
  .trim();

const errors = req.validationErrors();
if (errors) {
    if(dbg) console.log(util.inspect(errors, {depth: null}));
    const error = new Error('Informacion en body inválida!');
    error.status = 400;
    return next(error);
}

let crplaza = req.tokenData.crplaza;
let crtienda = req.tokenData.crtienda;
let fecha_token = req.tokenData.fecha;
let respuestas = req.body.respuestas || null;
let origen = req.body.origen || null;
let ip = req.app_client_ip_address;
let usuario = req.tokenData.usuario;
let data = null;
let stmt = null;
let status = 500;

if(!req.permitir_creacion_checklist_utensilios_del_mes_actual) {
    const error  = 
    new Error('Ya se han creado los checklist de utensilios permitidos para el mes actual!');
    error.status = 400;
    return next(error);
}

if(!respuestas || respuestas.length<1) {
  const error  = 
      new Error('Respuestas no recibidas!');
  error.status = 400;
  return next(error);
}

if(respuestas.length<0) {
  const error  = 
      new Error('Respuestas del checklist no recibidas!');
  error.status = 400;
  return next(error);
}

//stmt = "SELECT count(*) AS respuestas \
//FROM `xxbdo_respuestas_utensilios` \
//WHERE cr_plaza=? \
//AND cr_tienda=? \
//AND fecha_respuesta=?";
//data = [
//    crplaza, 
//    crtienda, 
//    fecha_token
//];

//qry = db.query(stmt, data, (err, result) => {
//  if(dbg) console.log("[UP:77] " + qry.sql);
//  if (err) {
//      err.status = 500;
//      return next(err);
//  }
  
//  if(result.length > 0) {
//      if(result[0].respuestas > 0) {
//          const error  = 
//              new Error('Checklist de utensilios para fecha '+fecha_token+' ya enviado!');
//          error.status = 400;
//          return next(error);
//      } else {
            let año = bdoDates.getBDOFormat(fecha_token, 'YYYY');
            let mes = bdoDates.getBDOFormattedDate(
                fecha_token, 
                "es", 
                "M",
                true
            );            
            let categoria_utensilios_varios = req.categoria_utensilios_varios;

            rst = formatInsertData (
                crplaza, 
                crtienda, 
                año,
                mes,
                categoria_utensilios_varios, 
                fecha_token, 
                req.permitir_nuevo_utensilio_mes_actual,
                respuestas, 
                origen,
                usuario, 
                ip
            );

          if(!rst) {
              const error  = 
                  new Error('Formato de respuestas no generado!');
              error.status = 400;
              return next(error);
          }

          stmt = "SELECT NOW() AS fecha_actual";
          data = null;
          status = 200;
          if(rst[1]) {
              if(req.permitir_nuevo_utensilio_mes_actual) {
                stmt = "INSERT INTO xxbdo_utensilios VALUES ?";
                data = [rst[1]];
              }
          }
          
          qry=db.query(stmt, data, (err, rst2) => {
              if(dbg) 
                  console.log("[UP:131] Insertar utensilios: "+qry.sql);
              if (err) {
                  err.status = 500;
                  return next(err);
              }

                stmt   = 'INSERT INTO xxbdo_respuestas_utensilios VALUES ?';        
                  data = [rst[0]];
                  qry=db.query(stmt, data, (err, rst3) => {
                      if(dbg) 
                          console.log("[UP:141] Insertar respuestas: "+qry.sql);
                      if (err) {
                          err.status = 500;
                          return next(err);
                      }
                      status = 201;
                      res.status(status).json();
                  });
          });
      //}
  //} 
//});
};

function formatInsertData(
    crplaza, 
    crtienda, 
    año,
    mes,
    xxbdo_utensilios_categorias_id, 
    fecha_respuesta, 
    permitir_nuevo_utensilio,
    respuestas, 
    origen,
    usuario, 
    ip
) {
    if(!respuestas) {
        if(dbg) console.log("[UP:175] No hay JSON con respuestas! "+respuestas);
        return;
    } else {
        let data = [];
        let utensilio = null;
        let utensilios = null;
        let timestamp = null;
        let uuid_utensilio = null;
        let nuevo_utensilio = false;
        let uuid_respuesta = null;

        if(respuestas.length>0) {
            respuestas.forEach(row => {
                uuid_utensilio = null;
                uuid_respuesta = uuidv4();
                timestamp = bdoDates.getBDOCurrentTimestamp();
                timeinsecs = Math.round(new Date() / 1000);
        
          if(row.utn && permitir_nuevo_utensilio) {
            uuid_utensilio = uuidv4();
            utensilio = [
                uuid_utensilio,
                xxbdo_utensilios_categorias_id,
                crplaza,
                crtienda,
                "V",
                row.utn,
                null, //row.utn.dsc,
                null, //row.utn.uso,
                timeinsecs, //orden
                1, //es seleccionable?
                null, //foto
                null, //row.utn.cdg,
                null, //row.utn.vds,
                1, //activo
                usuario, //usuario
                ip, //ip_address
                timestamp, //fecha_creacion
                timestamp //fecha_modificacion
            ];

            if(!nuevo_utensilio) {
                utensilios = [];
                nuevo_utensilio = true;
            }

            utensilios.push(utensilio);
        }
          if(uuid_utensilio || row.id) {
            res = [uuid_respuesta, 
                crplaza,
                crtienda,
                fecha_respuesta,
                (uuid_utensilio ? uuid_utensilio : row.id), 
                mes,
                año,
                (row.res ? row.res : ""),
                row.flo || null,
                null,//row.clr || 
                row.fap || null,
                null,
                origen,
                1,
                usuario,
                ip, 
                timestamp, 
                timestamp];
            
            data.push(res);
          }
      });
  }
  return [data, utensilios];
 }
}
