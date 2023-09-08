
const app_configuration = require('config'),
bdoDates = require("./../../helpers/bdo-dates"),
azureSasToken = require("./../../helpers/azure-sas-tokens"),
db = require("./../../../db"),
util = require('util'),
dbg = false;

exports.detalles_get = (req, res, next) => {
  if(!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status=500;
    return next(error);
  }
  //
  if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
    const error = new Error('crplaza o crtienda invalidos!');
    error.status=400;
    return next(error);
  }
  //
  req.checkParams('tipo_consulta')
  .matches(/^[D|S|M]/)//D:Diario, S:Semanal, M:Mensual//{1}
  .withMessage('Tipo de consulta invalido!')
  .trim();
    
  var errors = req.validationErrors();
  if (errors) {
        //console.log(util.inspect(errors, {depth: null}));
        const error = new Error('Tipo de consulta invalida!');
        error.status=400;
        return next(error);
    }
  //
  let consulta_respuesta = "'T','P','A','K',''";
  let tipo_respuesta = req.params.tipo_respuesta || null;
  let tipo_consulta  = req.params.tipo_consulta  || null;
  let valor          = req.params.valor || null;
  let year           = req.params.year  || 
                       bdoDates.getBDOFormat(req.tokenData.fecha, 'YYYY');
  let fecha_consulta = req.params.fecha_consulta || valor;
  let validation_errors = false;
  let crplaza           = req.tokenData.crplaza;
  let crtienda          = req.tokenData.crtienda;
  let fecha_token       = req.tokenData.fecha;
  let formattedDate     = null;
  let formattedDateName = null;
  let stmt              = null;
  let entries           = null;
  let results           = null;
  let sql_search        = null;
  let existe            = false;
  let num_week          = null;
  let num_month         = null;
  let date_array        = null;
  let titulo            = null;
  let subtitulo         = null;
  let num_week_or_month = null;
  //
  //added from checklist GET method
  switch(tipo_consulta) {
      case "D":
      entries       = [crplaza, crtienda, fecha_consulta, tipo_consulta];
      formattedDate = 
          bdoDates.getBDOFormattedDate(
              fecha_consulta, 
              "es", 
              "dddd, D MMMM YYYY");
      //
      titulo =
      bdoDates.getBDOFormattedDate(
          valor, 
          "es", 
          "dddd");
      subtitulo = 
      bdoDates.getBDOFormattedDate(
          fecha_consulta, 
          "es", 
          "D MMMM YYYY");
      num_week_or_month = fecha_consulta;
      break;
      case "S":
      //check if valor es mayor que la fecha actual
      //if(bdoDates.isDateGreatherThanCurrent(valor)) {
      //    fecha_consulta = valor = bdoDates.getBDOCurrentDate();
      //}
        isGreather = bdoDates.isDateGreatherThanCurrent(valor);
        if(isGreather) {
            fecha_consulta = valor = bdoDates.getBDOCurrentDate();
            const error  = new Error('Valor de día es mayor que el actual!');
            error.status = 400;
            return next(error);
        }
      [num_week, year] = bdoDates.getWeekAndYearFromDate(valor);
      if(dbg)console.log("[CD:87] Num week = "+num_week+" , year = "+year);
      date_array = bdoDates.formatWeekStartEndDays(num_week, year);
      titulo     = date_array[0];
      subtitulo  = date_array[1];
      entries    = [crplaza, crtienda, tipo_consulta, num_week, year];
      num_week_or_month = num_week;
      break;
      case "M":
      //check if valor es mayor que la fecha actual
      //if(bdoDates.isDateGreatherThanCurrent(valor)) {
      //    fecha_consulta = valor = bdoDates.getBDOCurrentDate();
      //}
        isGreather = bdoDates.isDateGreatherThanCurrent(valor);
        if(isGreather) {
            fecha_consulta = valor = bdoDates.getBDOCurrentDate();
            const error  = new Error('Valor de día es mayor que el actual!');
            error.status = 400;
            return next(error);
        }
      num_month = 
      bdoDates.getBDOFormattedDate(
          valor, 
          "es", 
          "M",
          true
      );
      //
      year = 
      bdoDates.getBDOFormattedDate(
          valor, 
          "es", 
          "YYYY",
          true
      );
      if(dbg)console.log("[CD:110] Num month = "+num_month+" , year = "+year);
      date_array = bdoDates.formatMonthStartEndDays(num_month, year);
      titulo = date_array[1];
      subtitulo = date_array[2];
      entries   = [crplaza, crtienda, tipo_consulta, num_month, year];
      num_week_or_month = num_month;
      break;
  }
  //
  switch(tipo_consulta) {
      case "D": //Respuestas Diarias
        sql = "SELECT COUNT(*) as respuestas \
        FROM `xxbdo_respuestas`, \
        `xxbdo_areas_estandares`, \
        `xxbdo_areas` \
        WHERE cr_plaza=? \
        AND cr_tienda=? \
        AND fecha_respuesta=? \
        AND tipo=? \
        AND `xxbdo_areas_estandares_id`= `xxbdo_areas_estandares`.`id` \
        AND `xxbdo_areas_estandares`.`xxbdo_areas_id`=`xxbdo_areas`.`id` \
        AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
        IN (SELECT `xxbdo_areas_grupos`.`id` \
        FROM `xxbdo_areas_grupos` WHERE \
        `tipo`='"+tipo_consulta+"')";
        // Incluir estandar libre
        tipo_condition = " AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
            IN (SELECT `xxbdo_areas_grupos`.`id` \
            FROM `xxbdo_areas_grupos` \
            WHERE `tipo` IN('"+tipo_consulta+"', 'L'))";
      break;
      case "S": //Respuestas Semanales
      case "M": //Respuestas Mensuales
      //1. Buscar si existen respuestas de la semana/mes seleccionada
      tipo_respuesta = (tipo_consulta=='S' ? "AND semana=?" : "AND mes=?");
      sql = "SELECT COUNT(*) as respuestas \
      FROM `xxbdo_respuestas`, \
      `xxbdo_areas_estandares`, \
      `xxbdo_areas` \
      WHERE cr_plaza=? \
      AND cr_tienda=? \
      AND tipo=? "+tipo_respuesta+" \
      AND año=? \
      AND `xxbdo_areas_estandares_id`= `xxbdo_areas_estandares`.`id` \
      AND `xxbdo_areas_estandares`.`xxbdo_areas_id`=`xxbdo_areas`.`id` \
      AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
      IN (SELECT `xxbdo_areas_grupos`.`id` \
      FROM `xxbdo_areas_grupos` WHERE `tipo` IN('"+tipo_consulta+"'))";
      break;
  }
  qry=db.query(sql, entries, (err, result) => {
      if(dbg) console.log("[CD:157] "+qry.sql);
  if (err) {
       err.status = 500;
       return next(err);
   }
   //
   if(result[0].respuestas>0) {
      if(dbg) console.log("[CD:164] answers already exists, get from xxbdo_respuestas "+result[0].respuestas);
      existe = true;
      if(tipo_respuesta) {
          req.checkParams('tipo_respuesta')
          .matches(/^$|^[K|T|A|P|V]{1}/)
          .withMessage('Respuesta de checklist invalida!')
          .trim();
         //
         validation_errors = req.validationErrors();
         if (validation_errors) {
             console.log(util.inspect(validation_errors, {depth: null}));
             const error  = new Error('Respuesta de checklist invalida!');
             error.status = 400;
             return next(error);
         }
         if(tipo_respuesta=='V') {
             //Buscar estándares no contestados
             tipo_respuesta='';
         }
         //consulta_respuesta="'"+tipo_respuesta+"'";
       }
      //
      switch(tipo_consulta) {
          case "D":
              if(fecha_consulta) {
                  req.checkParams('fecha_consulta')
                  .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)
                  .withMessage('Formato de fecha invalido!')
                  .trim();
                  //
                  validation_errors = req.validationErrors();
                  if (validation_errors) {
                      console.log(util.inspect(validation_errors, {depth: null}));
                      const error = new Error('fecha de consulta invalida!');
                      error.status = 400;
                      return next(error);
                  }
                  isGreather = bdoDates.isDateGreatherThanCurrent(fecha_consulta);
                  if(isGreather) {
                      const error  = new Error('Valor de día es mayor que el actual!');
                      error.status = 400;
                      return next(error);
                  }
              }
              sql_search=" AND `xxbdo_respuestas`.`fecha_respuesta`=? ";
              entries = [
                  crplaza, 
                  crtienda, 
                  tipo_consulta,
                  fecha_consulta,
                  crplaza, 
                  crtienda, 
                  tipo_consulta,
                  fecha_consulta
              ];
          break;
          case "S":
          sql_search = "AND `xxbdo_respuestas`.`semana`=? AND `xxbdo_respuestas`.`año`=?";
          entries = [
              crplaza, 
              crtienda, 
              tipo_consulta,
              num_week,
              year,
              crplaza, 
              crtienda, 
              tipo_consulta,
              num_week,
              year
          ];
          break;
          case "M":
          sql_search = "AND `xxbdo_respuestas`.`mes`=? AND `xxbdo_respuestas`.`año`=?";
          entries = [
              crplaza, 
              crtienda, 
              tipo_consulta,
              num_month,
              year,
              crplaza, 
              crtienda, 
              tipo_consulta,
              num_month,
              year
          ];
          break;
      }
      //
      stmt = "SELECT `xxbdo_respuestas`.`id` AS `id`, \
      `xxbdo_checklists`.`titulo_app` AS `version`, \
      `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
      `xxbdo_areas`.`titulo` AS `area_titulo`, \
      `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
      `xxbdo_estandares`.`estandar` AS `estandar`, \
      `xxbdo_estandares`.`titulo` AS `std_titulo`, \
      IFNULL(`xxbdo_estandares`.`detalle`,'') AS `detalle`, \
      `xxbdo_respuestas`.`respuesta`, \
      `xxbdo_respuestas`.`respuesta_asesor`, \
      `xxbdo_observaciones`.`id` AS `xxbdo_observaciones_id`, \
      `xxbdo_observaciones`.`descripcion`, \
      `xxbdo_observaciones`.`causa`, \
      `xxbdo_observaciones`.`accion`, \
      `xxbdo_observaciones`.`accion_responsable`, \
      `xxbdo_observaciones`.`accion_fecha`, \
      `xxbdo_observaciones`.`requiere_ajuste_ata`, \
      `xxbdo_observaciones`.`realizaron_plan_accion`, \
      `xxbdo_observaciones`.`resolvio_problema`, \
      `xxbdo_observaciones`.`observacion`, \
      `xxbdo_observaciones`.`foto` AS `foto_obs`, \
      `xxbdo_observaciones`.`folio` AS `folio`, \
      `xxbdo_observaciones`.`turno_mañana`, \
      `xxbdo_observaciones`.`turno_tarde`, \
      `xxbdo_observaciones`.`turno_noche`, \
      `xxbdo_circulo_de_congruencia`.`id` AS `xxbdo_cc_id`, \
      `xxbdo_circulo_de_congruencia`.`comentario` as `comentario_cc`, \
      `xxbdo_circulo_de_congruencia`.`foto` as `foto_cc`, \
      (SELECT count(*) \
      FROM `xxbdo_respuestas` \
      WHERE `xxbdo_respuestas`.`cr_plaza`=? \
      AND `xxbdo_respuestas`.`cr_tienda`=? \
      AND `xxbdo_respuestas`.`tipo`=? "+sql_search+"\
      ) AS total \
      FROM (`xxbdo_respuestas`, \
      `xxbdo_areas_estandares`, \
      `xxbdo_estandares`, \
      `xxbdo_areas`, \
      `xxbdo_checklists`) \
      LEFT OUTER JOIN `xxbdo_observaciones` \
      ON (`xxbdo_observaciones`.`xxbdo_respuestas_id` = `xxbdo_respuestas`.`id`) \
      LEFT JOIN xxbdo_circulo_de_congruencia \
      ON (`xxbdo_circulo_de_congruencia`.`xxbdo_respuestas_id` = `xxbdo_respuestas`.`id`) \
      WHERE `xxbdo_respuestas`.`cr_plaza`=? \
      AND `xxbdo_respuestas`.`cr_tienda`=? \
      AND `xxbdo_respuestas`.`tipo`=? "+sql_search+"\
      AND `xxbdo_areas_estandares`.`id`=`xxbdo_respuestas`.`xxbdo_areas_estandares_id` \
      AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
      AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
      AND `xxbdo_checklists`.`id`=`xxbdo_respuestas`.`xxbdo_checklists_id` \
      AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
      ORDER BY `xxbdo_areas`.`orden`, \
      `xxbdo_areas_estandares`.`orden`";
      //AND `xxbdo_respuestas`.`respuesta` IN ("+consulta_respuesta+") \
   } else {
       if(dbg) console.log("[CD:304] answers does not exists, get assigned checklist");
       switch(tipo_consulta) {
          case 'D'://Diario
              tipo_condition = " AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
              IN (SELECT `xxbdo_areas_grupos`.`id` \
              FROM `xxbdo_areas_grupos` \
              WHERE `tipo`='"+tipo_consulta+"')";
          //
          sql_stds_libres="SELECT `xxbdo_areas_estandares`.`id` AS `id`, \
          `xxbdo_checklists`.`titulo_app` AS `version`, \
          `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
          `xxbdo_areas`.`titulo` AS `area_titulo`, \
          `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
          `xxbdo_estandares`.`estandar` AS `estandar`, \
          `xxbdo_estandares`.`titulo` AS `std_titulo`, \
          `xxbdo_estandares`.`detalle`, \
          '' AS `respuesta`, \
          '' AS `respuesta_asesor`, \
          NULL AS `xxbdo_observaciones_id`, \
          '' AS `descripcion`, \
          '' AS `causa`, \
          '' AS `accion`, \
          '' AS `accion_responsable`, \
          '' AS `accion_fecha`, \
          '' AS `requiere_ajuste_ata`, \
          '' AS `realizaron_plan_accion`, \
          '' AS `resolvio_problema`, \
          '' AS `observacion`, \
          '' AS `foto_obs`, \
          '' AS `folio`, \
          '' AS `turno_mañana`, \
          '' AS `turno_tarde`, \
          '' AS `turno_noche`, \
          NULL AS `xxbdo_cc_id`, \
          '' AS `comentario_cc`, \
          '' AS `foto_cc`, \
          '' AS `total`, \
          `xxbdo_areas`.`orden` AS areas_orden, \
          `xxbdo_areas_estandares`.`orden` AS areas_estandares_orden \
          FROM `xxbdo_checklists`, \
          `xxbdo_areas_estandares`, \
          `xxbdo_areas`, \
          `xxbdo_estandares` \
          WHERE `xxbdo_checklists`.`id` = ( \
              SELECT `id` \
              FROM `xxbdo_checklists` \
              WHERE '"+valor+"' \
              BETWEEN `fecha_inicio` \
              AND IFNULL(`fecha_fin`, '"+fecha_token+"') \
              LIMIT 1 \
          ) \
          AND `xxbdo_areas_estandares`.`id` IN( \
              SELECT `xxbdo_tiendas_has_areas_estandares`.`xxbdo_areas_estandares_id` \
              FROM `xxbdo_tiendas_has_areas_estandares` \
              WHERE `xxbdo_tiendas_has_areas_estandares`.`cr_plaza`='"+crplaza+"' \
              AND `xxbdo_tiendas_has_areas_estandares`.`cr_tienda`='"+crtienda+"' \
              AND `xxbdo_tiendas_has_areas_estandares`.`xxbdo_checklists_id`= `xxbdo_checklists`.`id` \
              AND `xxbdo_tiendas_has_areas_estandares`.`es_visible`=1 \
              AND `xxbdo_tiendas_has_areas_estandares`.`activo`=1 \
          )\
          AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
          AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
          AND `xxbdo_estandares`.`cr_plaza`='"+crplaza+"' \
          AND `xxbdo_estandares`.`cr_tienda`='"+crtienda+"' \
          AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
          AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
          AND FIND_IN_SET((WEEKDAY('"+valor+"')+1), `xxbdo_areas_estandares`.`dias_activos`)>0 \
          AND `xxbdo_areas`.`activo`=1 \
          AND `xxbdo_estandares`.`activo`=1 \
          AND `xxbdo_estandares`.`es_visible`=1 \
          AND `xxbdo_checklists`.`activo`=1 \
          AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
          IN(SELECT `xxbdo_areas_grupos`.`id` \
          FROM `xxbdo_areas_grupos` \
          WHERE `tipo`='L')";
          //get records from xxbdo_checklists
          sql_stds = "SELECT `xxbdo_areas_estandares`.`id` AS `id`, \
          `xxbdo_checklists`.`titulo_app` AS `version`, \
          `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
          `xxbdo_areas`.`titulo` AS `area_titulo`, \
          `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
          `xxbdo_estandares`.`estandar` AS `estandar`, \
          `xxbdo_estandares`.`titulo` AS `std_titulo`, \
          `xxbdo_estandares`.`detalle`, \
          '' AS `respuesta`, \
          '' AS `respuesta_asesor`, \
          NULL AS `xxbdo_observaciones_id`, \
          '' AS `descripcion`, \
          '' AS `causa`, \
          '' AS `accion`, \
          '' AS `accion_responsable`, \
          '' AS `accion_fecha`, \
          '' AS `requiere_ajuste_ata`, \
          '' AS `realizaron_plan_accion`, \
          '' AS `resolvio_problema`, \
          '' AS `observacion`, \
          '' AS `foto_obs`, \
          '' AS `folio`, \
          '' AS `turno_mañana`, \
          '' AS `turno_tarde`, \
          '' AS `turno_noche`, \
          NULL AS `xxbdo_cc_id`, \
          '' AS `comentario_cc`, \
          '' AS `foto_cc`, \
          '' AS `total`, \
          `xxbdo_areas`.`orden` AS areas_orden, \
          `xxbdo_areas_estandares`.`orden` AS areas_estandares_orden \
          FROM `xxbdo_checklists`, \
          `xxbdo_areas_estandares`, \
          `xxbdo_areas`, \
          `xxbdo_estandares` \
          WHERE `xxbdo_checklists`.`id` = ( \
              SELECT `id` \
              FROM `xxbdo_checklists` \
              WHERE '"+valor+"' \
              BETWEEN `fecha_inicio` \
              AND IFNULL(`fecha_fin`, '"+fecha_token+"') \
              LIMIT 1 \
          ) \
          AND `xxbdo_areas_estandares`.`id` IN( \
              SELECT `xxbdo_tiendas_has_areas_estandares`.`xxbdo_areas_estandares_id` \
              FROM `xxbdo_tiendas_has_areas_estandares` \
              WHERE `xxbdo_tiendas_has_areas_estandares`.`cr_plaza`='"+crplaza+"' \
              AND `xxbdo_tiendas_has_areas_estandares`.`cr_tienda`='"+crtienda+"' \
              AND `xxbdo_tiendas_has_areas_estandares`.`xxbdo_checklists_id`= `xxbdo_checklists`.`id` \
              AND `xxbdo_tiendas_has_areas_estandares`.`es_visible`=1 \
              AND `xxbdo_tiendas_has_areas_estandares`.`activo`=1 \
          )\
          AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
          AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
          AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
          AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
          AND FIND_IN_SET((WEEKDAY(?)+1), `xxbdo_areas_estandares`.`dias_activos`)>0 \
          AND `xxbdo_areas`.`activo`=1 \
          AND `xxbdo_estandares`.`activo`=1 \
          AND `xxbdo_estandares`.`es_visible`=1 \
          AND `xxbdo_checklists`.`activo`=1 "+tipo_condition;
          entries = [valor];
          stmt="SELECT * FROM (\
              "+sql_stds+" \
              UNION \
              "+sql_stds_libres+" \
              ) tbl_respuestas \
              ORDER BY `tbl_respuestas`.`areas_orden`, \
          `tbl_respuestas`.`areas_estandares_orden`";
          break;
          case 'S'://Semanal
          case 'M'://Mensual
          //get records from xxbdo_checklists
          stmt = "SELECT `xxbdo_areas_estandares`.`id` AS `id`, \
          `xxbdo_checklists`.`titulo_app` AS `version`, \
          `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
          `xxbdo_areas`.`titulo` AS `area_titulo`, \
          `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
          `xxbdo_estandares`.`estandar` AS `estandar`, \
          `xxbdo_estandares`.`titulo` AS `std_titulo`, \
          IFNULL(`xxbdo_estandares`.`detalle`,'') AS `detalle`, \
          '' AS `respuesta`, \
          '' AS `respuesta_asesor`, \
          NULL AS `xxbdo_observaciones_id`, \
          '' AS `descripcion`, \
          '' AS `causa`, \
          '' AS `accion`, \
          '' AS `accion_responsable`, \
          '' AS `accion_fecha`, \
          '' AS `requiere_ajuste_ata`, \
          '' AS `realizaron_plan_accion`, \
          '' AS `resolvio_problema`, \
          '' AS `observacion`, \
          '' AS `foto_obs`, \
          '' AS `folio`, \
          '' AS `turno_mañana`, \
          '' AS `turno_tarde`, \
          '' AS `turno_noche`, \
          NULL AS `xxbdo_cc_id`, \
          '' AS `comentario_cc`, \
          '' AS `foto_cc`, \
          '' AS `total`, \
          `xxbdo_areas`.`orden` AS areas_orden, \
          `xxbdo_areas_estandares`.`orden` AS areas_estandares_orden \
          FROM `xxbdo_checklists`, \
          `xxbdo_areas_estandares`, \
          `xxbdo_areas`, \
          `xxbdo_estandares` \
          WHERE `xxbdo_checklists`.`id` = ( \
              SELECT `id` \
              FROM `xxbdo_checklists` \
              WHERE ? \
              BETWEEN `fecha_inicio` \
              AND IFNULL(`fecha_fin`, '"+fecha_token+"') \
              LIMIT 1 \
          ) \
          AND `xxbdo_areas_estandares`.`id` IN( \
              SELECT `xxbdo_tiendas_has_areas_estandares`.`xxbdo_areas_estandares_id` \
              FROM `xxbdo_tiendas_has_areas_estandares` \
              WHERE `xxbdo_tiendas_has_areas_estandares`.`cr_plaza`='"+crplaza+"' \
              AND `xxbdo_tiendas_has_areas_estandares`.`cr_tienda`='"+crtienda+"' \
              AND `xxbdo_tiendas_has_areas_estandares`.`xxbdo_checklists_id`= `xxbdo_checklists`.`id` \
              AND `xxbdo_tiendas_has_areas_estandares`.`es_visible`=1 \
              AND `xxbdo_tiendas_has_areas_estandares`.`activo`=1 \
          )\
          AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
          AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
          AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
          AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
          AND FIND_IN_SET((WEEKDAY(?)+1), `xxbdo_areas_estandares`.`dias_activos`)>0 \
          AND `xxbdo_areas`.`activo`=1 \
          AND `xxbdo_estandares`.`activo`=1 \
          AND `xxbdo_estandares`.`es_visible`=1 \
          AND `xxbdo_checklists`.`activo`=1 \
          AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
          IN (SELECT `xxbdo_areas_grupos`.`id` \
          FROM `xxbdo_areas_grupos` \
          WHERE `tipo`='"+tipo_consulta+"') \
          ORDER BY  `xxbdo_areas`.`orden`, \
          `xxbdo_areas_estandares`.`orden`";
          entries = [valor, valor];
          break;
      }
   }
   qry=db.query(stmt, entries, (err, resultB) => {
      if(dbg) console.log("[CD:528] "+qry.sql);
      if (err) {
          err.status = 500;
          return next(err);
      }
      
      results = formatResults(
          resultB, 
          tipo_consulta, 
          existe,
          //valor,
          year,
          num_week_or_month,
          titulo,
          subtitulo
      );
      
      if(!results) {
          const error = new Error('No hay Registros de bitacora!');
          error.status = 400;
          return next(error);
      }
      
      //res.api_response_body =JSON.stringify(results);

      res.status(200).json(results);
  });
  });
}

function formatResults(rows, tipo_consulta, existe_dia, year, num_week_or_month=null, titulo=null, subtitulo=null) {
    if(rows) {
        let results = [], plantilla = null, version = null;
        if(rows.length>0) {
            let areas=[],
            observacion = null, 
            uri_obs = null,
            circulo_de_congruencia = null, 
            uri_cc = null;
            rows.forEach(row => {
                observacion = null;
                uri_obs=null;
                if(row.xxbdo_observaciones_id) {
                    if(row.foto_obs) {
                        //get foto url from azure storage service
                        token = 
                            azureSasToken.generateSasToken(
                                app_configuration.
                                    get('azure.sas.blob.containers.observaciones.name'), 
                                row.foto_obs, 
                                app_configuration.
                                    get('azure.sas.blob.containers.observaciones.sharedAccessPolicy')
                            );
                        
                        if(!token) {
                            uri_obs = "";
                        } else {
                            uri_obs = token.uri;
                        }
                    }
      
                    observacion = {
                        "id":row.xxbdo_observaciones_id,
                        "desc":row.descripcion || "",
                        "uri":uri_obs,
                        "folio":row.folio || "",
                        "turnom":(row.turno_mañana ? true : false),
                        "turnot":(row.turno_tarde ? true : false),
                        "turnon":(row.turno_noche ? true : false),
                        "causa":row.causa || "",
                        "accion":row.accion || "",
                        "acresp":row.accion_responsable || "",
                        "acfecha":row.accion_fecha,
                        "ata":(row.requiere_ajuste_ata ? true : (row.requiere_ajuste_ata==0 ? false : null)),
                        "rpa":(row.realizaron_plan_accion ? true : (row.realizaron_plan_accion==0 ? false : null)),
                        "rep":(row.resolvio_problema ? true : (row.resolvio_problema==0 ? false : null)),
                        "obs":row.observacion
                    };
                    uri="";
            }
            //
            circulo_de_congruencia = null;
            uri_cc=null;
            if(row.xxbdo_cc_id) {
                if(row.foto_cc) {
                    //get foto url from azure storage service
                    tokencc = 
                        azureSasToken.generateSasToken(
                            app_configuration.
                                get('azure.sas.blob.containers.observaciones.name'), 
                            row.foto_cc, 
                            app_configuration.
                                get('azure.sas.blob.containers.observaciones.sharedAccessPolicy')
                        );
                    
                    if(!tokencc) {
                        uri_cc = "";
                    } else {
                        uri_cc = tokencc.uri;
                    }
                }
  
                circulo_de_congruencia = {
                    "id":row.xxbdo_cc_id,
                    "desc":row.comentario_cc,
                    "uri":uri_cc
                };
                uri_cc="";
        }
                //
                if(!areas.includes(row.xxbdo_areas_id)) {
                    //is new 
                    version = row.version;
                    areas.push(row.xxbdo_areas_id);
                    results.push(
                        {
                         "area":row.area_titulo, 
                         "stds":[]
                        }
                    );
                }
                //
                aindx = areas.indexOf(row.xxbdo_areas_id);
                if(existe_dia) {
                    switch(tipo_consulta) {
                        case 'D':
                        res = {
                            "id": row.id,
                            "eid": row.xxbdo_estandares_id,
                            //"area":row.area_titulo,
                            "std": row.estandar || "",
                            "titulo": row.std_titulo || "",
                            "detalle": row.detalle || "",
                            "res": (row.respuesta ? row.respuesta : ""),
                            "resa": (row.respuesta_asesor ? row.respuesta_asesor : ""),
                            "obs":observacion,
                            "cc":circulo_de_congruencia
                        };
                        break;
                        case 'S':
                        case 'M':
                        res = {
                            "id": row.id,
                            "eid": row.xxbdo_estandares_id,
                            //"area":row.area_titulo,
                            "std": row.estandar || "",
                            "titulo": row.std_titulo || "",
                            "detalle": row.detalle || "",
                            "res": row.respuesta || "",
                            "resa":row.respuesta_asesor || "",
                            "obs":observacion,
                            "cc":circulo_de_congruencia
                        };
                        break;
                    }
                } else {
                    switch(tipo_consulta) {
                        case 'D':
                        res={
                            "id": row.id, //xxbdo_areas_estandares_id,
                            "eid": row.xxbdo_estandares_id,
                            //"area":row.area_titulo,
                            "std": row.estandar || "",
                            "titulo": row.std_titulo || "",
                            "detalle": row.detalle || "",
                            "res":"",
                            "resa":"",
                            "obs":null,
                            "cc":null
                        };
                        break;
                        case 'S':
                        case 'M':
                        res={
                            "id": row.id, //xxbdo_areas_estandares_id,
                            "eid": row.xxbdo_estandares_id,
                            //"area":row.area_titulo,
                            "std": row.estandar || "",
                            "titulo": row.std_titulo || "",
                            "detalle": row.detalle || "",
                            "res":"",
                            "resa":"",
                            "obs":null,
                            "cc":null
                        };
                        break;

                    }
                    results[aindx].stds.push();
                }
                results[aindx].stds.push(res);
            });
            //
            plantilla = {
                "año":year,
                "num":num_week_or_month,
                "ver":version,
                "ttl":titulo,
                "sbtl":subtitulo,
                "existe":existe_dia,
                "checklist":results
            };
        }
        return plantilla;
    }
    return;
}
