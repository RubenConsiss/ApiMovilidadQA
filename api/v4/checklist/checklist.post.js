
const db = require("./../../../db");
const uuidv4 = require('uuid/v4');
bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;

exports.checklist_post = (req, res, next) => {
    if(dbg) console.log("[9] Start checklist_post...");
    if(!db) {
        const error = new Error('Conexion a BD no encontrada!');
        error.status = 500;
        return next(error);
    }
    //Validation chain
    req.checkBody('tipo')
        .matches(/^$|^[D|S|M]/)//D:Diario, S:Semanal, M:Mensual//{1}
        .withMessage('Tipo de consulta invalido!')
        .trim();
    req.checkBody('num')
    .matches(/^$|(5[0-3]|[1-4][0-9]|[1-9])/) //1 to 53 weeks
    .withMessage('Numero de semana/mes invalido!')
    .trim();
    req.checkBody('yr')
    .matches(/^$|\d{4}/)
    .withMessage('Numero de año invalido!')
    .trim();
    req.checkBody('respuestas.*.id')
       .isUUID(4)
       .withMessage('Formato de id(UUID4) invalido!')
       .trim();
    req.checkBody('respuestas.*.res')
        .matches(/^$|^[K|T|A|P]{1}/)
        .withMessage('Respuesta de lider invalida!')
        .trim();
    
    const errors = req.validationErrors();
    if (errors) {
      if(dbg) console.log(util.inspect(errors, {depth: null}));
      const error = new Error('Informacion en body invalida!');
      error.status=400;
      return next(error);
    }
    
    let crplaza = req.tokenData.crplaza;
    let crtienda = req.tokenData.crtienda;
    let fecha_token = req.tokenData.fecha;
    let fecha_respuesta = req.tokenData.fecha;
    let respuestas = req.body.respuestas || null;
    let tipo_respuesta = req.body.tipo;
    let numero = req.body.num || null;
    let year = req.body.yr || null;
    let ip = req.app_client_ip_address;
    let tienda_tz = req.tokenData.tz;
    let usuario = req.tokenData.usuario;
    let fecha_actual = bdoDates.getBDOCurrentDate(tienda_tz);
    let fecha_checklist = null;
    let data = null;
    let stmt = null;
    let status = 500;
    
    if(!respuestas || !tipo_respuesta || respuestas.length<1) {
        const error  = 
            new Error('Respuestas no recibidas!');
        error.status = 400;
        return next(error);
    }
    
    if(dbg) 
        console.log("[70] Tipo_respuesta= "+tipo_respuesta+
        " | fecha_respuesta= "+fecha_respuesta+
        " | num= "+numero+" | yr= "+year);
    switch(tipo_respuesta) {
        case "D":
            req.checkBody('fecha')
            .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)
            .withMessage('Formato de fecha invalido!')
            .trim();
            
            validation_errors = req.validationErrors();
            if (validation_errors) {
                console.log(util.inspect(validation_errors, {depth: null}));
                const error = 
                    new Error('fecha de consulta invalida!');
                error.status = 400;
                return next(error);
            }
            fecha_respuesta  = req.body.fecha || fecha_respuesta;
            isGreather = 
                bdoDates.isDateGreatherThanCurrent(fecha_respuesta);
            if(isGreather) {
                const error  = 
                    new Error('Fecha es mayor que la actual!');
                error.status = 400;
                return next(error);
            }
        break;
        case "S"://Semana
            if(!numero || !year) {
                const error  = 
                    new Error('Año o semana no recibidos!');
                error.status = 400;
                return next(error);
            }
            
            if(!bdoDates.isLeapYear(year)) {
                if(numero>53) {
                    const error  = 
                        new Error('Valor de semana invalido!');
                    error.status = 400;
                    return next(error);
                }
            }
            
            isGreather = 
                bdoDates.isWeekGreatherThanCurrent(numero, year);
            if(isGreather) {
                const error  = 
                    new Error('Valor de semana es mayor que la actual!');
                error.status = 400;
                return next(error);
            }
            var week_days_array = 
                bdoDates.formatWeekStartEndDays(numero, year);
            fecha_respuesta = week_days_array[3];//end week date
            tipo_consulta = "AND semana=?";
        break;
        case "M"://Mes
            if(!numero || !year) {
                const error  = 
                    new Error('Año o mes no recibidos!');
                error.status = 400;
                return next(error);
            }
            
            if(numero>12) {
                const error  = 
                    new Error('Valor de mes invalido!');
                error.status = 400;
                return next(error);
            }
            //check if month/year is not greater than current month/year
            isGreather = 
                bdoDates.isMonthGreatherThanCurrent(numero, year);
            if(isGreather) {
                const error  = 
                    new Error('Valor de mes es mayor que el actual!');
                error.status = 400;
                return next(error);
            }
            var month_days_array = 
                bdoDates.formatMonthStartEndDays(numero, year);
            fecha_respuesta = month_days_array[4];//end month date
            tipo_consulta = "AND mes=?";
        break;
    }
    
     if(respuestas.length<0) {
        const error  = 
            new Error('Respuestas del checklist no recibidas!');
        error.status = 400;
        return next(error);
    }
    
    switch(tipo_respuesta) {
        case "D"://Checklist Diario
            stmt = "SELECT `xxbdo_checklists_id` AS `checklist_tienda`, \
            (SELECT COUNT(*) AS respuestas \
            FROM xxbdo_respuestas \
            WHERE cr_plaza=? \
            AND cr_tienda=? \
            AND fecha_respuesta=? \
            AND tipo=?) AS respuestas, \
            IF((?=?), \
            true, \
            false \
            ) AS `is_on_time`, \
            ( \
                SELECT `xxbdo_checklists_id` \
                FROM `xxbdo_checklists_tiendas` \
                WHERE `cr_plaza`= '"+crplaza+"' \
                AND `cr_tienda`= '"+crtienda+"' \
                AND ? \
                BETWEEN `fecha_inicio` \
                AND IFNULL(`fecha_fin`, '"+fecha_token+"') \
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
                fecha_respuesta, 
                tipo_respuesta,
                fecha_respuesta, 
                fecha_actual,
                fecha_respuesta,
                crplaza, 
                crtienda
            ];
            fecha_checklist = fecha_respuesta;
        break;
        case "S"://Semanal
        case "M"://Mensual
            stmt = "SELECT `xxbdo_checklists_id`, \
                (SELECT COUNT(*) AS respuestas \
                FROM xxbdo_respuestas \
                WHERE cr_plaza=? \
                AND cr_tienda=? \
                AND tipo=? "+tipo_consulta+" \
                AND año=?) AS respuestas, \
                IF((?=?), \
                true, \
                false \
                ) AS `is_on_time`, \
                ( \
                    SELECT `xxbdo_checklists_id` \
                    FROM `xxbdo_checklists_tiendas` \
                    WHERE `cr_plaza`= '"+crplaza+"' \
                    AND `cr_tienda`= '"+crtienda+"' \
                    AND ? \
                    BETWEEN `fecha_inicio` \
                    AND IFNULL(`fecha_fin`, '"+fecha_token+"') \
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
                tipo_respuesta,
                numero,
                year,
                fecha_respuesta,
                fecha_actual,
                fecha_respuesta,
                crplaza, 
                crtienda
            ];
            fecha_checklist = fecha_respuesta; //fecha_actual;
        break;
    }
    
    qry=db.query(stmt, data, (err, result) => {
        if(dbg) console.log("[253] "+qry.sql);
        if (err) {
            err.status = 500;
            return next(err);
        }
        
        if(result.length>0) {
            if(result[0].respuestas>0) {
                //daily record already exists, ignore checklist
                const error  = 
                    new Error('Checklist tipo '+tipo_respuesta+' ya enviado!');
                error.status = 400;
                return next(error);
            } else {
                rst = formatInsertData(crplaza, 
                    crtienda, 
                    tipo_respuesta,
                    numero,
                    year,
                    (result[0].checklists_id ? 
                        result[0].checklists_id : 
                        result[0].xxbdo_checklists_id),
                    fecha_checklist, 
                    respuestas, 
                    usuario, 
                    ip);
                if(!rst) {
                    const error  = 
                        new Error('Formato de respuestas no generado!');
                    error.status = 400;
                    return next(error);
                }
                stmt = 'INSERT INTO xxbdo_respuestas VALUES ?';
                status = 201;
                data = [rst[0]];
                obs = rst[1]; // array of obs_id's
                resp = rst[2]; //array of json objects with {eid,obs_id}
                //run query
                qry=db.query(stmt, data, (err, rst2) => {
                    if(dbg) 
                        console.log("[288] Insert respuestas: "+qry.sql);

                    if (err) {
                        err.status = 500;
                        return next(err);
                    }

                    //check to insert observaciones
                    if(obs.length>0) {
                        stmt = "INSERT INTO xxbdo_observaciones VALUES ?";
                        data_obs = [obs];
                        qry=db.query(stmt, data_obs, (err3, rst3) => {
                            if(dbg) 
                                console.log("[306] Insert observaciones: "+qry.sql);

                            if (err3) {
                                err3.status = 500;
                                return next(err3);
                            }
                        });
                    }

                    res.status(status).json(resp);
                });
            }
        } else {
            const error  = new Error('Plantilla/Version Estandar para tienda '+crtienda+' no encontrada!');
            error.status = 400;
            return next(error);
        }
    });
};

