
const db = require("./../../../db");
bdoDates = require("./../../helpers/bdo-dates");
const dbg = false;

exports.resumenbdo_post = (req, res, next) => {
    if(dbg) console.log("[7] Start resumenbdo_post...");
    if(!db) {
        const error = new Error('Conexión a BD no encontrada!');
        error.status = 500;
        return next(error);
    }
    
    let crplaza = req.tokenData.crplaza;
    let crtienda = req.tokenData.crtienda;
    let fecha_token = req.tokenData.fecha;
    let tipo_cliente = req.body.cliente || null;
    let tipo_consulta = req.body.tipo || null;
    let fecha_consulta = req.body.fecha || 
                         bdoDates.getBDOFormat(fecha_token, 'YYYY-MM-DD');
    let fecha_actual = bdoDates.getBDOFormat(fecha_token, 'YYYY-MM-DD');
    let request_continue = true;
    let error_message = "";

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
    
    if(request_continue) {
        isGreather = bdoDates.isDateGreatherThanCurrent(fecha_consulta);
      if(isGreather) {
        fecha_consulta = fecha_token;
      }
        
        rst = {
            "tipo": tipo_consulta,
            "checklist_id": req.checklist_id,
            "checklist_ini": req.checklist_inicio,
            "checklist_fin":req.checklist_fin,
            "crplaza": req.reporte_cr_plaza,
            "fi": req.resumenbdo_fecha_inicio,
            "ff": req.resumenbdo_fecha_fin,
            "fs": fecha_consulta,
            "fc": fecha_actual,
            "chks":req.checklists_data,
            "hdrs": req.resumenbdo_headers,
            "tiendas":req.arreFinal
        };
                                    
        res.status(200).json(rst);

    } else {
        const error  = 
            new Error(error_message);
        error.status = 400;
        return next(error);
    }
};