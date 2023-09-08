
const db = require("./../../../db");
bdoDates = require("./../../helpers/bdo-dates");
const util = require('util');
const dbg = false;
const moment= require('moment');

exports.matriz_tiendas = (req, res, next) => {
    if(dbg) console.log("[9] Start resumen calendario...");
    if(!db) {
        const error = new Error('Conexión a BD no encontrada!');
        error.status = 500;
        return next(error);
    }
    
    let crplaza = req.tokenData.crplaza;
    let crtienda = req.tokenData.crtienda;
    let fecha_token = req.tokenData.fecha;
    let checklist_id = req.tokenData.checklist;
    let tipo_cliente = req.body.cliente || null;
    let tipo_consulta = req.body.tipo || null;
    let consulta_checklist_id = req.body.chk || null;
    let fecha_consulta = req.fecha_consulta;
    let cr_plaza = req.reporte_cr_plaza;
    let tiendas = req.reporte_lista_tiendas;
    let request_continue = true;
    let error_message = "";
    let num_interval =  7; //days
    
    req.fecha_body = req.fecha_consulta;

    if(consulta_checklist_id) {
        req.fecha_body = req.checklist_fin;
    }

    req.fecha_antes = moment(req.fecha_body).subtract(7,'d').format('YYYY-MM-DD');

    if(!crplaza || !crtienda) {
        request_continue = false;
        error_message = "Información de token inválida.";
    }

    if(!["1", "2", "3"].includes(tipo_cliente)) {
        request_continue = false;
        error_message = "Tipo de cliente inválido.";
    }

    if(!["D", "S", "M"].includes(tipo_consulta)) {
        request_continue = false;
        error_message = "Tipo de reporte inválido.";
    }

    if(!cr_plaza || !tiendas) {
        request_continue = false;
        error_message = "Plaza y Lista de tiendas es requerido.";
    }
    
    if(request_continue) {
        isGreather = bdoDates.isDateGreatherThanCurrent(fecha_consulta);
      if(isGreather) {
        fecha_consulta = fecha_token;
      }

      let nombre_mes_consulta = 
            bdoDates.getBDOFormattedDate(
                fecha_consulta, 
                "es", 
                "MMMM",
                true
            );

        let year_mes_consulta = 
        bdoDates.getBDOFormattedDate(
            fecha_consulta, 
            "es", 
            "YYYY",
            true
        );

      [req_inicio, 
        req_fin,
        bitacora_dias, 
        bitacora_semanas, 
        bitacora_meses] = 
            bdoDates.getReportData(checklist_id,
                                    fecha_consulta, 
                                    tipo_consulta, 
                                    tipo_cliente, 
                                    num_interval);

        let catalogo = req.pevop_catalogo_semaforizacion_fallas;
        let color_default = 
            catalogo[Object.keys(catalogo)[Object.keys(catalogo).length-1]];

        resumen_data = getCalendarData(
            tiendas, 
            bitacora_dias, 
            nombre_mes_consulta, 
            year_mes_consulta, 
            color_default
        );

        if(resumen_data) {
            [resumen_headers, matriz_tiendas] = resumen_data;
            req.resumenbdo_fecha_inicio = req_inicio;
            req.resumenbdo_fecha_fin = req_fin;
            req.resumenbdo_headers = resumen_headers;
            req.resumenbdo_matriz_tiendas = matriz_tiendas;
            req.resumenbdo_plaza = cr_plaza;
            req.resumenbdo_tiendas = tiendas;

            next();
        } else {
            const error = 
            new Error("Parámetros para generar matriz de resumen semanal BDO son requeridos.");
            error.status = 400;
            return next(error);
        }
        
    } else {
        const error = new Error(error_message);
        error.status = 400;
        return next(error);
    }
};

function getCalendarData(tiendas, dias, resumen_mes, resumen_year, color_default) {
    if(tiendas && dias) {
        let matriz = {};
        let headers = {};
        let headers_info = {};
        let headers_data = [];

        tiendas.forEach(tienda => {
            if(!matriz[tienda]) {
                matriz[tienda] = {};
            }

            dias.forEach(dia => {
                dname = dia.dt;
                if(dbg) console.log("Fecha Calendario: ", dname);
                if(!headers_info[dname]) {
                    headers_info[dname] = dia.dt;
                    abbr_day = (dia.mt ? dia.mt.substring(0, 3) : dia.tl);
                    headers_data.push({
                        "yr":dia.yr,
                        "dt":dia.dt,
                        "mt":dia.mt,
                        "tl":abbr_day,
                        "dy":dia.st,
                        "sl":dia.sl,
                        "cr":dia.cr
                    });
                }

                if(!matriz[tienda][dia.dt]) {
                    matriz[tienda][dia.dt] = [];
                }

                matriz[tienda][dia.dt] = 
                    {
                        "nm": dia.dt,
                        "mt":dia.mt,
                        "sl": dia.sl,
                        "cr": dia.cr,
                        "tl": "-",
                        "clr":color_default
                    }
            });
        });

        headers = {
            "month":resumen_mes, 
            "yr":resumen_year,
            "days":headers_data
        };

        return [headers, matriz];
    }
    return;
}