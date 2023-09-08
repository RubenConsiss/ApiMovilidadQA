module.exports.template = function (checks) {
  const checksToFill = checks.map(check => ({
    estatus: null
  }));
  return [
    {
      "elemento": "exterior_de_tienda",
      "descripcion": `<b>Limpieza:</b> Estacionamiento, ventanales, puerta de entrada , botes de basura. IMPORTANTE: <b>No POP dañado</b> (Promoxxo según aplique /  Lonas exteriores) , no exceso de basura y/o manchas en el ventanal.`,
      "checks": [
        {
          "nombre": "ventanales",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
        {
          "nombre": "puerta_de_Entrada",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
        {
          "nombre": "botes_de_Basura",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
        {
          "nombre": "estacionamiento",
          "indicaciones": [],
          "valores_del_check": checksToFill
        }
      ]
    },
    {
      "elemento": "gente",
      "descripcion": `<b>Imagen:</b> Uniforme completo.<br/>
      <b>Cliente:</b> Apego a la <b>experiencia memorable</b>, habilitado en Servicios Financieros (disponibilidad de efectivo), enfoque al Programa de Lealtad.<br/>
      <b>Foco en la persona:</b> Contar con los colaboradores necesarios según la definición de la tabla de frecuencia vigente que permita una carga equitativa de trabajo, asegurar salida de turno a tiempo y que el descanso semanal suceda todo en base al plan horario. Dar 30 min de descanso durante tu jornada laboral. Garantizar que el empleado nuevo esté en acompañamiento de algún colaborador durante los primeros 15 días.<br/>
      <b>Habilitadores COVID19:</b> Uso correcto de habilitadores COVID19 según lineamientos de Plaza.`,
      "checks": [
        {
          "nombre": "uniforme",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
        {
          "nombre": "experiencia_Memorable",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
        {
          "nombre": "foco_en_la_Persona",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
        {
          "nombre": "habilidades_COVID19",
          "indicaciones": [],
          "valores_del_check": checksToFill
        }
      ]
    },
    {
      "elemento": "ejecución_comercial_y_fast_food_(si aplica)",
      "descripcion": `<b>Limpieza:</b> Piso de venta / CF - Refrigerador / Fast Food ( góndolas, exhibidores, deslizadores, isla y producto ) despejado y sin obstrucciones.<br/>
      <b>Exhibición:</b> Producto <b>etiquetado, frenteado, sin huecos</b> y apto para la venta como indica la tira de Planograma o PROMOXXO (si aplica). Aplicar método PEPS.`,
      "checks": [
        {
          "nombre": "ejecución_de_Piso_de_venta",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
        {
          "nombre": "ejecución_de_Cuarto_Frío_/_Refrigeradores_/_Camara_Fría",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
        {
          "nombre": "ejecución_de_Koxka_y_Fast_Food",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
        {
          "nombre": "promociones_y_POP",
          "indicaciones": [],
          "valores_del_check": checksToFill
        }
      ]
    },
    {
      "elemento": "impulso_de_venta_y_gestión_comercial",
      "descripcion": `<b>Monitoreo de Venta:</b> Analizar diariamente la <b>venta</b> y el <b>ticket</b> vs las <b>categorías de enfoque</b> (Abasto, Exhibiciones adicionales, promotoreo del cajero).<br/>
      <b>Proyectos de enfoque y promociones:</b> Asegurar que se cumpla con la meta diaria de activaciones de <b>SPIN, OXXO PREMIA</b>, Promociones clave y Concursos.`,
      "checks": [
        {
          "nombre": "análasis_de_TGO_y_Resumen_Operativo",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
        {
          "nombre": "actualización_y_Seguimiento_de_Metas_Comerciales_en_TGO",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
      ]
    },
    {
      "elemento": "procesos",
      "descripcion": `Asegurar procesos de control de <b>mercancía y efectivo;</b> asi como la gestión de reporteo de fallas <b>(ATL).</b>`,
      "checks": [
        {
          "nombre": "control_de_Mercancía",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
        {
          "nombre": "control_de_Efectivo",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
        {
          "nombre": "gestión_de_Folios",
          "indicaciones": [],
          "valores_del_check": checksToFill
        },
      ]
    },
    {
      "elemento": "responsabilidad_de_enfoque",
      "descripcion": `<b>La Responsabilidad de Enfoque</b> se define por parte de la Región/Plaza/Asesor o Líder de Tienda en función de sus necesidades o alguna estrategia que esté en curso.`,
      "checks": [
        {
          "nombre": "enfoque",
          "indicaciones": "",
          "valores_del_check": checksToFill
        },
      ]
    }
  ]
}