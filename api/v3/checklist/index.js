
const express = require("express"),
      checkAuth = require("./../../middleware/authorize"),
      apiLogs = require("./../../middleware/api_logs");

const method_get = require("./checklist.get"),
      method_post  = require("./checklist.post"),
      method_put   = require("./checklist.put");

let router = express.Router();

router.get("/",
           checkAuth,
           apiLogs,
           method_get.checklist_get
);

router.get("/tipo/:tipo_consulta",
           checkAuth,
           apiLogs,
           method_get.checklist_get
);

router.get("/fecha/:fecha_consulta",
           checkAuth,
           apiLogs,
           method_get.checklist_get
);

router.get("/fecha/:fecha_consulta/tipo/:tipo_consulta",
           checkAuth,
           apiLogs,
           method_get.checklist_get
);

router.get("/tipo/:tipo_consulta/num/:numero/yr/:year",
           checkAuth,
           apiLogs,
           method_get.checklist_get
);

//new route
router.get("/tipo/:tipo_consulta/valor/:valor",
           checkAuth,
           apiLogs,
           method_get.checklist_get
);
//new route
router.get("/tipo/:tipo_consulta/valor/:valor/yr/:year",
           checkAuth,
           apiLogs,
           method_get.checklist_get
);

router.get("/incidencias",
           checkAuth,
           apiLogs,
           method_get.checklist_get_incidencias
);

router.get("/incidencias/tipo/:tipo_consulta",
           checkAuth,
           apiLogs,
           method_get.checklist_get_incidencias
);

router.get("/incidencias/tipo/:tipo_consulta/valor/:valor",
           checkAuth,
           apiLogs,
           method_get.checklist_get_incidencias
);

router.get("/incidencias/tipo/:tipo_consulta/valor/:valor/yr/:year",
           checkAuth,
           apiLogs,
           method_get.checklist_get_incidencias
);

router.get("/ayuda/std/:std",
           checkAuth,
           apiLogs,
           method_get.checklist_get_ayuda
);

router.post("/", 
            checkAuth, 
            apiLogs,
            method_post.checklist_post);

router.put("/", 
           checkAuth, 
           apiLogs,
           method_put.checklist_put);

module.exports = router;
