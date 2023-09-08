/** 
 * 
 /estandares

-- Servicios para vista de estándar
8) servicio POST para guardar detalle de estándar libre
8.1) POST bdo/v4/estandares

20200224:
-- proceso para crear nuevo estandar libre:

-- 1) en xxbdo_configuracion, agregar `xxbdo_areas_grupos_id` (86392947-9a57-46c0-a16f-f2f4e5c0745d) 
      del area del grupo de estándares libres.

-- 2) Obtener current `xxbdo_version_estandares_id` ('13d772fa-826b-424f-802e-63da4777e33c') 
      en base a la fecha current.

-- 3) Obtener current `xxbdo_checklists_id` ('3e50f58c-8634-41ce-93b5-c8bebb8bce46') 
      en base a la fecha current.

-- 4) Con 1) y 2) obtener `xxbdo_areas`.`id` (d5d547f8-d5f5-4c37-b1f1-f3823e24bd19), ejemplo:
      SELECT `xxbdo_areas`.`id` FROM `xxbdo_areas` 
      WHERE `xxbdo_areas`.`xxbdo_version_estandares_id`='13d772fa-826b-424f-802e-63da4777e33c' 
      AND `xxbdo_areas`.`xxbdo_areas_grupos_id`='86392947-9a57-46c0-a16f-f2f4e5c0745d';

-- 5) Con 2), "cr_plaza" y "cr_tienda", insertar registro en xxbdo_estandares:
      INSERT INTO `xxbdo_estandares` (`id`, `xxbdo_version_estandares_id`, `tipo`, `cr_plaza`, `cr_tienda`, `estandar`, `titulo`, `orden`, `detalle`, `descripcion`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
      ('0b2d76d9-14d1-4bda-9c93-a20ec71294ef', '13d772fa-826b-424f-802e-63da4777e33c', 'L', '10MON', '50EDI', NULL, 'Alumbrado Pasillo Lateral', 1, 'Vista Exterior', 'Verificar que el alumbrado del pasillo lateral exterior del edificio esté activo', 1, 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00');

-- 6) Con 4) y 5), insertar registro en xxbdo_areas_estandares:
      INSERT INTO `xxbdo_areas_estandares` (`id`, `xxbdo_areas_id`, `xxbdo_estandares_id`, `valor`, `orden`, `dias_activos`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
      ('0058a7a6-3249-4460-ac4e-c02720764d29', 'd5d547f8-d5f5-4c37-b1f1-f3823e24bd19', '0b2d76d9-14d1-4bda-9c93-a20ec71294ef', 0, 10, '1,2,3,4,5,6,7', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00');

-- 5) Con 2) y 6), insertar registro en la tabla `xxbdo_checklists_has_areas_estandares`:
      INSERT INTO `xxbdo_checklists_has_areas_estandares` (`xxbdo_checklists_id`, `xxbdo_areas_estandares_id`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
      ('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '0058a7a6-3249-4460-ac4e-c02720764d29', 1, 1, NULL, NULL, '2019-04-25 05:10:34', '2019-04-25 05:10:34');

-- 6) Con 2) y 6), "cr_plaza" y "cr_tienda",  insertar registro en la tabla `xxbdo_tiendas_has_areas_estandares`, ejemplo:
      INSERT INTO `xxbdo_tiendas_has_areas_estandares` (`cr_plaza`, `cr_tienda`, `xxbdo_checklists_id`, `xxbdo_areas_estandares_id`, `grupos_id`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
      ('10CTL', '500AW', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '0058a7a6-3249-4460-ac4e-c02720764d29', NULL, 1, 1, 'SACLMA7208143', '187.132.147.189', '2019-10-13 01:18:55', '2019-10-13 01:18:55');

*/

 
const db  = require("./../../../db");
const uuidv4 = require('uuid/v4');
const bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

exports.estandares_post = (req, res, next) => {
  if(dbg) console.log("[IP:34] Start estandares POST ...");
  if(!db) {
    const error = new Error('Conexión a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  
  //Validation chain
  req.checkBody('tl')
  .matches(/^$|^[^]/)
  .withMessage('Título del estándar es requerido!')
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
 let usuario = req.tokenData.usuario;
 let ip_address = req.app_client_ip_address;
 let titulo_estandar = req.body.tl || "";
 let detalle = req.body.dtl || "";
 let descripcion = req.body.dsc || "";


  let xxbdo_estandares_id = uuidv4();
  let orden = Math.round(new Date() / 1000);
  let timestamp = bdoDates.getBDOCurrentTimestamp();
  data = [
      xxbdo_estandares_id, 
      req.version_estandares_id, 
      "L", //`tipo`, 
      cr_plaza, 
      cr_tienda, 
      null, //`estandar`, 
      titulo_estandar, 
      orden, 
      detalle, 
      descripcion, 
      true, //`es_visible`, 
      true, //`activo`, 
      usuario, 
      ip_address, 
      timestamp, 
      timestamp
    ];

  sql = "INSERT INTO `xxbdo_estandares` VALUES (?)";

qry = db.query(sql, [data], (err, rst) => {
    if(dbg) console.log("[EP:129] ", qry.sql);
    if (err) {
        err.status = 500;
        return next(err);
    }

    if(xxbdo_estandares_id) {
        let xxbdo_areas_estandares_id = uuidv4();
        data = [
            xxbdo_areas_estandares_id, 
            req.xxbdo_areas_id_estandares_libres, 
            xxbdo_estandares_id, 
            0, //`valor`, 
            orden, 
            '1,2,3,4,5,6,7', //`dias_activos`, 
            true, //`activo`, 
            usuario, 
            ip_address, 
            timestamp, 
            timestamp
        ];
      sql = "INSERT INTO `xxbdo_areas_estandares` VALUES (?)";
      qry = db.query(sql, [data], (err2, rst2) => {
        if(dbg) console.log("[EP:152] ", qry.sql);
        if (err2) {
          err2.status = 500;
          return next(err2);
        }

        data = 
        [
            cr_plaza, 
            cr_tienda, 
            req.checklist_id, 
            xxbdo_areas_estandares_id, 
            null, //`grupos_id`, 
            true, //`es_visible`, 
            true, //`activo`, 
            usuario, 
            ip_address, 
            timestamp, 
            timestamp
        ];
        sql = "INSERT INTO `xxbdo_tiendas_has_areas_estandares` VALUES (?)";
        qry = db.query(sql, [data], (err3, rst3) => {
          if(dbg) console.log("[EP:174] ", qry.sql);
          if (err3) {
            err3.status = 500;
            return next(err3);
          }

          data = [
            req.checklist_id, 
            xxbdo_areas_estandares_id, 
            true, //`es_visible`, 
            true, //`activo`, 
            usuario, 
            ip_address, 
            timestamp, 
            timestamp
          ];
          sql="INSERT INTO `xxbdo_checklists_has_areas_estandares` VALUES (?)";
          qry = db.query(sql, [data], (err4, rst4) => {
            if(dbg) console.log("[EP:192] ", qry.sql);
            if (err4) {
              err4.status = 500;
              return next(err4);
            }

            if(dbg) console.log("[IP:122] End Estandares POST.");
            res.status(201).json();
          });
        });
      });
    } else {
        const error  = new Error('Error: registro de estándar es requerido!');
        error.status = 400;
        return next(error);
    }
  });
};