function formatInsertData(crplaza, 
    crtienda, 
    tipo_respuesta,
    numero,
    year,
    xxbdo_checklists_id, 
    fecha_respuesta, 
    respuestas, 
    usuario, 
    ip) {
    if(!respuestas) {
        return;
    } else {
        let data = [];
        let obs = [];
        let resp_obs = [];
        let uuid = null;
        let uuid_obs = null;
        let timestamp = null;
        //let fill_obs  = false;
        if(respuestas.length>0) {
            respuestas.forEach(row => {
                uuid      = uuidv4();
                timestamp = bdoDates.getBDOCurrentTimestamp();
                switch(tipo_respuesta) {
                    case "D"://Diario
                        res = [uuid, 
                            xxbdo_checklists_id, 
                            crplaza,
                            crtienda,
                            fecha_respuesta,
                            row.id, 
                            tipo_respuesta,
                            (row.res ? row.res : ""),
                            null,//row.resa,
                            null,//row.ata, 
                            null,//week number
                            null,//month number
                            bdoDates.getBDOFormat(fecha_respuesta, 'YYYY'),
                            1,
                            usuario,
                            ip, 
                            timestamp, 
                            timestamp];
                        //check if observacion is not null:

                    break;
                    case "S"://Semanal
                    case "M"://Mensual
                    valor_semana = (tipo_respuesta=='S' ? numero : null);
                    valor_mes = (tipo_respuesta=='M' ? numero : null);
                    res = [uuid, 
                        xxbdo_checklists_id, 
                        crplaza,
                        crtienda,
                        fecha_respuesta,
                        row.id, 
                        tipo_respuesta,
                        (row.res ? row.res : ""),
                        null, //row.resa,
                        null, //row.ata, 
                        valor_semana,
                        valor_mes,
                        year,
                        1,
                        usuario,
                        ip, 
                        timestamp, 
                        timestamp];
                    break;
                }

                //check if observacion is included
                if(row.obs) {
                    uuid_obs = uuidv4();
                    obs_array = [
                        uuid_obs,
                        uuid,
                        fecha_respuesta,
                        row.obs.desc,
                        row.obs.causa,
                        row.obs.accion,
                        row.obs.acresp,
                        row.obs.acfecha,
                        row.obs.ata,
                        row.obs.rpa,
                        row.obs.rep,
                        row.obs.alp,
                        row.obs.obs,
                        "",
                        row.obs.folio,
                        row.obs.turnom,
                        row.obs.turnot,
                        row.obs.turnon,
                        1,
                        usuario,
                        ip,
                        timestamp,
                        timestamp
                    ];
                    //if(!fill_obs) {
                    //    obs = [];
                    //    fill_obs=true;
                    //}
                    obs.push(obs_array);
                    resp_obs.push({"res":row.obs.eid, "obs":uuid_obs});//uuid
                }
                
                data.push(res);
            });
        }
        return [data, obs, resp_obs];
    }
}
