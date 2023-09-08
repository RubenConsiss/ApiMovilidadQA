
const db = require("./../../../db");

//const util = require('util');

exports.observaciones_get = (req, res, next) => {
if(!db) {
  const error = new Error('Conexion a BD no encontrada!');
  error.status=500;
  return next(error);
}
//
 req.checkParams('ofecha')
 .matches(/^\d{4}[-]\d{2}[-]\d{2}$/)
 .withMessage('Formato de fecha invalido!')
 .trim();

const errors = req.validationErrors();
if (errors || !req.tokenData.crplaza || !req.tokenData.crtienda) {
    //console.log(util.inspect(errors, {depth: null}));
    const error = new Error('crplaza o crtienda invalidos!');
    error.status=400;
    return next(error);
}
//
let crplaza = req.tokenData.crplaza,
    crtienda = req.tokenData.crtienda,
    fecha_respuesta = req.params.ofecha;
//
let results = null,
entries=[crplaza, crtienda, fecha_respuesta],
stmt = "SELECT `xxbdo_observaciones`.`id` AS `id`, \
`xxbdo_version_estandares`.`version`, \
`xxbdo_areas_estandares`.`areas_id`, \
`xxbdo_areas`.`titulo` AS `area_titulo`, \
`xxbdo_areas_estandares`.`estandares_id`, \
`xxbdo_estandares`.`estandar` AS `estandar`, \
`xxbdo_estandares`.`titulo` AS `std_titulo`, \
`xxbdo_estandares`.`detalle`, \
`xxbdo_observaciones`.`descripcion` AS `comentario`, \
`xxbdo_observaciones`.`foto` AS `foto`, \
`xxbdo_observaciones`.`folio` AS `folio`, \
`xxbdo_observaciones`.`turno` AS `turno`, \
`xxbdo_respuestas`.`respuesta` \
FROM `xxbdo_respuestas`, \
`xxbdo_observaciones`, \
`xxbdo_areas_estandares`, \
`xxbdo_estandares`, \
`xxbdo_areas`, `xxbdo_version_estandares` \
WHERE `xxbdo_respuestas`.`cr_plaza`=? \
AND `xxbdo_respuestas`.`cr_tienda`=? \
AND `xxbdo_respuestas`.`fecha_respuesta`=? \
AND `xxbdo_observaciones`.`bdo_id`=`xxbdo_respuestas`.`id` \
AND `xxbdo_respuestas`.`respuesta` IN('T','P','A') \
AND `xxbdo_areas_estandares`.`id`=`xxbdo_respuestas`.`areas_estandares_id` \
AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`estandares_id` \
AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`areas_id` \
AND `xxbdo_areas_estandares`.`version_estandares_id`=`xxbdo_version_estandares`.`id` \
ORDER BY `xxbdo_areas`.`orden`, `xxbdo_areas_estandares`.`orden`";
db.query(stmt, entries, (err, result) => {
    if (err) {
        err.status=500;
        return next(err);
    }
    //
    results = formatObservaciones(result, fecha_respuesta);
    //
    if(!results) {
        const error = new Error('No hay observaciones!');
        error.status=400;
        return next(error);
    }
    res.status(200).json(results);
});
};

function formatObservaciones(rows, fecha_observaciones) {
if(rows) {
  let results=[], plantilla=null, version_plantilla=null;
  if(rows.length>0) {
      let areas=[];
      rows.forEach(row => {
          if(!areas.includes(row.areas_id)) {
              //is new 
              version_plantilla = row.version;
              areas.push(row.areas_id);
              results.push(
                  {
                   "area":row.area_titulo, 
                   "estandares":[]
                  }
              );
          } 
          //add std to area
          aindx = areas.indexOf(row.areas_id);
              results[aindx].estandares.push({
                  "id": row.id,
                  "std": row.estandar,
                  "titulo": row.std_titulo,
                  "detalle": row.detalle,
                  "res":row.respuesta,
                  "desc": row.comentario,
                  "folio": row.folio,
                  "turno":row.turno,
                  "foto":row.foto
              });
      });
      //
      plantilla = {"version":version_plantilla,
          "fecha":fecha_observaciones,
          "observaciones":results
      };
  }
  return plantilla;
}
return;
}
