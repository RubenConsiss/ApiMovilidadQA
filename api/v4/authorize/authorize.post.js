
const app_configuration = require("config"),
      jwt      = require("jsonwebtoken"),
      db       = require("./../../../db"),
      isBase64 = require('is-base64'),
      bdoDates = require("./../../helpers/bdo-dates")
      dbg      = false;

exports.authorize_post = (req, res, next) => {
  if(dbg) console.log("--- Start authorize_post ---");
  req.checkBody('crplaza').trim();
  req.checkBody('crtienda').trim();
  req.checkBody('usuario').trim();

  const errors = req.validationErrors();
  if (errors || 
      !req.body.crplaza || 
      !req.body.crtienda || 
      !req.body.usuario || 
      !req.body.key) {
    //console.log(util.inspect(errors, {depth: null}));
    const error = new Error('crplaza, crtienda, usuario o key invalidos!');
    error.status=401;
    return next(error);
  }
  
  const akey      = req.body.key,
        crplaza   = req.body.crplaza,
        crtienda  = req.body.crtienda,
        usuario   = req.body.usuario,
        ipaddress = req.app_client_ip_address;
        
//  try {
    if(akey && crplaza && crtienda && usuario) {
      const apiJwtKey = app_configuration.get('application.api_jwt_key');
      const apiKey    = app_configuration.get('application.api_authorization_key');
      const apiJwtExpiresIn = app_configuration.get('application.api_jwt_expiresin');
      
      let login_succeed = false,
          buffApiKey = new Buffer(akey, 'base64'),
          buffPlaza  = new Buffer(crplaza, 'base64'),
          buffTienda = new Buffer(crtienda, 'base64'),
          dApiKey    = buffApiKey.toString('ascii'),
          dcrplaza   = buffPlaza.toString('ascii'),
          dcrtienda  = buffTienda.toString('ascii'), 
          dusuario   = '';
      if(dcrplaza.length>5) {
        dcrplaza = dcrplaza.substring(0, 5);
      }
      if(dcrtienda.length>5) {
        dcrtienda = dcrtienda.substring(0, 5);
      }

      if(isBase64(usuario, {allowBlank: false})) {
        buffUsuario = new Buffer(usuario, 'base64');
        dusuario    = buffUsuario.toString('ascii');
        dusuario    = dusuario.trim();
      }
      
      if(apiKey===dApiKey && dusuario) {
        //query to get current store's timezone
        let stmt = "SELECT IF(LENGTH(timezone)>0, timezone, 'UTC') AS tz, \
        (SELECT `xxbdo_checklists`.`id` \
          FROM `xxbdo_checklists`, \
          `xxbdo_version_estandares` \
          WHERE `xxbdo_checklists`.`xxbdo_version_estandares_id`=`xxbdo_version_estandares`.`id` \
          AND `xxbdo_version_estandares`.`es_default`=1 \
          AND `xxbdo_version_estandares`.`activo`=1 \
          AND `xxbdo_checklists`.`es_default`=1 \
          AND `xxbdo_checklists`.`activo`=1 \
          LIMIT 1 \
        ) AS checklist_default, \
        (SELECT `xxbdo_checklists_id` \
         FROM `xxbdo_checklists_tiendas` \
         WHERE `cr_plaza`=? \
         AND `cr_tienda`=? \
         AND `es_default`=1 \
         AND `activo`=1 \
         LIMIT 1 \
        ) AS tienda_checklist \
        FROM xxbdo_tiendas \
        WHERE cr_plaza=? \
        AND cr_tienda=? \
        LIMIT 1";
         
        let data = [dcrplaza, dcrtienda, dcrplaza, dcrtienda];
         console.log("[ap:85] ", stmt);
         
        db.query(stmt, data, (err, result) => {
          if (err) {
            console.log("errro query (LENGTH(timezone)> line 62");
              err.status = 500;
              return next(err);
          }
          
          if(result.length>0) {
            let tienda_tz         = result[0].tz,
                tienda_checklist  = result[0].tienda_checklist,
                checklist_default = result[0].checklist_default,
                fecha_tienda      = bdoDates.getBDOCurrentDate(tienda_tz);

            const token = jwt.sign(
              {
                crplaza:dcrplaza,
                crtienda:dcrtienda,
                usuario:dusuario,
                tz:tienda_tz,
                checklist:(tienda_checklist ? tienda_checklist : checklist_default),
                fecha:fecha_tienda,
                ip:ipaddress
              },
              apiJwtKey,
              {
                expiresIn: apiJwtExpiresIn
              }
            );

            login_succeed     = true;
            req.login_succeed = login_succeed;
            //update login attempt
            stmt = "UPDATE xxbdo_login_attempts \
            SET cr_plaza=?, \
            cr_tienda=?, \
            usuario=?, \
            login_succeed=?, \
            token=?, \
            is_valid_token=? \
            WHERE id=?",
            data = [
              dcrplaza, 
              dcrtienda, 
              dusuario, 
              login_succeed, 
              token, 
              login_succeed, 
              req.app_request_id
            ];
            db.query(stmt, data, (err, result) => {
              if(err) {
                console.log("errro query UPDATE xxbdo_login_attempts line 121");
                err.status = 500;
                return next(err);
              }
              if(dbg) console.log("token = "+token);
              if(dbg) console.log("auth_status_code = "+req.auth_status_code);
              if(dbg) console.log("--- End authorize_post ---");
              //res.operation_type='response';
              //res.operation_status=req.auth_status_code;
              //res.operation_message='Login Succeed!';
              res.status(req.auth_status_code).json({token:token});
            });
          } else {
            const error  = new Error('Timezone de tienda no encontrado!');
            error.status = 401;
            return next(error);
          }
        });
      } else {
        const error  = new Error('Api key invalido!');
        error.status = 401;
        return next(error);
      }
    } else {
      const error  = new Error('Api key, crplaza, crtienda o usuario invalido!');
      error.status = 401;
      return next(error);
    }
//  } catch(error) {
//    error.status = 500;
//    return next(error);
//  }
};

