module.exports.template = function (checks) {
  return [
    {
      "elemento": "exterior_de_tienda",
      "descripcion": `<b>Limpieza de estacionamiento:</b> Barrer banqueta y estacionamiento, limpiar jardinera (si aplica).<br/>
      <b>Limpieza de Ventanales:</b> Lavar ventanas asegurando que no queden huellas y estén en óptimo estado sin residuos de pegamento.<br/>
      <b>Limpieza de contenedor y botes de basura:</b> Limpios con tapa, con bolsa bien puesta y a no más de 3/4 de su capacidad y libres de mal olor y derrames.<br/>
      <b>Pop:</b> Revisar y mantener en buen estado material publicitario (Banner exterior, lonas, posters o cualquier otro material publicitario).<br/>
      <b>Toda la zona del exterior deben conservar un buen aspecto.</b>`,
      "checks": [
        {
          "nombre": "ventanales",
          "indicaciones": null,
          "valores_del_check": checks
        },
        {
          "nombre": "puerta_de_Entrada",
          "indicaciones": null,
          "valores_del_check": checks
        },
        {
          "nombre": "botes_de_Basura",
          "indicaciones": null,
          "valores_del_check": checks
        },
        {
          "nombre": "estacionamiento",
          "indicaciones": null,
          "valores_del_check": checks
        }
      ]
    },
    {
      "elemento": "gente",
      "descripcion": `<b>Imagen:</b> Uniforme oficial y cubrebocas institucional limpio y en buen estado, gafete a la vista y botón promocional y/o de entrenamiento, mostrando una actitud de servicio hacia el cliente proveedores y compañeros. No consumo de alimentos en isla, no uso de electrónicos ajenos a la tienda en horario laboral.<br/>
      <b>Experiencia del cliente:</b> Ofrecer un <b>saludo</b> y trato amable al cliente durante su estancia en la tienda, <b>abrir caja adicional</b> al detectar más de 3 clientes, cajero habilitado para servicios financieros, preguntar por tarjeta SPIN y/o OXXO Premia, contar con al menos 3 mil pesos disponibles para retiro de efectivo, ofrecer <b>PRO y venta sugerida.</b><br/>
      <b>Foco en la persona:</b> Contar con los colaboradores necesarios según la definición de la tabla de frecuencia vigente que permita una carga equitativa de trabajo, asegurar salida de turno a tiempo y que el descanso semanal suceda todo en base al plan horario. Dar 30 min de descanso durante tu jornada laboral. Garantizar que el empleado nuevo esté en acompañamiento de algún colaborador durante los primeros 15 días.<br/>
      <b>Habilitadores COVID19.</b> Asegurar existencia y uso correcto de Habilitadores COVID19 (Gel antiséptico, Solución sanitizante, Sana distancia, Protocolo de entrega y recepción de turno COVID19, Tapete con solución sanitizante, lentes, caretas y termómetro) (si aplica).`,
      "checks": [
        {
          "nombre": "uniforme",
          "indicaciones": null,
          "valores_del_check": checks
        },
        {
          "nombre": "experiencia_Memorable",
          "indicaciones": null,
          "valores_del_check": checks
        },
        {
          "nombre": "foco_en_la_Persona",
          "indicaciones": null,
          "valores_del_check": checks
        },
        {
          "nombre": "habilidades_COVID19",
          "indicaciones": null,
          "valores_del_check": checks
        }
      ]
    },
    {
      "elemento": "ejecucion_comercial_y_fast_food_(si aplica)",
      "descripcion": `<b>El piso, los muebles y el equipo en general</b> debe estar limpio y los cajones ordenados. 
      Bolsas para el cliente disponibles y ordenadas (si aplica). Libre de volantes, publicidad y exhibidores no autorizados, objetos personales e información confidencial de la tienda a la vista del cliente.  
      Piso de venta libre de bultos y cajas, mercancía solo en góndolas y exhibidores.<br/>
      <b>Productos</b> limpios y sin empaques alterados, raspados, o maltratados. (Apto para la venta). Producto en frutero se encuentran en buen estado, limpio, sin daño aparente y acomodado adecuadamente; apto para la venta (no sobremaduro).  (si aplica)
      Producto dentro del límite de caducidad establecido en el mismo.<br/>
      <b>Productos</b> sin señales de deterioro como hongos o resequedad, mal olor o color.<br/>
      <b>Etiquetas</b> actualizadas corresponde al producto exhibido y muestra el precio correcto, completamente legible (no decolorada) y no rota.<br/>
      <b>Resurtido</b> continuo de los productos en el Cuarto frío/Refrigerador y piso de venta (no más de 3 huecos visibles por puerta) y colocado como indica la tira de Planograma o PROMOXXO.  En caso de no contar con producto en existencia, rellenar el hueco con un ASLEP de la misma familia o con el producto del lado.  Asegurar correcta ejecución de material publicitario y promociones en tienda.`,
      "checks": [
        {
          "nombre": "ejecución_de_Piso_de_venta",
          "indicaciones": null,
          "valores_del_check": checks
        },
        {
          "nombre": "ejecución_de_Cuarto_Frío_/_Refrigeradores_/_Camara_Fría",
          "indicaciones": null,
          "valores_del_check": checks
        },
        {
          "nombre": "ejecución_de_Koxka_y_Fast_Food",
          "indicaciones": null,
          "valores_del_check": checks
        },
        {
          "nombre": "promociones_y_POP",
          "indicaciones": null,
          "valores_del_check": checks
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
          "indicaciones": null,
          "valores_del_check": checks
        },
        {
          "nombre": "actualización_y_Seguimiento_de_Metas_comerciales_en_TGO",
          "indicaciones": null,
          "valores_del_check": checks
        },
      ]
    },
    {
      "elemento": "procesos",
      "descripcion": `<b>Control de Mercancía: Preinventarios</b> según Rol definido, utilizando plantillas y enfocados según programa a los artículos de mayor faltante, artículos en promoción, eliminación de artículos frecuentes y de alto valor. <b>Mínimo 25% de cobertura.</b> Merma bajo control capturados en la pre-merma y aplicada en sistema al menos una vez por semana.<br/>
      <b>Control de Efectivo:</b> Se realizan las <b>entregas de turnos</b> y cierre de caja cuadrando el efectivo, se realizan arqueos y se mantiene un control exacto. La tómbola no está obstruida. Retiros de efectivo según los montos establecidos en la Plaza y su registro en bitácora. Se cuenta con la papelería necesaria para la entrega de valores (papeletas, bolsas). Se mantiene la morralla adecuada para dar servicio a clientes (fondo fijo).<br/>
      <b>Procesos de Gestión.</b> Canalizar diálogos a través del reporteo de fallas (ATL) detectadas en la revisión de las Responsabilidades.`,
      "checks": [
        {
          "nombre": "control_de_Mercancía",
          "indicaciones": null,
          "valores_del_check": checks
        },
        {
          "nombre": "control_de_Efectivo",
          "indicaciones": null,
          "valores_del_check": checks
        },
        {
          "nombre": "gestión_de_Folios",
          "indicaciones": null,
          "valores_del_check": checks
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
          "textFieldIsFill": false,
          "valores_del_check": checks
        },
      ]
    }
  ]
}