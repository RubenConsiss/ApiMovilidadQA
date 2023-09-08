
const db       = require("./../../../db"),
      bdoDates = require("./../../helpers/bdo-dates"),
      util     = require('util'),
      dbg      = false;

exports.foto_post = (req, res, next) => {
    if(!db) {
        const error = new Error('Conexion a BD no encontrada!');
        error.status=500;
        return next(error);
    }
    //Validation chain
    req.checkBody('id')
       .isUUID(4)
       .withMessage('Formato de id invalido!')
       .trim();
    req.checkBody('tp')
    .matches(/^$|^[obs|cc]/) //obs=observacion, cc=circulo de congruencia
    .withMessage('Tipo de foto invalido!')
       .trim();
    req.checkBody('bfoto')
       .matches(/^$|^[0-1|{1}]/)
       .withMessage('Bandera de borrado invalida!')
       .trim();
    //
    const errors = req.validationErrors();
    if (errors) {
        console.log(util.inspect(errors, {depth: null}));
        const error  = new Error('Datos de observación inválidos!');
        error.status = 400;
        return next(error);
    }

let registro_id = req.body.id;
let tipo_foto = req.body.tp || null;
let borrar_foto = req.body.bfoto || false;
let ip = req.app_client_ip_address;

let usuario = req.tokenData.usuario;
let crplaza = req.tokenData.crplaza;
let crtienda = req.tokenData.crtienda;
let data = null;
let stmt = null;
let tbl_name = null;
let foto = null;

switch(tipo_foto) {
    case "obs":
        tbl_name = "xxbdo_observaciones";
    break;
    case "cc":
        tbl_name = "xxbdo_circulo_de_congruencia";       
    break;
}
stmt = "SELECT COUNT(*) AS registros FROM "+tbl_name+" WHERE id=?";
data = [registro_id];

qry = db.query(stmt, data, (err, rst) => {
  if(dbg) console.log("[CF:60] "+qry.sql);
  if (err) {
      err.status = 500;
      return next(err);
  }
  //check if observacion already exists
  if(rst.length>0) {
      if(rst[0].registros<1) {
          //daily record already exists, ignore checklist
          const error = new Error(crplaza+" "+crtienda+ " No hay registros de "+tbl_name+" ("+registro_id+")");
          error.status = 400;
          return next(error);
      }
      
      foto = null;
      if(req.files) {
          if(req.files.length>0) {
              foto = req.files[0].blobPath;
              if(dbg) console.log("[CF:78] foto = "+foto);
          }
      }
      
      let registro = [
          {
              id:registro_id, 
              foto:foto, 
              bfoto:borrar_foto,
              usuario:usuario,
              ip:ip
          }
      ];
      
      postFotoRegistro(tbl_name, registro, function(results) {
          if(!results) {
              const error  = 
                  new Error('Error al ejecutar actualización de '+tbl_name);
              error.status = 500;
              return next(error);
          }
          res.status(200).json();
      });
  } else {
    const error = new Error(crplaza+" "+crtienda+ " Registro de "+tbl_name+" ("+registro_id+") no existe!");
      error.status = 400;
      return next(error);
  }
});
};

function postFotoRegistro(tbl_name, items, cb) {
    if(items.length<1) {
    return;
    }
    
    try {
    let bdo_registros = [], 
        stmt      = null, 
        data      = null,
        timestamp = bdoDates.getBDOCurrentTimestamp(),
        pending   = items.length;
    items.forEach(function(item) {
        stmt = "UPDATE "+tbl_name+" SET usuario=?, ip_address=? ";
        data = [
            item.usuario, 
            item.ip, 
            timestamp, 
            item.id
        ];
        if(item.foto || item.bfoto=="1") {
            stmt += ", foto=? ";
            data = [
                item.usuario, 
                item.ip, 
                (item.bfoto=="1" ? "" : item.foto), 
                timestamp, 
                item.id
            ];
        }
        stmt += ", fecha_modificacion=? WHERE id=?";
        
        qry=db.query(stmt, data, (err, result) => {
            if(dbg) console.log("[CF:139] "+qry.sql);
                if(err) {
                    err.status = 500;
                    throw err;
                }
                bdo_registros.push(result);
                if( 0 === --pending ) {
                    //callback if all queries are processed
                    cb(tbl_name, bdo_registros);
                }
            }
        );
    });
    } catch(error) {
    error.status = 500;
    throw error;
    }
}