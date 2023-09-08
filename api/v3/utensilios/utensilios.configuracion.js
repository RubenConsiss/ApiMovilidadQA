
const db = require("../../../db");
const dbg = false;

exports.configuracion = (req, res, next) => {
    if(dbg) console.log("[CR:8] Start utensilios configuracion ...");
    if(!db) {
        error = new Error('Conexion a BD no encontrada!');
        error.status=500;
        return next(error);
    }
    
    if (!req.tokenData.crplaza || !req.tokenData.crtienda) {
        error  = new Error('crplaza o crtienda invalidos!');
        error.status = 400;
        return next(error);
    }

    let cr_plaza = req.tokenData.crplaza;
    let cr_tienda = req.tokenData.crtienda;
    let fecha_token = req.tokenData.fecha;
    let entries = [
        cr_plaza, 
        cr_tienda, 
        fecha_token, 
        fecha_token, 
        fecha_token, 
        fecha_token, 
        fecha_token, 
        fecha_token
    ];

    let num_meses_vista_inicial_tablet_checklists_de_utensilios = null;
    let num_meses_vista_inicial_web_checklists_de_utensilios = null;

    stmt="SELECT ( \
            SELECT IF( \
                (SELECT COUNT(*) AS utensilios_nuevos_mes_actual \
                 FROM `xxbdo_utensilios` \
                 WHERE cr_plaza=? \
                 AND cr_tienda=? \
                 AND DATE(fecha_creacion) \
                 BETWEEN DATE_SUB(LAST_DAY(?), INTERVAL DAY(LAST_DAY(?))- 1 DAY) \
                 AND LAST_DAY(?)) >= `valor`, \
               0, \
               1) \
            FROM `xxbdo_configuracion` \
            WHERE `modulo`='utensilios' \
            AND `parametro`='num_maximo_utensilios_nuevos_permitidos_por_mes' \
            AND `es_visible`=1 \
            AND `activo`=1 \
            ) AS 'permitir_nuevo_utensilio_mes_actual', \
            ( \
             SELECT IF(? > DATE_SUB(DATE_ADD(DATE_SUB(LAST_DAY(?), \
                INTERVAL DAY(LAST_DAY(?)) - 1 DAY), \
                INTERVAL `valor` DAY), \
                INTERVAL 1 DAY), 0, 1) \
                FROM `xxbdo_configuracion` \
                WHERE modulo='utensilios' \
                AND parametro='dia_limite_mensual_para_envio_checklist_utensilios' \
            ) AS 'permitir_creacion_checklist_utensilios_del_mes_actual', \
            ( \
             SELECT `valor` \
             FROM `xxbdo_configuracion` \
             WHERE `modulo`='utensilios' \
             AND `parametro`='numero_meses_vista_inicial_tablet_checklist_utensilios' \
            ) AS 'num_meses_vista_inicial_tablet_checklists_de_utensilios', \
            ( \
                SELECT `valor` \
                FROM `xxbdo_configuracion` \
                WHERE `modulo`='utensilios' \
                AND `parametro`='numero_meses_vista_inicial_web_checklist_utensilios' \
               ) AS 'num_meses_vista_inicial_web_checklists_de_utensilios', \
            ( \
                SELECT `valor` \
                FROM `xxbdo_configuracion` \
                WHERE `modulo`='utensilios' \
                AND `parametro`='num_maximo_de_folios_por_utensilio' \
               ) AS num_maximo_de_folios_por_utensilio, \
               ( \
                SELECT `valor` \
                FROM `xxbdo_configuracion` \
                WHERE `modulo`='utensilios' \
                AND `parametro`='categoria_utensilios_varios' \
               ) AS categoria_utensilios_varios, \
               ( \
                SELECT `valor` \
                FROM `xxbdo_configuracion` \
                WHERE `modulo`='utensilios' \
                AND `parametro`='fecha_inicio_checklist_utensilios' \
               ) AS fecha_inicio_checklist_utensilios, \
               ( \
                SELECT `valor` \
                FROM `xxbdo_configuracion` \
                WHERE `modulo`='utensilios' \
                AND `parametro`='paleta_de_colores_hexadecimal' \
               ) AS paleta_de_colores_hexadecimal_utensilios";
    
    qry=db.query(stmt, entries, (err, rst) => {
        if(dbg) console.log("[27] Get configuracion de utensilios: ", qry.sql);
        if (err) {
            err.status=500;
            return next(err);
        }

        req.permitir_nuevo_utensilio_mes_actual = (rst[0].permitir_nuevo_utensilio_mes_actual ? true : false);
        req.permitir_creacion_checklist_utensilios_del_mes_actual = (rst[0].permitir_creacion_checklist_utensilios_del_mes_actual ? true : false);
        num_meses_vista_inicial_tablet_checklists_de_utensilios = rst[0].num_meses_vista_inicial_tablet_checklists_de_utensilios || 6;
        req.num_meses_vista_inicial_tablet_checklists_de_utensilios = num_meses_vista_inicial_tablet_checklists_de_utensilios;
        num_meses_vista_inicial_web_checklists_de_utensilios = rst[0].num_meses_vista_inicial_web_checklists_de_utensilios || 6;
        req.num_meses_vista_inicial_web_checklists_de_utensilios = num_meses_vista_inicial_web_checklists_de_utensilios;
        req.num_maximo_de_folios_por_utensilio = rst[0].num_maximo_de_folios_por_utensilio;
        req.categoria_utensilios_varios = rst[0].categoria_utensilios_varios;
        req.fecha_inicio_checklist_utensilios = rst[0].fecha_inicio_checklist_utensilios;
        req.paleta_de_colores_hexadecimal_utensilios = rst[0].paleta_de_colores_hexadecimal_utensilios;

        if(num_meses_vista_inicial_tablet_checklists_de_utensilios) {

            stmt="SELECT id, nombre FROM `xxbdo_roles_en_tienda` where visible=1 and activo=1 ORDER BY `xxbdo_roles_en_tienda`.`orden`";

            qry=db.query(stmt, null, (err, rows) => {
                if(dbg) console.log("[UCN:103] Get roles_en_tienda = ", qry.sql);
                if (err) {
                    err.status = 500;
                    return next(err);
                }
    
                utensilios_roles_en_tienda = formatResults(rows);
                req.utensilios_roles_en_tienda = utensilios_roles_en_tienda;
                next();
            });
        }
      });
};

function formatResults(rows) {
      if(rows) {
        let roles_en_tienda = [];
        if(rows.length>0) {
            let areas=[], nrow=0;
            rows.forEach(row => {
                roles_en_tienda.push(
                    {"id":row.id, "nm":row.nombre},
                );
            });
        }
        return roles_en_tienda;
      }
      return;
      }