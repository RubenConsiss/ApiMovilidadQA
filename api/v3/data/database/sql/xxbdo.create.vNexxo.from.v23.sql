
-- query para cerrar BDO version 23, change fecha_fin as required:
UPDATE `xxbdo_version_estandares` 
SET `descripcion` = 'Estándares Operativos Versión 23', 
`es_default` = '0', 
`fecha_fin` = '2019-10-14' 
WHERE `xxbdo_version_estandares`.`id` = '13d772fa-826b-424f-802e-63da4777e33c';

-- query para cerrar checklist vesion 23:
UPDATE `xxbdo_checklists` 
SET `fecha_fin` = '2019-10-14', 
`es_default` = '0' 
WHERE `xxbdo_checklists`.`id` = '3e50f58c-8634-41ce-93b5-c8bebb8bce46';

-- insertar registro de nueva version
INSERT INTO `xxbdo_version_estandares` (`id`, `titulo`, `titulo_app`, `descripcion`, `es_default`, `fecha_inicio`, `fecha_fin`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('a74a4a3f-20e1-44e3-aadd-354647fd8210', 'Estandares Operativos Version Nexxo', 'Versión Nexxo', 'Estandares Operativos Version Nexxo', 1, '2019-10-15', NULL, 1, NULL, NULL, NOW(), NOW());

-- insertar registro de checklist vNexxo = 7131ed27-5733-47e9-ad86-83cac29e9288 : 
INSERT INTO `xxbdo_checklists` (`id`, `xxbdo_version_estandares_id`, `titulo`, `descripcion`, `titulo_app`, `titulo_indicadores_app`, `fecha_inicio`, `fecha_fin`, `es_default`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) 
VALUES ('7131ed27-5733-47e9-ad86-83cac29e9288', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'Estándares Operativos Versión Nexxo', 'Estándares Operativos Versión Nexxo', 'BITACORA NEXXO', 'INDICADORES NEXXO', '2019-10-15', NULL, '1', '1', NULL, NULL, NOW(), NOW());

-- version estandar 23 = 13d772fa-826b-424f-802e-63da4777e33c
-- version estandar 24 = a74a4a3f-20e1-44e3-aadd-354647fd8210

-- ver areas de v23:
-- SELECT * FROM `xxbdo_areas` WHERE `xxbdo_version_estandares_id`='13d772fa-826b-424f-802e-63da4777e33c' order by orden;

--
-- Volcado de datos para la tabla `xxbdo_areas`
-- Insertar registro de areas de estandares diarios vNexxo:
INSERT INTO `xxbdo_areas` (`id`, `xxbdo_version_estandares_id`, `xxbdo_areas_grupos_id`, `titulo`, `descripcion`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
-- Estandares Diarios
('c00b4101-6d6e-437b-aeb3-4d2003b66e35', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', 'Servicio', 'Servicio', 1, 1, NULL, NULL, NOW(), NOW()),
('99eeb51f-930b-4601-8c7c-7a61311983fc', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', 'Ingreso', 'Ingreso', 2, 1, NULL, NULL, NOW(), NOW()),
('e9160e68-a4e2-463a-a305-71c16252f393', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', 'Gente', 'Gente', 3, 1, NULL, NULL, NOW(), NOW()),
('829ed6aa-4965-43f2-b661-d269bc36a685', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', 'Ejecución', 'Ejecución', 4, 1, NULL, NULL, NOW(), NOW()),
('deb5bbcf-910a-46a2-a3a2-1fc788c38d40', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', 'Cliente', 'Cliente', 5, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Semanales
('60b89d25-19a6-4426-a983-1320827edc88', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', '698d2abc-daad-4398-89e9-ad92fca812ae', 'Indicadores', 'Indicadores', 1, 1, NULL, NULL, NOW(), NOW()),
('4f17f8ad-48c7-49f8-ae3e-d4905782516e', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', '698d2abc-daad-4398-89e9-ad92fca812ae', 'Mantenimiento', 'Mantenimiento', 2, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Mensuales
('552949e1-3c9d-4859-8186-67604f6c0f31', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'ad642ddf-3050-4284-8f1b-42604d38f164', 'Cultura', 'Cultura', 1, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Libres
('750b5df7-5030-4306-b312-defa72c6ee4c', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', '86392947-9a57-46c0-a16f-f2f4e5c0745d', 'Libre', 'Estándar Libre', 10, 1, NULL, NULL, NOW(), NOW());

--
-- Volcado de datos para la tabla `xxbdo_estandares`
-- Insertar registros de estandares vNexxo:
INSERT INTO `xxbdo_estandares` (`id`, `xxbdo_version_estandares_id`, `tipo`, `cr_plaza`, `cr_tienda`, `estandar`, `titulo`, `orden`, `detalle`, `descripcion`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
-- Estandares Diarios
('d1fd38a0-6086-42aa-bc47-56ec3ba98197', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 1, 'Imagen y Comportamiento del personal de tienda', NULL, '- Presencia / Actitud / Comportamiento', '1.- <font color=red><b>Presencia impecable</b></font>, uniforme oficial de acuerdo a <font color\r\n=red>código de vestimenta</font> y gafete a la vista, botón promocional y/o de entrenamiento; gorra oficial sólo sí la Plaza lo autoriza.<br><br>\r\n2.- Mostrar una actitud de <b>servicio</b> hacia el cliente, proveedores y compañeros (optimista, proactivo, atento y servicial).<br><br>\r\n3.-No consumo de alimentos en isla, no uso de electrónicos laborando (especial cuidado al estar atendiendo al cliente).', 1, 1, NULL, NULL, NOW(), NOW()),
('52dd7a42-4499-41ea-a673-61bfecafbb58', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 2, 'Atención al cliente', NULL, '- Saludo / Caja adicional / PRO // No Venta Menores / Servicio Electrónico /Agradecer/ factuar/ estacionamiento/ Horarios / Prioridad de atención al cliente', '1.- Ofrecer un <b>saludo</b> y trato amable al cliente durante su estancia en la tienda, dando prioridad en atenderlo, interrumpiendo actividades que se estén realizando en los dispositivos móviles.<br><br>\r\n2.- <b>Abrir caja adicional</b> al detectar más de tres clientes en fila o si se está cobrando algún servicio financiero, boletos o facturación. Todas las cajas siempre con fondo y con morralla suficiente para recibir billetes de cualquier denominación y/o realizar retiros. Colocar letrero de \"caja cerrada\" cuando la caja no esté disponible para venta.<br><br>\r\n3.- Preguntar al cliente si desea redondear (<b>PRO</b>) y mencionar la institución beneficiada en caso de que pregunte.<br><br>\r\n4.- <b>Negar la venta de alcohol y/o cigarros</b> a menores de edad o fuera del horario permitido por la ley, ante la duda de la edad del cliente, solicitar Identificación Oficial.<br><br>\r\n5.- <font color=red>Siempre intentar realizar cualquier <b>servicio electrónico</b> antes de indicar al cliente que no hay sistema. Informar el monto a pagar incluyendo comisión por servicio.</font><br><br>\r\n6.- <b>Agradecer la compra</b> y/o despedirse amablemente y/o invitar al  cliente a regresar de nuevo.<br><br>\r\n7.- Generar y entregar la <b>factura</b> cuando el cliente lo solicite (verificando que los datos son correctos) e informarle que una vez generada la factura en tienda sólo podrá generar el archivo XML en el portal web.<br><br>\r\n8.- Realizar la devolución de productos cuando el cliente así lo desee y resguardar tickets de devolución.<br><br>\r\n9.- Mantener disponibilidad de <b>estacionamiento</b> para nuestros clientes.<br><br>\r\n10.- Cumplir con los <b>horarios de apertura y cierre de tiendas</b> de acuerdo a lo establecido por la Plaza.', 1, 1, NULL, NULL, NOW(), NOW()),
('339372b7-2b08-445f-aac5-cc07a175317f', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 3, 'Control', NULL, '- Preinventarios /Efectivo /Merma y Devolución aplicada en sistema', '1.- <b>Preinventarios</b> según Rol definido, utilizando plantillas y enfocados según programa a los artículos de mayor faltante, artículos en promoción, eliminación de artículos frecuentes, y de alto valor. Mínimo 2,500 conteos por semana y al menos 40% de cobertura.<br><br>\r\n2.- Se realizan las entregas de turnos y cierre de caja cuadrando el <b>efectivo</b>, se realizan arqueos y se mantiene un control exacto, adicional se hace la entrega de los dispositivos móviles y sus cargadores. La tómbola no está obstruida. Retiros de efectivo según los montos establecidos en la Plaza, se depositan de inmediato en tómbola y se cumple con el llenado del Control de Depósitos. Se cuenta con la papelería necesaria para la entrega de valores (papeletas, bolsas) y la entrega se asegura contra el catálogo de custodios. Se mantiene la morralla adecuada para dar servicio a nuestros clientes (fondo fijo).<br><br>\r\n3.- <b>Merma</b> bajo control. Los productos a mermar están en una bolsa de plástico en el contenedor de merma autorizado en el cuarto frío, capturados en la pre-merma y aplicada en sistema al menos una vez por semana.<br><br>\r\n4.- Los productos con <b>devolución</b> autorizada a Cedis y proveedores, se almacenan en el contenedor  de devoluciones y/o lugar definido por el Asesor una vez aplicada la devolución en sistema. Las devoluciones a IMMEX son del 1 al 15 y se entregan en presencia del vendedor.', 1, 1, NULL, NULL, NOW(), NOW()),
('82c7ee00-9f85-43ba-8edd-d589df96f130', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 4, 'Habilitación Equipo Tienda', NULL, '- Entienda /Servicios Financieros/ Estándares/  Clasificación / Dispositivos móviles', '1.- Equipo completo de acuerdo a tabulador, todos registrados en SADEL e IMSS, con <b>ENTIENDA completo</b>. Conocen sus beneficios así como los incentivos.<br><br>\r\n2.- <b>Servicios financieros</b> al menos un cajero habilitado por turno (aplica de 6:00 AM a 10:00 PM) usuario y contraseña sin bloqueos.  Los cajeros habilitados actualmente laboran en la tienda cuentan con la documentación personal vigente.<br><br>\r\n3.- Todos los empleados conocen y están habilitados para cumplir los <b>estándares</b> operativos, cuentan con los dispositivos móviles funcionando correctamente, siempre encendidos y en buen estado.<br><br>\r\n4.- El equipo de tienda conoce y sabe su enfoque de acuerdo a su <b>clasificación</b> de líder, está comprometido con su plan de acción y saben como imprimir sus asignaciones de tareas.', 1, 1, NULL, NULL, NOW(), NOW()),
('d321a40f-847c-4e8d-b17e-d628999e2449', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 5, 'Manejo de gente', NULL, '- 2XTurno /Nuevo con Líder/ Hora salida/ Vacaciones /Balanceo /Descanso /Plan horario / Alimentación /Cargas de Trabajo/ Tarjeta bancaria', '1.- Contar con mínimo <b>dos empleados por turno</b>, incluyendo al Líder de Tienda.<br><br>\r\n2.- <b>Acompañamiento</b> del Líder de Tienda a empleados nuevos en los primeros 15 días.<br><br>\r\n3.- <b>Salida</b> de turno a tiempo.<br><br>\r\n4.- Cumplir con el rol anual de <b>vacaciones</b>.<br><br>\r\n5.- <b>Balanceo</b> de asignación de tareas (Sem 1 60% ; Sem 2 65% ; Sem 3 70%  y  Sem 4 75%. ) y/o ATA´s <font color=red>especiales</font>.<br><br>\r\n6.- <b>Descanso</b> semanal.<br><br>\r\n7.- <b>Plan horario</b> acordado previo al inicio de la semana, considerando en lo posible temas del personal.  En el corcho y firmado por los empleados. Se cuenta con un tiempo para tomar los alimentos (sin Chaquetín).<br><br>\r\n8.- <font color=red>Se respeta horario establecido para <b>alimentación</b></font>.<br><br>\r\n9.- <b>Cargas de trabajo</b> buscando balance.<br><br>\r\n10.- Se paga a tiempo y completo (tiempos extras, días festivos , etc.), mediante <b>tarjeta bancaria</b> proporcionada por plaza.', 1, 1, NULL, NULL, NOW(), NOW()),
('da73ab7e-cbbe-4ce5-9d4b-555298d0024a', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 6, 'Limpieza', NULL, '- Exterior/ Botes basura/ Isla/ Piso de Venta/ Equipamiento/ Frutero/ Baño/ Bodega/Químicos de Limpieza', '1.- <b>Exterior</b> <font color=red>en buen estado</font>. Banqueta, estacionamiento, pasillos, topes, jardinera y equipos limpios. Cajón y rampa para personas con discapacidad señalizado. Sin grafiti, lámparas limpias. Sin publicidad no autorizada. Árboles, jardineras en buen estado y pasto recortado (si aplica).<br><br>\r\n2.- Contenedor y <b>botes de basura</b> limpios con tapa, en buen estado y señalizados como Orgánico e Inorgánico, con bolsa blanca para Inorgánico y negra para Orgánico (si aplica). Bolsas con no más de 3/4 de su capacidad y área sin exceso de basura, derrames y libre de mal olor.<br><br>\r\n3.-<b>Isla</b>. El piso, los muebles y el equipo en general debe estar limpio y los cajones ordenados. Bolsas para el cliente disponibles y ordenadas. Tapete antifatiga en buen estado. Libre de volantes, <font color=red>publicidad y exhibidores no autorizados, objetos personales e información confidencial de la tienda a la vista del cliente.</font><br><br>\r\n4.- <b>Piso de venta</b> libre de bultos y cajas, mercancía solo en góndolas y exhibidores. Pisos limpios.  Tapete de entrada limpio y en buen estado. La tienda tiene un olor agradable o neutro, se encuentra libre de insectos <font color=red>y/o fauna nociva</font>.<br><br>\r\n5.- <b>Equipamiento</b>: Góndolas (cabeceras, lomo), paletero, hieleras, revisteros, exhibidores en piso de venta y racks para garrafones (incluyendo el espacio entre el piso y la base inferior de ellos) limpios.<br><br>\r\n6.- <b>Frutero</b> limpio incluyendo las charolas, sin derrames de líquidos de frutas o verduras.<br><br>\r\n7.- <b>Baño</b> con olor neutro o agradable. Inodoro, mingitorio, lavamanos, espejo, porta rollo, porta papel de manos y jabonera, paredes, piso y puerta limpios.<br><br>\r\n8.- <b>Bodega</b>. Limpieza. Tarja, paredes, piso, rack, locker y  puertas  limpios. Tener luces de bodega encendidas solo cuando sea necesario. No focos fundidos.<br><br>\r\n9.- Almacenamiento de <b>Químicos de Limpieza</b>. Los químicos de limpieza en uso deberán ser colocados en la canastilla ubicada sobre la tarja de lavado, el resto de químicos (contenedores grandes) deberán ser colocados exclusivamente en el espacio especificado (identificado con una etiqueta).<br><br>\r\n10.- <b>Dispositivos móviles de Tienda</b> no se dejan al alcance del cliente, si no se están usando se mantienen resguardados en el segundo cajón de la isla.', 1, 1, NULL, NULL, NOW(), NOW()),
('6fc69885-e1f7-48e6-b226-aacbd98f35a2', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 7, 'Exhibición', NULL, '- Mapa Legos/ Planograma/  Límite Altura/  Espacios ASLEP/  rotación de productos / Cigarrera/ Hieleras/ Paquetería', '1.- Los <b>planogramas</b> y exhibidores tienen la misma ubicación y tamaño que el <b>mapa de Legos</b> de la Tienda. <font color=red>Los productos colocados como indica la tira de planograma o PROMOXXO, frenteados y fondeados correctamente. En caso de no haber producto, rellenar el hueco con un ASLEP de la misma familia o con  el producto del lado.</font><br><br>\r\n2.- Los productos ubicados en la charola superior no sobrepasan 10cm del <b>límite de altura</b> de la góndola. Para botanas, abarrotes, vinos y bebidas el limite máximo es 20cm de altura.<br><br>\r\n<font color=red>3.- Contar con exhibidores de piso y hieleras acorde a inventario de espacios.</font><br><br>\r\n4.- Los productos indicados en la de tira <b>ASLEP</b> están ubicados en charolas de expulsión, exhibidores de remate o mueble definidos por la plaza en piso de venta. Todo articulo que no se pueda colocar deberá tener un folio generado.<br><br>\r\n5.- La <b>rotación de productos</b> debe de basarse en \"Lo primero que entra es lo primero que sale, \"<b>PEPS</b>\".<br><br>\r\n6.- <b>Cigarrera</b> con producto exhibido en todos sus carriles y con su respectiva comunicación de precios en cada artículo. <font color=red>Cuenta con charola promocional. Carriles y copete en buen estado (si aplica).</font><br><br>\r\n7.- <b>Hieleras</b> con producto de CCM con al menos el 50% de su capacidad, excepto viernes, sábado y domingo que debe de ocupar el 100%, exhibido de acuerdo a guía de acomodo (si aplica).<br><br>\r\n8.-  Artículos de <b>paquetería</b> en tienda colocados en el espacio definido en el checkout (si aplica) y con <font color=red>calcomanía</font> especificada, libre de otras mercancías o utensilios.', 1, 1, NULL, NULL, NOW(), NOW()),
('8bc82813-3ed0-459d-a1bb-f0dcaf524300', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 8, 'Calidad y Condiciones del Producto', NULL, '- Limpios/ Frutero/ Caducidad/ Deterioro/ Temperatura de Equipos', '1.- Productos <b>limpios</b> y sin empaques alterados, raspados, o maltratados. (Apto para la venta).<br><br>\r\n2.- Producto en frutero se encuentran en buen estado, limpio, sin daño aparente y acomodado adecuadamente; apto para la venta (no sobremaduro).<br><br>\r\n3.- Producto dentro del límite de <b>caducidad</b> establecido en el mismo (retirar los productos un día antes de la fecha de vencimiento, a menos que tenga la leyenda \"Fresco hasta\") y los más próximos a caducar colocados al frente o más cerca del cliente. Los caducos retirarlos y colocarlos en contenedor de merma (aplica para todos los productos).En los productos que solo contengan la caducidad en mes y año, retirar el último día del mes indicado en de la etiqueta. Retirar los productos perecederos que no tengan etiqueta de caducidad.  Insumos de café y alimentos no caducos.<br><br>\r\n4.- Productos sin <b>señales de deterioro</b> como hongos o resequedad, mal olor o color.<br><br>\r\n5.-  <b>Temperatura de equipos</b>. Cámara de conservación de \"Refrescos y lácteos\" (2 a 5 ºC) o (36 - 41 °F), cámara de conservación de \"hielo\" (-10 a -7 ºC), cámara fría o \"cervecero\"  (de 0 a 2 °C)  a excepción de las siguientes plazas: (de 2 a 5 ºC)  en Obregón, Nogales, Monterrey, Saltillo, Allende, Laguna, Piedras Negras, Monclova, Culiacán, La Paz, Los Mochis, Reynosa, Laredo, Matamoros y Cd. Juárez. De ( -2 a 0 ) para plaza Mexicali . Salchichonero a una temperatura de 2 a 6 ºC o 35 a 42 °F. <font color=red>Para equipos de comida rápida consultar Anexo FF.</font>', 1, 1, NULL, NULL, NOW(), NOW()),
('2cd92cf6-08cf-4a42-ba80-5faf3b447fd4', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 9, 'Etiqueteo', NULL, '- Actualizadas/ Etiqueta varios frentes/ Colocadas/ Preciadores/ Remate/ Mismo Precio/ Cerveza', '1.- <b>Etiquetas actualizadas</b> corresponde al producto exhibido y muestra el precio correcto, completamente legible (no decolorada) y no rota.<br><br>\r\n2.- Si el producto es más pequeño que la etiqueta ó los productos son de la misma presentación mismo sabor se coloca al menos <b>una etiqueta para todos los frentes.</b><br><br>\r\n3.- Etiquetas <b>colocadas</b> en porta etiquetas o holders institucionales y <font color=red>ambos en</font> buen estado. No colocar etiquetas en la rejillas frontales del koxka.<br><br>\r\n4.- <b>Preciadores</b> del canasto, de vinos y licores, exhibidores de telefonía y tecnología colocados frente al producto que hace referencia.<br><br>\r\n5.- Producto que aplique con preciador de <b>remate</b> oficial.<br><br>\r\n6.- Productos con misma presentación pero diferente sabor, deben tener el <b>mismo precio</b>.<br><br>\r\n7.- Productos de <b>cerveza</b> que apliquen con etiqueta de precio multi-unidad y su etiqueta de precios individual. Si el producto tiene solo un frente, colocar etiqueta de precio individual.', 1, 1, NULL, NULL, NOW(), NOW()),
('c1e11e5d-ac2d-4a80-8cb0-9177a8d8249c', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 10, 'Comida rápida', NULL, '- Estándares FF/ Insumos/ Caducidad/ Limpios/ Limpieza del área/ Utensilios', 'Todos los conceptos de <b>Fast Food Alimentos y Bebidas</b> que aplican para la tienda se ejecutan según lo definido en base al <b>Anexo a Estándares de Fast Food</b>.<br><br>\r\n1.- Todos los equipos de Fast Food limpios interna y externamente, con vestido y piezas completas y en buen estado.<br><br>\r\n2.- <b>Limpieza</b> del piso, panel duela (si aplica), muebles de comida rápida y café. Botes de basura con bolsa no más de 3/4 de su capacidad y señalizados como Orgánico e Inorgánico, con bolsa blanca para Inorgánico y negra para Orgánico (si aplica). Área libre de malos olores.<br><br>\r\n3.- <b>Utensilios</b> disponibles, limpios y en buen estado.', 1, 1, NULL, NULL, NOW(), NOW()),
('6f6b7f28-1711-4fb0-8ac6-8fdd4f2fd9cf', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 11, 'Cuarto Frío', NULL, '- Resurtido/ Limpieza/Orden/ Exhibición Visible/ Buenas Prácticas/ Hielo/ Chamarras', '1.- <b>Resurtido</b> continuo de los producto en el cuarto frio (no más de 3 huecos visibles).<br><br>\r\n2.- <b>Limpieza</b>: Puertas, techo y marcos de cuarto frío, parrillas, deslizadores, acrílicos, porta etiquetas, puerta de acceso al cuarto frio, cortina hawaiana, piso, paredes interiores y exteriores (sin evidencia de derrames), rack y exhibidores  limpios y en buen estado.<br><br>\r\n3.- <b>Orden</b>: Pisos sin objetos tirados, barrido y trapeado, libre de malos olores. Sólo exhibidores y productos autorizados para el cuarto frío. Carriles bien definidos con acrílicos de acuerdo al tamaño. El producto apilado está dentro del limite permitido (1.5 mts. de altura). <font color=red>No se coloca producto alimenticio directamente sobre el piso.</font><br><br>\r\n4.- <b>Exhibición visible</b> e iluminada en todo momento. No lámparas fundidas.<br><br>\r\n5.- Buenas prácticas: La cortina de PVC (hawaiana) nunca se encuentra \"colgada\" o \"amarrada\". La(s) puerta(s) de acceso al cuarto frío se mantienen bien cerradas. Productos resguardados en el rack de acuerdo a la guía. Alimentos de personal de tienda en su cajonera autorizada. Aplicación del 5S + 1.<br><br>\r\n6.- Al menos el 50% de <b>existencia de  hielo</b> apto para su venta y con buena accesibilidad. No se estiba más de 1.5 m de altura. No escarcha y/o agua escurriendo en piso del contenedor.<br><br>\r\n7.- Existen 2 <b>chamarras</b> en la tienda en buen estado <font color=red>colgadas en el perchero.</font>', 1, 1, NULL, NULL, NOW(), NOW()),
('6ae06442-1544-4a5a-9f3a-bcc5a87711e6', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 12, 'Promociones', NULL, '- Promoxxo/ Oficial/ Vigente/ No Cinta Adhesiva', '1.- Exhibiciones de Piso, Checkout, cabeceras, tiras promocionales  y adicionales con producto de acuerdo al <b>planograma</b> en Promoxxo.<br><br>\r\n2.- El material que se encuentre en tienda debe de ser el <b>oficial</b> y estar <b>vigente</b>.<br><br>\r\n3.- Los materiales <b>POP</b> deben de estar colocados/desplegados correctamente (de acuerdo a  Promoxxo), en buenas condiciones, visibles y sin obstrucciones.<br><br>\r\n4.- Todos los materiales deberán estar pegados con la cinta doble cara que trae el material, en los marcos donde corresponden o colgados con cinchos <font color=red>ó ventosas</font> si es que aplican. <b>Ningún material debe tener cinta adhesiva</b>, ni grapas.', 1, 1, NULL, NULL, NOW(), NOW()),
('21469197-833c-4e11-a1e2-346e6b4123a6', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 13, 'Venta Enfocada', NULL, '- Sugerir/ Servicios/ TGO', '1.- <font color=red>Preguntar si se le ofrece \"algo más\" y/o <b>sugerir</b> promociones o productos de forma constante.</font><br><br>\r\n2.- <b>Servicios</b> (lo que aplique). Portaboletos de autobús, llaveros para TAE, exhibidor de tecnología y telefonía disponibilidad y exhibición, seguros y disponibilidad tarjetas regalo, prepago y Saldazo que apliquen.<br><br>\r\n3.- Se cuenta con las metas definidas por el Asesor de Tienda para cada indicador y se captura el seguimiento diario de avance al indicador en el <b>TGO</b>. Se analiza diariamente el estatus actual de los Factores Críticos así como las gráficas de seguimiento diario y gráficas de proyección mensual en el Tablero de Gestión Operativa.', 1, 1, NULL, NULL, NOW(), NOW()),
('ab9e5aff-2dfe-4062-9fb1-3f1f5980ee5c', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 14, 'Ambientación y Seguridad', NULL, '- No almacenar en/ Luces/ Buenas Prácticas/ 5S+1', '1.- <b>Prohibido almacenar</b> producto y/o chaquetines en el baño. Entrada no obstruida.<br><br>\r\n2.- Tener <b>luces</b> de exterior, piso de venta y baño encendidas solo cuando sea necesario. No focos fundidos.<br><br>\r\n3.- <b>Buenas prácticas</b>. La puerta de la bodega se mantiene cerrada y se abre sólo cuando es necesario. No se colocan productos u objetos encima de equipos eléctricos y de cómputo (si aplica), en el techo del cuarto frío o conservadores de hielo en bolsa. Tableros eléctricos y de control, extintores, salidas de emergencia, puertas de cuarto frío y de bodega libres de cualquier obstrucción.<br><br>\r\n4.- Orden. Aplicación del <b>5S + 1</b> en bodega, incluyendo el escritorio, equipo de cómputo (si aplica), rack y tarja. Los productos se encuentran acomodados en su lugar asignado en carriles delimitados y los utensilios de limpieza se colocan en el Rack de Limpieza. Nota: los productos se encuentran separados al menos 10 cm de la pared (no colocar productos sobre la línea roja) y no se apilan a más de 1.5 metros de altura (no sobrepasan la línea amarilla).', 1, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Semanales
('505ffd8c-daa0-4863-9aca-9385b01bb035', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 15, 'Herramienta de Compra /Tablero de Gestión Operativa', 1, NULL, '1.- Se monitorea diariamente las Tiras de PAFS en riesgo de desabasto, Resumen Operativo, Tira de Venta Recuperada por Exhibición y Tira de Venta Perdida Proveedor-Artículo del Tablero de Gestión Operativa, se imprimen y almacenan día / semana anterior y actual en la Carpeta Operativa y se llevan a cabo acciones para disminuirlos. El pedido se hace de acuerdo al sugerido y se aumenta en caso de ser hueco. Stocks actualizados para artículos durante el periodo promocional.  Se almacenan las compras por día y se revisan contra la hoja de arrastre de saldo diario validando compras y devoluciones.', 1, 1, NULL, NULL, NOW(), NOW()),
('8a1e9e51-5937-49dd-ae5c-3e833e84a46d', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 16, 'Asignación de Tareas', 2, NULL, '1.- Todos los empleados cuentan con su tira en el turno. El Líder y/o Encargado monitorean diariamente la ejecución de las tareas asignadas. Al menos de manera semanal el líder revisa las tareas creadas y como están asignadas, de forma que coincidan con las áreas de oportunidad encontradas. Las cargas están entre 85% y 100%  y equilibradas, para personal nuevo de acuerdo a vector gente. Se encuentran en el corcho las tiras del último día y turnos laborados.', 1, 1, NULL, NULL, NOW(), NOW()),
('88468aac-3d20-4c03-8bfc-b6461f019b62', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 17, 'Carpeta Operativa/ Permisos Oficiales/ Corcho Operativo', 3, NULL, '1.- Las carpeta operativa  se encuentra actualizada (aplica según lo comunicado de acuerdo a la última versión), organizada y en buenas condiciones y los puntos que se deban de llenar se llenan tal y como se definió.<br><br>\r\n2.-  Se verifica que los permisos oficiales se encuentren en tienda y vigentes, de acuerdo a la ley local vigente (visibles, donde aplique).<br><br>\r\n<font color=red>3.- Se encuentra en el corcho la tira de artículos del \"Inventario en bodega sin exhibición\" actualizada (no tiene más de 7 días desde su impresión).</font><br><br>\r\n<font color=red>4.- Existe el formato de responsable por Lego evaluado correctamente en el corcho operativo. Se agrega la tira de resumen de cambios todos los lunes.</font>', 1, 1, NULL, NULL, NOW(), NOW()),
('b7fa7bbc-3eaa-44ea-bf23-cd4ce2859106', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 18, 'Señalizaciones, Utensilios, equipos y habilitadores', 4, NULL, '1.- Se cuenta con toda la señalización (que aplique) de acuerdo al <b>Catálogo</b> de Señalización Institucional en tienda, en buen estado y colocada en los lugares correspondientes (basureros, bodega, caja, comida rápida, cuarto frio, estacionamiento, piso de venta, puerta de acceso y baños).<br><br>\r\n2.- <b>Servicios</b> (lo que aplique en plaza). Colgante de cajeros automáticos en buen estado.<br><br>\r\n3.- Anuncio de <b>tipo de cambio</b> (donde aplique) actualizado, en buen estado y colocado a la vista del cliente.<br><br>\r\n4.- Se cuenta con todos los <b>utensilios, habilitadores y equipos</b> de acuerdo al catálogo institucional y estos se encuentran en buen estado.', 1, 1, NULL, NULL, NOW(), NOW()),
('0e62de7f-655f-434a-9dbe-b01c18852c8c', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 19, 'Condiciones', 5, NULL, '1.- <b>Iluminación</b> de la Tienda (interior y exterior) de acuerdo a la hora del día. No focos y/o lámparas fundidos en exterior ni en piso de venta, bodega o cuarto frío. Anuncios (marquesina, paleta, cajeros automáticos), banqueta (plafón de marquesina, luces de pared y toldos) y estacionamiento (reflectores). Reflectores orientados hacia el estacionamiento. Acrílicos de luminarias limpios y en buen estado.<br><br>\r\n2.- <b>Exterior</b>: Basureros señalizados como orgánico e inorgánico (si aplica) y en buen estado. Marquesina sin golpes. Contenedor de basura en buen estado, con tapa  candado (si aplica) y sin graffitis. Plafones completos y no dañados. Teléfonos públicos con calcomanías bien adheridas y funcionando. Equipo de proveedores (hielo, agua, teléfonos públicos) sin graffiti y en buenas condiciones. Portabanner bien instalado y en  buen estado.<br><br>\r\n3.- <b>Equipo de Isla</b> (los que apliquen) y vidrio de escáner (si aplica) en buen estado. Refrigeradores en buen estado sin exceso de escarcha, sin lámparas fundidas y con puerta bien cerrada.<br><br>\r\n4.- <b>Piso de Venta y Bodega</b>: Temperatura ambiente en el piso de venta es agradable (si se cuenta con termostato o indicador de temperatura a la vista deberá marcar entre 22ºC y 26ºC).  En las Tiendas con aire acondicionado la puerta de acceso a la Tienda se encuentra cerrada y sólo se abre cuando entra y sale gente. Paletero sin exceso de escarcha de hielo, con rejillas despejadas, exterior en  buen estado y con calcomanías bien pegadas. Cajero automático y/o caseta telefónica (si aplican) operando correctamente y limpios. Parrilla de Punto Frío sin polvo o pelusa. Máquinas de Fast Food bebidas (café grano, frappé, capuchino) operando correctamente de acuerdo a la guía rápida de operación. Equipo de comida rápida en buen estado y termómetro (si aplica) funcionando. Máquina de hielo (si aplica en la plaza) operando correctamente, sin goteras, fugas y filtraciones de agua, depósito de hielo funcionando y limpio. Hielera de cerveza sin óxido, manchas, en  buen estado (sin roturas o decoloración), incluyendo estructura, tapas, desagüe y cubetas de desagüe. Equipo de aire acondicionado en  buen estado. Nota: los paleteros, equipos eléctricos o transformadores se encuentran separados al menos 10 cm de la pared u otros objetos. Sin reguladores de voltaje en piso de venta. Góndola mercancías generales (Novelty) o exhibidor pentagonal exhibido en piso de venta de acuerdo al layout de tienda , en buen estado, limpio y con su material POP instalado. Mobiliario de madera en buen estado. Bomba de agua funcionando. Equipo de cómputo en bodega (si aplica) instalado correctamente con base en lo definido. Paredes, ventanas, extractores, plafones y rejilla de aire acondicionado limpios y en buen estado Plafones no rotos o dañados, ni huecos en el techo por falta del mismo. Góndolas en  buen estado  y no despintadas. Pisos no quebrados, despostillados o manchados. Puerta principal en buen estado operando correctamente. Sin manchas por filtraciones en paredes ni goteras en el techo. Mesas/barras y bancos/sillas de Comida Rápida en buen estado. Sin restos de alimentos, basura o  insectos/fauna en el área de comida y Tienda. Con certificado de fumigación vigente. Puerta de bodega en buen estado cerrando correctamente, con cubre polvos y sin huecos o aberturas en sus lados. Sin mercancía, equipo o productos en la parte superior del Cuarto Frío.  Tarja y pileta limpia y en buen estado. Disponibilidad de agua para la operación. Drenaje y fosa séptica de la Tienda en buen estado, sin tuberías o coladeras abiertas y expuestas. Ventanas o rejillas de bodega con malla protectora. Sin huecos en las paredes e instalaciones eléctricas.<br><br>\r\n5.- Refrigerador de hielo \"del proveedor\" (la perilla debe encontrarse en el punto medio del rango del termostato). En Cuarto Frío, (incluyendo cámaras de hielo), la temperatura está dentro de rango establecido, verificar que los difusores estén libres de hielo. Verificar que no haya ruido excesivo o fuera de lo normal en los motores, ni fugas de aire  o agua en las cámaras. Al abrir completamente las puertas se mantienen abiertas; en caso contrario deben cerrarse por sí mismas a \"presión\" (que cierren \"de regreso\"). Puertas no desniveladas.  Empaques de las puertas en buen estado. Existencia de cortina de PVC (hawaiana) limpia y en buen estado. En caso de contar con máquina de hielo que esté en buen estado, la puerta debe permanecer cerrada cuando no se utilice y las rejillas de ventilación despejadas. Parrillas y deslizadores en buen estado. Parrillas no oxidadas. Sólo exhibidores y productos autorizados para el cuarto frío. Nota: no colocar cartones, acrílicos o algún otro material en las parrillas. Productos ordenados (apilados a una distancia mínima de 40 cms. de las parrillas y difusores). Las parrillas tienen la inclinación correcta (multiempaque cero inclinación, productos chicos nivel 2, productos medianos nivel 1 o 2 y productos grandes nivel 1). En parrillas combinadas se usa el acrílico y la inclinación del producto más grande.  Aplicación del 5S + 1 en cuarto frío.<br><br>\r\n6.- <b>Baños</b> de Empleados y Públicos, Inodoro, mingitorio, lavamanos, porta rollo, papel para secar las manos y jabonera, funcionando y en óptimas condiciones (sin fuga de agua, roturas, astillados, quebrados). Inodoro con asiento de acuerdo al tamaño y forma del inodoro, no roto, y funcionando correctamente. Piso no quebrado ni despostillado. Puerta de acceso y/o puerta de baño operando correctamente y funcionando la chapa y el seguro.', 1, 1, NULL, NULL, NOW(), NOW()),
('ecfdfed9-25ef-47a7-ad3f-4f21d4faa6c8', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 20, 'Seguridad y Prevención', 6, NULL, '1.-<b>Sistemas de seguridad</b> funcionando correctamente como CCTV (cámaras de seguridad), lámparas de emergencia y alarmas, así como chapas de puertas funcionando correctamente. Extintores vigentes. Existe un botiquín de primeros auxilios con producto en buen estado y completo.<br><br>\r\n2.- <b>Resguardo</b> de Productos de Alto Riesgo (paquetes de cigarros, vinos, celulares y tarjetas excedentes) en la herramienta de resguardo (jaula, bóveda o gaveta de resguardo) y exhibidor de celulares y tecnología bajo llave.<br><br>\r\n3.- No se deberán dejar paquetes de <b>cigarros</b> en cualquier otro lugar que no sea el exhibidor de cigarros.<br><br>\r\n4.- Prevención de <b>Extorsiones</b>: Ningún empleado o persona externa puede solicitar realizar transacciones electrónica (TAE, corresponsalías, etc...) vía telefónica<br><br>\r\n5.- <b>Calcomanías</b> preventivas en buen estado (número de Centro de Control, CCTV, Avisos de Privacidad, otras) en caso de que estas presenten desgaste o no se tengan en Tienda, solicitar por medio de  ATL o Protección Patrimonial.', 1, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Mensuales
('843982b3-4283-40f2-95d4-e4e41522110d', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 21, 'Revisión Vertical', 1, NULL, '1.- Se tiene Revisión Vertical trimestral con cada empleado.', 1, 1, NULL, NULL, NOW(), NOW()),
('0e0303a5-63ce-4d57-a3c0-0c31ec0abe78', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 22, 'Dinámica de Cultura', 2, NULL, '1.- Se tiene <b>Dinámica de Cultura</b> bimestral con los empleados. Se da vida y se busca la mejora en base a los dialogos sostenidos. Se logra participación de todos y se llega a acuerdos.', 1, 1, NULL, NULL, NOW(), NOW()),
('eac5bd69-9b04-4c52-aa7f-9ed598608350', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 23, 'Rituales de Gestión', 3, NULL, '1.- <b>Asesor-Líder de Tienda</b> se coordinan acciones con enfoque al incremento de Ventas de la Plaza con el apoyo de los Asesores Tienda, así como también la revisión de proyectos e iniciativas de la Plaza.<br><br>\r\n2.- <b>Líder-Equipo de Tienda</b> se están realizando de forma constante revisando oportunidades y generando plan de acción. \r\nSe da cumplimiento, seguimiento y hay avance en el <b>plan de acción</b> de la tienda.', 1, 1, NULL, NULL, NOW(), NOW()),
('357b70fa-50bf-466b-bd8c-8cd08d5aad66', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'E', NULL, NULL, 24, 'Evaluaciones', 4, 'Ev operativa y Scorecard de ejecución', '1.- <b>Lider de Tienda</b> realiza <b>evaluación operativa</b> de su Tienda dentro de los primeros 25 días del mes, evaluando la historia de las últimas 4 semanas de la Tienda.<br><br>\r\n2.- <b>Líder de Tienda</b> realiza evaluación de <b>Scorecard de ejecución</b> dentro de los primeros 25 días del mes.', 1, 1, NULL, NULL, NOW(), NOW());
--
-- Volcado de datos para la tabla `xxbdo_areas_estandares`
-- Insertar registros de area-estandares diarios vNexxo
INSERT INTO `xxbdo_areas_estandares` (`id`, `xxbdo_areas_id`, `xxbdo_estandares_id`, `valor`, `orden`, `dias_activos`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
-- Estandares Diarios - Servicio
('6ae21935-0c62-45b4-a24f-84260272029f', 'c00b4101-6d6e-437b-aeb3-4d2003b66e35', 'd1fd38a0-6086-42aa-bc47-56ec3ba98197', 0, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('b2c37637-33b0-4d5a-995d-8a4fb015fad0', 'c00b4101-6d6e-437b-aeb3-4d2003b66e35', '52dd7a42-4499-41ea-a673-61bfecafbb58', 0, 3, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- Estandares Diarios - Ingreso
('6709305d-dcf6-4ca9-b9b5-e5611dc4ca69', '99eeb51f-930b-4601-8c7c-7a61311983fc', '339372b7-2b08-445f-aac5-cc07a175317f', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- Estandares Diarios - Gente
('77a900a2-bb40-4e80-9e84-384501475a47', 'e9160e68-a4e2-463a-a305-71c16252f393', '82c7ee00-9f85-43ba-8edd-d589df96f130', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('8ea26335-27cb-43da-a90d-c97c24091358', 'e9160e68-a4e2-463a-a305-71c16252f393', 'd321a40f-847c-4e8d-b17e-d628999e2449', 0, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- Estandares Diarios - Ejecución
('1df617f8-8676-4b1b-b667-f414044b6302', '829ed6aa-4965-43f2-b661-d269bc36a685', 'da73ab7e-cbbe-4ce5-9d4b-555298d0024a', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('e9dcef1f-db4c-4b9e-b1fa-be32f2898d26', '829ed6aa-4965-43f2-b661-d269bc36a685', '6fc69885-e1f7-48e6-b226-aacbd98f35a2', 0, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('3215c476-23a9-40d8-9203-bb12bed5a9dc', '829ed6aa-4965-43f2-b661-d269bc36a685', '8bc82813-3ed0-459d-a1bb-f0dcaf524300', 0, 3, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('11b70b51-a231-481e-bc13-9cb6c42fe92f', '829ed6aa-4965-43f2-b661-d269bc36a685', '2cd92cf6-08cf-4a42-ba80-5faf3b447fd4', 0, 4, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('463437b2-32cb-4c2e-be0c-8c94de4278da', '829ed6aa-4965-43f2-b661-d269bc36a685', 'c1e11e5d-ac2d-4a80-8cb0-9177a8d8249c', 0, 5, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('4cc50d05-d80e-4202-91ba-db5532205b02', '829ed6aa-4965-43f2-b661-d269bc36a685', '6f6b7f28-1711-4fb0-8ac6-8fdd4f2fd9cf', 0, 6, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('c150ce14-ef5c-47fc-850c-5e0a537e16d8', '829ed6aa-4965-43f2-b661-d269bc36a685', '6ae06442-1544-4a5a-9f3a-bcc5a87711e6', 0, 7, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- Estandares Diarios - Cliente
('8458bbde-fafb-4651-a983-28e65f8b3eba', 'deb5bbcf-910a-46a2-a3a2-1fc788c38d40', '21469197-833c-4e11-a1e2-346e6b4123a6', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('93074a1f-5aef-492c-990b-dec3d860d3fd', 'deb5bbcf-910a-46a2-a3a2-1fc788c38d40', 'ab9e5aff-2dfe-4062-9fb1-3f1f5980ee5c', 0, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- -----------------------------------
-- 
-- Estandares Semanales - Indicadores
('4888202b-315f-4da3-b922-b53356549386', '60b89d25-19a6-4426-a983-1320827edc88', '505ffd8c-daa0-4863-9aca-9385b01bb035', 1, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('4c2ca198-ddeb-4623-a9b0-cc14c5efe076', '60b89d25-19a6-4426-a983-1320827edc88', '8a1e9e51-5937-49dd-ae5c-3e833e84a46d', 1, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('cbfaca95-be37-4521-a335-e29f10587909', '60b89d25-19a6-4426-a983-1320827edc88', '88468aac-3d20-4c03-8bfc-b6461f019b62', 1, 3, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('dc17828c-37ce-4b48-b71d-24a71ad28abd', '60b89d25-19a6-4426-a983-1320827edc88', 'b7fa7bbc-3eaa-44ea-bf23-cd4ce2859106', 1, 4, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- Estandares Semanales - Mantenimiento
('dd35bd58-831b-4843-be77-00e6c52869fc', '4f17f8ad-48c7-49f8-ae3e-d4905782516e', '0e62de7f-655f-434a-9dbe-b01c18852c8c', 1, 5, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('1e998c13-744a-4f5e-9f96-90697093bfaa', '4f17f8ad-48c7-49f8-ae3e-d4905782516e', 'ecfdfed9-25ef-47a7-ad3f-4f21d4faa6c8', 1, 6, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- ------------------------------------
-- Estandares Mensuales - Cultura
('e6e632b1-33a2-4392-996f-7a77beca132d', '552949e1-3c9d-4859-8186-67604f6c0f31', '843982b3-4283-40f2-95d4-e4e41522110d', 1, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('dabf79de-82d8-42b9-ac90-12424bb00208', '552949e1-3c9d-4859-8186-67604f6c0f31', '0e0303a5-63ce-4d57-a3c0-0c31ec0abe78', 1, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('60f31743-a141-4d6e-81fc-f108d6593e02', '552949e1-3c9d-4859-8186-67604f6c0f31', 'eac5bd69-9b04-4c52-aa7f-9ed598608350', 1, 3, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('6b624f1a-fe51-48fd-9ff4-e95f4e486793', '552949e1-3c9d-4859-8186-67604f6c0f31', '357b70fa-50bf-466b-bd8c-8cd08d5aad66', 1, 4, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW());
-- ------------------------------------

-- Insertar registros de checklist-area-estandares diarios/semanales/mensuales vNexxo:
INSERT INTO `xxbdo_checklists_has_areas_estandares` (`xxbdo_checklists_id`, `xxbdo_areas_estandares_id`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('7131ed27-5733-47e9-ad86-83cac29e9288', '6ae21935-0c62-45b4-a24f-84260272029f', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'b2c37637-33b0-4d5a-995d-8a4fb015fad0', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '6709305d-dcf6-4ca9-b9b5-e5611dc4ca69', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '77a900a2-bb40-4e80-9e84-384501475a47', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '8ea26335-27cb-43da-a90d-c97c24091358', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '1df617f8-8676-4b1b-b667-f414044b6302', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'e9dcef1f-db4c-4b9e-b1fa-be32f2898d26', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '3215c476-23a9-40d8-9203-bb12bed5a9dc', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '11b70b51-a231-481e-bc13-9cb6c42fe92f', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '463437b2-32cb-4c2e-be0c-8c94de4278da', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '4cc50d05-d80e-4202-91ba-db5532205b02', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'c150ce14-ef5c-47fc-850c-5e0a537e16d8', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '8458bbde-fafb-4651-a983-28e65f8b3eba', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '93074a1f-5aef-492c-990b-dec3d860d3fd', 1, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Semanales
('7131ed27-5733-47e9-ad86-83cac29e9288', '4888202b-315f-4da3-b922-b53356549386', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '4c2ca198-ddeb-4623-a9b0-cc14c5efe076', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'cbfaca95-be37-4521-a335-e29f10587909', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'dc17828c-37ce-4b48-b71d-24a71ad28abd', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'dd35bd58-831b-4843-be77-00e6c52869fc', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '1e998c13-744a-4f5e-9f96-90697093bfaa', 1, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Mensuales
('7131ed27-5733-47e9-ad86-83cac29e9288', 'e6e632b1-33a2-4392-996f-7a77beca132d', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'dabf79de-82d8-42b9-ac90-12424bb00208', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '60f31743-a141-4d6e-81fc-f108d6593e02', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '6b624f1a-fe51-48fd-9ff4-e95f4e486793', 1, 1, NULL, NULL, NOW(), NOW());
-- queries para cambiar checklist default de tiendas:
-- obtener current checklist de v23 = 3e50f58c-8634-41ce-93b5-c8bebb8bce46 
UPDATE `xxbdo_checklists_tiendas` SET es_default=0 WHERE xxbdo_checklists_id='3e50f58c-8634-41ce-93b5-c8bebb8bce46';
INSERT INTO `xxbdo_checklists_tiendas` SELECT '7131ed27-5733-47e9-ad86-83cac29e9288' AS cid, `cr_plaza`, `cr_tienda`, '1' AS `es_default`, '1' AS `activo`, 'adrian.zenteno.ext@oxxo.com' AS `usuario`, NULL AS  `ip_address`, NOW(), NOW() FROM `xxbdo_checklists_tiendas` WHERE `xxbdo_checklists_id`='3e50f58c-8634-41ce-93b5-c8bebb8bce46';

-- query para insertar registros en xxbdo_tiendas_has_areas_estandares:
INSERT INTO `xxbdo_tiendas_has_areas_estandares` 
SELECT `xxbdo_checklists_tiendas`.`cr_plaza`, 
`xxbdo_checklists_tiendas`.`cr_tienda`, 
`xxbdo_checklists_tiendas`.`xxbdo_checklists_id`, 
`xxbdo_checklists_has_areas_estandares`.`xxbdo_areas_estandares_id`,
NULL AS `grupos_id`,
1 AS `es_visible`,
1 AS `activo`,
'adrian.zenteno.ext@oxxo.com' AS `usuario`, 
NULL AS `ip_address`,
NOW() AS `fecha_creacion`,
NOW() AS `fecha_modificacion` 
FROM `xxbdo_checklists_tiendas`,
`xxbdo_checklists_has_areas_estandares`  
WHERE `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`='7131ed27-5733-47e9-ad86-83cac29e9288' 
AND `xxbdo_checklists_has_areas_estandares`.`xxbdo_checklists_id` = `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`;

-- ---------------------------------------------------------
--
-- Volcado de datos para la tabla `xxbdo_indicadores`
--
INSERT INTO `xxbdo_indicadores` (`id`, `xxbdo_version_estandares_id`, `tipo`, `cr_plaza`, `cr_tienda`, `titulo`, `descripcion`, `xxbdo_indicadores_frecuencias_id`, `orden`, `tipo_dato`, `default`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
-- ---------------------------------------------
-- Indicadores Semanales de Estándares Diarios:
-- ---------------------------------------------
-- -- Ingreso - Control
('e64d54a6-7306-4852-bb23-60d228755b50', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Conteos', 'Conteos', 'S', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),
('864ce17f-52d8-46ff-8da0-a0f5a4245579', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Cobertura', 'Cobertura (Indicador de tipo porcentaje)', 'S', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Gente - Manejo de Gente
('eb3d8624-8ad3-42a8-a172-5b70142a3441', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Vector Gente', 'Vector Gente', 'S', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Ejecución - Comida Rápida
('7ec1533d-5141-4ee0-8ebd-43cf3a61268c', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Exhibición Real Americano', 'Exhibición Real Americano (Indicador de tipo porcentaje)', 'S', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
('adab0efc-5c9d-49be-b106-749ab0b14020', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Exhibición Real Roller', 'Exhibición Real Roller (Indicador de tipo Porcentaje)', 'S', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
('6a514af2-f93f-4f70-8d66-dd266f9ed4f0', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Veracidad de Inventarios', 'Veracidad de Inventarios', 'S', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),
('2b46b81b-087b-4d37-84c5-e8230b3df8ba', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, '% Cumplimiento a devoluciones diarias', 'Porcentaje de cumplimiento a devoluciones diarias (Indicador de tipo Porcentaje)', 'S', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Cliente - Venta Sugerida
('b1f45640-b002-429a-a3c4-f5f247fba287', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Venta sugerida', 'Venta sugerida (Indicador de tipo monetario)', 'S', NULL, 'money', '0.00', 1, NULL, NULL, NOW(), NOW()),
('6d9d5b29-5baf-4190-9023-f6a691280ed5', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Usuarios activos', 'Usuarios activos', 'S', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Cliente - Ambientación, Seguridad
('5a857865-50a4-4194-83d9-67b3098b4f13', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Ev. 5S + 1', 'Ev. 5S + 1', 'S', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),
-- ---------------------------------------------
-- Indicadores Mensuales de Estándares Diarios:
-- ---------------------------------------------
-- -- Servicio - Imagen y comportamiento
('00a1126c-6a87-409c-8f1f-5536af51e207', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Ev. Operativa Sección Atención', 'Ev. Operativa Sección Atención', 'M', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Servicio - Atención al cliente
('87288270-668d-4996-93a9-d47ce3d007a6', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Protocolo de Servicio', 'Protocolo de Servicio', 'M', NULL, 'int', '0', 0, NULL, NULL, NOW(), NOW()),
('af5bcdeb-33e8-43e5-b9d2-8052d6765cc1', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Ev. Operativa Sección Rapidez', 'Ev. Operativa Sección Rapidez (indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Ingreso - Control
('342dda3f-4514-4266-a168-493125a7ea83', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Resultado de Inventario', 'Resultado de Inventario (Indicador de tipo monetario)', 'M', NULL, 'money', '0.00', 1, NULL, NULL, NOW(), NOW()),
('c44a15bf-ef47-4222-9b13-734b61eb2083', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Scorecard preinventarios/ Entrega de Valores', 'Scorecard preinventarios/ Entrega de Valores (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Gente - Habilitación Equipo de Tienda
('5317bc5e-9dc8-4855-a5f3-c8bdc584131e', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Equipos Completos', 'Equipos Completos (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
('7fb127d6-9851-465b-a741-b7567a8e76ed', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Equipos Capacitados', 'Equipos Capacitados (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Gente - Manejo de Gente
('e280bd02-9070-4fcd-a69a-7eddd4a9cfdf', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Rotación', 'Rotación', 'M', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Ejecución - Limpieza
('fbeca7fa-044f-485a-bb7f-ce611f6ef0e3', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Ev. Operativa Sección Limpieza', 'Ev. Operativa Sección Limpieza (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Ejecución - Exhibición
('c11e7a35-49de-4a4c-9bd1-28b16cb0de65', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Planogramas (Charola/Mueble)', 'Planogramas (Charola/Mueble) (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
('760bd87c-9030-4b87-994d-901d2e28b230', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'MEP P.P.', 'MEP P.P. (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Ejecución - Condiciones y calidad del producto
('a88e0093-6cab-426a-8428-b7b750c2167b', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Scorecard Calidad de Producto', 'Scorecard Calidad de Producto (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
('ca0d7934-9a27-450f-baf1-7f3c61a46482', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Ev. Operativa Sección Abasto', 'Ev. Operativa Sección Abasto (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Ejecución - Etiqueteo
('fd4d0d05-b34f-485c-8cfd-44e5e6e67468', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Scorecard Etiqueteo', 'Scorecard Etiqueteo (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Ejecución - Comida Rápida
('bcaf848b-c82f-427f-bc1b-677e22cb43e5', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Ev. Donas a Granel', 'Ev. Donas a Granel (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Ejecución - Cuarto Frío
('44d8a502-a887-4d9c-8edd-93924e47f5c3', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'Ev. Operativa Puntos Cuarto Frío', 'Ev. Operativa Puntos Cuarto Frío (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
-- -- Ejecución - Promociones
('7e213e5c-c810-484b-817f-4e43c73c7e99', 'a74a4a3f-20e1-44e3-aadd-354647fd8210', 'I', NULL, NULL, 'MEP POP', 'MEP POP (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW());

-- Insertar relacion de areas_estandares + indicadores:
INSERT INTO `xxbdo_areas_estandares_indicadores` (`id`, `xxbdo_areas_estandares_id`, `xxbdo_indicadores_id`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
-- -- Std # 3 - Indicador Semanal: Conteos
('bd29c0a3-9090-4f52-abe4-da649072fe65', '6709305d-dcf6-4ca9-b9b5-e5611dc4ca69', 'e64d54a6-7306-4852-bb23-60d228755b50', 1, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 3 - Indicador Semanal: Cobertura
('9102bf40-c488-4db9-9a10-a2865da71521', '6709305d-dcf6-4ca9-b9b5-e5611dc4ca69', '864ce17f-52d8-46ff-8da0-a0f5a4245579', 2, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 5 - Indicador Semanal: Vector Gente
('3a0b881e-415d-4e5d-a104-cdfcfdb3e041', '8ea26335-27cb-43da-a90d-c97c24091358', 'eb3d8624-8ad3-42a8-a172-5b70142a3441', 3, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 10 - Indicador Semanal: Exhibición Real Americano
('b5b60a48-b143-4ca1-bca1-c6270b888d35', '463437b2-32cb-4c2e-be0c-8c94de4278da', '7ec1533d-5141-4ee0-8ebd-43cf3a61268c', 4, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 10 - Indicador Semanal: Exhibición Real Roller
('b29eaa58-24e3-4776-9d59-32193b44542e', '463437b2-32cb-4c2e-be0c-8c94de4278da', 'adab0efc-5c9d-49be-b106-749ab0b14020', 5, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 10 - Indicador Semanal: Veracidad de Inventarios
('3299063d-fbb6-4038-8b23-9460798a9fac', '463437b2-32cb-4c2e-be0c-8c94de4278da', '6a514af2-f93f-4f70-8d66-dd266f9ed4f0', 6, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 10 - Indicador Semanal: % Cumplimiento a devoluciones diarias
('55620672-c3c5-4567-90fb-8b708e5c9411', '463437b2-32cb-4c2e-be0c-8c94de4278da', '2b46b81b-087b-4d37-84c5-e8230b3df8ba', 7, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 13 - Indicador Semanal: Venta Sugerida
('e40a4a40-5353-4ec6-ad02-e4212401bebd', '8458bbde-fafb-4651-a983-28e65f8b3eba', 'b1f45640-b002-429a-a3c4-f5f247fba287', 8, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 13 - Indicador Semanal: Usuarios activos
('18e252a2-7cc9-40cc-a318-d15fddd15d2d', '8458bbde-fafb-4651-a983-28e65f8b3eba', '6d9d5b29-5baf-4190-9023-f6a691280ed5', 9, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 14 - Indicador Semanal: Ev. 5S + 1
('35cbcfff-6318-4c6d-9645-fad25ea4b71e', '93074a1f-5aef-492c-990b-dec3d860d3fd', '5a857865-50a4-4194-83d9-67b3098b4f13', 10, 1, NULL, NULL, NOW(), NOW()),
-- -------------------------------
-- -- Std # 1 - Indicador Mensual: Ev. Operativa Sección Atención
('c1845a55-d672-4c50-8161-02ca023b18a7', '6ae21935-0c62-45b4-a24f-84260272029f', '00a1126c-6a87-409c-8f1f-5536af51e207', 1, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 2 - Indicador Mensual: Protocolo de Servicio
('ab82e8d6-5737-4b63-ac7c-b170bc84a992', 'b2c37637-33b0-4d5a-995d-8a4fb015fad0', '87288270-668d-4996-93a9-d47ce3d007a6', 2, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 2 - Indicador Mensual: Ev. Operativa Sección Rapidez
('223dae5f-1c57-48ea-9607-fc0be9729e43', 'b2c37637-33b0-4d5a-995d-8a4fb015fad0', 'af5bcdeb-33e8-43e5-b9d2-8052d6765cc1', 3, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 3 - Indicador Mensual: Resultado de Inventario
('bf4244aa-2e37-418f-87af-90cea6e79120', '6709305d-dcf6-4ca9-b9b5-e5611dc4ca69', '342dda3f-4514-4266-a168-493125a7ea83', 4, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 3 - Indicador Mensual: Scorecard preinventarios
('b6d86340-a670-4612-9914-931ad8d9f1ec', '6709305d-dcf6-4ca9-b9b5-e5611dc4ca69', 'c44a15bf-ef47-4222-9b13-734b61eb2083', 5, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 4 - Indicador Mensual: Equipos completos 
('74bec862-1986-483b-ae4d-e855d922fa05', '77a900a2-bb40-4e80-9e84-384501475a47', '5317bc5e-9dc8-4855-a5f3-c8bdc584131e', 6, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 4 - Indicador Mensual: Equipos capacitados
('a9a9f967-9319-43f1-bc87-74eafa539d43', '77a900a2-bb40-4e80-9e84-384501475a47', '7fb127d6-9851-465b-a741-b7567a8e76ed', 7, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 5 - Indicador Mensual: Rotación
('736ddb09-ae50-42e2-baa5-8c61332eb922', '8ea26335-27cb-43da-a90d-c97c24091358', 'e280bd02-9070-4fcd-a69a-7eddd4a9cfdf', 8, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 6 - Indicador Mensual: Ev. Operativa Sección Limpieza
('e8da2f0b-1e0b-4ece-8291-f81caf226f29', '1df617f8-8676-4b1b-b667-f414044b6302', 'fbeca7fa-044f-485a-bb7f-ce611f6ef0e3', 9, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 7 - Indicador Mensual: Planogramas(Charola/Mueble)
('19e78cf0-6cf8-4713-adfd-7f467a244fee', 'e9dcef1f-db4c-4b9e-b1fa-be32f2898d26', 'c11e7a35-49de-4a4c-9bd1-28b16cb0de65', 10, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 7 - Indicador Mensual: MEPP P.P.
('a437c554-d6f4-45f6-9df0-d043cf54663b', 'e9dcef1f-db4c-4b9e-b1fa-be32f2898d26', '760bd87c-9030-4b87-994d-901d2e28b230', 11, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 8 - Indicador Mensual: Scorecard calidad de producto
('ac4c26d9-febf-4f58-9909-b45311a8e8ec', '3215c476-23a9-40d8-9203-bb12bed5a9dc', 'a88e0093-6cab-426a-8428-b7b750c2167b', 12, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 8 - Indicador Mensual: Ev. Operativa sección abasto
('96ea3ceb-0acb-4338-9ec0-649bfe18a8d5', '3215c476-23a9-40d8-9203-bb12bed5a9dc', 'ca0d7934-9a27-450f-baf1-7f3c61a46482', 13, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 9 - Indicador Mensual: Scorecard Etiqueteo
('585e144d-fb49-42df-b861-5495c4e98afe', '11b70b51-a231-481e-bc13-9cb6c42fe92f', 'fd4d0d05-b34f-485c-8cfd-44e5e6e67468', 14, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 10 - Indicador Mensual: Ev. Donas a Granel
('fada4c05-fbf4-45d0-b3dc-937a3c172550', '463437b2-32cb-4c2e-be0c-8c94de4278da', 'bcaf848b-c82f-427f-bc1b-677e22cb43e5', 15, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 11 - Indicador Mensual: Ev. Operativa Puntos Cuarto Frío
('64b23d85-dbef-4a87-b857-ff51697ed0bc', '4cc50d05-d80e-4202-91ba-db5532205b02', '44d8a502-a887-4d9c-8edd-93924e47f5c3', 16, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 12 - Indicador Mensual: MEP POP
('1c4b7319-1920-43aa-bd82-50638a0441bd', 'c150ce14-ef5c-47fc-850c-5e0a537e16d8', '7e213e5c-c810-484b-817f-4e43c73c7e99', 17, 1, NULL, NULL, NOW(), NOW());

-- query para insertar registros en xxbdo_checklists_has_areas_estandares_indicadores
INSERT INTO `xxbdo_checklists_has_areas_estandares_indicadores` (`xxbdo_checklists_id`, `xxbdo_areas_estandares_indicadores_id`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('7131ed27-5733-47e9-ad86-83cac29e9288', 'c1845a55-d672-4c50-8161-02ca023b18a7', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'ab82e8d6-5737-4b63-ac7c-b170bc84a992', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '223dae5f-1c57-48ea-9607-fc0be9729e43', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'bd29c0a3-9090-4f52-abe4-da649072fe65', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '9102bf40-c488-4db9-9a10-a2865da71521', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'bf4244aa-2e37-418f-87af-90cea6e79120', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'b6d86340-a670-4612-9914-931ad8d9f1ec', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '74bec862-1986-483b-ae4d-e855d922fa05', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'a9a9f967-9319-43f1-bc87-74eafa539d43', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '736ddb09-ae50-42e2-baa5-8c61332eb922', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '3a0b881e-415d-4e5d-a104-cdfcfdb3e041', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'e8da2f0b-1e0b-4ece-8291-f81caf226f29', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '19e78cf0-6cf8-4713-adfd-7f467a244fee', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'a437c554-d6f4-45f6-9df0-d043cf54663b', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'ac4c26d9-febf-4f58-9909-b45311a8e8ec', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '96ea3ceb-0acb-4338-9ec0-649bfe18a8d5', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '585e144d-fb49-42df-b861-5495c4e98afe', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'fada4c05-fbf4-45d0-b3dc-937a3c172550', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'b5b60a48-b143-4ca1-bca1-c6270b888d35', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'b29eaa58-24e3-4776-9d59-32193b44542e', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '3299063d-fbb6-4038-8b23-9460798a9fac', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '55620672-c3c5-4567-90fb-8b708e5c9411', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '64b23d85-dbef-4a87-b857-ff51697ed0bc', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '1c4b7319-1920-43aa-bd82-50638a0441bd', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', 'e40a4a40-5353-4ec6-ad02-e4212401bebd', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '18e252a2-7cc9-40cc-a318-d15fddd15d2d', 1, 1, NULL, NULL, NOW(), NOW()),
('7131ed27-5733-47e9-ad86-83cac29e9288', '35cbcfff-6318-4c6d-9645-fad25ea4b71e', 1, 1, NULL, NULL, NOW(), NOW());

-- query para insertar registros en xxbdo_tiendas_has_areas_estandares_indicadores:
INSERT INTO `xxbdo_tiendas_has_areas_estandares_indicadores` 
SELECT `xxbdo_checklists_tiendas`.`cr_plaza`, 
`xxbdo_checklists_tiendas`.`cr_tienda`, 
`xxbdo_checklists_tiendas`.`xxbdo_checklists_id`, 
`xxbdo_checklists_has_areas_estandares_indicadores`.`xxbdo_areas_estandares_indicadores_id`,
1 AS `es_visible`,
1 AS `activo`,
'adrian.zenteno.ext@oxxo.com' AS `usuario`, 
NULL AS `ip_address`,
NOW() AS `fecha_creacion`,
NOW() AS `fecha_modificacion` 
FROM `xxbdo_checklists_tiendas`,
`xxbdo_checklists_has_areas_estandares_indicadores`  
WHERE `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`='7131ed27-5733-47e9-ad86-83cac29e9288' 
AND `xxbdo_checklists_has_areas_estandares_indicadores`.`xxbdo_checklists_id` = `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`;
