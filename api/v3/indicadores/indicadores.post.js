
const db  = require("./../../../db"),
uuidv4    = require('uuid/v4'),
bdoDates  = require("./../../helpers/bdo-dates"),
util      = require('util'),
dbg       = false;

exports.indicadores_post = (req, res, next) => {
  if(!db) {
    const error = new Error('Conexión a BD no encontrada!');
    error.status = 500;
    return next(error);
  }
  //Validation chain
  req.checkBody('fecha')
    .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)
    .withMessage('Formato de fecha inválido!')
    .trim();
  req.checkBody('frec')
    .matches(/^$|^[S|M]/)//S:Ind.Semanal, M:Ind.Mensual
    .withMessage('Formato de frecuencia ID inválido!')
    .trim();
  req.checkBody('resp.*.id')
   .isUUID(4)
   .withMessage('Formato de id(UUID4) inválido!')
   .trim();
   req.checkBody('resp.*.tp')
    .matches(/^$|^[I|L]/)//I:Indicador Normal, L:Indicador Libre
    .withMessage('Tipo de indicador inválido!')
    .trim();
  req.checkBody('resp.*.res')
    .matches(/^$|^[^]/)
    .withMessage('Respuesta de indicador inválida!')
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
  let fecha_token = req.tokenData.fecha;
  let fecha_respuesta = req.body.fecha || null;
  let respuestas = req.body.resp || null;
  let frecuencia = req.body.frec || null;
  let ip = req.app_client_ip_address;
  let usuario = req.tokenData.usuario;
  let data = null;
  let stmt = null;
  let valor = null;
  let year = null;
  let status = 500;
  //
  if(!respuestas || !frecuencia) {
    const error  = new Error('Respuestas no recibidas!');
    error.status = 400;
    return next(error);
  }
  //
  if(respuestas.length<0) {
    const error  = new Error('Respuestas de indicadores no recibidas!');
    error.status = 400;
    return next(error);
  }
  //
  if(bdoDates.isDateGreatherThanCurrent(fecha_respuesta)) {
    const error  = new Error('Fecha de respuesta ' + 
                   fecha_respuesta + 
                   ' es mayor que la fecha actual!');
    error.status = 400;
    return next(error);
  }
  //
  switch(frecuencia) {
    case 'S'://Ind.Semanal
      tipo_consulta = "AND semana=?";
      [valor, year] = bdoDates.getWeekAndYearFromDate(fecha_respuesta);
    break;
    case 'M'://Mensual
      tipo_consulta = "AND mes=?";
      valor = 
      bdoDates.getBDOFormattedDate(
          fecha_respuesta, 
          "es", 
          "M",
          true
      );
      //
      year = 
      bdoDates.getBDOFormattedDate(
          fecha_respuesta, 
          "es", 
          "YYYY",
          true
      );
    break;
  }
  //
  stmt = "SELECT `xxbdo_checklists_id`, \
      (SELECT COUNT(*) AS respuestas \
      FROM xxbdo_respuestas_indicadores \
      WHERE cr_plaza=? \
      AND cr_tienda=? \
      AND xxbdo_indicadores_frecuencias_id=? " + 
      tipo_consulta + " \
      AND año=?) AS respuestas, \
      ( \
          SELECT `xxbdo_checklists_id` \
          FROM `xxbdo_checklists_tiendas` \
          WHERE `cr_plaza`='"+crplaza+"' \
          AND `cr_tienda`='"+crtienda+"' \
          AND ? \
          BETWEEN `fecha_inicio` \
          AND IFNULL(`fecha_fin`, ?) \
          AND `activo`=1 \
          LIMIT 1 \
      ) AS `checklists_id` \
      FROM `xxbdo_checklists_tiendas` \
      WHERE `cr_plaza`=? \
      AND `cr_tienda`=? \
      AND `es_default`=1 \
      AND `activo`=1";
  data = [
    crplaza,
    crtienda,
    frecuencia,
    valor,
    year,
    fecha_respuesta,
    fecha_token,
    crplaza,
    crtienda
    ];
  //
  qry=db.query(stmt, data, (err, result) => {
    if(dbg) console.log("[136] "+qry.sql);
    if (err) {
        err.status = 500;
        return next(err);
    }
    //check daily checklist rules:
    if(result.length>0) {
        if(result[0].respuestas>0) {
            //daily record already exists, ignore checklist
            const error  = new Error('Indicadores de ' + 
                           fecha_respuesta + 
                           ' con frecuencia ' +
                           frecuencia +
                           ' ya enviados!');
            error.status = 400;
            return next(error);
        }
      //
      rst = formatInsertData(crplaza, 
          crtienda, 
          frecuencia,
          result[0].checklists_id,
          fecha_respuesta, 
          respuestas, 
          valor,
          year,
          usuario, 
          ip);
      if(!rst) {
          const error  = new Error('Formato de respuestas no generado!');
          error.status = 400;
          return next(error);
      }
      stmt   = 'INSERT INTO xxbdo_respuestas_indicadores VALUES ?';
      status = 201;
      data   = [rst[0]];
      //run query
      qry=db.query(stmt, data, (err, rst2) => {
          if(dbg) console.log("[185] "+qry.sql);
          if (err) {
              err.status = 500;
              return next(err);
          }
          res.status(status).json();
      });
    } else {
        const error  = new Error('Checklist para tienda ' + 
                      crtienda + 
                      ' no encontrada!');
        error.status = 400;
        return next(error);
    }
  });
};
  
  function formatInsertData(crplaza, 
    crtienda, 
    frecuencia,
    checklists_id, 
    fecha_respuesta, 
    respuestas, 
    valor,
    year,
    usuario, 
    ip) {
  if(!respuestas) {
    return;
  } else {
    let data      = [],
        uuid      = null, 
        timestamp = null;
    if(respuestas.length>0) {
        respuestas.forEach(row => {
            uuid      = uuidv4();
            timestamp = bdoDates.getBDOCurrentTimestamp();
            res = [uuid, 
              checklists_id, 
              crplaza,
              crtienda,
              fecha_respuesta,
              row.id, 
              frecuencia,
              row.tp,
              "",
              row.res,
              (frecuencia=='S'? valor : null),
              (frecuencia=='M'? valor : null),
              year,
              1,
              usuario,
              ip, 
              timestamp, 
              timestamp];
            //
            data.push(res);
        });
    }
    return [data];
  }
  }
