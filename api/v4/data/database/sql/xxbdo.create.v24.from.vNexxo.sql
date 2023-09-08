
-- query para cerrar BDO version Nexxo, change fecha_fin as required:
UPDATE `xxbdo_version_estandares` 
SET `es_default` = '0', 
`fecha_fin` = '2020-02-29' 
WHERE `xxbdo_version_estandares`.`id` = 'a74a4a3f-20e1-44e3-aadd-354647fd8210';

-- query para cerrar checklist vesion Nexxo:
UPDATE `xxbdo_checklists` 
SET `fecha_fin` = '2020-02-29', 
`es_default` = '0' 
WHERE `xxbdo_checklists`.`id` = '7131ed27-5733-47e9-ad86-83cac29e9288';

-- insertar registro de nueva version v24
INSERT INTO `xxbdo_version_estandares` (`id`, `titulo`, `titulo_app`, `descripcion`, `es_default`, `fecha_inicio`, `fecha_fin`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'Estandares Operativos Versión 24', 'Versión 24', 'Estandares Operativos Versión 24', 1, '2020-03-01', NULL, 1, NULL, NULL, NOW(), NOW());

-- insertar registro de checklist v24: 
INSERT INTO `xxbdo_checklists` (`id`, `xxbdo_version_estandares_id`, `titulo`, `descripcion`, `titulo_app`, `titulo_indicadores_app`, `fecha_inicio`, `fecha_fin`, `es_default`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) 
VALUES ('c98336f8-cf56-4a30-909a-42b592928219', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'Estándares Operativos Versión 24', 'Estándares Operativos Versión 24', 'BITACORA v24', 'INDICADORES v24', '2020-03-01', NULL, 1, 1, NULL, NULL, NOW(), NOW());

