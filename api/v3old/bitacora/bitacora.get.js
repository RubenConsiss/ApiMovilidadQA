
const app_configuration = require('config'),
      bdoDates = require("./../../helpers/bdo-dates"),
      azureSasToken = require("./../../helpers/azure-sas-tokens"),
      db = require("./../../../db"),
      util = require('util'),
      dbg = false;

exports.bitacora_get = (req, res, next) => {
    if(!db) {
      const error = new Error('Conexion a BD no encontrada!');
      error.status=500;
      return next(error);
    }
    
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        const error = new Error('crplaza o crtienda invalidos!');
        error.status=400;
        return next(error);
    }
    req.checkParams('tipo_cliente')
    .withMessage('Tipo de cliente invalido!')
    .matches(/^$|^[1-2|{1}]/)//1=handheld | 2=tablet
    .trim();
    req.checkParams('tipo_consulta')
    .matches(/^$|^[D|S|M]/)//D:Diario, S:Semanal, M:Mensual//{1}
    .withMessage('Tipo de consulta invalido!')
    .trim();
      
    var errors = req.validationErrors();
    if (errors) {
          console.log(util.inspect(errors, {depth: null}));
          const error = new Error('Valor de cliente o tipo de consulta invalida!');
          error.status=400;
          return next(error);
      }
    //
    let crplaza        = req.tokenData.crplaza,
        crtienda       = req.tokenData.crtienda,
        fecha_token    = req.tokenData.fecha,
        tipo_cliente   = req.params.tipo_cliente || null,
        tipo_consulta  = req.params.tipo_consulta || "D",
        valor          = req.params.valor || req.tokenData.fecha,
        year           = req.params.year || 
            bdoDates.getBDOFormat(req.tokenData.fecha, 'YYYY'),
        fecha_consulta = req.params.fecha_consulta || valor,
        num_interval   = 7, //days
        results        = null, 
        stmt           = null, 
        entries        = null,
        bitacora_columns='';
    //
    switch(tipo_consulta) {
        case "D"://Diario
            req.checkParams('valor')
            .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)
            .withMessage('Formato de fecha invalido!')
            .trim();
            errors = req.validationErrors();
            if (errors) {
                console.log(util.inspect(errors, {depth: null}));
                const error  = new Error('fecha de consulta invalida!');
                error.status = 400;
                return next(error);
            }
            //
            entries = [fecha_consulta,
                fecha_consulta,
                fecha_consulta,
                fecha_consulta,
                crplaza, 
                crtienda,
                tipo_consulta,
                fecha_consulta,
                fecha_consulta];
            //1=handheld, 2=tablet
            if(tipo_cliente=='2') {
                num_interval = 14; //show 14 days
            }
        break;
        case "S"://Semanal
            req.checkParams('valor')
            .withMessage('Numero de semana Invalido!')
            .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)//is valid date
            .trim();
            errors = req.validationErrors();
            if (errors) {
                const error  = new Error('Número de semana invalido!');
                error.status = 400;
                return next(error);
            }
            //
            //num_week = 
            //bdoDates.getBDOFormattedDate(
            //    valor, 
            //    "es", 
            //    "w",
            //    true
            //);
            //get year number from next date
            //next_date_year = bdoDates.getNextDate(valor, 'YYYY');
            //if(dbg)console.log("Next date year = "+next_date_year);
            //
            //date_year = 
            //    bdoDates.getBDOFormattedDate(
            //        valor, 
            //        "es", 
            //        "YYYY",
            //        true
            //    );
            //check week year number
            //year = (next_date_year>date_year ? next_date_year : date_year);
            //if(dbg)console.log("Num week = "+num_week+" , year = "+year);
            [num_week, year] = bdoDates.getWeekAndYearFromDate(valor);
            //
            var week_days_array = 
                bdoDates.formatWeekStartEndDays(num_week, year, tipo_cliente);
            fecha_consulta = week_days_array[3];//YYYY-MM-DD
            interval_name='WEEK';
            num_interval = 1; //for 2 weeks
            if(tipo_cliente=='2') {//tablet
                num_interval = 3; //for 4 weeks
            }
            group_by="GROUP BY YEARWEEK(bitacora.fecha_respuesta, 3) ";
            sql_columns="YEARWEEK(bitacora.`fecha_respuesta`,3) AS num_year_week, \
            WEEKOFYEAR('"+fecha_token+"') AS num_current_week, ";
            bitacora_columns ="num_year_week, num_current_week";
            fecha_inicial="STR_TO_DATE(CONCAT(num_year_week,' Monday'), '%x%v %W')";
        break;
        case "M"://Mensual
        req.checkParams('valor')
            .withMessage('Numero de mes Invalido!')
            .matches(/^$|^\d{4}[-]\d{2}[-]\d{2}$/)//is valid date
            .trim();
            errors = req.validationErrors();
            if(valor>12 || errors) {
                const error  = new Error('Valor de mes invalido!');
                error.status = 400;
                return next(error);
            }
            //
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
            if(dbg)console.log("Num month = "+num_month+" , year = "+year);
            var month_days_array = bdoDates.formatMonthStartEndDays(num_month, year, tipo_cliente);
            fecha_consulta = month_days_array[4];//YYYY-MM-DD
            interval_name='MONTH';
            num_interval = 2; //for 3 months
            if(tipo_cliente=='2') {//tablet
                num_interval = 5; //for 6 months
            }
            group_by="GROUP BY num_year, num_month";
            sql_columns="MONTH(bitacora.fecha_respuesta) AS num_month, \
            YEAR(bitacora.fecha_respuesta) AS num_year, \
            MONTH('"+fecha_token+"') AS num_current_month,";
            bitacora_columns="num_month, num_year, num_current_month";
            fecha_inicial = "CONCAT(num_year, '-', num_month, '-01')";
        break;
    }
    //
    switch(tipo_consulta) {
        case "D":
            // Comentario: Si en un dia no hay registros, se devuelve como total
            // de reactivos "null" el numero de estandares del checklist de ese día
            stmt = "SELECT cal.fecha_respuesta, \
            IF(?=cal.fecha_respuesta, 1, 0) is_current_day, \
            (CASE DAYOFWEEK(cal.fecha_respuesta) \
            WHEN 1 THEN 'Domingo' \
            WHEN 2 THEN 'Lunes' \
            WHEN 3 THEN 'Martes' \
            WHEN 4 THEN 'Miércoles' \
            WHEN 5 THEN 'Jueves' \
            WHEN 6 THEN 'Viernes' \
            WHEN 7 THEN 'Sábado' \
            END) AS `title`, \
            (CASE DAYOFWEEK(cal.fecha_respuesta) \
            WHEN 1 THEN 'D' \
            WHEN 2 THEN 'L' \
            WHEN 3 THEN 'M' \
            WHEN 4 THEN 'Mi' \
            WHEN 5 THEN 'J' \
            WHEN 6 THEN 'V' \
            WHEN 7 THEN 'S' \
            END) AS `abr`, \
            IFNULL(res.`ok`, NULL) AS ok, \
            IFNULL(res.`tienda`, NULL) AS tienda, \
            IFNULL(res.`plaza`, NULL) AS plaza, \
            IFNULL(res.`ambos`, NULL) AS ambos, \
            IFNULL(res.`vacios`, NULL) AS vacios, \
            IFNULL(res.`num_stds`, NULL) AS num_stds \
            FROM \
            ( \
            SELECT DATE_SUB( \
                    ?, \
                    INTERVAL c.number DAY) AS fecha_respuesta \
            FROM \
            ( \
                SELECT singles + tens + hundreds+thousands number FROM \
                ( \
                    SELECT 0 singles \
                    UNION ALL SELECT   1 UNION ALL SELECT   2 UNION ALL SELECT   3 \
                    UNION ALL SELECT   4 UNION ALL SELECT   5 UNION ALL SELECT   6 \
                    UNION ALL SELECT   7 UNION ALL SELECT   8 UNION ALL SELECT   9 \
                ) singles JOIN \
                ( \
                    SELECT 0 tens \
                    UNION ALL SELECT  10 UNION ALL SELECT  20 UNION ALL SELECT  30 \
                    UNION ALL SELECT  40 UNION ALL SELECT  50 UNION ALL SELECT  60 \
                    UNION ALL SELECT  70 UNION ALL SELECT  80 UNION ALL SELECT  90 \
                ) tens  JOIN \
                ( \
                    SELECT 0 hundreds \
                    UNION ALL SELECT  100 UNION ALL SELECT  200 UNION ALL SELECT  300 \
                    UNION ALL SELECT  400 UNION ALL SELECT  500 UNION ALL SELECT  600 \
                    UNION ALL SELECT  700 UNION ALL SELECT  800 UNION ALL SELECT  900 \
                ) hundreds \
                JOIN \
                ( \
                    SELECT 0 thousands \
                    UNION ALL SELECT  1000 UNION ALL SELECT  2000 UNION ALL SELECT  3000 \
                    UNION ALL SELECT  4000 UNION ALL SELECT  5000 UNION ALL SELECT  6000 \
                    UNION ALL SELECT  7000 UNION ALL SELECT  8000 UNION ALL SELECT  9000 \
                ) thousands \
                ORDER BY number DESC \
            ) c \
            WHERE c.number BETWEEN \
            0 \
            AND \
            DATEDIFF( \
                ?,\
                DATE_SUB(?, INTERVAL "+num_interval+" DAY) \
            ) \
            ) AS cal \
            LEFT JOIN( \
                SELECT `fecha_respuesta`, \
                COUNT(CASE WHEN respuesta='K' THEN respuesta END) AS `ok`, \
                COUNT(CASE WHEN respuesta='T' THEN respuesta END) AS `tienda`, \
                COUNT(CASE WHEN respuesta='P' THEN respuesta END) AS `plaza`, \
                COUNT(CASE WHEN respuesta='A' THEN respuesta END) AS `ambos`, \
                COUNT(CASE WHEN respuesta='' OR respuesta IS NULL THEN 1 END) AS `vacios`, \
                '0' AS num_stds \
                FROM `xxbdo_respuestas` WHERE `cr_plaza`=? \
                AND `cr_tienda`=? \
                AND `tipo`=? \
                AND fecha_respuesta \
                BETWEEN DATE_SUB(?, INTERVAL "+num_interval+" DAY) \
                AND ? \
                GROUP BY fecha_respuesta \
            ) AS res \
            USING(fecha_respuesta) \
            ORDER BY 1 ASC";
            // query to include num of stds by daily checklist
            stmt = "SELECT `fecha_respuesta`, \
            `is_current_day`, \
            `title`, \
            `abr`, \
            `ok`, \
            `tienda`, \
            `plaza`, \
            `ambos`, \
            `vacios`, \
            (SELECT COUNT(*) AS num_stds \
            FROM `xxbdo_areas_estandares`, \
            `xxbdo_areas` \
            WHERE `xxbdo_areas_estandares`.`id` \
            IN (SELECT `xxbdo_areas_estandares_id` \
                FROM `xxbdo_tiendas_has_areas_estandares` \
                WHERE `xxbdo_tiendas_has_areas_estandares`.`cr_plaza`='"+crplaza+"' \
                AND `xxbdo_tiendas_has_areas_estandares`.`cr_tienda`='"+crtienda+"' \
                AND `xxbdo_checklists_id`= \
                ( \
                SELECT `id` \
                FROM `xxbdo_checklists` \
                WHERE `fecha_respuesta` \
                BETWEEN `fecha_inicio` \
                AND IFNULL(`fecha_fin`, '"+fecha_token+"') \
                AND `es_visible`=1 \
                AND `activo`=1 \
                LIMIT 1) \
                ) \
                AND `xxbdo_areas_estandares`.`xxbdo_areas_id` = `xxbdo_areas`.`id` \
                AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
                IN (SELECT `xxbdo_areas_grupos`.`id` \
                    FROM `xxbdo_areas_grupos` \
                    WHERE `tipo`='"+tipo_consulta+"'\
                    AND activo=1 \
                ) \
            ) AS num_stds \
            FROM ("+stmt+") bitacora";
        break;
        case "S":
        case "M":
        entries = [
            fecha_consulta,
            fecha_consulta,
            fecha_consulta,
            num_interval,
            crplaza,
            crtienda,
            tipo_consulta,
            fecha_consulta,
            num_interval,
            fecha_consulta
        ];
        stmt = "SELECT YEAR('"+fecha_token+"') AS num_current_year, \
        "+sql_columns+" \
        IFNULL(SUM(bitacora.`lider_ok`), NULL) AS ok, \
        IFNULL(SUM(bitacora.`lider_tienda`), NULL) AS tienda, \
        IFNULL(SUM(bitacora.`lider_plaza`), NULL) AS plaza, \
        IFNULL(SUM(bitacora.`lider_ambos`), NULL) AS ambos, \
        IFNULL(SUM(bitacora.`lider_vacios`), NULL) AS vacios \
        FROM (\
        SELECT cal.fecha_respuesta, \
            IFNULL(res.`lider_ok`, NULL) AS lider_ok, \
            IFNULL(res.`lider_tienda`, NULL) AS lider_tienda, \
            IFNULL(res.`lider_plaza`, NULL) AS lider_plaza, \
            IFNULL(res.`lider_ambos`, NULL) AS lider_ambos, \
            IFNULL(res.`lider_vacios`, NULL) AS lider_vacios \
            FROM \
            ( \
            SELECT DATE_SUB( \
                    ?, \
                    INTERVAL c.number DAY) AS fecha_respuesta \
            FROM \
            ( \
                SELECT singles + tens + hundreds+thousands number FROM \
                ( \
                    SELECT 0 singles \
                    UNION ALL SELECT   1 UNION ALL SELECT   2 UNION ALL SELECT   3 \
                    UNION ALL SELECT   4 UNION ALL SELECT   5 UNION ALL SELECT   6 \
                    UNION ALL SELECT   7 UNION ALL SELECT   8 UNION ALL SELECT   9 \
                ) singles JOIN \
                ( \
                    SELECT 0 tens \
                    UNION ALL SELECT  10 UNION ALL SELECT  20 UNION ALL SELECT  30 \
                    UNION ALL SELECT  40 UNION ALL SELECT  50 UNION ALL SELECT  60 \
                    UNION ALL SELECT  70 UNION ALL SELECT  80 UNION ALL SELECT  90 \
                ) tens  JOIN \
                ( \
                    SELECT 0 hundreds \
                    UNION ALL SELECT  100 UNION ALL SELECT  200 UNION ALL SELECT  300 \
                    UNION ALL SELECT  400 UNION ALL SELECT  500 UNION ALL SELECT  600 \
                    UNION ALL SELECT  700 UNION ALL SELECT  800 UNION ALL SELECT  900 \
                ) hundreds \
                 JOIN \
                ( \
                    SELECT 0 thousands \
                    UNION ALL SELECT  1000 UNION ALL SELECT  2000 UNION ALL SELECT  3000 \
                    UNION ALL SELECT  4000 UNION ALL SELECT  5000 UNION ALL SELECT  6000 \
                    UNION ALL SELECT  7000 UNION ALL SELECT  8000 UNION ALL SELECT  9000 \
                ) thousands \
                ORDER BY number DESC \
            ) c \
            WHERE c.number BETWEEN \
            0 \
            AND \
            DATEDIFF( \
                ?,\
                DATE_SUB(?, INTERVAL ? "+interval_name+") \
            ) \
            ) AS cal \
            LEFT JOIN( \
                SELECT `fecha_respuesta`, \
                COUNT(CASE WHEN respuesta='K' THEN respuesta END) AS `lider_ok`, \
                COUNT(CASE WHEN respuesta='T' THEN respuesta END) AS `lider_tienda`, \
                COUNT(CASE WHEN respuesta='P' THEN respuesta END) AS `lider_plaza`, \
                COUNT(CASE WHEN respuesta='A' THEN respuesta END) AS `lider_ambos`, \
                COUNT(CASE WHEN respuesta='' OR respuesta IS NULL THEN 1 END) AS `lider_vacios` \
                FROM `xxbdo_respuestas` WHERE `cr_plaza`=? \
                AND `cr_tienda`=? \
                AND `tipo`=? \
                AND fecha_respuesta \
                BETWEEN DATE_SUB(?, INTERVAL ? "+interval_name+") \
                AND ? \
                GROUP BY fecha_respuesta \
            ) AS res \
            USING(fecha_respuesta) \
        ) AS bitacora \
        "+group_by;
        //query to include number of stds by weekly/monthly checklist
        stmt = "SELECT num_current_year,\
        "+bitacora_columns+",\
        `ok`,\
        `tienda`,\
        `plaza`,\
        `ambos`,\
        `vacios`,\
        (SELECT COUNT(*) AS num_stds \
            FROM `xxbdo_areas_estandares`,`xxbdo_areas` \
            WHERE `xxbdo_areas_estandares`.`id` \
            IN (SELECT `xxbdo_areas_estandares_id` \
            FROM `xxbdo_tiendas_has_areas_estandares` \
            WHERE `xxbdo_tiendas_has_areas_estandares`.`cr_plaza`='"+crplaza+"' \
            AND `xxbdo_tiendas_has_areas_estandares`.`cr_tienda`='"+crtienda+"' \
            AND `xxbdo_checklists_id`= \
            ( \
                SELECT `id` \
                FROM `xxbdo_checklists` \
                WHERE "+fecha_inicial+" \
                BETWEEN `fecha_inicio` \
                AND IFNULL(`fecha_fin`, '"+fecha_token+"') \
                AND `es_visible`=1 \
                AND `activo`=1 \
                LIMIT 1) \
            ) \
            AND `xxbdo_areas_estandares`.`xxbdo_areas_id` = `xxbdo_areas`.`id` \
            AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
            IN (SELECT `xxbdo_areas_grupos`.`id` \
            FROM `xxbdo_areas_grupos` \
            WHERE `tipo`='"+tipo_consulta+"') \
            ) AS num_stds \
        FROM ("+stmt+") bitacora";
        break;
    }
    //
    qry=db.query(stmt, entries, (err, result) => {
        if(dbg) console.log(qry.sql);
        if (err) {
            err.status=500;
            return next(err);
        }
        results = formatBitacora(tipo_consulta, tipo_cliente, result);
        if(!results) {
            const error = new Error('No hay bitacora!');
            error.status=400;
            return next(error);
        }
        res.body = results;
        if(dbg) 
            console.log("["+req.app_request_id+
            "] Response: "+
            JSON.stringify(results));
        res.status(200).json(results);
    });
};
    
    function formatBitacora(tipo_consulta, tipo_cliente, rows) {
    if(rows) {
      let bitacora = null;
      if(rows.length>0) {
        let bitacora_dates = [], 
        prev_week_day  = null,
        nrow           = 0, 
        total          = null;
        var year_week = null,
        num_year = null,
        num_week = null,
        vacios = 0;

          rows.forEach(row => {
            switch(tipo_consulta) {
                case "D"://Diario
                    if(nrow>0) {
                        total = row.ok     + 
                                row.tienda + 
                                row.plaza  + 
                                row.ambos  + 
                                row.vacios;
                        vacios =  row.num_stds - (total ? total : 0);
                        yr = bdoDates.getBDOFormat(row.fecha_respuesta, 'YYYY');
                        sin_responder = (row.vacios ? row.vacios : 0);
                        bitacora_dates.push({
                        "yr":yr,
                        "nm":row.fecha_respuesta,//dt
                        "cr":(row.is_current_day ? true : false),//cd
                        "mt":row.title, //nm
                        "st":row.abr, //ab
                        //"sd":null,
                        //"ed":null,
                        "tc":(total ? total : 0),
                        "k":(row.ok ? row.ok : 0),
                        "t":(row.tienda ? row.tienda: 0),
                        "p":(row.plaza ? row.plaza : 0),
                        "a":(row.ambos ? row.ambos:0),
                        "v":(vacios ? vacios : sin_responder),
                        "e":row.num_stds
                        });
                    } else {
                        prev_week_day = row.fecha_respuesta;
                    }
                break;
                case "S"://Semanal
                    year_week = ""+row.num_year_week;
                    num_year  = year_week.substr(0, 4) * 1;
                    num_week  = year_week.substr(4, 2) * 1;
                    week_days_array = 
                        bdoDates.formatWeekStartEndDays(num_week, num_year, tipo_cliente);
                    total = row.ok + 
                    row.tienda + 
                    row.plaza  + 
                    row.ambos  + 
                    row.vacios;
                    vacios =  row.num_stds - (total ? total : 0);
                    sin_responder = (row.vacios ? row.vacios : 0);
                    is_current = ((nrow+1)>=rows.length ? true : false);
                    bitacora_dates.push({
                    "yr":num_year,
                    "nm":num_week,
                    //"cr":(num_year==row.num_current_year && num_week==row.num_current_week ? true : false),
                    "cr":is_current,
                    "mt":week_days_array[0], //main title, ex.: SEMANA 5
                    "st":week_days_array[1], //sub title, ex.: 29 ENERO-4 FEBRERO
                    "sd":week_days_array[2], //week start date, ex.: 2018-01-29
                    "ed":week_days_array[3], //week end date, ex.: 2018-02-04
                    "tc":(total ? total : 0),
                    "k":(row.ok ? row.ok : 0),
                    "t":(row.tienda ? row.tienda : 0),
                    "p":(row.plaza ? row.plaza : 0),
                    "a":(row.ambos ? row.ambos : 0),
                    "v":(vacios ? vacios : sin_responder),
                    "e":row.num_stds
                    });
                break;
                case "M"://Mensual
                    //[ '2', '2018', 'FEBRERO', '2018-02-01', '2018-02-28' ]
                    var month_days_array = 
                        bdoDates.formatMonthStartEndDays(row.num_month, row.num_year, tipo_cliente);
                    total = row.ok + 
                    row.tienda + 
                    row.plaza  + 
                    row.ambos  + 
                    row.vacios;
                    vacios =  row.num_stds - (total ? total : 0);
                    sin_responder = (row.vacios ? row.vacios : 0);
                    is_current = ((nrow+1)>=rows.length ? true : false);
                    bitacora_dates.push({
                    "yr":row.num_year,
                    "nm":row.num_month,
                    //"cr":((row.num_year==row.num_current_year && row.num_month==row.num_current_month) ? true : false),
                    "cr":is_current,
                    "mt":month_days_array[2], //main title, ex.: FEBRERO
                    //"st":null,
                    "sd":month_days_array[3], //month first day
                    "ed":month_days_array[4], //month last day
                    "tc":(total ? total : 0),
                    "k":(row.ok ? row.ok : 0),
                    "t":(row.tienda ? row.tienda : 0),
                    "p":(row.plaza ? row.plaza : 0),
                    "a":(row.ambos ? row.ambos : 0),
                    "v":(vacios ? vacios : sin_responder),
                    "e":row.num_stds
                    });
                break;
            }
              nrow++;
          });
          //
          bitacora = {
            //"pd":prev_week_day, //for tipo=D only
            "data":bitacora_dates //fechas
        };
      }
      return bitacora;
    }
    return;
    }

    exports.bitacora_get_detalles = (req, res, next) => {
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
        let consulta_respuesta = "'T','P','A','K',''",
            tipo_respuesta = req.params.tipo_respuesta || null,
            tipo_consulta  = req.params.tipo_consulta || null,
        valor         = req.params.valor || null,
        year           = req.params.year || 
            bdoDates.getBDOFormat(req.tokenData.fecha, 'YYYY'),
        fecha_consulta = req.params.fecha_consulta || valor,
        validation_errors = false,
        crplaza           = req.tokenData.crplaza,
        crtienda          = req.tokenData.crtienda,
        formattedDate     = null, 
        formattedDateName = null, 
        stmt              = null, 
        entries           = null,
        results           = null,
        sql_search        = null,
        existe            = false,
        num_week          = null,
        num_month         = null;
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
            break;
            case "S":
            //check if valor es mayor que la fecha actual
            if(bdoDates.isDateGreatherThanCurrent(valor)) {
                fecha_consulta = valor = bdoDates.getBDOCurrentDate();
            }
            //num_week = 
            //    bdoDates.getBDOFormattedDate(
            //        valor, 
            //        "es", 
            //        "w",
            //        true
            //    );
                //
            //    year = 
            //    bdoDates.getBDOFormattedDate(
            //        valor, 
            //        "es", 
            //        "YYYY",
            //        true
            //    );
            [num_week, year] = bdoDates.getWeekAndYearFromDate(valor);
            if(dbg)console.log("Num week = "+num_week+" , year = "+year);
            entries   = [crplaza, crtienda, tipo_consulta, num_week, year];
            break;
            case "M":
            //check if valor es mayor que la fecha actual
            if(bdoDates.isDateGreatherThanCurrent(valor)) {
                fecha_consulta = valor = bdoDates.getBDOCurrentDate();
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
            if(dbg)console.log("Num month = "+num_month+" , year = "+year);
            entries   = [crplaza, crtienda, tipo_consulta, num_month, year];
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
            if(dbg) console.log("[1202] "+qry.sql);
        if (err) {
             err.status = 500;
             return next(err);
         }
         //
         if(result[0].respuestas>0) {
            if(dbg) console.log("[1209] answers already exists, get from xxbdo_respuestas "+result[0].respuestas);
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
            `xxbdo_checklists`.`titulo` AS `version`, \
            `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
            `xxbdo_areas`.`titulo` AS `area_titulo`, \
            `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
            `xxbdo_estandares`.`estandar` AS `estandar`, \
            `xxbdo_estandares`.`titulo` AS `std_titulo`, \
            IFNULL(`xxbdo_estandares`.`detalle`,'') AS `detalle`, \
            `xxbdo_respuestas`.`respuesta`, \
            `xxbdo_respuestas`.`valor_ata`, \
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
            `xxbdo_observaciones`.`foto`, \
            `xxbdo_observaciones`.`folio` AS `folio`, \
            `xxbdo_observaciones`.`turno_mañana`, \
            `xxbdo_observaciones`.`turno_tarde`, \
            `xxbdo_observaciones`.`turno_noche`, \
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
            WHERE `xxbdo_respuestas`.`cr_plaza`=? \
            AND `xxbdo_respuestas`.`cr_tienda`=? \
            AND `xxbdo_respuestas`.`tipo`=? "+sql_search+"\
            AND `xxbdo_areas_estandares`.`id`=`xxbdo_respuestas`.`xxbdo_areas_estandares_id` \
            AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id` \
            AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id` \
            AND `xxbdo_checklists`.`id`=`xxbdo_respuestas`.`xxbdo_checklists_id` \
            AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
            AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id` \
            ORDER BY `xxbdo_respuestas`.`respuesta`, \
            `xxbdo_areas`.`orden`, \
            `xxbdo_areas_estandares`.`orden`";
            //AND `xxbdo_respuestas`.`respuesta` IN ("+consulta_respuesta+") \
         } else {
             if(dbg) console.log("[1383] answers does not exists, get assigned checklist");
             switch(tipo_consulta) {
                case 'D'://Diario
                    tipo_condition = " AND `xxbdo_areas`.`xxbdo_areas_grupos_id` \
                    IN (SELECT `xxbdo_areas_grupos`.`id` \
                    FROM `xxbdo_areas_grupos` \
                    WHERE `tipo`='"+tipo_consulta+"')";
                //
                sql_stds_libres="SELECT `xxbdo_areas_estandares`.`id` AS `id`, \
                `xxbdo_checklists`.`titulo` AS `version`, \
                `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
                `xxbdo_areas`.`titulo` AS `area_titulo`, \
                `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
                `xxbdo_estandares`.`estandar` AS `estandar`, \
                `xxbdo_estandares`.`titulo` AS `std_titulo`, \
                `xxbdo_estandares`.`detalle`, \
                '' AS `respuesta`, \
                '' AS `valor_ata`, \
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
                '' AS `foto`, \
                '' AS `folio`, \
                '' AS `turno_mañana`, \
                '' AS `turno_tarde`, \
                '' AS `turno_noche`, \
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
                `xxbdo_checklists`.`titulo` AS `version`, \
                `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
                `xxbdo_areas`.`titulo` AS `area_titulo`, \
                `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
                `xxbdo_estandares`.`estandar` AS `estandar`, \
                `xxbdo_estandares`.`titulo` AS `std_titulo`, \
                `xxbdo_estandares`.`detalle`, \
                '' AS `respuesta`, \
                '' AS `valor_ata`, \
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
                '' AS `foto`, \
                '' AS `folio`, \
                '' AS `turno_mañana`, \
                '' AS `turno_tarde`, \
                '' AS `turno_noche`, \
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
                `xxbdo_checklists`.`titulo` AS `version`, \
                `xxbdo_areas_estandares`.`xxbdo_areas_id`, \
                `xxbdo_areas`.`titulo` AS `area_titulo`, \
                `xxbdo_areas_estandares`.`xxbdo_estandares_id`, \
                `xxbdo_estandares`.`estandar` AS `estandar`, \
                `xxbdo_estandares`.`titulo` AS `std_titulo`, \
                IFNULL(`xxbdo_estandares`.`detalle`,'') AS `detalle`, \
                '' AS `respuesta`, \
                '' AS `valor_ata`, \
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
                '' AS `foto`, \
                '' AS `folio`, \
                '' AS `turno_mañana`, \
                '' AS `turno_tarde`, \
                '' AS `turno_noche`, \
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
            if(dbg) console.log("[1581] "+qry.sql);
            if (err) {
                err.status = 500;
                return next(err);
            }
            //
            results = formatRegistros(
                existe,
                resultB, 
                tipo_consulta, 
                valor
            );
            //
            if(!results) {
                const error = new Error('No hay Registros de bitacora!');
                error.status = 400;
                return next(error);
            }
            if(dbg)
                console.log("["+req.app_request_id+
                "] Response: "+
                JSON.stringify(results));
            res.status(200).json(results);
        });
        });
    }
        
    function formatRegistros(existe, rows, tipo_consulta, fecha) {
        if(rows) {
            if(rows.length>0) {
                let orden_respuestas        = ['K', 'T', 'P', 'A', ''], 
                    registros_por_respuesta = [],
                    areas_v     = [],
                    registros_v = [],
                    total_v     = 0,
                    areas_t     = [],
                    registros_t = [],
                    total_t     = 0,
                    areas_p     = [],
                    registros_p = [],
                    total_p     = 0,
                    areas_a     = [],
                    registros_a = [],
                    total_a     = 0,
                    areas_k     = [],
                    registros_k = [],
                    total_k     = 0,
                    total_va    = 0,
                    total_dia   = 0,
                    bitacora    = [],
                    observacion = null, 
                    uri         = null;

            rows.forEach(row => {
                observacion = null;
                //
                if(row.xxbdo_observaciones_id) {
                    if(row.foto) {
                        //get foro url from azure storage service
                        token = 
                            azureSasToken.generateSasToken(
                                app_configuration.
                                    get('azure.sas.blob.containers.observaciones.name'), 
                                row.foto, 
                                app_configuration.
                                    get('azure.sas.blob.containers.observaciones.sharedAccessPolicy')
                            );
                        
                        if(!token) {
                            uri = "";
                        } else {
                            uri = token.uri;
                        }
                    }

                    observacion = {
                        "id":row.xxbdo_observaciones_id,
                        "desc":row.descripcion,
                        "uri":uri,
                        "folio":row.folio,
                        "turnom":(row.turno_mañana ? true : false),
                        "turnot":(row.turno_tarde ? true : false),
                        "turnon":(row.turno_noche ? true : false),
                        "causa":row.causa,
                        "accion":row.accion,
                        "acresp":row.accion_responsable,
                        "acfecha":row.accion_fecha,
                        "ata":(row.requiere_ajuste_ata ? true : (row.requiere_ajuste_ata==0 ? false : null)),
                        "rpa":(row.realizaron_plan_accion ? true : (row.realizaron_plan_accion==0 ? false : null)),
                        "rep":(row.resolvio_problema ? true : (row.resolvio_problema==0 ? false : null)),
                        "obs":row.observacion
                    };
                    uri="";
            }

                switch(row.respuesta) {
                    case "":
                    if(!areas_v.includes(row.xxbdo_areas_id)) {
                        areas_v.push(row.xxbdo_areas_id);
                        registros_v.push(
                            {
                                "area":row.area_titulo,
                                "estandares":[]
                            }
                        );
                        }
                        //
                        aindx = areas_v.indexOf(row.xxbdo_areas_id);
                        registros_v[aindx].estandares.push({
                            "id":row.id,
                            "eid":row.xxbdo_estandares_id,
                            "std":row.estandar,
                            "titulo":row.std_titulo,
                            "det":row.detalle,
                            "res":(row.respuesta ? row.respuesta: ""),
                            "obs":observacion
                        });
                        total_v++;
                    break;
                    case "T":
                    if(!areas_t.includes(row.xxbdo_areas_id)) {
                        areas_t.push(row.xxbdo_areas_id);
                        registros_t.push(
                            {
                                "area":row.area_titulo,
                                "estandares":[]
                            }
                        );
                        }
                        //
                        aindx = areas_t.indexOf(row.xxbdo_areas_id);
                        registros_t[aindx].estandares.push({
                            "id":row.id,
                            "eid":row.xxbdo_estandares_id,
                            "std":row.estandar,
                            "titulo":row.std_titulo,
                            "det":row.detalle,
                            "res":row.respuesta,
                            "obs":observacion
                        });
                        total_t++;
                    break;
                    case "P":
                    if(!areas_p.includes(row.xxbdo_areas_id)) {
                        areas_p.push(row.xxbdo_areas_id);
                        registros_p.push(
                            {
                            "area":row.area_titulo, 
                            "estandares":[]
                            }
                        );
                    }
                    //
                    aindx = areas_p.indexOf(row.xxbdo_areas_id);
                    registros_p[aindx].estandares.push({
                        "id":row.id,
                        "eid":row.xxbdo_estandares_id,
                        "std":row.estandar,
                        "titulo":row.std_titulo,
                        "det":row.detalle,
                        "res":row.respuesta,
                        "obs":observacion
                    });
                    total_p++;
                    break;
                    case "A":
                    if(!areas_a.includes(row.xxbdo_areas_id)) {
                        areas_a.push(row.xxbdo_areas_id);
                        registros_a.push(
                            {
                            "area":row.area_titulo, 
                            "estandares":[]
                            }
                        );
                    }
                    //
                    aindx = areas_a.indexOf(row.xxbdo_areas_id);
                    registros_a[aindx].estandares.push({
                        "id":row.id,
                        "eid":row.xxbdo_estandares_id,
                        "std":row.estandar,
                        "titulo":row.std_titulo,
                        "det":row.detalle,
                        "res":row.respuesta,
                        "obs":observacion
                    });
                    total_a++;
                    break;
                    case "K":
                    if(!areas_k.includes(row.xxbdo_areas_id)) {
                        areas_k.push(row.xxbdo_areas_id);
                        registros_k.push(
                            {
                            "area":row.area_titulo, 
                            "estandares":[]
                            }
                        );
                    }
                    //
                    aindx = areas_k.indexOf(row.xxbdo_areas_id);
                    registros_k[aindx].estandares.push({
                        "id":row.id,
                        "eid":row.xxbdo_estandares_id,
                        "std":row.estandar,
                        "titulo":row.std_titulo,
                        "det":row.detalle,
                        "res":row.respuesta,
                        "obs":observacion
                    });
                    total_k++;
                    break;
                    default:
                    total_va++;
                }
                total_dia++;// = row.total;
                });
                //Generate bitacora array
                orden_respuestas.forEach(respuesta => {
                    switch(respuesta) {
                        case "":
                        if(registros_v.length>0) {
                            registros_por_respuesta.push(
                                {
                                    "respuesta":"",
                                    "total":total_v,
                                    "registros":registros_v
                                }
                            );
                        }
                        break;
                        case "T":
                        if(registros_t.length>0) {
                            registros_por_respuesta.push(
                                {
                                    "respuesta":respuesta,
                                    "total":total_t,
                                    "registros":registros_t
                                }
                            );
                        }
                        break;
                        case "P":
                        if(registros_p.length>0) {
                            registros_por_respuesta.push(
                                {
                                    "respuesta":respuesta,
                                    "total":total_p,
                                    "registros":registros_p
                                }
                            );
                        }
                        break;
                        case "A":
                        if(registros_a.length>0) {
                            registros_por_respuesta.push(
                                {
                                    "respuesta":respuesta,
                                    "total":total_a,
                                    "registros":registros_a
                                }
                            );
                        }
                        break;
                        case "K":
                        if(registros_k.length>0) {
                            registros_por_respuesta.push(
                                {
                                    "respuesta":respuesta,
                                    "total":total_k,
                                    "registros":registros_k
                                }
                            );
                        }
                        break;
                    }
                });
                //
                year = 
                bdoDates.getBDOFormattedDate(
                    fecha, 
                    "es", 
                    "YYYY",
                    true
                );
                //
                switch(tipo_consulta) {
                    case "D":
                    formattedDateName = 
                        bdoDates.getBDOFormattedDate(
                            fecha, 
                            "es", 
                            "dddd",
                            true
                        );
                        formattedDate = 
                        bdoDates.getBDOFormattedDate(
                            fecha, 
                            "es", 
                            "D [de] MMMM [de] YYYY",//dddd 
                            true
                        );
                        formattedDateName = 
                        bdoDates.getBDOFormattedDate(
                            fecha, 
                            "es", 
                            "dddd",
                            true
                        );
                        bitacora = {
                            "año":year,
                            "titulo":formattedDateName,//formattedDate,
                            "sbtl":formattedDate,//fecha,
                            "total":total_dia,
                            "existe":existe,
                            "bitacora":registros_por_respuesta
                        };
                    break;
                    case "S":
                    //num_week = 
                    //bdoDates.getBDOFormattedDate(
                    //    fecha, 
                    //    "es", 
                    //    "w",
                    //    true
                    //);
                    [num_week, year] = bdoDates.getWeekAndYearFromDate(fecha);
                    week_days_array = bdoDates.formatWeekStartEndDays(num_week, year);
                    bitacora = {
                        "año":year,
                        "titulo":week_days_array[0],
                        "sbtl":week_days_array[1],
                        total:total_dia,
                        "existe":existe,
                        "bitacora":registros_por_respuesta
                    };
                    break;
                    case "M":
                    num_month = 
                    bdoDates.getBDOFormattedDate(
                        fecha, 
                        "es", 
                        "M",
                        true
                    );
                    var month_days_array = bdoDates.formatMonthStartEndDays(num_month, year);
                    bitacora = {
                        "año":year,
                        "titulo":year,//month_days_array[2],
                        "sbtl":month_days_array[2],//"",
                        "total":total_dia,
                        "existe":existe,
                        "bitacora":registros_por_respuesta
                    };
                    break;
                }
                //
                return bitacora;
            }
        }
        return;
    }

    function formatValorATA(ata) {
        if(ata) {
            let title_ata = '';
            switch(ata) {
                case "1": 
                    title_ata = "Tarea NO asignada";
                break;
                case "2":
                    title_ata="Tarea Asignada pero NO realizada";
                break;
                case "3":
                    title_ata="Frecuencia incorrecta";
                break;
                case "4":
                    title_ata="No aplica";
                break;
                default:
                    title_ata="";
            }
            return title_ata;
        }
        return "";
    }

//reference mysql build calendar dates:
//https://dba.stackexchange.com/questions/97773/get-all-dates-in-the-current-month