exports.authorize_post_login_attempt = (req, res, next) => {
  if(dbg) console.log("--- Start authorize_post_login_attempt ---");
  if(!db) {
    console.log("errro Conexion a BD no encontrad line 178");
    const error  = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  let timestamp = bdoDates.getBDOCurrentTimestamp();
  let dprinter_name = (req.body.ptrn 
    ? 
    (Buffer.from(req.body.ptrn, 'base64').toString('base64') === req.body.ptrn ? Buffer(req.body.ptrn, 'base64').toString('ascii') : req.body.ptrn) 
    : 
    null);
  let dapp_version = (req.body.appver 
    ? 
    (Buffer.from(req.body.appver, 'base64').toString('base64') === req.body.appver ? Buffer(req.body.appver, 'base64').toString('ascii') : req.body.appver) 
    : 
    null);
  let dcrplaza = 
    (req.body.crplaza 
    ? 
    (Buffer.from(req.body.crplaza, 'base64').toString('base64') === req.body.crplaza ? Buffer(req.body.crplaza, 'base64').toString('ascii') : req.body.crplaza) 
    : 
    '');
  let dcrtienda  = 
    (req.body.crtienda 
      ? 
      (Buffer.from(req.body.crtienda, 'base64').toString('base64') === req.body.crtienda ? Buffer(req.body.crtienda, 'base64').toString('ascii') : req.body.crtienda) 
      : 
      '');
  let dusuario = 
    (req.body.usuario 
      ? 
      (Buffer.from(req.body.usuario, 'base64').toString('base64') === req.body.usuario ? Buffer(req.body.usuario, 'base64').toString('ascii') : req.body.usuario)
      : 
      '');
  let ddispositivo = 
      (req.body.disp 
        ? 
        (Buffer.from(req.body.disp, 'base64').toString('base64') === req.body.disp ? Buffer(req.body.disp, 'base64').toString('ascii') : req.body.disp)
        : 
        null);
  let stmt = "INSERT INTO xxbdo_login_attempts VALUES (?)";
  let data = [
    req.app_request_id, 
    timestamp, 
    req.app_client_ip_address, 
    dcrplaza, 
    dcrtienda, 
    dusuario, 
    ddispositivo,
    dapp_version,
    dprinter_name,
    false,
    null,
    null
  ];
  //run query
  qry = db.query(stmt, [data], (err, rst, fields) => {
    console.log(qry.sql);
    if (err) {
       console.log("errror qry INSERT INTO xxbdo_login_attempts line 217");
        err.status = 500;
        return next(err);
    }
    req.login_succeed = false;
    req.tokenData = {"crplaza":dcrplaza,"crtienda":dcrtienda,"usuario":dusuario,"appver":dapp_version};
    if(dbg) console.log("--- End authorize_post_login_attempt ---");
    next();
  });
};


exports.authorize_post_store_validation = (req, res, next) => {
  if(dbg) console.log("--- Start authorize_post_store_validation ---");
  if(!db) {
     console.log("errror Conexion a BD no encontrad2 line 250");
    const error  = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }
  //
  const authDefaultTimeZone  = app_configuration.get('application.api_default_tz'),
        authDefaultUtcOffset = app_configuration.get('application.api_default_utc_offset');

  req.checkBody('crplaza').trim();
  req.checkBody('crtienda').trim();
  req.checkBody('usuario').trim();

  let valid_entries = true,
      timestamp = bdoDates.getBDOCurrentTimestamp(),
      crplaza   = req.body.crplaza,
      crtienda  = req.body.crtienda,
      usuario   = req.body.usuario,
      dcrplaza  = null,
      dcrtienda = null,
      dusuario  = null,
      stmt = null;

  if(isBase64(crplaza, {allowBlank: false})) {
    buffPlaza = new Buffer(crplaza, 'base64');
    dcrplaza  = buffPlaza.toString('ascii').trim();
    if(dbg) console.log("decoded plaza : "+dcrplaza);
    if(dcrplaza.length>5) {
      dcrplaza = dcrplaza.substring(0, 5);
    }
    if (!dcrplaza.match(/^[0-9a-zA-Z]+$/)) {
          if(dbg) console.log("formato de plaza invalido : "+dcrplaza.length);
      valid_entries = false;
    }
  } else {
    valid_entries = false;
  }

  if(isBase64(crtienda, {allowBlank: false})) {
    buffTienda = new Buffer(crtienda, 'base64');
    dcrtienda  = buffTienda.toString('ascii').trim();
    if(dcrtienda.length>5) {
      dcrtienda = dcrtienda.substring(0, 5);
    }
    if (!dcrtienda.match(/^[0-9a-zA-Z]+$/)) {
          if(dbg) console.log("formato de tienda invalido : "+dcrtienda.length);
      valid_entries = false;
    }
  } else {
    valid_entries = false;
  }

  if(isBase64(usuario, {allowBlank: false})) {
    buffUsuario = new Buffer(usuario, 'base64');
    dusuario    = buffUsuario.toString('ascii').trim();
  } else {
    if(dbg) console.log("usuario invalido : "+dusuario.length);
    valid_entries = false;
  }

  if(!valid_entries) {
    const error = new Error('formato de crplaza, crtienda o usuario invalidos!');
    error.status = 401;
    return next(error);
  }
  //query to check if tienda already exists
  stmt = "SELECT `xxbdo_checklists`.`id` as checklist_default, \
  `xxbdo_checklists`.`xxbdo_version_estandares_id`, \
  `xxbdo_checklists`.`titulo`, \
  `xxbdo_checklists`.`descripcion`, \
  `xxbdo_checklists`.`titulo_app`, \
  `xxbdo_checklists`.`titulo_indicadores_app`, \
  `xxbdo_checklists`.`fecha_inicio`, \
  `xxbdo_checklists`.`fecha_fin`, \
  (SELECT timezone \
  FROM xxbdo_tiendas \
  WHERE cr_plaza=? \
  AND cr_tienda=? \
  AND activo=1 \
  LIMIT 1) AS tz_tienda \
  FROM `xxbdo_checklists`, \
  `xxbdo_version_estandares` \
  WHERE `xxbdo_checklists`.`xxbdo_version_estandares_id` = `xxbdo_version_estandares`.id \
  AND `xxbdo_version_estandares`.`es_default`=1 \
  AND `xxbdo_version_estandares`.`activo`=1 \
  AND `xxbdo_checklists`.`es_default`=1 \
  AND `xxbdo_checklists`.`activo`=1 \
  LIMIT 1";
  let data = [dcrplaza, dcrtienda, dcrplaza, dcrtienda];
  req.auth_status_code=200;
  //run query
  qry=db.query(stmt, data, (err, result) => {
    console.log("[ap:321] ", qry.sql);
    if (err) {
      console.log("errror qry SELECT `xxbdo_checklists`.`id line 318");
        err.status=500;
        return next(err);
    }
    if(result.length>0) {
      let checklist_default = result[0].checklist_default;
      let tz_tienda = result[0].tz_tienda;
      let xxbdo_version_estandares_id = result[0].xxbdo_version_estandares_id;
      let titulo = result[0].titulo;
      let descripcion = result[0].descripcion;
      let titulo_app = result[0].titulo_app;
      let titulo_indicadores_app = result[0].titulo_indicadores_app;
      let fecha_inicio = result[0].fecha_inicio;
      let fecha_fin = result[0].fecha_fin;
      if(dbg) console.log(checklist_default+' | '+tz_tienda);
      if(!tz_tienda) {
            stmt = "INSERT INTO xxbdo_tiendas VALUES(?)";
            data = [
              dcrplaza, 
              dcrtienda, 
              null, 
              null, 
              authDefaultTimeZone, 
              authDefaultUtcOffset,
              null,
              null,
              3, // 3=tienda no existe en catálogo interno de tiendas
              1, // activo
              dusuario,
              req.app_client_ip_address,
              timestamp,
              timestamp
            ];
            //run query
            qry=db.query(stmt, [data], (err, rsti) => {
               console.log(qry.sql);
              if (err) {
                console.log("errror qry INSERT INTO xxbdo_tiendas VALUES  line 362");
                  err.status=500;
                  return next(err);
              }
              data = [checklist_default, 
                dcrplaza, 
                dcrtienda, 
                xxbdo_version_estandares_id,
                titulo,
                descripcion,
                titulo_app,
                titulo_indicadores_app,
                fecha_inicio,
                fecha_fin,
                1, 
                1, 
                dusuario, 
                req.app_client_ip_address,
                timestamp,
                timestamp
              ];
              stmt = "INSERT INTO `xxbdo_checklists_tiendas` VALUES(?)";
              qry  = db.query(stmt, [data], (err, rstict) => {
               console.log(qry.sql);
                if (err) {
                      console.log("errror qry INSERT INTO `xxbdo_checklists_tien  line 404");
                    err.status=500;
                    return next(err);
                }
                stmt = "INSERT INTO `xxbdo_tiendas_has_areas_estandares` \
                SELECT ? AS `cr_plaza`, \
                ? AS `cr_tienda`, \
                `xxbdo_checklists_id`, \
                `xxbdo_areas_estandares_id`, \
                NULL, \
                `es_visible`, \
                `activo`, \
                ? AS `usuario`, \
                ? AS `ip_address`, \
                ? AS `created_at`, \
                ? AS `updated_at` \
                FROM `xxbdo_checklists_has_areas_estandares` \
                WHERE `xxbdo_checklists_id`=?";
                data = [
                  dcrplaza, 
                  dcrtienda, 
                  dusuario, 
                  req.app_client_ip_address, 
                  timestamp,
                  timestamp,
                  checklist_default
                ];
                qry=db.query(stmt, data, (err) => {
                  console.log(qry.sql);
                  if (err) {
                    console.log("errror qry INSERT INTO `xxbdo_tiendas_has_areas_estandares` line 412");
                      err.status=500;
                      return next(err);
                  }
                  //insert indicadores de tienda
                  stmt="INSERT INTO \
                  `xxbdo_tiendas_has_areas_estandares_indicadores` \
                  SELECT ? AS `cr_plaza`, \
                  ? AS `cr_tienda`, \
                  `xxbdo_checklists_id`, \
                  `xxbdo_areas_estandares_indicadores_id`, \
                  `es_visible`, \
                  `activo`, \
                  ? AS `usuario`, \
                  ? AS `ip_address`, \
                  ? AS `created_at`, \
                  ? AS `updated_at` \
                  FROM `xxbdo_checklists_has_areas_estandares_indicadores` \
                  WHERE `xxbdo_checklists_id`=?";
                  data = [
                    dcrplaza, 
                    dcrtienda, 
                    dusuario, 
                    req.app_client_ip_address, 
                    timestamp,
                    timestamp,
                    checklist_default
                  ];
                  qry=db.query(stmt, data, (err) => {
                     console.log(qry.sql);
                    if (err) {
                      console.log("errror qry INSERT INTO \
                  `xxbdo_tiendas_has_areas_estandares_indicadores` line 443");
                        err.status=500;
                        return next(err);
                    }
                    //
                    req.auth_status_code=201;//New tienda created with status 3
                    if(dbg) console.log("--- 1) End authorize_post_store_validation ---");
                    next();
                  });
                });
              });
            });
          } else {
            if(dbg) console.log("--- 2) End authorize_post_store_validation ---");
            next();
          }
    } else {
      const error  = new Error('No existe checklist default!');
      error.status = 400;
      return next(error);
    }
  });
};