--
-- Volcado de datos para la tabla `xxbdo_areas`
-- Insertar registro de areas de estandares diarios vNexxo:
INSERT INTO `xxbdo_areas` (`id`, `xxbdo_version_estandares_id`, `xxbdo_areas_grupos_id`, `titulo`, `descripcion`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
-- Estandares Diarios
('1b7ea94a-9914-4bb3-b7d6-d8e8b1861777', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', 'Servicio', 'Servicio', 1, 1, NULL, NULL, NOW(), NOW()),
('3cf78e75-ad58-4364-a90a-a5d06a1acd42', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', 'Ingreso', 'Ingreso', 2, 1, NULL, NULL, NOW(), NOW()),
('bbc01530-1401-484d-8b2b-0418b17f6a13', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', 'Gente', 'Gente', 3, 1, NULL, NULL, NOW(), NOW()),
('018e59f2-b950-4340-b8dc-6cee7171e975', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', 'Ejecución', 'Ejecución', 4, 1, NULL, NULL, NOW(), NOW()),
('7733e43b-19e4-4860-bfcd-73a9cee1d6ea', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', 'Cliente', 'Cliente', 5, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Semanales
('23c00046-77bf-4527-832b-b03c0c0968a3', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', '698d2abc-daad-4398-89e9-ad92fca812ae', 'Indicadores', 'Indicadores', 1, 1, NULL, NULL, NOW(), NOW()),
('1bdc2857-54ec-4ec6-9dd2-5e3360f608f2', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', '698d2abc-daad-4398-89e9-ad92fca812ae', 'Mantenimiento', 'Mantenimiento', 2, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Mensuales
('1380cce4-1495-4ff3-bd08-285bced3b540', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'ad642ddf-3050-4284-8f1b-42604d38f164', 'Cultura', 'Cultura', 1, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Libres
('2c7cbdec-c599-461a-a12c-ca4a639f4c72', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', '86392947-9a57-46c0-a16f-f2f4e5c0745d', 'Libre', 'Estándar Libre', 10, 1, NULL, NULL, NOW(), NOW());

--
-- Volcado de datos para la tabla `xxbdo_estandares`
-- Insertar registros de estandares vNexxo:
INSERT INTO `xxbdo_estandares` (`id`, `xxbdo_version_estandares_id`, `tipo`, `cr_plaza`, `cr_tienda`, `estandar`, `titulo`, `orden`, `detalle`, `descripcion`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
-- Estandares Diarios
('10f81bf8-ff1b-415e-8fda-c420f1dbf914', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 1, 'Imagen y Comportamiento del personal', NULL, '- Presencia / Actitud / Comportamiento', '1.- <font color=red><b>Presencia impecable</b></font>, uniforme oficial de acuerdo a <font color\r\n=red>código de vestimenta</font> y gafete a la vista, botón promocional y/o de entrenamiento; gorra oficial sólo sí la Plaza lo autoriza.<br><br>\r\n2.- Mostrar una actitud de <b>servicio</b> hacia el cliente, proveedores y compañeros (optimista, proactivo, atento y servicial).<br><br>\r\n3.-No consumo de alimentos en isla, no uso de electrónicos laborando (especial cuidado al estar atendiendo al cliente).', 1, 1, NULL, NULL, NOW(), NOW()),
('63dbc878-8105-40d6-8cb9-2acfddce1640', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 2, 'Atención al cliente', NULL, '- Saludo / Caja adicional / PRO / No Venta Menores / Servicios / Entregar Ticket / Agradecer / Factuar / Estacionamiento/ Horarios', '1.- Ofrecer un <b>saludo</b> y trato amable al cliente durante su estancia en la tienda, dando prioridad en atenderlo, interrumpiendo actividades que se estén realizando en los dispositivos móviles.<br><br>\r\n2.- <b>Abrir caja adicional</b> al detectar más de tres clientes en fila o si se está cobrando algún servicio financiero, boletos o facturación. Todas las cajas siempre con fondo y con morralla suficiente para recibir billetes de cualquier denominación y/o realizar retiros. Colocar letrero de \"caja cerrada\" cuando la caja no esté disponible para venta.<br><br>\r\n3.- Preguntar al cliente si desea redondear (<b>PRO</b>) y mencionar la institución beneficiada en caso de que pregunte.<br><br>\r\n4.- <b>Negar la venta de alcohol y/o cigarros</b> a menores de edad o fuera del horario permitido por la ley, ante la duda de la edad del cliente, solicitar Identificación Oficial.<br><br>\r\n5.- <font color=red>Siempre intentar realizar cualquier <b>servicio electrónico</b> antes de indicar al cliente que no hay sistema. Informar el monto a pagar incluyendo comisión por servicio.</font><br><br>\r\n6.- <b>Agradecer la compra</b> y/o despedirse amablemente y/o invitar al  cliente a regresar de nuevo.<br><br>\r\n7.- Generar y entregar la <b>factura</b> cuando el cliente lo solicite (verificando que los datos son correctos) e informarle que una vez generada la factura en tienda sólo podrá generar el archivo XML en el portal web.<br><br>\r\n8.- Realizar la devolución de productos cuando el cliente así lo desee y resguardar tickets de devolución.<br><br>\r\n9.- Mantener disponibilidad de <b>estacionamiento</b> para nuestros clientes.<br><br>\r\n10.- Cumplir con los <b>horarios de apertura y cierre de tiendas</b> de acuerdo a lo establecido por la Plaza.', 1, 1, NULL, NULL, NOW(), NOW()),
('139e7f1b-ca27-4000-96c2-3e5b4dda3c3e', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 3, 'Control', NULL, '- Preinventarios / Efectivo / Merma / Devolución', '1.- <b>Preinventarios</b> según Rol definido, utilizando plantillas y enfocados según programa a los artículos de mayor faltante, artículos en promoción, eliminación de artículos frecuentes, y de alto valor. Mínimo 2,500 conteos por semana y al menos 40% de cobertura.<br><br>\r\n2.- Se realizan las entregas de turnos y cierre de caja cuadrando el <b>efectivo</b>, se realizan arqueos y se mantiene un control exacto, adicional se hace la entrega de los dispositivos móviles y sus cargadores. La tómbola no está obstruida. Retiros de efectivo según los montos establecidos en la Plaza, se depositan de inmediato en tómbola y se cumple con el llenado del Control de Depósitos. Se cuenta con la papelería necesaria para la entrega de valores (papeletas, bolsas) y la entrega se asegura contra el catálogo de custodios. Se mantiene la morralla adecuada para dar servicio a nuestros clientes (fondo fijo).<br><br>\r\n3.- <b>Merma</b> bajo control. Los productos a mermar están en una bolsa de plástico en el contenedor de merma autorizado en el cuarto frío, capturados en la pre-merma y aplicada en sistema al menos una vez por semana.<br><br>\r\n4.- Los productos con <b>devolución</b> autorizada a Cedis y proveedores, se almacenan en el contenedor  de devoluciones y/o lugar definido por el Asesor una vez aplicada la devolución en sistema. Las devoluciones a IMMEX son del 1 al 15 y se entregan en presencia del vendedor.', 1, 1, NULL, NULL, NOW(), NOW()),
('390d1816-4beb-4884-b156-10374f142e1b', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 4, 'Habilitación Equipo Tienda', NULL, '- Entienda /Servicios Financieros/ Estándares/  Clasificación / Dispositivos móviles', '1.- Equipo completo de acuerdo a tabulador, todos registrados en SADEL e IMSS, con <b>ENTIENDA completo</b>. Conocen sus beneficios así como los incentivos.<br><br>\r\n2.- <b>Servicios financieros</b> al menos un cajero habilitado por turno (aplica de 6:00 AM a 10:00 PM) usuario y contraseña sin bloqueos.  Los cajeros habilitados actualmente laboran en la tienda cuentan con la documentación personal vigente.<br><br>\r\n3.- Todos los empleados conocen y están habilitados para cumplir los <b>estándares</b> operativos, cuentan con los dispositivos móviles funcionando correctamente, siempre encendidos y en buen estado.<br><br>\r\n4.- El equipo de tienda conoce y sabe su enfoque de acuerdo a su <b>clasificación</b> de líder, está comprometido con su plan de acción y saben como imprimir sus asignaciones de tareas.', 1, 1, NULL, NULL, NOW(), NOW()),
('8fb4955e-688a-4e01-bbe4-872218262a1d', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 5, 'Manejo de gente', NULL, '- 2XTurno /Nuevo con Líder/ Hora salida/ Vacaciones /Balanceo /Descanso /Plan horario / Alimentación /Cargas de Trabajo/ Tarjeta bancaria', '1.- Contar con mínimo <b>dos empleados por turno</b>, incluyendo al Líder de Tienda.<br><br>\r\n2.- <b>Acompañamiento</b> del Líder de Tienda a empleados nuevos en los primeros 15 días.<br><br>\r\n3.- <b>Salida</b> de turno a tiempo.<br><br>\r\n4.- Cumplir con el rol anual de <b>vacaciones</b>.<br><br>\r\n5.- <b>Balanceo</b> de asignación de tareas (Sem 1 60% ; Sem 2 65% ; Sem 3 70%  y  Sem 4 75%. ) y/o ATA´s <font color=red>especiales</font>.<br><br>\r\n6.- <b>Descanso</b> semanal.<br><br>\r\n7.- <b>Plan horario</b> acordado previo al inicio de la semana, considerando en lo posible temas del personal.  En el corcho y firmado por los empleados. Se cuenta con un tiempo para tomar los alimentos (sin Chaquetín).<br><br>\r\n8.- <font color=red>Se respeta horario establecido para <b>alimentación</b></font>.<br><br>\r\n9.- <b>Cargas de trabajo</b> buscando balance.<br><br>\r\n10.- Se paga a tiempo y completo (tiempos extras, días festivos , etc.), mediante <b>tarjeta bancaria</b> proporcionada por plaza.', 1, 1, NULL, NULL, NOW(), NOW()),
('5ae71d28-c4f9-4968-a3ce-c60908fc8bdf', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 6, 'Limpieza (área de clientes)', NULL, '- Exterior/ Botes basura / Isla / Piso de Venta / Equipamiento / Frutero / Baño Clientes', '1.- <b>Exterior</b> <font color=red>en buen estado</font>. Banqueta, estacionamiento, pasillos, topes, jardinera y equipos limpios. Cajón y rampa para personas con discapacidad señalizado. Sin grafiti, lámparas limpias. Sin publicidad no autorizada. Árboles, jardineras en buen estado y pasto recortado (si aplica).<br><br>\r\n2.- Contenedor y <b>botes de basura</b> limpios con tapa, en buen estado y señalizados como Orgánico e Inorgánico, con bolsa blanca para Inorgánico y negra para Orgánico (si aplica). Bolsas con no más de 3/4 de su capacidad y área sin exceso de basura, derrames y libre de mal olor.<br><br>\r\n3.-<b>Isla</b>. El piso, los muebles y el equipo en general debe estar limpio y los cajones ordenados. Bolsas para el cliente disponibles y ordenadas. Tapete antifatiga en buen estado. Libre de volantes, <font color=red>publicidad y exhibidores no autorizados, objetos personales e información confidencial de la tienda a la vista del cliente.</font><br><br>\r\n4.- <b>Piso de venta</b> libre de bultos y cajas, mercancía solo en góndolas y exhibidores. Pisos limpios.  Tapete de entrada limpio y en buen estado. La tienda tiene un olor agradable o neutro, se encuentra libre de insectos <font color=red>y/o fauna nociva</font>.<br><br>\r\n5.- <b>Equipamiento</b>: Góndolas (cabeceras, lomo), paletero, hieleras, revisteros, exhibidores en piso de venta y racks para garrafones (incluyendo el espacio entre el piso y la base inferior de ellos) limpios.<br><br>\r\n6.- <b>Frutero</b> limpio incluyendo las charolas, sin derrames de líquidos de frutas o verduras.<br><br>\r\n7.- <b>Baño</b> con olor neutro o agradable. Inodoro, mingitorio, lavamanos, espejo, porta rollo, porta papel de manos y jabonera, paredes, piso y puerta limpios.<br><br>\r\n8.- <b>Bodega</b>. Limpieza. Tarja, paredes, piso, rack, locker y  puertas  limpios. Tener luces de bodega encendidas solo cuando sea necesario. No focos fundidos.<br><br>\r\n9.- Almacenamiento de <b>Químicos de Limpieza</b>. Los químicos de limpieza en uso deberán ser colocados en la canastilla ubicada sobre la tarja de lavado, el resto de químicos (contenedores grandes) deberán ser colocados exclusivamente en el espacio especificado (identificado con una etiqueta).<br><br>\r\n10.- <b>Dispositivos móviles de Tienda</b> no se dejan al alcance del cliente, si no se están usando se mantienen resguardados en el segundo cajón de la isla.', 1, 1, NULL, NULL, NOW(), NOW()),
('7e0ae661-3de5-40af-9047-72e7f2481db7', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 6, 'Limpieza (área interior)', NULL, '- Baño Empleados / Bodega / Químicos de Limpieza', '1.- <b>Exterior</b> <font color=red>en buen estado</font>. Banqueta, estacionamiento, pasillos, topes, jardinera y equipos limpios. Cajón y rampa para personas con discapacidad señalizado. Sin grafiti, lámparas limpias. Sin publicidad no autorizada. Árboles, jardineras en buen estado y pasto recortado (si aplica).<br><br>\r\n2.- Contenedor y <b>botes de basura</b> limpios con tapa, en buen estado y señalizados como Orgánico e Inorgánico, con bolsa blanca para Inorgánico y negra para Orgánico (si aplica). Bolsas con no más de 3/4 de su capacidad y área sin exceso de basura, derrames y libre de mal olor.<br><br>\r\n3.-<b>Isla</b>. El piso, los muebles y el equipo en general debe estar limpio y los cajones ordenados. Bolsas para el cliente disponibles y ordenadas. Tapete antifatiga en buen estado. Libre de volantes, <font color=red>publicidad y exhibidores no autorizados, objetos personales e información confidencial de la tienda a la vista del cliente.</font><br><br>\r\n4.- <b>Piso de venta</b> libre de bultos y cajas, mercancía solo en góndolas y exhibidores. Pisos limpios.  Tapete de entrada limpio y en buen estado. La tienda tiene un olor agradable o neutro, se encuentra libre de insectos <font color=red>y/o fauna nociva</font>.<br><br>\r\n5.- <b>Equipamiento</b>: Góndolas (cabeceras, lomo), paletero, hieleras, revisteros, exhibidores en piso de venta y racks para garrafones (incluyendo el espacio entre el piso y la base inferior de ellos) limpios.<br><br>\r\n6.- <b>Frutero</b> limpio incluyendo las charolas, sin derrames de líquidos de frutas o verduras.<br><br>\r\n7.- <b>Baño</b> con olor neutro o agradable. Inodoro, mingitorio, lavamanos, espejo, porta rollo, porta papel de manos y jabonera, paredes, piso y puerta limpios.<br><br>\r\n8.- <b>Bodega</b>. Limpieza. Tarja, paredes, piso, rack, locker y  puertas  limpios. Tener luces de bodega encendidas solo cuando sea necesario. No focos fundidos.<br><br>\r\n9.- Almacenamiento de <b>Químicos de Limpieza</b>. Los químicos de limpieza en uso deberán ser colocados en la canastilla ubicada sobre la tarja de lavado, el resto de químicos (contenedores grandes) deberán ser colocados exclusivamente en el espacio especificado (identificado con una etiqueta).<br><br>\r\n10.- <b>Dispositivos móviles de Tienda</b> no se dejan al alcance del cliente, si no se están usando se mantienen resguardados en el segundo cajón de la isla.', 1, 1, NULL, NULL, NOW(), NOW()),
('152ce08f-b465-44f8-9560-32e09a67865f', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 7, 'Exhibición', NULL, '- Mapa Legos/ Planograma/  Límite Altura/  Espacios ASLEP/  rotación de productos / Cigarrera/ Hieleras/ Paquetería', '1.- Los <b>planogramas</b> y exhibidores tienen la misma ubicación y tamaño que el <b>mapa de Legos</b> de la Tienda. <font color=red>Los productos colocados como indica la tira de planograma o PROMOXXO, frenteados y fondeados correctamente. En caso de no haber producto, rellenar el hueco con un ASLEP de la misma familia o con  el producto del lado.</font><br><br>\r\n2.- Los productos ubicados en la charola superior no sobrepasan 10cm del <b>límite de altura</b> de la góndola. Para botanas, abarrotes, vinos y bebidas el limite máximo es 20cm de altura.<br><br>\r\n<font color=red>3.- Contar con exhibidores de piso y hieleras acorde a inventario de espacios.</font><br><br>\r\n4.- Los productos indicados en la de tira <b>ASLEP</b> están ubicados en charolas de expulsión, exhibidores de remate o mueble definidos por la plaza en piso de venta. Todo articulo que no se pueda colocar deberá tener un folio generado.<br><br>\r\n5.- La <b>rotación de productos</b> debe de basarse en \"Lo primero que entra es lo primero que sale, \"<b>PEPS</b>\".<br><br>\r\n6.- <b>Cigarrera</b> con producto exhibido en todos sus carriles y con su respectiva comunicación de precios en cada artículo. <font color=red>Cuenta con charola promocional. Carriles y copete en buen estado (si aplica).</font><br><br>\r\n7.- <b>Hieleras</b> con producto de CCM con al menos el 50% de su capacidad, excepto viernes, sábado y domingo que debe de ocupar el 100%, exhibido de acuerdo a guía de acomodo (si aplica).<br><br>\r\n8.-  Artículos de <b>paquetería</b> en tienda colocados en el espacio definido en el checkout (si aplica) y con <font color=red>calcomanía</font> especificada, libre de otras mercancías o utensilios.', 1, 1, NULL, NULL, NOW(), NOW()),
('942567f1-9891-4cf1-bdb9-eafb8339f0e3', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 8, 'Condiciones y Calidad del Producto', NULL, '- Limpios/ Frutero/ Caducidad/ Deterioro/ Temperatura de Equipos', '1.- Productos <b>limpios</b> y sin empaques alterados, raspados, o maltratados. (Apto para la venta).<br><br>\r\n2.- Producto en frutero se encuentran en buen estado, limpio, sin daño aparente y acomodado adecuadamente; apto para la venta (no sobremaduro).<br><br>\r\n3.- Producto dentro del límite de <b>caducidad</b> establecido en el mismo (retirar los productos un día antes de la fecha de vencimiento, a menos que tenga la leyenda \"Fresco hasta\") y los más próximos a caducar colocados al frente o más cerca del cliente. Los caducos retirarlos y colocarlos en contenedor de merma (aplica para todos los productos).En los productos que solo contengan la caducidad en mes y año, retirar el último día del mes indicado en de la etiqueta. Retirar los productos perecederos que no tengan etiqueta de caducidad.  Insumos de café y alimentos no caducos.<br><br>\r\n4.- Productos sin <b>señales de deterioro</b> como hongos o resequedad, mal olor o color.<br><br>\r\n5.-  <b>Temperatura de equipos</b>. Cámara de conservación de \"Refrescos y lácteos\" (2 a 5 ºC) o (36 - 41 °F), cámara de conservación de \"hielo\" (-10 a -7 ºC), cámara fría o \"cervecero\"  (de 0 a 2 °C)  a excepción de las siguientes plazas: (de 2 a 5 ºC)  en Obregón, Nogales, Monterrey, Saltillo, Allende, Laguna, Piedras Negras, Monclova, Culiacán, La Paz, Los Mochis, Reynosa, Laredo, Matamoros y Cd. Juárez. De ( -2 a 0 ) para plaza Mexicali . Salchichonero a una temperatura de 2 a 6 ºC o 35 a 42 °F. <font color=red>Para equipos de comida rápida consultar Anexo FF.</font>', 1, 1, NULL, NULL, NOW(), NOW()),
('6bcfaf2f-40a7-44bf-b554-d07c644196b9', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 9, 'Etiqueteo', NULL, '- Actualizadas/ Etiqueta varios frentes/ Colocadas/ Preciadores/ Remate/ Mismo Precio/ Cerveza', '1.- <b>Etiquetas actualizadas</b> corresponde al producto exhibido y muestra el precio correcto, completamente legible (no decolorada) y no rota.<br><br>\r\n2.- Si el producto es más pequeño que la etiqueta ó los productos son de la misma presentación mismo sabor se coloca al menos <b>una etiqueta para todos los frentes.</b><br><br>\r\n3.- Etiquetas <b>colocadas</b> en porta etiquetas o holders institucionales y <font color=red>ambos en</font> buen estado. No colocar etiquetas en la rejillas frontales del koxka.<br><br>\r\n4.- <b>Preciadores</b> del canasto, de vinos y licores, exhibidores de telefonía y tecnología colocados frente al producto que hace referencia.<br><br>\r\n5.- Producto que aplique con preciador de <b>remate</b> oficial.<br><br>\r\n6.- Productos con misma presentación pero diferente sabor, deben tener el <b>mismo precio</b>.<br><br>\r\n7.- Productos de <b>cerveza</b> que apliquen con etiqueta de precio multi-unidad y su etiqueta de precios individual. Si el producto tiene solo un frente, colocar etiqueta de precio individual.', 1, 1, NULL, NULL, NOW(), NOW()),
('fc921750-4a86-4c65-a663-b3d9ac0fa155', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 10, 'Comida rápida', NULL, '- Estándares FF/ Insumos/ Caducidad/ Limpios/ Limpieza del área/ Utensilios', 'Todos los conceptos de <b>Fast Food Alimentos y Bebidas</b> que aplican para la tienda se ejecutan según lo definido en base al <b>Anexo a Estándares de Fast Food</b>.<br><br>\r\n1.- Todos los equipos de Fast Food limpios interna y externamente, con vestido y piezas completas y en buen estado.<br><br>\r\n2.- <b>Limpieza</b> del piso, panel duela (si aplica), muebles de comida rápida y café. Botes de basura con bolsa no más de 3/4 de su capacidad y señalizados como Orgánico e Inorgánico, con bolsa blanca para Inorgánico y negra para Orgánico (si aplica). Área libre de malos olores.<br><br>\r\n3.- <b>Utensilios</b> disponibles, limpios y en buen estado.', 1, 1, NULL, NULL, NOW(), NOW()),
('88622a43-736e-4bdc-87d2-08b0da8ad325', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 11, 'Cuarto Frío', NULL, '- Resurtido/ Limpieza/Orden/ Exhibición Visible/ Buenas Prácticas/ Hielo/ Chamarras', '1.- <b>Resurtido</b> continuo de los producto en el cuarto frio (no más de 3 huecos visibles).<br><br>\r\n2.- <b>Limpieza</b>: Puertas, techo y marcos de cuarto frío, parrillas, deslizadores, acrílicos, porta etiquetas, puerta de acceso al cuarto frio, cortina hawaiana, piso, paredes interiores y exteriores (sin evidencia de derrames), rack y exhibidores  limpios y en buen estado.<br><br>\r\n3.- <b>Orden</b>: Pisos sin objetos tirados, barrido y trapeado, libre de malos olores. Sólo exhibidores y productos autorizados para el cuarto frío. Carriles bien definidos con acrílicos de acuerdo al tamaño. El producto apilado está dentro del limite permitido (1.5 mts. de altura). <font color=red>No se coloca producto alimenticio directamente sobre el piso.</font><br><br>\r\n4.- <b>Exhibición visible</b> e iluminada en todo momento. No lámparas fundidas.<br><br>\r\n5.- Buenas prácticas: La cortina de PVC (hawaiana) nunca se encuentra \"colgada\" o \"amarrada\". La(s) puerta(s) de acceso al cuarto frío se mantienen bien cerradas. Productos resguardados en el rack de acuerdo a la guía. Alimentos de personal de tienda en su cajonera autorizada. Aplicación del 5S + 1.<br><br>\r\n6.- Al menos el 50% de <b>existencia de  hielo</b> apto para su venta y con buena accesibilidad. No se estiba más de 1.5 m de altura. No escarcha y/o agua escurriendo en piso del contenedor.<br><br>\r\n7.- Existen 2 <b>chamarras</b> en la tienda en buen estado <font color=red>colgadas en el perchero.</font>', 1, 1, NULL, NULL, NOW(), NOW()),
('b1b19ac7-b4b5-4d82-bd95-9d674f24de3d', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 12, 'Promociones', NULL, '- Promoxxo/ Oficial/ Vigente/ No Cinta Adhesiva', '1.- Exhibiciones de Piso, Checkout, cabeceras, tiras promocionales  y adicionales con producto de acuerdo al <b>planograma</b> en Promoxxo.<br><br>\r\n2.- El material que se encuentre en tienda debe de ser el <b>oficial</b> y estar <b>vigente</b>.<br><br>\r\n3.- Los materiales <b>POP</b> deben de estar colocados/desplegados correctamente (de acuerdo a  Promoxxo), en buenas condiciones, visibles y sin obstrucciones.<br><br>\r\n4.- Todos los materiales deberán estar pegados con la cinta doble cara que trae el material, en los marcos donde corresponden o colgados con cinchos <font color=red>ó ventosas</font> si es que aplican. <b>Ningún material debe tener cinta adhesiva</b>, ni grapas.', 1, 1, NULL, NULL, NOW(), NOW()),
('f52971ec-e16e-46f7-a1fe-ced9410059b3', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 13, 'Venta Enfocada', NULL, '- Sugerir/ Servicios/ TGO', '1.- <font color=red>Preguntar si se le ofrece \"algo más\" y/o <b>sugerir</b> promociones o productos de forma constante.</font><br><br>\r\n2.- <b>Servicios</b> (lo que aplique). Portaboletos de autobús, llaveros para TAE, exhibidor de tecnología y telefonía disponibilidad y exhibición, seguros y disponibilidad tarjetas regalo, prepago y Saldazo que apliquen.<br><br>\r\n3.- Se cuenta con las metas definidas por el Asesor de Tienda para cada indicador y se captura el seguimiento diario de avance al indicador en el <b>TGO</b>. Se analiza diariamente el estatus actual de los Factores Críticos así como las gráficas de seguimiento diario y gráficas de proyección mensual en el Tablero de Gestión Operativa.', 1, 1, NULL, NULL, NOW(), NOW()),
('ff0647e5-6b8a-4e64-83f6-90e986c90fee', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 14, 'Ambientación, Seguridad', NULL, '- No almacenar en/ Luces/ Buenas Prácticas/ 5S+1', '1.- <b>Prohibido almacenar</b> producto y/o chaquetines en el baño. Entrada no obstruida.<br><br>\r\n2.- Tener <b>luces</b> de exterior, piso de venta y baño encendidas solo cuando sea necesario. No focos fundidos.<br><br>\r\n3.- <b>Buenas prácticas</b>. La puerta de la bodega se mantiene cerrada y se abre sólo cuando es necesario. No se colocan productos u objetos encima de equipos eléctricos y de cómputo (si aplica), en el techo del cuarto frío o conservadores de hielo en bolsa. Tableros eléctricos y de control, extintores, salidas de emergencia, puertas de cuarto frío y de bodega libres de cualquier obstrucción.<br><br>\r\n4.- Orden. Aplicación del <b>5S + 1</b> en bodega, incluyendo el escritorio, equipo de cómputo (si aplica), rack y tarja. Los productos se encuentran acomodados en su lugar asignado en carriles delimitados y los utensilios de limpieza se colocan en el Rack de Limpieza. Nota: los productos se encuentran separados al menos 10 cm de la pared (no colocar productos sobre la línea roja) y no se apilan a más de 1.5 metros de altura (no sobrepasan la línea amarilla).', 1, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Semanales
('d63ccefb-7f39-46ea-b679-3b1c50b3499b', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 15, 'Herramienta de Compra /Tablero de Gestión Operativa', 1, NULL, '1.- Se monitorea diariamente las Tiras de PAFS en riesgo de desabasto, Resumen Operativo, Tira de Venta Recuperada por Exhibición y Tira de Venta Perdida Proveedor-Artículo del Tablero de Gestión Operativa, se imprimen y almacenan día / semana anterior y actual en la Carpeta Operativa y se llevan a cabo acciones para disminuirlos. El pedido se hace de acuerdo al sugerido y se aumenta en caso de ser hueco. Stocks actualizados para artículos durante el periodo promocional.  Se almacenan las compras por día y se revisan contra la hoja de arrastre de saldo diario validando compras y devoluciones.', 1, 1, NULL, NULL, NOW(), NOW()),
('8da6fae3-fb89-4a1b-b1cd-2df71ae0a18a', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 16, 'Asignación de Tareas', 2, NULL, '1.- Todos los empleados cuentan con su tira en el turno. El Líder y/o Encargado monitorean diariamente la ejecución de las tareas asignadas. Al menos de manera semanal el líder revisa las tareas creadas y como están asignadas, de forma que coincidan con las áreas de oportunidad encontradas. Las cargas están entre 85% y 100%  y equilibradas, para personal nuevo de acuerdo a vector gente. Se encuentran en el corcho las tiras del último día y turnos laborados.', 1, 1, NULL, NULL, NOW(), NOW()),
('504d21a0-28f3-46a6-ae42-62aeb0d37f67', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 17, 'Carpeta Operativa / Permisos Oficiales / Corcho Operativo', 3, NULL, '1.- Las carpeta operativa  se encuentra actualizada (aplica según lo comunicado de acuerdo a la última versión), organizada y en buenas condiciones y los puntos que se deban de llenar se llenan tal y como se definió.<br><br>\r\n2.-  Se verifica que los permisos oficiales se encuentren en tienda y vigentes, de acuerdo a la ley local vigente (visibles, donde aplique).<br><br>\r\n<font color=red>3.- Se encuentra en el corcho la tira de artículos del \"Inventario en bodega sin exhibición\" actualizada (no tiene más de 7 días desde su impresión).</font><br><br>\r\n<font color=red>4.- Existe el formato de responsable por Lego evaluado correctamente en el corcho operativo. Se agrega la tira de resumen de cambios todos los lunes.</font>', 1, 1, NULL, NULL, NOW(), NOW()),
('a4b72428-0295-40e7-bc9d-bcaf6df4470e', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 18, 'Señalizaciones, Utensilios, equipos y habilitadores', 4, NULL, '1.- Se cuenta con toda la señalización (que aplique) de acuerdo al <b>Catálogo</b> de Señalización Institucional en tienda, en buen estado y colocada en los lugares correspondientes (basureros, bodega, caja, comida rápida, cuarto frio, estacionamiento, piso de venta, puerta de acceso y baños).<br><br>\r\n2.- <b>Servicios</b> (lo que aplique en plaza). Colgante de cajeros automáticos en buen estado.<br><br>\r\n3.- Anuncio de <b>tipo de cambio</b> (donde aplique) actualizado, en buen estado y colocado a la vista del cliente.<br><br>\r\n4.- Se cuenta con todos los <b>utensilios, habilitadores y equipos</b> de acuerdo al catálogo institucional y estos se encuentran en buen estado.', 1, 1, NULL, NULL, NOW(), NOW()),
('25e13971-255b-4a0e-b735-0ec52f58199c', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 19, 'Condiciones', 5, NULL, '1.- <b>Iluminación</b> de la Tienda (interior y exterior) de acuerdo a la hora del día. No focos y/o lámparas fundidos en exterior ni en piso de venta, bodega o cuarto frío. Anuncios (marquesina, paleta, cajeros automáticos), banqueta (plafón de marquesina, luces de pared y toldos) y estacionamiento (reflectores). Reflectores orientados hacia el estacionamiento. Acrílicos de luminarias limpios y en buen estado.<br><br>\r\n2.- <b>Exterior</b>: Basureros señalizados como orgánico e inorgánico (si aplica) y en buen estado. Marquesina sin golpes. Contenedor de basura en buen estado, con tapa  candado (si aplica) y sin graffitis. Plafones completos y no dañados. Teléfonos públicos con calcomanías bien adheridas y funcionando. Equipo de proveedores (hielo, agua, teléfonos públicos) sin graffiti y en buenas condiciones. Portabanner bien instalado y en  buen estado.<br><br>\r\n3.- <b>Equipo de Isla</b> (los que apliquen) y vidrio de escáner (si aplica) en buen estado. Refrigeradores en buen estado sin exceso de escarcha, sin lámparas fundidas y con puerta bien cerrada.<br><br>\r\n4.- <b>Piso de Venta y Bodega</b>: Temperatura ambiente en el piso de venta es agradable (si se cuenta con termostato o indicador de temperatura a la vista deberá marcar entre 22ºC y 26ºC).  En las Tiendas con aire acondicionado la puerta de acceso a la Tienda se encuentra cerrada y sólo se abre cuando entra y sale gente. Paletero sin exceso de escarcha de hielo, con rejillas despejadas, exterior en  buen estado y con calcomanías bien pegadas. Cajero automático y/o caseta telefónica (si aplican) operando correctamente y limpios. Parrilla de Punto Frío sin polvo o pelusa. Máquinas de Fast Food bebidas (café grano, frappé, capuchino) operando correctamente de acuerdo a la guía rápida de operación. Equipo de comida rápida en buen estado y termómetro (si aplica) funcionando. Máquina de hielo (si aplica en la plaza) operando correctamente, sin goteras, fugas y filtraciones de agua, depósito de hielo funcionando y limpio. Hielera de cerveza sin óxido, manchas, en  buen estado (sin roturas o decoloración), incluyendo estructura, tapas, desagüe y cubetas de desagüe. Equipo de aire acondicionado en  buen estado. Nota: los paleteros, equipos eléctricos o transformadores se encuentran separados al menos 10 cm de la pared u otros objetos. Sin reguladores de voltaje en piso de venta. Góndola mercancías generales (Novelty) o exhibidor pentagonal exhibido en piso de venta de acuerdo al layout de tienda , en buen estado, limpio y con su material POP instalado. Mobiliario de madera en buen estado. Bomba de agua funcionando. Equipo de cómputo en bodega (si aplica) instalado correctamente con base en lo definido. Paredes, ventanas, extractores, plafones y rejilla de aire acondicionado limpios y en buen estado Plafones no rotos o dañados, ni huecos en el techo por falta del mismo. Góndolas en  buen estado  y no despintadas. Pisos no quebrados, despostillados o manchados. Puerta principal en buen estado operando correctamente. Sin manchas por filtraciones en paredes ni goteras en el techo. Mesas/barras y bancos/sillas de Comida Rápida en buen estado. Sin restos de alimentos, basura o  insectos/fauna en el área de comida y Tienda. Con certificado de fumigación vigente. Puerta de bodega en buen estado cerrando correctamente, con cubre polvos y sin huecos o aberturas en sus lados. Sin mercancía, equipo o productos en la parte superior del Cuarto Frío.  Tarja y pileta limpia y en buen estado. Disponibilidad de agua para la operación. Drenaje y fosa séptica de la Tienda en buen estado, sin tuberías o coladeras abiertas y expuestas. Ventanas o rejillas de bodega con malla protectora. Sin huecos en las paredes e instalaciones eléctricas.<br><br>\r\n5.- Refrigerador de hielo \"del proveedor\" (la perilla debe encontrarse en el punto medio del rango del termostato). En Cuarto Frío, (incluyendo cámaras de hielo), la temperatura está dentro de rango establecido, verificar que los difusores estén libres de hielo. Verificar que no haya ruido excesivo o fuera de lo normal en los motores, ni fugas de aire  o agua en las cámaras. Al abrir completamente las puertas se mantienen abiertas; en caso contrario deben cerrarse por sí mismas a \"presión\" (que cierren \"de regreso\"). Puertas no desniveladas.  Empaques de las puertas en buen estado. Existencia de cortina de PVC (hawaiana) limpia y en buen estado. En caso de contar con máquina de hielo que esté en buen estado, la puerta debe permanecer cerrada cuando no se utilice y las rejillas de ventilación despejadas. Parrillas y deslizadores en buen estado. Parrillas no oxidadas. Sólo exhibidores y productos autorizados para el cuarto frío. Nota: no colocar cartones, acrílicos o algún otro material en las parrillas. Productos ordenados (apilados a una distancia mínima de 40 cms. de las parrillas y difusores). Las parrillas tienen la inclinación correcta (multiempaque cero inclinación, productos chicos nivel 2, productos medianos nivel 1 o 2 y productos grandes nivel 1). En parrillas combinadas se usa el acrílico y la inclinación del producto más grande.  Aplicación del 5S + 1 en cuarto frío.<br><br>\r\n6.- <b>Baños</b> de Empleados y Públicos, Inodoro, mingitorio, lavamanos, porta rollo, papel para secar las manos y jabonera, funcionando y en óptimas condiciones (sin fuga de agua, roturas, astillados, quebrados). Inodoro con asiento de acuerdo al tamaño y forma del inodoro, no roto, y funcionando correctamente. Piso no quebrado ni despostillado. Puerta de acceso y/o puerta de baño operando correctamente y funcionando la chapa y el seguro.', 1, 1, NULL, NULL, NOW(), NOW()),
('b95192ee-8c21-44c4-bb84-6496101a876c', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 20, 'Seguridad y Prevención', 6, NULL, '1.-<b>Sistemas de seguridad</b> funcionando correctamente como CCTV (cámaras de seguridad), lámparas de emergencia y alarmas, así como chapas de puertas funcionando correctamente. Extintores vigentes. Existe un botiquín de primeros auxilios con producto en buen estado y completo.<br><br>\r\n2.- <b>Resguardo</b> de Productos de Alto Riesgo (paquetes de cigarros, vinos, celulares y tarjetas excedentes) en la herramienta de resguardo (jaula, bóveda o gaveta de resguardo) y exhibidor de celulares y tecnología bajo llave.<br><br>\r\n3.- No se deberán dejar paquetes de <b>cigarros</b> en cualquier otro lugar que no sea el exhibidor de cigarros.<br><br>\r\n4.- Prevención de <b>Extorsiones</b>: Ningún empleado o persona externa puede solicitar realizar transacciones electrónica (TAE, corresponsalías, etc...) vía telefónica<br><br>\r\n5.- <b>Calcomanías</b> preventivas en buen estado (número de Centro de Control, CCTV, Avisos de Privacidad, otras) en caso de que estas presenten desgaste o no se tengan en Tienda, solicitar por medio de  ATL o Protección Patrimonial.', 1, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Mensuales
('8be7758e-5c60-4c9b-a57e-a655d7c19d0b', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 21, 'Revisión Vertical', 1, NULL, '1.- Se tiene Revisión Vertical trimestral con cada empleado.', 1, 1, NULL, NULL, NOW(), NOW()),
('d7603d42-6819-466b-a7c1-505afb1bcbd9', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 22, 'Dinámica de Cultura', 2, NULL, '1.- Se tiene <b>Dinámica de Cultura</b> bimestral con los empleados. Se da vida y se busca la mejora en base a los dialogos sostenidos. Se logra participación de todos y se llega a acuerdos.', 1, 1, NULL, NULL, NOW(), NOW()),
('9eef3935-d834-46d6-a30f-dd3a0dd7e5ec', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 23, 'Rituales de Gestión', 3, NULL, '1.- <b>Asesor-Líder de Tienda</b> se coordinan acciones con enfoque al incremento de Ventas de la Plaza con el apoyo de los Asesores Tienda, así como también la revisión de proyectos e iniciativas de la Plaza.<br><br>\r\n2.- <b>Líder-Equipo de Tienda</b> se están realizando de forma constante revisando oportunidades y generando plan de acción. \r\nSe da cumplimiento, seguimiento y hay avance en el <b>plan de acción</b> de la tienda.', 1, 1, NULL, NULL, NOW(), NOW()),
('cc4ac679-6538-4c7d-8656-801c8a48c020', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'E', NULL, NULL, 24, 'Evaluaciones', 4, 'Ev operativa y Scorecard de ejecución', '1.- <b>Lider de Tienda</b> realiza <b>evaluación operativa</b> de su Tienda dentro de los primeros 25 días del mes, evaluando la historia de las últimas 4 semanas de la Tienda.<br><br>\r\n2.- <b>Líder de Tienda</b> realiza evaluación de <b>Scorecard de ejecución</b> dentro de los primeros 25 días del mes.', 1, 1, NULL, NULL, NOW(), NOW());

-- query para insertar nombres de fotos para v24:
INSERT INTO `xxbdo_estandares_fotos` (`id`, `xxbdo_estandares_id`, `foto`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
('7a995845-5e71-405b-9b8c-6bf854450f51', '10f81bf8-ff1b-415e-8fda-c420f1dbf914', '1539890983917-c3RkLTIzLTAxLnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('bcc07dd0-883f-4fd4-ae39-dd0d1aac9ac0', '63dbc878-8105-40d6-8cb9-2acfddce1640', '1539891011940-c3RkLTIzLTAyLnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('72aa839c-fca6-4319-a5b1-242a2387c282', '139e7f1b-ca27-4000-96c2-3e5b4dda3c3e', '1539891044032-c3RkLTIzLTAzLnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('fa0e9584-586f-4e4c-9da8-fcc939b9b069', '390d1816-4beb-4884-b156-10374f142e1b', '1539891403168-dHNkLTIzLTA0LnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('0e463db7-196d-483a-99a6-ecb213e55f75', '8fb4955e-688a-4e01-bbe4-872218262a1d', '1539891103645-c3RkLTIzLTA1LnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('96018ac7-03f4-4cb7-9cbc-829f3f4254ce', '5ae71d28-c4f9-4968-a3ce-c60908fc8bdf', '1539891136296-c3RkLTIzLTA2LnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('f58c3053-bf9f-4955-9408-b4309384c2f8', '7e0ae661-3de5-40af-9047-72e7f2481db7', '1539891136296-c3RkLTIzLTA2LnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('ccb37243-f83f-41f5-bad6-2f9b16c822b5', '152ce08f-b465-44f8-9560-32e09a67865f', '1539891168890-c3RkLTIzLTA3LnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('bdc5299f-c101-4eee-846b-f626b91199ad', '942567f1-9891-4cf1-bdb9-eafb8339f0e3', '1539891205496-c3RkLTIzLTA4LnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('b51ad65e-a314-4065-8495-b395254b3672', '6bcfaf2f-40a7-44bf-b554-d07c644196b9', '1539891235403-c3RkLTIzLTA5LnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('ea5510e0-5420-406e-900b-fda8a201e08e', 'fc921750-4a86-4c65-a663-b3d9ac0fa155', '1539891258006-c3RkLTIzLTEwLnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('550c8a41-dea1-4390-b586-8050e1d6e8c2', '88622a43-736e-4bdc-87d2-08b0da8ad325', '1539891295618-c3RkLTIzLTExLnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('909992c7-b1a5-4459-a3b6-2ddfb7e066bc', 'b1b19ac7-b4b5-4d82-bd95-9d674f24de3d', '1539891318260-c3RkLTIzLTEyLnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('709344a3-fe70-4162-bda1-c6b5e44ad5d2', 'f52971ec-e16e-46f7-a1fe-ced9410059b3', '1539891358413-c3RkLTIzLTEzLnBuZw==.png', 1, NULL, NULL, NOW(), NOW()),
('ebef70f6-8006-4020-8c66-3783718874f0', 'ff0647e5-6b8a-4e64-83f6-90e986c90fee', '1539891383577-c3RkLTIzLTE0LnBuZw==.png', 1, NULL, NULL, NOW(), NOW());

--
-- Volcado de datos para la tabla `xxbdo_areas_estandares`
-- Insertar registros de area-estandares diarios v24
INSERT INTO `xxbdo_areas_estandares` (`id`, `xxbdo_areas_id`, `xxbdo_estandares_id`, `valor`, `orden`, `dias_activos`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
-- Estandares Diarios - Servicio
('ccd17e86-82c5-41ff-8922-d7a35d1979ad', '1b7ea94a-9914-4bb3-b7d6-d8e8b1861777', '10f81bf8-ff1b-415e-8fda-c420f1dbf914', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('a48f63e6-6e94-4052-adfc-971d35d96d0f', '1b7ea94a-9914-4bb3-b7d6-d8e8b1861777', '63dbc878-8105-40d6-8cb9-2acfddce1640', 0, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- Estandares Diarios - Ingreso
('8d5ed8e7-2f5a-4924-9818-6900ca1db549', '3cf78e75-ad58-4364-a90a-a5d06a1acd42', '139e7f1b-ca27-4000-96c2-3e5b4dda3c3e', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- Estandares Diarios - Gente
('3a25a34e-c248-4a51-ba9e-a518c35d5b37', 'bbc01530-1401-484d-8b2b-0418b17f6a13', '390d1816-4beb-4884-b156-10374f142e1b', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('91ec9e8d-5e38-4d4d-ab7f-b661f0ee8edd', 'bbc01530-1401-484d-8b2b-0418b17f6a13', '8fb4955e-688a-4e01-bbe4-872218262a1d', 0, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- Estandares Diarios - Ejecución
('06a40226-a528-430f-86fd-08277a0dde4b', '018e59f2-b950-4340-b8dc-6cee7171e975', '5ae71d28-c4f9-4968-a3ce-c60908fc8bdf', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('c7e15d80-f88c-4879-9cb8-41323d27c255', '018e59f2-b950-4340-b8dc-6cee7171e975', '7e0ae661-3de5-40af-9047-72e7f2481db7', 0, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('abe9cc02-abf4-4b64-a6f5-09b989fcafad', '018e59f2-b950-4340-b8dc-6cee7171e975', '152ce08f-b465-44f8-9560-32e09a67865f', 0, 3, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('e4e9c493-3bb5-4f0e-9ce2-5de9ee98b9af', '018e59f2-b950-4340-b8dc-6cee7171e975', '942567f1-9891-4cf1-bdb9-eafb8339f0e3', 0, 4, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('146c9090-3820-4df7-836c-4498c9c23621', '018e59f2-b950-4340-b8dc-6cee7171e975', '6bcfaf2f-40a7-44bf-b554-d07c644196b9', 0, 5, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('516f3630-3dca-4f72-b967-973181766d38', '018e59f2-b950-4340-b8dc-6cee7171e975', 'fc921750-4a86-4c65-a663-b3d9ac0fa155', 0, 6, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('6d375a88-e693-4af5-9f96-798ae4fb0f04', '018e59f2-b950-4340-b8dc-6cee7171e975', '88622a43-736e-4bdc-87d2-08b0da8ad325', 0, 7, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('48f07de9-fe2d-47ea-bcc3-ae369bdfe5ac', '018e59f2-b950-4340-b8dc-6cee7171e975', 'b1b19ac7-b4b5-4d82-bd95-9d674f24de3d', 0, 8, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- Estandares Diarios - Cliente
('b4c03189-52ae-4e5e-adaf-dcad4b4e3197', '7733e43b-19e4-4860-bfcd-73a9cee1d6ea', 'f52971ec-e16e-46f7-a1fe-ced9410059b3', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('e4ae6ce9-470b-44b9-bc78-2cab718f4d79', '7733e43b-19e4-4860-bfcd-73a9cee1d6ea', 'ff0647e5-6b8a-4e64-83f6-90e986c90fee', 0, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- -----------------------------------
-- 
-- Estandares Semanales - Indicadores
('81ef21bf-d2f8-4cd4-a069-c58d6f5cb80d', '23c00046-77bf-4527-832b-b03c0c0968a3', 'd63ccefb-7f39-46ea-b679-3b1c50b3499b', 1, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('2495853d-1b91-4b33-925f-934f1c28a272', '23c00046-77bf-4527-832b-b03c0c0968a3', '8da6fae3-fb89-4a1b-b1cd-2df71ae0a18a', 1, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('5c0509c7-ca4d-477f-9fa3-e71ebb90430b', '23c00046-77bf-4527-832b-b03c0c0968a3', '504d21a0-28f3-46a6-ae42-62aeb0d37f67', 1, 3, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('5683a017-21f1-4137-9478-ebc121273cc3', '23c00046-77bf-4527-832b-b03c0c0968a3', 'a4b72428-0295-40e7-bc9d-bcaf6df4470e', 1, 4, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- Estandares Semanales - Mantenimiento
('5482e15b-cdd0-46a5-97a4-459817061586', '1bdc2857-54ec-4ec6-9dd2-5e3360f608f2', '25e13971-255b-4a0e-b735-0ec52f58199c', 1, 5, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('2667f4c6-739f-4cd6-9bb7-d7d971c9a06b', '1bdc2857-54ec-4ec6-9dd2-5e3360f608f2', 'b95192ee-8c21-44c4-bb84-6496101a876c', 1, 6, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- ------------------------------------
-- Estandares Mensuales - Cultura
('9b6f5cee-67e3-479c-aa65-63bf21b82e43', '1380cce4-1495-4ff3-bd08-285bced3b540', '8be7758e-5c60-4c9b-a57e-a655d7c19d0b', 1, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('05f2e4a1-d7b0-44ad-8260-dd0b0f4ef772', '1380cce4-1495-4ff3-bd08-285bced3b540', 'd7603d42-6819-466b-a7c1-505afb1bcbd9', 1, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('a9185cff-7543-43ad-a006-0decba644a75', '1380cce4-1495-4ff3-bd08-285bced3b540', '9eef3935-d834-46d6-a30f-dd3a0dd7e5ec', 1, 3, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
('0d1ee5db-ef14-47d6-8ea2-9ede8cd3897f', '1380cce4-1495-4ff3-bd08-285bced3b540', 'cc4ac679-6538-4c7d-8656-801c8a48c020', 1, 4, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW());
-- ------------------------------------

-- Insertar registros de checklist-area-estandares diarios/semanales/mensuales vNexxo:
INSERT INTO `xxbdo_checklists_has_areas_estandares` (`xxbdo_checklists_id`, `xxbdo_areas_estandares_id`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('c98336f8-cf56-4a30-909a-42b592928219', 'ccd17e86-82c5-41ff-8922-d7a35d1979ad', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'a48f63e6-6e94-4052-adfc-971d35d96d0f', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '8d5ed8e7-2f5a-4924-9818-6900ca1db549', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '3a25a34e-c248-4a51-ba9e-a518c35d5b37', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '91ec9e8d-5e38-4d4d-ab7f-b661f0ee8edd', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '06a40226-a528-430f-86fd-08277a0dde4b', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'c7e15d80-f88c-4879-9cb8-41323d27c255', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'abe9cc02-abf4-4b64-a6f5-09b989fcafad', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'e4e9c493-3bb5-4f0e-9ce2-5de9ee98b9af', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '146c9090-3820-4df7-836c-4498c9c23621', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '516f3630-3dca-4f72-b967-973181766d38', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '6d375a88-e693-4af5-9f96-798ae4fb0f04', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '48f07de9-fe2d-47ea-bcc3-ae369bdfe5ac', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'b4c03189-52ae-4e5e-adaf-dcad4b4e3197', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'e4ae6ce9-470b-44b9-bc78-2cab718f4d79', 1, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Semanales
('c98336f8-cf56-4a30-909a-42b592928219', '81ef21bf-d2f8-4cd4-a069-c58d6f5cb80d', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '2495853d-1b91-4b33-925f-934f1c28a272', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '5c0509c7-ca4d-477f-9fa3-e71ebb90430b', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '5683a017-21f1-4137-9478-ebc121273cc3', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '5482e15b-cdd0-46a5-97a4-459817061586', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '2667f4c6-739f-4cd6-9bb7-d7d971c9a06b', 1, 1, NULL, NULL, NOW(), NOW()),
-- Estandares Mensuales
('c98336f8-cf56-4a30-909a-42b592928219', '9b6f5cee-67e3-479c-aa65-63bf21b82e43', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '05f2e4a1-d7b0-44ad-8260-dd0b0f4ef772', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'a9185cff-7543-43ad-a006-0decba644a75', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '0d1ee5db-ef14-47d6-8ea2-9ede8cd3897f', 1, 1, NULL, NULL, NOW(), NOW());

-- queries para cambiar checklist default de tiendas:
-- obtener current checklist de vNexxo = 7131ed27-5733-47e9-ad86-83cac29e9288 
UPDATE `xxbdo_checklists_tiendas` 
SET es_default=0,
fecha_fin = '2020-02-29'
WHERE xxbdo_checklists_id='7131ed27-5733-47e9-ad86-83cac29e9288';

INSERT INTO `xxbdo_checklists_tiendas` 
SELECT 'c98336f8-cf56-4a30-909a-42b592928219' AS cid, 
`cr_plaza`, 
`cr_tienda`, 
'b794eae6-25c5-4e01-a69b-4a0fc29b259b' AS `nxxbdo_version_estandares_id`,
'Estándares Operativos Versión 24' AS `ntitulo`,
'Estándares Operativos Versión 24' AS `ndescripcion`,
'BITACORA v24' AS `ntitulo_app`,
'INDICADORES v24' AS `ntitulo_indicadores_app`,
'2020-03-01' AS `nfecha_inicio`,
NULL AS `nfecha_fin`,
'1' AS `es_default`, 
'1' AS `activo`, 
'adrian.zenteno.ext@oxxo.com' AS `usuario`, 
NULL AS `ip_address`, 
NOW() AS `fecha_creacion`, 
NOW() AS `fecha_modificacion` 
FROM `xxbdo_checklists_tiendas` 
WHERE `xxbdo_checklists_id`='7131ed27-5733-47e9-ad86-83cac29e9288';

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
WHERE `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`='c98336f8-cf56-4a30-909a-42b592928219' 
AND `xxbdo_checklists_has_areas_estandares`.`xxbdo_checklists_id` = `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`;

-- ---------------------------------------------------------
--
-- Volcado de datos para la tabla `xxbdo_indicadores`
-- Indicadores Mensuales de Estándares Diarios v24:
--
INSERT INTO `xxbdo_indicadores` (`id`, `xxbdo_version_estandares_id`, `tipo`, `cr_plaza`, `cr_tienda`, `titulo`, `descripcion`, `xxbdo_indicadores_frecuencias_id`, `orden`, `tipo_dato`, `default`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
-- -- Servicio - Imagen y comportamiento
('1bc6288f-a443-4154-a769-dfbb7fe0229a', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'EO Sección Atención', 'Ev. Operativa Sección Atención', 'M', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),

-- -- Servicio - Atención al cliente
('983c8c27-dfe2-46fd-a473-b5b8536b772b', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'EO Sección Rapidez', 'Ev. Operativa Sección Rapidez (indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),

-- -- Ingreso - Control
('142cb69b-c96d-41c2-a264-004355d340f5', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Conteos', 'Conteos', 'M', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),
('0b9037f6-beb1-443f-a563-ecf09e6dd0da', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Cobertura', 'Cobertura (Indicador de tipo porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
('e7a0cc48-d265-4a8e-a2a7-f73c287c97e5', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Resultado de Inventario', 'Resultado de Inventario (Indicador de tipo monetario)', 'M', NULL, 'money', '0.00', 1, NULL, NULL, NOW(), NOW()),
('ec7ee9da-2a54-467e-b1a8-95dc65fd3179', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'SC Preinventarios/ Entrega de Valores', 'Scorecard preinventarios/ Entrega de Valores (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),

-- -- Gente - Habilitación Equipo de Tienda
('70411ce6-2684-4ff4-9883-daef4b2fade6', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Equipos Completos', 'Equipos Completos (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
('e3657741-22bb-4372-ad18-bee44f3092fb', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Equipos Capacitados', 'Equipos Capacitados (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),

-- -- Gente - Manejo de Gente
('89da2f27-9167-457d-9b38-fa108f3af824', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, '% Rotación Empleados', '% Rotación Empleados', 'M', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),

-- -- Ejecución - Limpieza
('349162f9-cf00-49dd-8a87-c5479c7d04e1', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'EO Sección Limpieza', 'Ev. Operativa Sección Limpieza (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),

-- -- Ejecución - Exhibición
('00e0692d-9c0e-41e2-970b-37053c451efb', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'MEP Promociones P.', 'MEP Promociones P. (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
('d507f027-fa52-47c8-a671-bf07e8f32ce4', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'EO Sección Abasto', 'Ev. Operativa Sección Abasto (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
('9b33a063-283b-4cb5-8804-4642a935dafe', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'EP Charola/Mueble', 'Planogramas (Charola/Mueble) (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),

-- -- Ejecución - Condiciones y calidad del producto
('6468d978-6073-4748-8012-eea033d8caa7', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Ev. Donas a Granel', 'Ev. Donas a Granel (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
('fa2177be-44f1-4a5b-be4a-e8656e1cf1e5', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Exhibición Real Café Americano', 'Exhibición Real Americano (Indicador de tipo porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
('1e0199dc-a190-4e5a-830f-f0a25d43ab67', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Exhibición Real Roller', 'Exhibición Real Roller (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
('d6e40fc0-1221-4900-a98e-b554bf7e6842', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Veracidad Fast Food', 'Veracidad Fast Food', 'M', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),

-- -- Ejecución - Etiqueteo
('d1f41413-1911-4e96-8cad-c41fa8933ea0', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'EO Etiqueteo', 'EO Etiqueteo (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),

-- -- Ejecución - Comida Rápida
('44f442b5-7ec4-4e38-a7a5-fc4473f96081', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, '% Cumplimiento a devoluciones diarias', 'Porcentaje de cumplimiento a devoluciones diarias (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),

-- -- Ejecución - Cuarto Frío
('801a5e8e-f97a-49de-9217-7414fce2c0ef', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'EO Cuarto Frío', 'EO Cuarto Frío (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),

-- -- Ejecución - Promociones
('6b5140d7-e653-4512-8096-99cc5edba209', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'MEP POP', 'MEP POP (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),

-- -- Cliente - Venta Enfocada
('1a5a2c1c-205e-45be-8376-69647b695fd5', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Usuarios activos', 'Usuarios activos', 'M', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),
('3495b774-00de-4a6b-849b-a1a4bf74c465', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Venta sugerida', 'Venta sugerida (Indicador de tipo monetario)', 'M', NULL, 'money', '0.00', 1, NULL, NULL, NOW(), NOW());

-- indicadores not required in v24:
-- ('64581739-9877-4d34-bdff-461b2105f689', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Scorecard Calidad de Producto', 'Scorecard Calidad de Producto (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, NOW(), NOW()),
-- ('b71aa545-2a1f-40d6-aa97-7360b314511a', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Vector Gente', 'Vector Gente', 'M', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),
-- ('472a59d1-d20b-4a3d-a99c-c56928509f39', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Protocolo de Servicio', 'Protocolo de Servicio', 'M', NULL, 'int', '0', 0, NULL, NULL, NOW(), NOW()),
-- ('162647c5-64be-4bc6-af31-0b1ade168623', 'b794eae6-25c5-4e01-a69b-4a0fc29b259b', 'I', NULL, NULL, 'Ev. 5S + 1', 'Ev. 5S + 1', 'M', NULL, 'int', '0', 1, NULL, NULL, NOW(), NOW()),


-- Insertar relacion de areas_estandares + indicadores:
INSERT INTO `xxbdo_areas_estandares_indicadores` (`id`, `xxbdo_areas_estandares_id`, `xxbdo_indicadores_id`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
-- -- Std # 1 - Indicador Mensual: Ev. Operativa Sección Atención
('c02cb983-f23e-4733-a39b-11366d007ad1', 'ccd17e86-82c5-41ff-8922-d7a35d1979ad', '1bc6288f-a443-4154-a769-dfbb7fe0229a', 1, 1, NULL, NULL, NOW(), NOW()),

-- -- Std # 2 - Indicador Mensual: Ev. Operativa Sección Rapidez
('d8badeee-82ed-4576-9f27-c051f4fc5bbd', 'a48f63e6-6e94-4052-adfc-971d35d96d0f', '983c8c27-dfe2-46fd-a473-b5b8536b772b', 2, 1, NULL, NULL, NOW(), NOW()),

-- -- Std # 3 - Indicador Semanal: Conteos
('39602934-f3dc-4a96-ab9b-4efb39af059e', '8d5ed8e7-2f5a-4924-9818-6900ca1db549', '142cb69b-c96d-41c2-a264-004355d340f5', 3, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 3 - Indicador Semanal: Cobertura
('50fb948b-0fd9-4bfa-9577-3106b1e12d7c', '8d5ed8e7-2f5a-4924-9818-6900ca1db549', '0b9037f6-beb1-443f-a563-ecf09e6dd0da', 4, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 3 - Indicador Mensual: Resultado de Inventario
('6bb95421-e21a-4ba9-81d0-102dc8300bd3', '8d5ed8e7-2f5a-4924-9818-6900ca1db549', 'e7a0cc48-d265-4a8e-a2a7-f73c287c97e5', 5, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 3 - Indicador Mensual: Scorecard preinventarios
('5042aa87-128d-4804-91c8-7dcab513f3d1', '8d5ed8e7-2f5a-4924-9818-6900ca1db549', 'ec7ee9da-2a54-467e-b1a8-95dc65fd3179', 6, 1, NULL, NULL, NOW(), NOW()),

-- -- Std # 4 - Indicador Mensual: Equipos completos 
('df27bfb8-3628-4acf-bf95-c642714ffd89', '3a25a34e-c248-4a51-ba9e-a518c35d5b37', '70411ce6-2684-4ff4-9883-daef4b2fade6', 7, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 4 - Indicador Mensual: Equipos capacitados
('168d2b4a-f740-4283-8cf3-c9fc6a0496fd', '3a25a34e-c248-4a51-ba9e-a518c35d5b37', 'e3657741-22bb-4372-ad18-bee44f3092fb', 8, 1, NULL, NULL, NOW(), NOW()),

-- -- Std # 5 - Indicador Mensual: Rotación
('cebe044f-1b2f-4f06-a461-e65dd9439a22', '91ec9e8d-5e38-4d4d-ab7f-b661f0ee8edd', '89da2f27-9167-457d-9b38-fa108f3af824', 9, 1, NULL, NULL, NOW(), NOW()),

-- -- Std # 6a - Indicador Mensual: Ev. Operativa Sección Limpieza
('c95fc68c-7a92-4506-bc8e-0633994e76c4', '06a40226-a528-430f-86fd-08277a0dde4b', '349162f9-cf00-49dd-8a87-c5479c7d04e1', 10, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 6b - Indicador Mensual: Ev. Operativa Sección Limpieza
('424bfcbd-a580-4907-9a95-80423c27f993', 'c7e15d80-f88c-4879-9cb8-41323d27c255', '349162f9-cf00-49dd-8a87-c5479c7d04e1', 11, 1, NULL, NULL, NOW(), NOW()),

-- -- Std # 7 - Indicador Mensual: MEPP P.P.
('10b32ea7-9461-480d-abf7-3596167bf8e5', 'abe9cc02-abf4-4b64-a6f5-09b989fcafad', '00e0692d-9c0e-41e2-970b-37053c451efb', 12, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 7 - Indicador Mensual: Ev. Operativa sección abasto
('a923f18d-af68-43c9-9cb1-5bf4d5f8a00c', 'abe9cc02-abf4-4b64-a6f5-09b989fcafad', 'd507f027-fa52-47c8-a671-bf07e8f32ce4', 13, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 7 - Indicador Mensual: Planogramas(Charola/Mueble)
('aa045ad9-16fa-4d16-a0ac-4917c45fda9c', 'abe9cc02-abf4-4b64-a6f5-09b989fcafad', '9b33a063-283b-4cb5-8804-4642a935dafe', 14, 1, NULL, NULL, NOW(), NOW()),

-- -- Std # 8 - Indicador Mensual: Ev. Donas a Granel
('fcc3de6a-9383-43fa-9a95-5df6c5e6f5d2', 'e4e9c493-3bb5-4f0e-9ce2-5de9ee98b9af', '6468d978-6073-4748-8012-eea033d8caa7', 15, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 8 - Indicador Semanal: Exhibición Real Americano
('9e403359-c992-434e-8756-ac0756563ef9', 'e4e9c493-3bb5-4f0e-9ce2-5de9ee98b9af', 'fa2177be-44f1-4a5b-be4a-e8656e1cf1e5', 16, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 8 - Indicador Semanal: Exhibición Real Roller
('f4ba7fc6-584b-4f14-98b6-7ffaf8c4ddbd', 'e4e9c493-3bb5-4f0e-9ce2-5de9ee98b9af', '1e0199dc-a190-4e5a-830f-f0a25d43ab67', 17, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 8 - Indicador Semanal: Veracidad de Fast Food
('42de4c85-8ccc-47cb-842e-8a71a390b2b9', 'e4e9c493-3bb5-4f0e-9ce2-5de9ee98b9af', 'd6e40fc0-1221-4900-a98e-b554bf7e6842', 18, 1, NULL, NULL, NOW(), NOW()),

-- -- Std # 9 - Indicador Mensual: Scorecard Etiqueteo
('9106de72-da01-4f6d-a5d5-c4ac82c875e7', '146c9090-3820-4df7-836c-4498c9c23621', 'd1f41413-1911-4e96-8cad-c41fa8933ea0', 19, 1, NULL, NULL, NOW(), NOW()),

-- -- Std # 10 - Indicador Semanal: % Cumplimiento a devoluciones diarias
('bbe8c7e4-a0e9-4ce6-b741-770034813759', '516f3630-3dca-4f72-b967-973181766d38', '44f442b5-7ec4-4e38-a7a5-fc4473f96081', 20, 1, NULL, NULL, NOW(), NOW()),

-- -- Std # 11 - Indicador Mensual: Ev. Operativa Puntos Cuarto Frío
('b0e8b3d6-710c-4d35-a895-6eabf0ca8469', '6d375a88-e693-4af5-9f96-798ae4fb0f04', '801a5e8e-f97a-49de-9217-7414fce2c0ef', 21, 1, NULL, NULL, NOW(), NOW()),

-- -- Std # 12 - Indicador Mensual: MEP POP
('87d16200-105f-428c-8145-a8fb469fdc01', '48f07de9-fe2d-47ea-bcc3-ae369bdfe5ac', '6b5140d7-e653-4512-8096-99cc5edba209', 22, 1, NULL, NULL, NOW(), NOW()),

-- -- Std # 13 - Indicador Semanal: Usuarios activos
('3348ca30-5a15-4d9c-9499-f2ee2fc74591', 'b4c03189-52ae-4e5e-adaf-dcad4b4e3197', '1a5a2c1c-205e-45be-8376-69647b695fd5', 23, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 13 - Indicador Semanal: Venta Sugerida
('0207a836-d94b-4507-a9bd-62867e0f5c48', 'b4c03189-52ae-4e5e-adaf-dcad4b4e3197', '3495b774-00de-4a6b-849b-a1a4bf74c465', 24, 1, NULL, NULL, NOW(), NOW());

-- -- Std # 2 - Indicador Mensual: Protocolo de Servicio
-- ('0e9b312f-f0ea-4e26-9392-0e937ec487e8', 'a48f63e6-6e94-4052-adfc-971d35d96d0f', '472a59d1-d20b-4a3d-a99c-c56928509f39', 2, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 5 - Indicador Semanal: Vector Gente
-- ('3a4bf230-b49d-439e-9279-6c56ecfea351', '91ec9e8d-5e38-4d4d-ab7f-b661f0ee8edd', 'b71aa545-2a1f-40d6-aa97-7360b314511a', 3, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 8 - Indicador Mensual: Scorecard calidad de producto
-- ('5f7d0fc7-29d3-438c-bd55-f828f46349f2', 'e4e9c493-3bb5-4f0e-9ce2-5de9ee98b9af', '64581739-9877-4d34-bdff-461b2105f689', 13, 1, NULL, NULL, NOW(), NOW()),
-- -- Std # 14 - Indicador Semanal: Ev. 5S + 1
-- ('ac9fb548-8458-4678-bf8a-8894f9ea0f27', 'e4ae6ce9-470b-44b9-bc78-2cab718f4d79', '162647c5-64be-4bc6-af31-0b1ade168623', 10, 1, NULL, NULL, NOW(), NOW());


-- query para insertar registros en xxbdo_checklists_has_areas_estandares_indicadores
INSERT INTO `xxbdo_checklists_has_areas_estandares_indicadores` (`xxbdo_checklists_id`, `xxbdo_areas_estandares_indicadores_id`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('c98336f8-cf56-4a30-909a-42b592928219', 'c02cb983-f23e-4733-a39b-11366d007ad1', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'd8badeee-82ed-4576-9f27-c051f4fc5bbd', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '39602934-f3dc-4a96-ab9b-4efb39af059e', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '50fb948b-0fd9-4bfa-9577-3106b1e12d7c', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '6bb95421-e21a-4ba9-81d0-102dc8300bd3', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '5042aa87-128d-4804-91c8-7dcab513f3d1', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'df27bfb8-3628-4acf-bf95-c642714ffd89', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '168d2b4a-f740-4283-8cf3-c9fc6a0496fd', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'cebe044f-1b2f-4f06-a461-e65dd9439a22', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'c95fc68c-7a92-4506-bc8e-0633994e76c4', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '424bfcbd-a580-4907-9a95-80423c27f993', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'aa045ad9-16fa-4d16-a0ac-4917c45fda9c', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '10b32ea7-9461-480d-abf7-3596167bf8e5', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'a923f18d-af68-43c9-9cb1-5bf4d5f8a00c', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '9106de72-da01-4f6d-a5d5-c4ac82c875e7', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'fcc3de6a-9383-43fa-9a95-5df6c5e6f5d2', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '9e403359-c992-434e-8756-ac0756563ef9', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'f4ba7fc6-584b-4f14-98b6-7ffaf8c4ddbd', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '42de4c85-8ccc-47cb-842e-8a71a390b2b9', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'bbe8c7e4-a0e9-4ce6-b741-770034813759', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', 'b0e8b3d6-710c-4d35-a895-6eabf0ca8469', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '87d16200-105f-428c-8145-a8fb469fdc01', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '0207a836-d94b-4507-a9bd-62867e0f5c48', 1, 1, NULL, NULL, NOW(), NOW()),
('c98336f8-cf56-4a30-909a-42b592928219', '3348ca30-5a15-4d9c-9499-f2ee2fc74591', 1, 1, NULL, NULL, NOW(), NOW());
-- ('c98336f8-cf56-4a30-909a-42b592928219', '0e9b312f-f0ea-4e26-9392-0e937ec487e8', 1, 1, NULL, NULL, NOW(), NOW()),
-- ('c98336f8-cf56-4a30-909a-42b592928219', '3a4bf230-b49d-439e-9279-6c56ecfea351', 1, 1, NULL, NULL, NOW(), NOW()),
-- ('c98336f8-cf56-4a30-909a-42b592928219', '5f7d0fc7-29d3-438c-bd55-f828f46349f2', 1, 1, NULL, NULL, NOW(), NOW()),
-- ('c98336f8-cf56-4a30-909a-42b592928219', 'ac9fb548-8458-4678-bf8a-8894f9ea0f27', 1, 1, NULL, NULL, NOW(), NOW());

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
WHERE `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`='c98336f8-cf56-4a30-909a-42b592928219' 
AND `xxbdo_checklists_has_areas_estandares_indicadores`.`xxbdo_checklists_id` = `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`;
