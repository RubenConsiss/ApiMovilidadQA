
const express = require("express"),
checkAuth = require("./../../middleware/authorize"),
apiLogs = require("./../../middleware/api_logs");

const method_get = require("./bitacora.get");

let router = express.Router();

//cliente : 1=handheld | 2=tablet
//tipo : D=Diario|S=Semanal|M=Mensual
//valor : tipo(D)=fecha | tipo(S)=número de semana | tipo(M)=número de mes
//yr : Año
router.get("/cliente/:tipo_cliente/tipo/:tipo_consulta/valor/:valor",
checkAuth,
apiLogs,
method_get.bitacora_get
);

// /cliente/<1|2>/tipo/<D|S|M>
router.get("/cliente/:tipo_cliente/tipo/:tipo_consulta",
checkAuth,
apiLogs,
method_get.bitacora_get
);

// /cliente/<1|2>/tipo/<S|M>/valor/<NN>/yr/<YYYY>
router.get("/cliente/:tipo_cliente/tipo/:tipo_consulta/valor/:valor/yr/:year",
checkAuth,
apiLogs,
method_get.bitacora_get
);

// /detalles/tipo/<D>/valor/<YYYY-MM-DD>
router.get("/detalles/tipo/:tipo_consulta/valor/:valor",
           checkAuth,
           apiLogs,
           method_get.bitacora_get_detalles
);
// /detalles/tipo/<D>/valor/<YYYY-MM-DD>/res/<K|T|P|A|V>
router.get("/detalles/tipo/:tipo_consulta/valor/:valor/res/:tipo_respuesta",
           checkAuth,
           apiLogs,
           method_get.bitacora_get_detalles
);

// /detalles/tipo/<S|M>/valor/<NN>/yr/<YYYY>
router.get("/detalles/tipo/:tipo_consulta/valor/:valor/yr/:year",
           checkAuth,
           apiLogs,
           method_get.bitacora_get_detalles
);

// /detalles/tipo/<D|S|M>/valor/<YYYY-MM-DD|NN>/yr/<YYYY>/res/<K|T|P|A|V>
router.get("/detalles/tipo/:tipo_consulta/valor/:valor/yr/:year/res/:tipo_respuesta",
           checkAuth,
           apiLogs,
           method_get.bitacora_get_detalles
);

module.exports = router;
