
const db = require("../../../db");
bdoDates = require("../../helpers/bdo-dates");
const dbg = false;

exports.change_url = (req, res, next) => {

    if(dbg) console.log("[9] Start change_url_post...");
    if(!db) {
        const error = new Error('Conexión a BD no encontrada!');
        error.status = 500;
        return next(error);
    }
   
    let crplaza = req.tokenData.crplaza;
    let stmt = null;

      entries = [crplaza];
      stmt = "SELECT url AS `url_cambio` \
        FROM `configuraciones_url` \
        WHERE cr_plaza=? ";
      qry = db.query(stmt, entries, (err, rst) => {
          if (err) {
              err.status = 500;
              return next(err);
          }
          res.status(200).json({"url_cambio":rst[0].url_cambio});
      });
};