 
const db  = require("./../../../db");
const uuidv4 = require('uuid/v4');
const bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

exports.indicadores_post = (req, res, next) => {
  if(dbg) console.log("[IP:9] Start indicadores POST ...");
  if(!db) {
    const error = new Error('Conexión a BD no encontrada!');
    error.status = 500;
    return next(error);
  }
  
  //Validation chain
  req.checkBody('aeid')
  .optional({"nullable":true})
  .isUUID(4)
  .withMessage('Formato de área estandar indicador ID inválido!!')
  .trim();
  req.checkBody('asid')
  .optional({"nullable":true})
  .isUUID(4)
  .withMessage('Formato de área estándar ID inválido!!')
  .trim();
  req.checkBody('tp')
  .matches(/^[L|I]{1}/)
  .withMessage('Tipo de indicador inválido!')
  .trim();
  req.checkBody('frc')
  .matches(/^[M|S]{1}/)
  .withMessage('Frecuencia de indicador inválido!')
  .trim();
  req.checkBody('tdd')
  .optional({"nullable":true})
  .matches(/^[int|pct|pnt|money]{1}/)
  .withMessage('Tipo de dato para indicador inválido!!')
  .trim();
  
  const errors = req.validationErrors();
  if (errors) {
    if(dbg) console.log(util.inspect(errors, {depth: null}));
    const error  = new Error('Informacion en body inválida!');
    error.status = 400;
    return next(error);
  }
  
 let cr_plaza = req.tokenData.crplaza;
 let cr_tienda = req.tokenData.crtienda;
 let fecha_respuesta = req.tokenData.fecha;
 let xxbdo_checklists_id = req.tokenData.checklist;
 let usuario = req.tokenData.usuario;
 let ip = req.app_client_ip_address;
 let xxbdo_areas_estandares_id = req.body.asid || null;
 let xxbdo_areas_estandares_indicadores_id = req.body.aeid || null;
 let xxbdo_indicadores_frecuencias_id = req.body.frc || null;
 let tipo_indicador = req.body.tp;
 let respuesta_indicador = req.body.res;
 let xxbdo_version_estandares_id = req.version_estandares_id || null;
 let titulo_indicador = req.body.tl || "";
 let descripcion_indicador = req.body.ta || "";
 let tipo_de_dato = req.body.tdd || "int";
 let dato_default = req.body.dfl || "0";

  rst = formatSaveData(
    cr_plaza,
    cr_tienda,
    fecha_respuesta,
    xxbdo_version_estandares_id,
    xxbdo_checklists_id,
    xxbdo_areas_estandares_id,
    xxbdo_areas_estandares_indicadores_id,
    xxbdo_indicadores_frecuencias_id,
    tipo_indicador,
    respuesta_indicador,
    titulo_indicador,
    descripcion_indicador,
    tipo_de_dato,
    dato_default,
    usuario,
    ip
    );
  if(!rst) {
      const error  = new Error('Datos incorrectos para guardar indicador o respuesta de indicador!');
      error.status = 400;
      return next(error);
  }

  [
    crear_nuevo_indicador, 
    sql_indicador, 
    data_indicador,
    data_area_estandar_indicador,
    data_tiendas_has_areas_estandares_indicadores,
    data_checklists_has_areas_estandares_indicadores
  ] = rst;

qry = db.query(sql_indicador, [data_indicador], (err, rst) => {
    if(dbg) console.log("[IP:98] ", qry.sql);
    if (err) {
        err.status = 500;
        return next(err);
    }

    if(crear_nuevo_indicador) {
      sql = "INSERT INTO xxbdo_areas_estandares_indicadores VALUES ?";
      qry = db.query(sql, [data_area_estandar_indicador], (err2, rst2) => {
        if(dbg) console.log("[IP:107] ", qry.sql);
        if (err2) {
          err2.status = 500;
          return next(err2);
        }
        sql = "INSERT INTO `xxbdo_tiendas_has_areas_estandares_indicadores` VALUES ?";
        qry = db.query(sql, [data_tiendas_has_areas_estandares_indicadores], (err3, rst3) => {
          if(dbg) console.log("[IP:114] ", qry.sql);
          if (err3) {
            err3.status = 500;
            return next(err3);
          }

          sql="INSERT INTO `xxbdo_checklists_has_areas_estandares_indicadores` VALUES ?";
          qry = db.query(sql, [data_checklists_has_areas_estandares_indicadores], (err4, rst4) => {
            if(dbg) console.log("[IP:122] ", qry.sql);
            if (err4) {
              err4.status = 500;
              return next(err4);
            }

            if(dbg) console.log("[IP:128] End Indicadores POST.");
            res.status(201).json();
          });
        });
      });
    } else {
      if(dbg) console.log("[IP:134] End Indicadores POST.");
      res.status(201).json();
    }
  });
};
  
  function formatSaveData(
    cr_plaza,
    cr_tienda,
    fecha_respuesta,
    xxbdo_version_estandares_id,
    xxbdo_checklists_id,
    xxbdo_areas_estandares_id,
    xxbdo_areas_estandares_indicadores_id,
    xxbdo_indicadores_frecuencias_id,
    tipo_indicador,
    respuesta_indicador,
    titulo_indicador,
    descripcion_indicador,
    tipo_de_dato,
    dato_default,
    usuario,
    ip
    ) {
    if(!fecha_respuesta) {
      return null;
    } else {
      let uuid = uuidv4();
      let orden = Math.round(new Date() / 1000);
      let timestamp = bdoDates.getBDOCurrentTimestamp();
      let crear_nuevo_indicador = 
        ((xxbdo_version_estandares_id && 
          !xxbdo_areas_estandares_indicadores_id) ? true : false);
      let sql_indicador = null;
      let data_indicador = [];
      let data_area_estandar_indicador = [];
      let data_tiendas_has_areas_estandares_indicadores = [];
      let data_checklists_has_areas_estandares_indicadores = [];
      let frecuencia_valida = false;
      let semana_respuesta = null;
      let mes_respuesta = null;
      let año_respuesta = 
        bdoDates.getBDOFormattedDate(
            fecha_respuesta, 
            "es", 
            "YYYY",
            true
        );

        switch(xxbdo_indicadores_frecuencias_id) {
          case "S":
            [
              semana_respuesta, 
              año_respuesta
            ] = bdoDates.getWeekAndYearFromDate(fecha_respuesta);
            frecuencia_valida = true;
          break;
          case "M":
            mes_respuesta = 
              bdoDates.getBDOFormattedDate(
                  fecha_respuesta, 
                  "es", 
                  "M",
                  true
              );
              frecuencia_valida = true;
          break;
          default:break;
         }
     

      if(frecuencia_valida) {
        if(crear_nuevo_indicador) {
          sql_indicador = "INSERT INTO xxbdo_indicadores VALUES ?";
          res = [
            uuid, 
            xxbdo_version_estandares_id,
            tipo_indicador,
            cr_plaza,
            cr_tienda,
            titulo_indicador,
            descripcion_indicador,
            xxbdo_indicadores_frecuencias_id,
            orden,
            tipo_de_dato,
            dato_default,
            null,
            null,
            1,
            usuario,
            ip, 
            timestamp, 
            timestamp
          ];

            uuid_aeid = uuidv4();

            data_area_estandar_indicador.push(
              [
                uuid_aeid,
                xxbdo_areas_estandares_id,
                uuid, 
                orden,
                1,
                usuario,
                ip, 
                timestamp, 
                timestamp
              ]
            );

            data_tiendas_has_areas_estandares_indicadores.push(
              [
                cr_plaza, 
                cr_tienda, 
                xxbdo_checklists_id, 
                uuid_aeid, 
                1, 
                1, 
                usuario, 
                ip, 
                timestamp, 
                timestamp
              ]
            );

            data_checklists_has_areas_estandares_indicadores.push(
              [
                xxbdo_checklists_id, 
                uuid_aeid, 
                1, 
                1, 
                null, 
                null, 
                timestamp, 
                timestamp
              ]
            );
        } else {
          sql_indicador = "INSERT INTO xxbdo_respuestas_indicadores VALUES ?";
          res = [uuid, 
            xxbdo_checklists_id,
            cr_plaza,
            cr_tienda,
            fecha_respuesta,
            xxbdo_areas_estandares_indicadores_id,
            xxbdo_indicadores_frecuencias_id,
            tipo_indicador,
            null,
            respuesta_indicador,
            semana_respuesta,
            mes_respuesta,
            año_respuesta,
            1,
            usuario,
            ip, 
            timestamp, 
            timestamp];
        }
  
        data_indicador.push(res);
  
        return [
          crear_nuevo_indicador, 
          sql_indicador, 
          data_indicador,
          data_area_estandar_indicador,
          data_tiendas_has_areas_estandares_indicadores,
          data_checklists_has_areas_estandares_indicadores
        ];
      }

      return null;
    }
  }

  /**
 * 
 POST /indicadores

1) servicio para guardar respuesta del indicador
1.1) POST /bdo/v4/indicadores
1.2) Ejemplo JSON request:
{
  "aeid":"<uuid4>",  //xxbdo_areas_estandares_indicadores_id
  "frc":"M",  //xxbdo_indicadores_frecuencias_id: S=Semanal, M=Mensual
  "tp":"I",  //tipo, de indicador: I=Indicador Estándar, L=Indicador Libre
  "res":"10" 
}

2) servicio POST para guardar detalle de indicador libre
2.1) POST /bdo/v4/indicadores
2.2) Ejemplo de JSON request:
{
  "asid":"<uuid4>",  //xxbdo_areas_estandares_id
  "tp": "L", //tipo: L=indicador libre , I=Indicador Estándar
  "tl":"Titulo del indicador",  //titulo
  "frc": "M",  //xxbdo_indicadores_frecuencias_id: S=Semanal, M=Mensual
  "tdd":"int",   //tipo_dato:  int, pnt, pct, money
  "dfl": "0"
}
*/