-- ------------------------------
-- Retire BDO Version v23
UPDATE `xxbdo_version_estandares` 
SET `es_default` = '0', 
`fecha_fin` = '2019-09-08' 
WHERE `xxbdo_version_estandares`.`id` = '13d772fa-826b-424f-802e-63da4777e33c';

-- ------------------------------
-- Retire BDO Checklist v23
UPDATE `xxbdo_checklists` 
SET `fecha_fin` = '2019-09-08', 
`es_default` = '0' 
WHERE `xxbdo_checklists`.`id` = '3e50f58c-8634-41ce-93b5-c8bebb8bce46';

-- ------------------------------
-- Create BDO Version v24
INSERT INTO `xxbdo_version_estandares` (`id`, `titulo`, `titulo_app`, `descripcion`, `es_default`, `fecha_inicio`, `fecha_fin`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('c817b538-1b4d-4901-9181-f89aaeb15171', 'Estándares Operativos Versión 24', 'Versión 24', NULL, 1, '2019-09-09', NULL, 1, NULL, NULL, NOW(), NOW());

-- ------------------------------
-- Create BDO Checklist v24
INSERT INTO `xxbdo_checklists` (`id`, `xxbdo_version_estandares_id`, `titulo`, `descripcion`, `titulo_app`, `titulo_indicadores_app`, `fecha_inicio`, `fecha_fin`, `es_default`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('f767aea8-988c-4e36-9037-59660573b877', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'Estándares Operativos Versión 24', 'Estándares Operativos Versión 24', 'BITACORA v24', 'INDICADORES v24', '2019-09-09', NULL, 1, 1, NULL, NULL, NOW(), NOW());

-- ------------------------------
-- Create BDO Areas
INSERT INTO `xxbdo_areas` (`id`, `xxbdo_version_estandares_id`, `xxbdo_areas_grupos_id`, `titulo`, `descripcion`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
-- Enfoque de Estándares Diarios
('a04328ea-05db-490e-bc63-5475d03877ab', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', '*Servicio', 'Servicio', 1, 1, NULL, NULL, NOW(), NOW()),
('8ca08d52-21b6-439a-a471-d2fa7449f47d', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', '*Ingreso', 'Ingreso', 2, 1, NULL, NULL, NOW(), NOW()),
('afe19eee-2af9-4ab1-bd87-69222dfd0466', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', '*Gente', 'Gente', 3, 1, NULL, NULL, NOW(), NOW()),
('c7f52328-2e89-4571-92e5-3bf12733b205', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', '*Ejecución', 'Ejecución', 4, 1, NULL, NULL, NOW(), NOW()),
('1f67e255-4de1-4bab-a2d4-1e1040a7d14d', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'f1fe43c0-7c93-4342-98e0-f5be8bc3a7fb', '*Cliente', 'Cliente', 5, 1, NULL, NULL, NOW(), NOW()),
-- Enfoque de Estándares Semanales
('c8ac9cd8-a9e9-49d9-bcb5-5410f5eb019a', 'c817b538-1b4d-4901-9181-f89aaeb15171', '698d2abc-daad-4398-89e9-ad92fca812ae', '*Indicadores', 'Indicadores', 1, 1, NULL, NULL, NOW(), NOW()),
('4d8e6e26-d10d-4163-856a-b1c5b59e8794', 'c817b538-1b4d-4901-9181-f89aaeb15171', '698d2abc-daad-4398-89e9-ad92fca812ae', '*Mantenimiento', 'Mantenimiento', 2, 1, NULL, NULL, NOW(), NOW()),
-- Enfoque de Estándares Mensuales
('05189091-7829-4880-8cda-d6c74c9728ac', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'ad642ddf-3050-4284-8f1b-42604d38f164', '*Cultura', 'Cultura', 1, 1, NULL, NULL, NOW(), NOW()),
-- Estándares Libres
('4f877113-0848-43bb-be8d-09cbacb7323c', 'c817b538-1b4d-4901-9181-f89aaeb15171', '86392947-9a57-46c0-a16f-f2f4e5c0745d', '*Libre', 'Estándar Libre', 10, 1, NULL, NULL, NOW(), NOW());

-- -------------------------------
-- Create Estándares v24
INSERT INTO `xxbdo_estandares` (`id`, `xxbdo_version_estandares_id`, `tipo`, `cr_plaza`, `cr_tienda`, `estandar`, `titulo`, `orden`, `detalle`, `descripcion`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
-- Estándares Diarios
-- -- Area: Servicio
('5fb981a4-bd6c-435d-9f6b-b14a17fd40d6', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 1, '*Imagen y Comportamiento del personal de tienda', NULL, '- Presencia / Actitud / Comportamiento', '1.- <font color=red><b>Presencia impecable</b></font>, uniforme oficial de acuerdo a <font color\r\n=red>código de vestimenta</font> y gafete a la vista, botón promocional y/o de entrenamiento; gorra oficial sólo sí la Plaza lo autoriza.<br><br>\r\n2.- Mostrar una actitud de <b>servicio</b> hacia el cliente, proveedores y compañeros (optimista, proactivo, atento y servicial).<br><br>\r\n3.-No consumo de alimentos en isla, no uso de electrónicos laborando (especial cuidado al estar atendiendo al cliente).', 1, 1, NULL, NULL, NOW(), NOW()),
('12608581-10cb-497b-8126-4aeea7c98c2c', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 2, '*Atención al cliente', NULL, '- Saludo / Caja adicional / PRO // No Venta Menores / Servicio Electrónico /Agradecer/ factuar/ estacionamiento/ Horarios', '1.- Ofrecer un <b>saludo</b> y trato amable al cliente durante su estancia en la tienda, dando prioridad en atenderlo.<br><br>\r\n2.- <b>Abrir caja adicional</b> al detectar más de tres clientes en fila o si se está cobrando algún servicio financiero, boletos o facturación. Todas las cajas siempre con fondo y con morralla suficiente para recibir billetes de cualquier denominación y/o realizar retiros. Colocar letrero de \"caja cerrada\" cuando la caja no esté disponible para venta.<br><br>\r\n3.- Preguntar al cliente si desea redondear (<b>PRO</b>) y mencionar la institución beneficiada en caso de que pregunte.<br><br>\r\n4.- <b>Negar la venta de alcohol y/o cigarros</b> a menores de edad o fuera del horario permitido por la ley, ante la duda de la edad del cliente, solicitar Identificación Oficial.<br><br>\r\n5.- <font color=red>Siempre intentar realizar cualquier <b>servicio electrónico</b> antes de indicar al cliente que no hay sistema. Informar el monto a pagar incluyendo comisión por servicio.</font><br><br>\r\n6.- <b>Agradecer la compra</b> y/o despedirse amablemente y/o invitar al  cliente a regresar de nuevo.<br><br>\r\n7.- Generar y entregar la <b>factura</b> cuando el cliente lo solicite (verificando que los datos son correctos) e informarle que una vez generada la factura en tienda sólo podrá generar el archivo XML en el portal web.<br><br>\r\n8.- Mantener disponibilidad de <b>estacionamiento</b> para nuestros clientes.<br><br>\r\n9.- Cumplir con los <b>horarios de apertura y cierre de tiendas</b> de acuerdo a lo establecido por la Plaza.', 1, 1, NULL, NULL, NOW(), NOW()),
-- -- Area: Ingreso
('64bf0700-6e1b-48c0-ac57-a72fba24ca5b', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 3, '*Control', NULL, '- Preinventarios /Efectivo /Merma /Devolución', '1.- <b>Preinventarios</b> según Rol definido, utilizando plantillas y enfocados según programa a los artículos de mayor faltante, artículos en promoción, eliminación de artículos frecuentes, y de alto valor. Mínimo 2,500 conteos por semana y al menos 40% de cobertura.<br><br>\r\n2.- Se realizan las entregas de turnos y cierre de caja cuadrando el <b>efectivo</b>, se realizan arqueos y se mantiene un control exacto. La tómbola no está obstruida. Retiros de efectivo según los montos establecidos en la Plaza, se depositan de inmediato en tómbola y se cumple con el llenado del Control de Depósitos. Se cuenta con la papelería necesaria para la entrega de valores (papeletas, bolsas) y la entrega se asegura contra el catálogo de custodios. Se mantiene la morralla adecuada para dar servicio a nuestros clientes (fondo fijo).<br><br>\r\n3.- <b>Merma</b> bajo control. Los productos a mermar están en una bolsa de plástico en el contenedor de merma autorizado en el cuarto frío, capturados en la pre-merma.<br><br>\r\n4.- Los productos con <b>devolución</b> autorizada a Cedis y proveedores, se almacenan en el contenedor  de devoluciones y/o lugar definido por el Asesor una vez aplicada la devolución en sistema. Las devoluciones a IMMEX son del 1 al 15 y se entregan en presencia del vendedor.', 1, 1, NULL, NULL, NOW(), NOW()),
-- -- Area: Gente
('52ad88e6-4dcb-40d2-99b9-d55e06dc8240', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 4, '*Habilitación Equipo Tienda', NULL, '- Entienda /Servicios Financieros/ Estándares/  Clasificación', '1.- Equipo completo de acuerdo a tabulador, todos registrados en SADEL e IMSS, con <b>ENTIENDA completo</b>. Conocen sus beneficios así como los incentivos.<br><br>\r\n2.- <b>Servicios financieros</b> al menos un cajero habilitado por turno (aplica de 6:00 AM a 10:00 PM) usuario y contraseña sin bloqueos.  Los cajeros habilitados actualmente laboran en la tienda cuentan con la documentación personal vigente.<br><br>\r\n3.- Todos los empleados conocen y están habilitados para cumplir los <b>estándares</b> operativos.<br><br>\r\n4.- El equipo de tienda conoce y sabe su enfoque de acuerdo a su <b>clasificación</b> de líder, está comprometido con su plan de acción y saben como imprimir sus asignaciones de tareas.', 1, 1, NULL, NULL, NOW(), NOW()),
('6f1cdbed-19c1-4422-af61-827a8cde9cb6', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 5, '*Manejo de gente', NULL, '- 2XTurno /Nuevo con Líder/ Hora salida/ Vacaciones /Balanceo /Descanso /Plan horario / Alimentación /Cargas de Trabajo/ Tarjeta bancaria', '1.- Contar con mínimo <b>dos empleados por turno</b>, incluyendo al Líder de Tienda.<br><br>\r\n2.- <b>Acompañamiento</b> del Líder de Tienda a empleados nuevos en los primeros 15 días.<br><br>\r\n3.- <b>Salida</b> de turno a tiempo.<br><br>\r\n4.- Cumplir con el rol anual de <b>vacaciones</b>.<br><br>\r\n5.- <b>Balanceo</b> de asignación de tareas (Sem 1 60% ; Sem 2 65% ; Sem 3 70%  y  Sem 4 75%. ) y/o ATA´s <font color=red>especiales</font>.<br><br>\r\n6.- <b>Descanso</b> semanal.<br><br>\r\n7.- <b>Plan horario</b> acordado previo al inicio de la semana, considerando en lo posible temas del personal.  En el corcho y firmado por los empleados. Se cuenta con un tiempo para tomar los alimentos (sin Chaquetín).<br><br>\r\n8.- <font color=red>Se respeta horario establecido para <b>alimentación</b></font>.<br><br>\r\n9.- <b>Cargas de trabajo</b> buscando balance.<br><br>\r\n10.- Se paga a tiempo y completo (tiempos extras, días festivos , etc.), mediante <b>tarjeta bancaria</b> proporcionada por plaza.', 1, 1, NULL, NULL, NOW(), NOW()),
-- -- Area: Ejecución
('e4ef3bd1-7594-4c8b-979f-36502aa841e6', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 6, '*Limpieza', NULL, '- Exterior/ Botes basura/ Isla/ Piso de Venta/ Equipamiento/ Frutero/ Baño/ Bodega/Químicos de Limpieza', '1.- <b>Exterior</b> <font color=red>en buen estado</font>. Banqueta, estacionamiento, pasillos, topes, jardinera y equipos limpios. Cajón y rampa para personas con discapacidad señalizado. Sin grafiti, lámparas limpias. Sin publicidad no autorizada. Árboles, jardineras en buen estado y pasto recortado (si aplica).<br><br>\r\n2.- Contenedor y <b>botes de basura</b> limpios con tapa, en buen estado y señalizados como Orgánico e Inorgánico, con bolsa blanca para Inorgánico y negra para Orgánico (si aplica). Bolsas con no más de 3/4 de su capacidad y área sin exceso de basura, derrames y libre de mal olor.<br><br>\r\n3.-<b>Isla</b>. El piso, los muebles y el equipo en general debe estar limpio y los cajones ordenados. Bolsas para el cliente disponibles y ordenadas. Tapete antifatiga en buen estado. Libre de volantes, <font color=red>publicidad y exhibidores no autorizados, objetos personales e información confidencial de la tienda a la vista del cliente.</font><br><br>\r\n4.- <b>Piso de venta</b> libre de bultos y cajas, mercancía solo en góndolas y exhibidores. Pisos limpios.  Tapete de entrada limpio y en buen estado. La tienda tiene un olor agradable o neutro, se encuentra libre de insectos <font color=red>y/o fauna nociva</font>.<br><br>\r\n5.- <b>Equipamiento</b>: Góndolas (cabeceras, lomo), paletero, hieleras, revisteros, exhibidores en piso de venta y racks para garrafones (incluyendo el espacio entre el piso y la base inferior de ellos) limpios.<br><br>\r\n6.- <b>Frutero</b> limpio incluyendo las charolas, sin derrames de líquidos de frutas o verduras.<br><br>\r\n7.- <b>Baño</b> con olor neutro o agradable. Inodoro, mingitorio, lavamanos, espejo, porta rollo, porta papel de manos y jabonera, paredes, piso y puerta limpios.<br><br>\r\n8.- <b>Bodega</b>. Limpieza. Tarja, paredes, piso, rack, locker y  puertas  limpios. Tener luces de bodega encendidas solo cuando sea necesario. No focos fundidos.<br><br>\r\n9.- Almacenamiento de <b>Químicos de Limpieza</b>. Los químicos de limpieza en uso deberán ser colocados en la canastilla ubicada sobre la tarja de lavado, el resto de químicos (contenedores grandes) deberán ser colocados exclusivamente en el espacio especificado (identificado con una etiqueta).', 1, 1, NULL, NULL, NOW(), NOW()),
('2c0d9fa2-3f56-4fa4-91fd-410c45e36f7a', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 7, '*Exhibición', NULL, '- Mapa Legos/ Planograma/  Límite Altura/  Espacios ASLEP/  rotación de productos / Cigarrera/ Hieleras/ Paquetería', '1.- Los <b>planogramas</b> y exhibidores tienen la misma ubicación y tamaño que el <b>mapa de Legos</b> de la Tienda. <font color=red>Los productos colocados como indica la tira de planograma o PROMOXXO, frenteados y fondeados correctamente. En caso de no haber producto, rellenar el hueco con un ASLEP de la misma familia o con  el producto del lado.</font><br><br>\r\n2.- Los productos ubicados en la charola superior no sobrepasan 10cm del <b>límite de altura</b> de la góndola. Para botanas, abarrotes, vinos y bebidas el limite máximo es 20cm de altura.<br><br>\r\n<font color=red>3.- Contar con exhibidores de piso y hieleras acorde a inventario de espacios.</font><br><br>\r\n4.- Los productos indicados en la de tira <b>ASLEP</b> están ubicados en charolas de expulsión, exhibidores de remate o mueble definidos por la plaza en piso de venta. Todo articulo que no se pueda colocar deberá tener un folio generado.<br><br>\r\n5.- La <b>rotación de productos</b> debe de basarse en \"Lo primero que entra es lo primero que sale, \"<b>PEPS</b>\".<br><br>\r\n6.- <b>Cigarrera</b> con producto exhibido en todos sus carriles y con su respectiva comunicación de precios en cada artículo. <font color=red>Cuenta con charola promocional. Carriles y copete en buen estado (si aplica).</font><br><br>\r\n7.- <b>Hieleras</b> con producto de CCM con al menos el 50% de su capacidad, excepto viernes, sábado y domingo que debe de ocupar el 100%, exhibido de acuerdo a guía de acomodo (si aplica).<br><br>\r\n8.-  Artículos de <b>paquetería</b> en tienda colocados en el espacio definido en el checkout (si aplica) y con <font color=red>calcomanía</font> especificada, libre de otras mercancías o utensilios.', 1, 1, NULL, NULL, NOW(), NOW()),
('aa4e957a-b3ca-48a4-b349-7b7900bc9471', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 8, '*Calidad y Condiciones del Producto', NULL, '- Limpios/ Frutero/ Caducidad/ Deterioro/ Temperatura de Equipos', '1.- Productos <b>limpios</b> y sin empaques alterados, raspados, o maltratados. (Apto para la venta).<br><br>\r\n2.- Producto en frutero se encuentran en buen estado, limpio, sin daño aparente y acomodado adecuadamente; apto para la venta (no sobremaduro).<br><br>\r\n3.- Producto dentro del límite de <b>caducidad</b> establecido en el mismo (retirar los productos un día antes de la fecha de vencimiento, a menos que tenga la leyenda \"Fresco hasta\") y los más próximos a caducar colocados al frente o más cerca del cliente. Los caducos retirarlos y colocarlos en contenedor de merma (aplica para todos los productos).En los productos que solo contengan la caducidad en mes y año, retirar el último día del mes indicado en de la etiqueta. Retirar los productos perecederos que no tengan etiqueta de caducidad.  Insumos de café y alimentos no caducos.<br><br>\r\n4.- Productos sin <b>señales de deterioro</b> como hongos o resequedad, mal olor o color.<br><br>\r\n5.-  <b>Temperatura de equipos</b>. Cámara de conservación de \"Refrescos y lácteos\" (2 a 5 ºC) o (36 - 41 °F), cámara de conservación de \"hielo\" (-10 a -7 ºC), cámara fría o \"cervecero\"  (de 0 a 2 °C)  a excepción de las siguientes plazas: (de 2 a 5 ºC)  en Obregón, Nogales, Monterrey, Saltillo, Allende, Laguna, Piedras Negras, Monclova, Culiacán, La Paz, Los Mochis, Reynosa, Laredo, Matamoros y Cd. Juárez. De ( -2 a 0 ) para plaza Mexicali . Salchichonero a una temperatura de 2 a 6 ºC o 35 a 42 °F. <font color=red>Para equipos de comida rápida consultar Anexo FF.</font>', 1, 1, NULL, NULL, NOW(), NOW()),
('ba25a814-54fb-493b-a1d1-6c7ff3412290', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 9, '*Etiqueteo', NULL, '- Actualizadas/ Etiqueta varios frentes/ Colocadas/ Preciadores/ Remate/ Mismo Precio/ Cerveza', '1.- <b>Etiquetas actualizadas</b> corresponde al producto exhibido y muestra el precio correcto, completamente legible (no decolorada) y no rota.<br><br>\r\n2.- Si el producto es más pequeño que la etiqueta ó los productos son de la misma presentación mismo sabor se coloca al menos <b>una etiqueta para todos los frentes.</b><br><br>\r\n3.- Etiquetas <b>colocadas</b> en porta etiquetas o holders institucionales y <font color=red>ambos en</font> buen estado. No colocar etiquetas en la rejillas frontales del koxka.<br><br>\r\n4.- <b>Preciadores</b> del canasto, de vinos y licores, exhibidores de telefonía y tecnología colocados frente al producto que hace referencia.<br><br>\r\n5.- Producto que aplique con preciador de <b>remate</b> oficial.<br><br>\r\n6.- Productos con misma presentación pero diferente sabor, deben tener el <b>mismo precio</b>.<br><br>\r\n7.- Productos de <b>cerveza</b> que apliquen con etiqueta de precio multi-unidad y su etiqueta de precios individual. Si el producto tiene solo un frente, colocar etiqueta de precio individual.', 1, 1, NULL, NULL, NOW(), NOW()),
('869aec64-ee19-4982-8b14-ddc0b025127c', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 10, '*Comida rápida', NULL, '- Estándares FF/ Insumos/ Caducidad/ Limpios/ Limpieza del área/ Utensilios', 'Todos los conceptos de <b>Fast Food Alimentos y Bebidas</b> que aplican para la tienda se ejecutan según lo definido en base al <b>Anexo a Estándares de Fast Food</b>.<br><br>\r\n1.- Todos los equipos de Fast Food limpios interna y externamente, con vestido y piezas completas y en buen estado.<br><br>\r\n2.- <b>Limpieza</b> del piso, panel duela (si aplica), muebles de comida rápida y café. Botes de basura con bolsa no más de 3/4 de su capacidad y señalizados como Orgánico e Inorgánico, con bolsa blanca para Inorgánico y negra para Orgánico (si aplica). Área libre de malos olores.<br><br>\r\n3.- <b>Utensilios</b> disponibles, limpios y en buen estado.', 1, 1, NULL, NULL, NOW(), NOW()),
('b350cd87-b5fa-44f6-83e5-125b07808f01', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 11, '*Cuarto Frío', NULL, '- Resurtido/ Limpieza/Orden/ Exhibición Visible/ Buenas Prácticas/ Hielo/ Chamarras', '1.- <b>Resurtido</b> continuo de los producto en el cuarto frio (no más de 3 huecos visibles).<br><br>\r\n2.- <b>Limpieza</b>: Puertas, techo y marcos de cuarto frío, parrillas, deslizadores, acrílicos, porta etiquetas, puerta de acceso al cuarto frio, cortina hawaiana, piso, paredes interiores y exteriores (sin evidencia de derrames), rack y exhibidores  limpios y en buen estado.<br><br>\r\n3.- <b>Orden</b>: Pisos sin objetos tirados, barrido y trapeado, libre de malos olores. Sólo exhibidores y productos autorizados para el cuarto frío. Carriles bien definidos con acrílicos de acuerdo al tamaño. El producto apilado está dentro del limite permitido (1.5 mts. de altura). <font color=red>No se coloca producto alimenticio directamente sobre el piso.</font><br><br>\r\n4.- <b>Exhibición visible</b> e iluminada en todo momento. No lámparas fundidas.<br><br>\r\n5.- Buenas prácticas: La cortina de PVC (hawaiana) nunca se encuentra \"colgada\" o \"amarrada\". La(s) puerta(s) de acceso al cuarto frío se mantienen bien cerradas. Productos resguardados en el rack de acuerdo a la guía. Alimentos de personal de tienda en su cajonera autorizada. Aplicación del 5S + 1.<br><br>\r\n6.- Al menos el 50% de <b>existencia de  hielo</b> apto para su venta y con buena accesibilidad. No se estiba más de 1.5 m de altura. No escarcha y/o agua escurriendo en piso del contenedor.<br><br>\r\n7.- Existen 2 <b>chamarras</b> en la tienda en buen estado <font color=red>colgadas en el perchero.</font>', 1, 1, NULL, NULL, NOW(), NOW()),
('6ea02823-255a-41ce-a02f-1de07d70546d', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 12, '*Promociones', NULL, '- Promoxxo/ Oficial/ Vigente/ No Cinta Adhesiva', '1.- Exhibiciones de Piso, Checkout, cabeceras, tiras promocionales  y adicionales con producto de acuerdo al <b>planograma</b> en Promoxxo.<br><br>\r\n2.- El material que se encuentre en tienda debe de ser el <b>oficial</b> y estar <b>vigente</b>.<br><br>\r\n3.- Los materiales <b>POP</b> deben de estar colocados/desplegados correctamente (de acuerdo a  Promoxxo), en buenas condiciones, visibles y sin obstrucciones.<br><br>\r\n4.- Todos los materiales deberán estar pegados con la cinta doble cara que trae el material, en los marcos donde corresponden o colgados con cinchos <font color=red>ó ventosas</font> si es que aplican. <b>Ningún material debe tener cinta adhesiva</b>, ni grapas.', 1, 1, NULL, NULL, NOW(), NOW()),
-- -- Area: Cliente
('c45e9bee-e0b9-4046-ae9e-5b71f517430f', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 13, '*Venta Enfocada', NULL, '- Sugerir/ Servicios/ TGO', '1.- <font color=red>Preguntar si se le ofrece \"algo más\" y/o <b>sugerir</b> promociones o productos de forma constante.</font><br><br>\r\n2.- <b>Servicios</b> (lo que aplique). Portaboletos de autobús, llaveros para TAE, exhibidor de tecnología y telefonía disponibilidad y exhibición, seguros y disponibilidad tarjetas regalo, prepago y Saldazo que apliquen.<br><br>\r\n3.- Se cuenta con las metas definidas por el Asesor de Tienda para cada indicador y se captura el seguimiento diario de avance al indicador en el <b>TGO</b>. Se analiza diariamente el estatus actual de los Factores Críticos así como las gráficas de seguimiento diario y gráficas de proyección mensual en el Tablero de Gestión Operativa.', 1, 1, NULL, NULL, NOW(), NOW()),
('b37408cc-2b36-4c54-b64b-a6a9e386e4ef', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 14, '*Ambientación y Seguridad', NULL, '- No almacenar en/ Luces/ Buenas Prácticas/ 5S+1', '1.- <b>Prohibido almacenar</b> producto y/o chaquetines en el baño. Entrada no obstruida.<br><br>\r\n2.- Tener <b>luces</b> de exterior, piso de venta y baño encendidas solo cuando sea necesario. No focos fundidos.<br><br>\r\n3.- <b>Buenas prácticas</b>. La puerta de la bodega se mantiene cerrada y se abre sólo cuando es necesario. No se colocan productos u objetos encima de equipos eléctricos y de cómputo (si aplica), en el techo del cuarto frío o conservadores de hielo en bolsa. Tableros eléctricos y de control, extintores, salidas de emergencia, puertas de cuarto frío y de bodega libres de cualquier obstrucción.<br><br>\r\n4.- Orden. Aplicación del <b>5S + 1</b> en bodega, incluyendo el escritorio, equipo de cómputo (si aplica), rack y tarja. Los productos se encuentran acomodados en su lugar asignado en carriles delimitados y los utensilios de limpieza se colocan en el Rack de Limpieza. Nota: los productos se encuentran separados al menos 10 cm de la pared (no colocar productos sobre la línea roja) y no se apilan a más de 1.5 metros de altura (no sobrepasan la línea amarilla).', 1, 1, NULL, NULL, NOW(), NOW()),
-- Estándares Semanales:
-- -- Area: Indicadores
('5beb267e-4596-4b9d-800e-b174687d2862', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 15, '*Herramienta de Compra /Tablero de Gestión Operativa', 1, NULL, '1.- Se monitorea diariamente las Tiras de PAFS en riesgo de desabasto, Resumen Operativo, Tira de Venta Recuperada por Exhibición y Tira de Venta Perdida Proveedor-Artículo del Tablero de Gestión Operativa, se imprimen y almacenan día / semana anterior y actual en la Carpeta Operativa y se llevan a cabo acciones para disminuirlos. El pedido se hace de acuerdo al sugerido y se aumenta en caso de ser hueco. Stocks actualizados para artículos durante el periodo promocional.  Se almacenan las compras por día y se revisan contra la hoja de arrastre de saldo diario validando compras y devoluciones.', 1, 1, NULL, NULL, NOW(), NOW()),
('d028e04f-6518-4774-95a8-9b068de756d6', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 16, '*Asignación de Tareas', 2, NULL, '1.- Todos los empleados cuentan con su tira en el turno. El Líder y/o Encargado monitorean diariamente la ejecución de las tareas asignadas. Al menos de manera semanal el líder revisa las tareas creadas y como están asignadas, de forma que coincidan con las áreas de oportunidad encontradas. Las cargas están entre 85% y 100%  y equilibradas, para personal nuevo de acuerdo a vector gente. Se encuentran en el corcho las tiras del último día y turnos laborados.', 1, 1, NULL, NULL, NOW(), NOW()),
('5f3b7982-9938-4e92-b24b-4faaaafbd320', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 17, '*Carpeta Operativa/ Permisos Oficiales/ Corcho Operativo', 3, NULL, '1.- Las carpeta operativa  se encuentra actualizada (aplica según lo comunicado de acuerdo a la última versión), organizada y en buenas condiciones y los puntos que se deban de llenar se llenan tal y como se definió.<br><br>\r\n2.-  Se verifica que los permisos oficiales se encuentren en tienda y vigentes, de acuerdo a la ley local vigente (visibles, donde aplique).<br><br>\r\n<font color=red>3.- Se encuentra en el corcho la tira de artículos del \"Inventario en bodega sin exhibición\" actualizada (no tiene más de 7 días desde su impresión).</font><br><br>\r\n<font color=red>4.- Existe el formato de responsable por Lego evaluado correctamente en el corcho operativo. Se agrega la tira de resumen de cambios todos los lunes.</font>', 1, 1, NULL, NULL, NOW(), NOW()),
('c9db2a88-a6c3-4163-8a7d-2646c4cac677', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 18, '*Señalizaciones, Utensilios, equipos y habilitadores', 4, NULL, '1.- Se cuenta con toda la señalización (que aplique) de acuerdo al <b>Catálogo</b> de Señalización Institucional en tienda, en buen estado y colocada en los lugares correspondientes (basureros, bodega, caja, comida rápida, cuarto frio, estacionamiento, piso de venta, puerta de acceso y baños).<br><br>\r\n2.- <b>Servicios</b> (lo que aplique en plaza). Colgante de cajeros automáticos en buen estado.<br><br>\r\n3.- Anuncio de <b>tipo de cambio</b> (donde aplique) actualizado, en buen estado y colocado a la vista del cliente.<br><br>\r\n4.- Se cuenta con todos los <b>utensilios, habilitadores y equipos</b> de acuerdo al catálogo institucional y estos se encuentran en buen estado.', 1, 1, NULL, NULL, NOW(), NOW()),
-- -- Area: Mantenimiento
('f79c4559-5182-40eb-803f-ca51898c09b6', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 19, '*Condiciones', 5, NULL, '1.- <b>Iluminación</b> de la Tienda (interior y exterior) de acuerdo a la hora del día. No focos y/o lámparas fundidos en exterior ni en piso de venta, bodega o cuarto frío. Anuncios (marquesina, paleta, cajeros automáticos), banqueta (plafón de marquesina, luces de pared y toldos) y estacionamiento (reflectores). Reflectores orientados hacia el estacionamiento. Acrílicos de luminarias limpios y en buen estado.<br><br>\r\n2.- <b>Exterior</b>: Basureros señalizados como orgánico e inorgánico (si aplica) y en buen estado. Marquesina sin golpes. Contenedor de basura en buen estado, con tapa  candado (si aplica) y sin graffitis. Plafones completos y no dañados. Teléfonos públicos con calcomanías bien adheridas y funcionando. Equipo de proveedores (hielo, agua, teléfonos públicos) sin graffiti y en buenas condiciones. Portabanner bien instalado y en  buen estado.<br><br>\r\n3.- <b>Equipo de Isla</b> (los que apliquen) y vidrio de escáner (si aplica) en buen estado. Refrigeradores en buen estado sin exceso de escarcha, sin lámparas fundidas y con puerta bien cerrada.<br><br>\r\n4.- <b>Piso de Venta y Bodega</b>: Temperatura ambiente en el piso de venta es agradable (si se cuenta con termostato o indicador de temperatura a la vista deberá marcar entre 22ºC y 26ºC).  En las Tiendas con aire acondicionado la puerta de acceso a la Tienda se encuentra cerrada y sólo se abre cuando entra y sale gente. Paletero sin exceso de escarcha de hielo, con rejillas despejadas, exterior en  buen estado y con calcomanías bien pegadas. Cajero automático y/o caseta telefónica (si aplican) operando correctamente y limpios. Parrilla de Punto Frío sin polvo o pelusa. Máquinas de Fast Food bebidas (café grano, frappé, capuchino) operando correctamente de acuerdo a la guía rápida de operación. Equipo de comida rápida en buen estado y termómetro (si aplica) funcionando. Máquina de hielo (si aplica en la plaza) operando correctamente, sin goteras, fugas y filtraciones de agua, depósito de hielo funcionando y limpio. Hielera de cerveza sin óxido, manchas, en  buen estado (sin roturas o decoloración), incluyendo estructura, tapas, desagüe y cubetas de desagüe. Equipo de aire acondicionado en  buen estado. Nota: los paleteros, equipos eléctricos o transformadores se encuentran separados al menos 10 cm de la pared u otros objetos. Sin reguladores de voltaje en piso de venta. Góndola mercancías generales (Novelty) o exhibidor pentagonal exhibido en piso de venta de acuerdo al layout de tienda , en buen estado, limpio y con su material POP instalado. Mobiliario de madera en buen estado. Bomba de agua funcionando. Equipo de cómputo en bodega (si aplica) instalado correctamente con base en lo definido. Paredes, ventanas, extractores, plafones y rejilla de aire acondicionado limpios y en buen estado Plafones no rotos o dañados, ni huecos en el techo por falta del mismo. Góndolas en  buen estado  y no despintadas. Pisos no quebrados, despostillados o manchados. Puerta principal en buen estado operando correctamente. Sin manchas por filtraciones en paredes ni goteras en el techo. Mesas/barras y bancos/sillas de Comida Rápida en buen estado. Sin restos de alimentos, basura o  insectos/fauna en el área de comida y Tienda. Con certificado de fumigación vigente. Puerta de bodega en buen estado cerrando correctamente, con cubre polvos y sin huecos o aberturas en sus lados. Sin mercancía, equipo o productos en la parte superior del Cuarto Frío.  Tarja y pileta limpia y en buen estado. Disponibilidad de agua para la operación. Drenaje y fosa séptica de la Tienda en buen estado, sin tuberías o coladeras abiertas y expuestas. Ventanas o rejillas de bodega con malla protectora. Sin huecos en las paredes e instalaciones eléctricas.<br><br>\r\n5.- Refrigerador de hielo \"del proveedor\" (la perilla debe encontrarse en el punto medio del rango del termostato). En Cuarto Frío, (incluyendo cámaras de hielo), la temperatura está dentro de rango establecido, verificar que los difusores estén libres de hielo. Verificar que no haya ruido excesivo o fuera de lo normal en los motores, ni fugas de aire  o agua en las cámaras. Al abrir completamente las puertas se mantienen abiertas; en caso contrario deben cerrarse por sí mismas a \"presión\" (que cierren \"de regreso\"). Puertas no desniveladas.  Empaques de las puertas en buen estado. Existencia de cortina de PVC (hawaiana) limpia y en buen estado. En caso de contar con máquina de hielo que esté en buen estado, la puerta debe permanecer cerrada cuando no se utilice y las rejillas de ventilación despejadas. Parrillas y deslizadores en buen estado. Parrillas no oxidadas. Sólo exhibidores y productos autorizados para el cuarto frío. Nota: no colocar cartones, acrílicos o algún otro material en las parrillas. Productos ordenados (apilados a una distancia mínima de 40 cms. de las parrillas y difusores). Las parrillas tienen la inclinación correcta (multiempaque cero inclinación, productos chicos nivel 2, productos medianos nivel 1 o 2 y productos grandes nivel 1). En parrillas combinadas se usa el acrílico y la inclinación del producto más grande.  Aplicación del 5S + 1 en cuarto frío.<br><br>\r\n6.- <b>Baños</b> de Empleados y Públicos, Inodoro, mingitorio, lavamanos, porta rollo, papel para secar las manos y jabonera, funcionando y en óptimas condiciones (sin fuga de agua, roturas, astillados, quebrados). Inodoro con asiento de acuerdo al tamaño y forma del inodoro, no roto, y funcionando correctamente. Piso no quebrado ni despostillado. Puerta de acceso y/o puerta de baño operando correctamente y funcionando la chapa y el seguro.', 1, 1, NULL, NULL, NOW(), NOW()),
('ccf96047-05ef-4923-ad9c-ddb6bf0f6b8b', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 20, '*Seguridad y Prevención', 6, NULL, '1.-<b>Sistemas de seguridad</b> funcionando correctamente como CCTV (cámaras de seguridad), lámparas de emergencia y alarmas, así como chapas de puertas funcionando correctamente. Extintores vigentes. Existe un botiquín de primeros auxilios con producto en buen estado y completo.<br><br>\r\n2.- <b>Resguardo</b> de Productos de Alto Riesgo (paquetes de cigarros, vinos, celulares y tarjetas excedentes) en la herramienta de resguardo (jaula, bóveda o gaveta de resguardo) y exhibidor de celulares y tecnología bajo llave.<br><br>\r\n3.- No se deberán dejar paquetes de <b>cigarros</b> en cualquier otro lugar que no sea el exhibidor de cigarros.<br><br>\r\n4.- Prevención de <b>Extorsiones</b>: Ningún empleado o persona externa puede solicitar realizar transacciones electrónica (TAE, corresponsalías, etc...) vía telefónica<br><br>\r\n5.- <b>Calcomanías</b> preventivas en buen estado (número de Centro de Control, CCTV, Avisos de Privacidad, otras) en caso de que estas presenten desgaste o no se tengan en Tienda, solicitar por medio de  ATL o Protección Patrimonial.', 1, 1, NULL, NULL, NOW(), NOW()),
-- Estándares Mensuales
-- -- Area: Cultura
('46dbf15a-b493-4445-9066-9dce342abb90', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 21, '*Revisión Vertical', 1, NULL, '1.- Se tiene Revisión Vertical trimestral con cada empleado.', 1, 1, NULL, NULL, NOW(), NOW()),
('2e93b9dd-9daf-4ecd-81fa-b267800f1e94', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 22, '*Dinámica de Cultura', 2, NULL, '1.- Se tiene <b>Dinámica de Cultura</b> bimestral con los empleados. Se da vida y se busca la mejora en base a los dialogos sostenidos. Se logra participación de todos y se llega a acuerdos.', 1, 1, NULL, NULL, NOW(), NOW()),
('9e31cc0e-5b00-417f-88e8-4ea1060a4754', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'E', NULL, NULL, 23, '*Rituales de Gestión', 3, NULL, '1.- <b>Asesor-Líder de Tienda</b> se coordinan acciones con enfoque al incremento de Ventas de la Plaza con el apoyo de los Asesores Tienda, así como también la revisión de proyectos e iniciativas de la Plaza.<br><br>\r\n2.- <b>Líder-Equipo de Tienda</b> se están realizando de forma constante revisando oportunidades y generando plan de acción. \r\nSe da cumplimiento, seguimiento y hay avance en el <b>plan de acción</b> de la tienda.', 1, 1, NULL, NULL, NOW(), NOW());

-- SELECT * FROM `xxbdo_estandares_fotos` WHERE `xxbdo_estandares_id` IN (SELECT id FROM `xxbdo_estandares` WHERE `xxbdo_version_estandares_id`='13d772fa-826b-424f-802e-63da4777e33c' );

-- -----------------------------------
-- Create link to fotos for v24 
INSERT INTO `xxbdo_estandares_fotos` (`id`, `xxbdo_estandares_id`, `foto`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
-- std 1
('308be21b-b323-4cb0-8c76-c352c84e1b80', '5fb981a4-bd6c-435d-9f6b-b14a17fd40d6', '1539890983917-c3RkLTIzLTAxLnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00'),
-- std 2
('a8b91a7d-46c0-4d62-bd0e-2d42b412118d', '12608581-10cb-497b-8126-4aeea7c98c2c', '1539891011940-c3RkLTIzLTAyLnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00'),
-- std 3
('98a42fa4-5e0b-40cc-bef4-9b80fdace0ff', '64bf0700-6e1b-48c0-ac57-a72fba24ca5b', '1539891044032-c3RkLTIzLTAzLnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00'),
-- std 4
('313ed393-16f2-4e35-9552-c59d9158515c', '52ad88e6-4dcb-40d2-99b9-d55e06dc8240', '1539891403168-dHNkLTIzLTA0LnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00'),
-- std 5
('35ad2689-22a9-48ed-aa83-ebc498d3e220', '6f1cdbed-19c1-4422-af61-827a8cde9cb6', '1539891103645-c3RkLTIzLTA1LnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00'),
-- std 6
('4910f36b-adfb-43a7-b4cd-144ef7e11de3', 'e4ef3bd1-7594-4c8b-979f-36502aa841e6', '1539891136296-c3RkLTIzLTA2LnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00'),
-- std 7
('1670de17-1437-49f3-83fb-9e89b3af917f', '2c0d9fa2-3f56-4fa4-91fd-410c45e36f7a', '1539891168890-c3RkLTIzLTA3LnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00'),
-- std 8
('c067f699-ad8a-4e9c-b9c4-96bd59474356', 'aa4e957a-b3ca-48a4-b349-7b7900bc9471', '1539891205496-c3RkLTIzLTA4LnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00'),
-- std 9
('d86d0261-1bf6-4c50-afba-6ded47471e2b', 'ba25a814-54fb-493b-a1d1-6c7ff3412290', '1539891235403-c3RkLTIzLTA5LnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00'),
-- std 10
('f6dd748d-f7b8-4027-8397-91448e9d9ff2', '869aec64-ee19-4982-8b14-ddc0b025127c', '1539891258006-c3RkLTIzLTEwLnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00'),
-- std 11
('0418d31d-833f-42e2-bff2-f39243e772d6', 'b350cd87-b5fa-44f6-83e5-125b07808f01', '1539891295618-c3RkLTIzLTExLnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00'),
-- std 12
('7e66e1b1-6b25-4cc0-ac07-4d772705c1f8', '6ea02823-255a-41ce-a02f-1de07d70546d', '1539891318260-c3RkLTIzLTEyLnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00'),
-- std 13
('f511bdd1-5fed-4cb7-9df8-a0d440d2318c', 'c45e9bee-e0b9-4046-ae9e-5b71f517430f', '1539891358413-c3RkLTIzLTEzLnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00'),
-- std 14
('4a79d28a-f85a-4802-b355-8a63e8a7b926', 'b37408cc-2b36-4c54-b64b-a6a9e386e4ef', '1539891383577-c3RkLTIzLTE0LnBuZw==.png', 1, NULL, NULL, '2018-10-18 00:00:00', '2018-10-18 00:00:00');

-- Query to create tmp table to exporte area_estandares records from v23:
-- CREATE TABLE tbl_areas_estandares_v23 SELECT * FROM `xxbdo_areas_estandares` WHERE `xxbdo_estandares_id` IN (SELECT `id` FROM `xxbdo_estandares` WHERE `xxbdo_version_estandares_id`='13d772fa-826b-424f-802e-63da4777e33c' AND tipo NOT IN ('L')) ORDER BY xxbdo_areas_id, orden;

-- ----------------------
-- Create records for areas_estandares v24
INSERT INTO `xxbdo_areas_estandares` (`id`, `xxbdo_areas_id`, `xxbdo_estandares_id`, `valor`, `orden`, `dias_activos`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
-- Estándares Diarios:
-- -- Area: Servicio
-- 5a6f7661-afb3-497a-8e39-10d176cc42bb
('66a57677-e5c8-48d0-94f2-5d48670f3ced', 'a04328ea-05db-490e-bc63-5475d03877ab', '5fb981a4-bd6c-435d-9f6b-b14a17fd40d6', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- 8c5843a4-4ee9-4a9c-a497-e880a0029a95 
('066474b3-8464-4410-abf0-820ce79baf89', 'a04328ea-05db-490e-bc63-5475d03877ab', '12608581-10cb-497b-8126-4aeea7c98c2c', 0, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- -- Area: Ingreso
-- c580fa9e-b53f-4cdd-820c-f98e85dedbe2
('0bdd0358-1b9e-41b5-bb20-fc3b328cf122', '8ca08d52-21b6-439a-a471-d2fa7449f47d', '64bf0700-6e1b-48c0-ac57-a72fba24ca5b', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- -- Area: Gente
-- 3079d111-f116-4845-8eb5-85b759b92e4f
('ed2f4dbb-41ff-4e9e-b8b3-f0fb288abc3c', 'afe19eee-2af9-4ab1-bd87-69222dfd0466', '52ad88e6-4dcb-40d2-99b9-d55e06dc8240', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- acc00d84-4e1d-4ad9-be75-a84ac091ccc6
('55ea8f07-fb96-422c-8ded-5b10ffe9a8d9', 'afe19eee-2af9-4ab1-bd87-69222dfd0466', '6f1cdbed-19c1-4422-af61-827a8cde9cb6', 0, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- -- Area: Ejecución
-- 87af5596-f2e0-409b-b757-bcaa2f7d0a0d
('0952ec6a-dcbc-4410-9f17-063072d9286d', 'c7f52328-2e89-4571-92e5-3bf12733b205', 'e4ef3bd1-7594-4c8b-979f-36502aa841e6', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- 9825f468-d2cc-4805-ab47-804cea7e659e
('6e4e6771-be4c-406b-968a-3e6a574cc4bf', 'c7f52328-2e89-4571-92e5-3bf12733b205', '2c0d9fa2-3f56-4fa4-91fd-410c45e36f7a', 0, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- fe70e125-ab5d-400d-8bc9-00acf4727a66
('90dc7007-4f5a-4374-9429-d76af0c9c571', 'c7f52328-2e89-4571-92e5-3bf12733b205', 'aa4e957a-b3ca-48a4-b349-7b7900bc9471', 0, 3, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- 8fe04362-c309-4549-8d50-9b25a8e364c7
('8e0bf2ca-efc0-417d-abb4-b75ef0e15034', 'c7f52328-2e89-4571-92e5-3bf12733b205', 'ba25a814-54fb-493b-a1d1-6c7ff3412290', 0, 4, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- 3f36624d-56d0-487e-bad7-fdabf644f027
('c1a30e8b-e2a4-46ab-a6ce-0b2d71ba695e', 'c7f52328-2e89-4571-92e5-3bf12733b205', '869aec64-ee19-4982-8b14-ddc0b025127c', 0, 5, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- bc37070e-525d-4900-8732-c5b90c60f5b3 
('2a12e860-03b4-462c-bef3-1588ec014674', 'c7f52328-2e89-4571-92e5-3bf12733b205', 'b350cd87-b5fa-44f6-83e5-125b07808f01', 0, 6, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- 8a4b9e51-197d-4725-b42e-aeca39598b2a 
('732a2781-84df-4e6c-acab-c7b25cf42bb0', 'c7f52328-2e89-4571-92e5-3bf12733b205', '6ea02823-255a-41ce-a02f-1de07d70546d', 0, 7, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- -- Area: Cliente
-- 6e1b34ef-2eee-41f4-a1d0-79227af1de5d 
('02b1799d-a7cd-42bc-b6c4-2e30ceef6d0e', '1f67e255-4de1-4bab-a2d4-1e1040a7d14d', 'c45e9bee-e0b9-4046-ae9e-5b71f517430f', 0, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- f33edcf7-8d8d-4049-a26f-1770bd0b197d 
('b8bb2675-f355-4249-888e-0ae38f570773', '1f67e255-4de1-4bab-a2d4-1e1040a7d14d', 'b37408cc-2b36-4c54-b64b-a6a9e386e4ef', 0, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- Estándares Semanales
-- -- Area: Indicadores
-- f62ca608-cfac-4b65-8168-36bf5bb5277d 
('57da0b69-c6b3-4912-8d51-ea99e38bc464', 'c8ac9cd8-a9e9-49d9-bcb5-5410f5eb019a', '5beb267e-4596-4b9d-800e-b174687d2862', 1, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- d45bb2af-8d7a-4797-a2aa-103e83481145
('87ee8906-a108-4458-b862-d93b46e4d4cd', 'c8ac9cd8-a9e9-49d9-bcb5-5410f5eb019a', 'd028e04f-6518-4774-95a8-9b068de756d6', 1, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- 385aafdb-2d04-424e-af65-918b5057295d
('7fd5b719-5d51-4a9b-920e-9f4e33472709', 'c8ac9cd8-a9e9-49d9-bcb5-5410f5eb019a', '5f3b7982-9938-4e92-b24b-4faaaafbd320', 1, 3, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- 30cdb8b4-d614-4f42-a804-2f378d1e940d
('917400aa-ab7f-4571-88e1-c36e8a59dbe4', 'c8ac9cd8-a9e9-49d9-bcb5-5410f5eb019a', 'c9db2a88-a6c3-4163-8a7d-2646c4cac677', 1, 4, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- Area: Mantenimiento
-- 70f6862d-80ea-462b-b7fb-bb2eadaf9b16
('9fbee4c1-4667-48d6-8fd1-0268fd1d9ae1', '4d8e6e26-d10d-4163-856a-b1c5b59e8794', 'f79c4559-5182-40eb-803f-ca51898c09b6', 1, 5, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- 14cf6b5f-45a7-4564-b515-fca0de4d6152 
('98a81a09-dbd1-4b4f-a55d-650431ce8d23', '4d8e6e26-d10d-4163-856a-b1c5b59e8794', 'ccf96047-05ef-4923-ad9c-ddb6bf0f6b8b', 1, 6, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- Area: Cultura
-- b4ab76e8-8f54-4104-8685-d051a4ed8358
('d7b3e5fb-385a-4a22-9f39-c773f1122689', '05189091-7829-4880-8cda-d6c74c9728ac', '46dbf15a-b493-4445-9066-9dce342abb90', 1, 1, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- d1479d38-2e91-4d90-982d-794b3e9dc5df
('053c58d2-9081-4482-b4da-6cbe43c91d81', '05189091-7829-4880-8cda-d6c74c9728ac', '2e93b9dd-9daf-4ecd-81fa-b267800f1e94', 1, 2, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW()),
-- 12c3fbc4-d016-4c69-89fe-c5fe1f29175e
('dc3233dc-ffc8-4b1f-a7b7-cfcfe4bd3006', '05189091-7829-4880-8cda-d6c74c9728ac', '9e31cc0e-5b00-417f-88e8-4ea1060a4754', 1, 3, '1,2,3,4,5,6,7', 1, NULL, NULL, NOW(), NOW());

-- Query to create tmp table to select records from xxbdo_checklists_has_areas_estandares:
-- create table tbl_checklists_has_areas_estandares_v23 SELECT * FROM `xxbdo_checklists_has_areas_estandares` WHERE `xxbdo_checklists_id`='3e50f58c-8634-41ce-93b5-c8bebb8bce46' AND xxbdo_areas_estandares_id IN( SELECT `id` FROM `xxbdo_areas_estandares` WHERE `xxbdo_estandares_id` IN (SELECT `id` FROM `xxbdo_estandares` WHERE `xxbdo_version_estandares_id`='13d772fa-826b-424f-802e-63da4777e33c' AND tipo NOT IN ('L'))) ;

-- ----------------------------------
-- Create records for `xxbdo_checklists_has_areas_estandares` v24
INSERT INTO `xxbdo_checklists_has_areas_estandares` (`xxbdo_checklists_id`, `xxbdo_areas_estandares_id`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('f767aea8-988c-4e36-9037-59660573b877', '66a57677-e5c8-48d0-94f2-5d48670f3ced', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '066474b3-8464-4410-abf0-820ce79baf89', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '0bdd0358-1b9e-41b5-bb20-fc3b328cf122', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'ed2f4dbb-41ff-4e9e-b8b3-f0fb288abc3c', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '55ea8f07-fb96-422c-8ded-5b10ffe9a8d9', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '0952ec6a-dcbc-4410-9f17-063072d9286d', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '6e4e6771-be4c-406b-968a-3e6a574cc4bf', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '90dc7007-4f5a-4374-9429-d76af0c9c571', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '8e0bf2ca-efc0-417d-abb4-b75ef0e15034', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'c1a30e8b-e2a4-46ab-a6ce-0b2d71ba695e', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '2a12e860-03b4-462c-bef3-1588ec014674', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '732a2781-84df-4e6c-acab-c7b25cf42bb0', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '02b1799d-a7cd-42bc-b6c4-2e30ceef6d0e', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'b8bb2675-f355-4249-888e-0ae38f570773', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '57da0b69-c6b3-4912-8d51-ea99e38bc464', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '87ee8906-a108-4458-b862-d93b46e4d4cd', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '7fd5b719-5d51-4a9b-920e-9f4e33472709', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '917400aa-ab7f-4571-88e1-c36e8a59dbe4', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '9fbee4c1-4667-48d6-8fd1-0268fd1d9ae1', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '98a81a09-dbd1-4b4f-a55d-650431ce8d23', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'd7b3e5fb-385a-4a22-9f39-c773f1122689', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '053c58d2-9081-4482-b4da-6cbe43c91d81', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'dc3233dc-ffc8-4b1f-a7b7-cfcfe4bd3006', 1, 1, NULL, NULL, NOW(), NOW());

-- ------------------------------
-- Create indicadores v24
-- SELECT `xxbdo_areas_estandares_indicadores`.id, xxbdo_areas_estandares_id, xxbdo_indicadores_id,`xxbdo_areas_estandares_indicadores`.orden, titulo FROM `xxbdo_areas_estandares_indicadores`, `xxbdo_indicadores` WHERE `xxbdo_indicadores_id` = `xxbdo_indicadores`.`id` AND `xxbdo_areas_estandares_indicadores`.activo=1 ORDER BY `xxbdo_areas_estandares_indicadores`.`orden` ASC ;
INSERT INTO `xxbdo_indicadores` (`id`, `xxbdo_version_estandares_id`, `tipo`, `cr_plaza`, `cr_tienda`, `titulo`, `descripcion`, `xxbdo_indicadores_frecuencias_id`, `orden`, `tipo_dato`, `default`, `foto`, `detalle`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
-- bbfe5636-4304-4b9d-810a-178fad1130e6
('dcc1ddeb-fde3-43ce-9bb7-4220c520c74b', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Ev. Operativa Sección Atención', 'Ev. Operativa Sección Atención', 'M', NULL, 'int', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- ad340633-9e7d-412f-a0b8-7b4f905a69ec
('7266b508-79b1-4b51-9b50-1413e3b10564', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Protocolo de Servicio', 'Protocolo de Servicio', 'M', NULL, 'int', '0', NULL, NULL, 0, NULL, NULL, NOW(), NOW()),
-- 469f5845-1498-4ae8-a0c2-d30e2b806e09
('75e5a7b3-af5d-4b94-af3a-3a824b7251a8', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Ev. Operativa Sección Rapidez', 'Ev. Operativa Sección Rapidez (indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- 5e9e6b32-8d7a-43ad-8145-2ba627f2b67d
('b07f7c77-d276-453f-b248-fc41892b6bc9', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Conteos', 'Conteos', 'S', NULL, 'int', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- b49f07bc-93e7-4eab-b3f6-ae65bb60d91c
('e7f384e5-43e9-4c0f-9662-023b5c564e98', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Cobertura', 'Cobertura (Indicador de tipo porcentaje)', 'S', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- ad3846a4-15b3-47a0-a775-2e1a5ce2e20f
('c5ec27ae-0f43-40e5-b04c-db5dc73b3102', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Resultado de Inventario', 'Resultado de Inventario (Indicador de tipo monetario)', 'M', NULL, 'money', '0.00', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- 4fd79d79-9e95-4b1e-85f0-bdd750214c8f
('b2103939-e31f-45e8-8461-7f0f83bf134c', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Scorecard preinventarios/ Entrega de Valores', 'Scorecard preinventarios/ Entrega de Valores (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- fc5bb88c-0753-4b89-b2ba-25a69a81c62f
('b8f0756f-0a2f-42e1-b23b-ad2f2ac5857d', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Equipos Completos', 'Equipos Completos (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- c16be293-3f3a-4b98-81b1-4d5334cff7f6
('6e0a3a59-542b-4e51-90d8-fc92bc21ecd1', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Equipos Capacitados', 'Equipos Capacitados (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- db3ba55e-145b-4429-8050-42c195d15ab7
('eb3cdd32-f3eb-48d2-a05d-04a334978ae5', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Vector Gente', 'Vector Gente', 'S', NULL, 'int', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- 2c09cdc0-4e93-4f28-9d78-0158c8a566c6
('af34c7db-879f-462a-9939-a78abdecb67e', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Rotación', 'Rotación', 'M', NULL, 'int', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- 222968a6-d9ea-46de-aa5c-c9412167972d
('e022a745-cb30-4de4-a9bd-8662cb0e87eb', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Ev. Operativa Sección Limpieza', 'Ev. Operativa Sección Limpieza (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- 5de6ee9f-7186-4ee2-978c-b71727e3e0d8
('4d3ffb1b-5449-48d0-8611-18c90441c5df', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Planogramas (Charola/Mueble)', 'Planogramas (Charola/Mueble) (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- ae77c68b-3e63-4f96-9426-aec3f553b845
('e18639a5-9296-4e7e-a2bf-69ba62149852', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*MEP P.P.', 'MEP P.P. (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- ddd7944c-088a-49df-a7ea-f128fea386c8
('17ae3375-f157-4014-bb01-444b37c77cbc', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Scorecard Calidad de Producto', 'Scorecard Calidad de Producto (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- b1e27dfd-e37a-455e-b668-ccda29db8e9f
('a1a7f344-3e3a-456a-b06e-f45e834f8071', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Ev. Operativa Sección Abasto', 'Ev. Operativa Sección Abasto (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- e0f79432-a0e5-47c9-9692-9cd59a039d0c
('dca1fb28-6625-4574-b533-83799252ab12', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Scorecard Etiqueteo', 'Scorecard Etiqueteo (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- 5f128883-45d3-42b0-bfc5-07790eac9215
('e0b20727-8bb6-4c0c-8532-12b2ee5f645d', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Exhibición Real Americano', 'Exhibición Real Americano (Indicador de tipo porcentaje)', 'S', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- 2cd8037e-e777-4db4-8fa5-9ce702b5343f
('f183a0ef-15fd-420c-a626-16bf0e3c09bb', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Exhibición Real Roller', 'Exhibición Real Roller (Indicador de tipo Porcentaje)', 'S', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- 5c5bd2dc-c4fe-42cd-affa-52d693389d5b
('2aaedd6a-fa82-45c9-a6b7-a3db0d539199', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Veracidad de Inventarios', 'Veracidad de Inventarios', 'S', NULL, 'int', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- ee838814-41d5-43a0-a289-48357aa68fb8
('c18f2918-651c-4d23-9cd6-e30eb4cc6fb4', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*% Cumplimiento a devoluciones diarias', 'Porcentaje de cumplimiento a devoluciones diarias (Indicador de tipo Porcentaje)', 'S', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- a2738a70-7352-4b7b-a63f-663fdb2ee89e
('35584e3e-6cdd-4587-a1ef-d4d6799bfb7e', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Ev. Donas a Granel', 'Ev. Donas a Granel (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- 222eb7fa-71f4-44be-9057-edf33fd98cc7
('7bb169b8-ace1-48ae-99ef-7f8e0fcc84b6', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Ev. Operativa Puntos Cuarto Frío', 'Ev. Operativa Puntos Cuarto Frío (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- 6568ab1b-2ff9-40ad-8b09-5663ddddcf5a
('36884fb6-18b7-4657-80f2-45b1123785bc', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*MEP POP', 'MEP POP (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- 59a7c719-36af-415f-a176-558bbf2f3794
('bd28758f-5bd5-43f6-b47c-d5437e0f3d95', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Venta sugerida', 'Venta sugerida (Indicador de tipo monetario)', 'S', NULL, 'money', '0.00', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- 7af2d792-0453-4cca-ba4c-243edcc06526
('0f73ad1b-0a6e-4c60-ba77-7c17ccb20b97', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Usuarios activos', 'Usuarios activos', 'S', NULL, 'int', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW()),
-- 202b995f-f4fe-4805-8a61-1ec28fcc7c73
('74f9d3fc-ead1-4519-a32c-17f4d800ad54', 'c817b538-1b4d-4901-9181-f89aaeb15171', 'I', NULL, NULL, '*Ev. 5S + 1', 'Ev. 5S + 1', 'S', NULL, 'int', '0', NULL, NULL, 1, NULL, NULL, NOW(), NOW());

-- ---------------------------------------
-- Dumping data for table `xxbdo_areas_estandares_indicadores`
-- 
INSERT INTO `xxbdo_areas_estandares_indicadores` (`id`, `xxbdo_areas_estandares_id`, `xxbdo_indicadores_id`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
-- 686fcba0-f0c2-49d4-9c94-56871ddd2bee 
('42236e1b-ff18-4d15-a447-9edf2fac2965', '66a57677-e5c8-48d0-94f2-5d48670f3ced', 'dcc1ddeb-fde3-43ce-9bb7-4220c520c74b', 1, 1, NULL, NULL, NOW(), NOW()),
-- 6c4e8f4b-237e-45a9-bfa0-4b6d291eca75 
('396490b2-9acc-4cea-a88d-cfda2f44b481', '066474b3-8464-4410-abf0-820ce79baf89', '7266b508-79b1-4b51-9b50-1413e3b10564', 2, 0, NULL, NULL, NOW(), NOW()),
-- edaf6de7-181b-4433-be39-57bfe196dcfe 
('158a5322-5ba1-48cd-a4e4-16f5277b7a31', '066474b3-8464-4410-abf0-820ce79baf89', '75e5a7b3-af5d-4b94-af3a-3a824b7251a8', 3, 1, NULL, NULL, NOW(), NOW()),
-- 28fe2251-7417-4d36-b8b1-cc7b1e49277a 
('673076d9-74c7-42d1-9f44-6eb4ae37f3ec', '0bdd0358-1b9e-41b5-bb20-fc3b328cf122', 'b07f7c77-d276-453f-b248-fc41892b6bc9', 4, 1, NULL, NULL, NOW(), NOW()),
-- ea10c7b1-4d37-4bf7-97d2-f50223f87cfc 
('291bfa4d-cda8-4fa0-869f-859b50bde85f', '0bdd0358-1b9e-41b5-bb20-fc3b328cf122', 'e7f384e5-43e9-4c0f-9662-023b5c564e98', 5, 1, NULL, NULL, NOW(), NOW()),
-- 9dbdd38b-bff6-459f-87a4-b3d6c3eeaee1 
('c407cd7a-4e05-440d-bad9-4d3d979730d3', '0bdd0358-1b9e-41b5-bb20-fc3b328cf122', 'c5ec27ae-0f43-40e5-b04c-db5dc73b3102', 6, 1, NULL, NULL, NOW(), NOW()),
-- 24c8cfb5-c62c-4eb2-9323-90c5740dca57 
('f648f814-bc2c-48a3-856d-da2be7857e5a', '0bdd0358-1b9e-41b5-bb20-fc3b328cf122', 'b2103939-e31f-45e8-8461-7f0f83bf134c', 7, 1, NULL, NULL, NOW(), NOW()),
-- a616a9f9-3aae-42b4-8299-c76e497ce45d 
('4334201a-dfb3-4fe2-8d60-9e5ce3142200', 'ed2f4dbb-41ff-4e9e-b8b3-f0fb288abc3c', 'b8f0756f-0a2f-42e1-b23b-ad2f2ac5857d', 8, 1, NULL, NULL, NOW(), NOW()),
-- 93f43e13-b366-4006-bf96-d08f72296ba0 
('6e054463-6b28-40d0-9fa3-984aa7f2bee4', 'ed2f4dbb-41ff-4e9e-b8b3-f0fb288abc3c', '6e0a3a59-542b-4e51-90d8-fc92bc21ecd1', 9, 1, NULL, NULL, NOW(), NOW()),
-- 8de6905e-8cc5-4d9d-b13b-7b8a1137c8ee 
('aa78422c-d81b-4d5a-acda-0e55296e2c81', '55ea8f07-fb96-422c-8ded-5b10ffe9a8d9', 'eb3cdd32-f3eb-48d2-a05d-04a334978ae5', 10, 1, NULL, NULL, NOW(), NOW()),
-- c00c8799-2e22-4b3e-92a1-98d264bcbde8 
('e15d57cb-2df6-418b-a25f-d481f597b367', '55ea8f07-fb96-422c-8ded-5b10ffe9a8d9', 'af34c7db-879f-462a-9939-a78abdecb67e', 11, 1, NULL, NULL, NOW(), NOW()),
-- 9e17146e-1152-4f56-92b9-eb0190d20f6c 
('3d99be3e-207f-4f59-8907-10284b0e9f19', '0952ec6a-dcbc-4410-9f17-063072d9286d', 'e022a745-cb30-4de4-a9bd-8662cb0e87eb', 12, 1, NULL, NULL, NOW(), NOW()),
-- b8e6349e-b29d-4a0d-8daa-80c4c8b3a216 
('17392fc5-5cb1-44e2-94ee-871d0ef8a3e6', '6e4e6771-be4c-406b-968a-3e6a574cc4bf', '4d3ffb1b-5449-48d0-8611-18c90441c5df', 13, 1, NULL, NULL, NOW(), NOW()),
-- 3a1f97fe-8efe-4b53-808d-d737e296dd81 
('d13020a1-1933-40db-98b6-e03ad0a2ef09', '6e4e6771-be4c-406b-968a-3e6a574cc4bf', 'e18639a5-9296-4e7e-a2bf-69ba62149852', 14, 1, NULL, NULL, NOW(), NOW()),
-- 38792cd8-6404-4850-95e3-c57f430f7182 
('59b7255e-bf39-4e90-af66-259a37b71839', '90dc7007-4f5a-4374-9429-d76af0c9c571', '17ae3375-f157-4014-bb01-444b37c77cbc', 15, 1, NULL, NULL, NOW(), NOW()),
-- 1e88d131-dec3-4014-b61e-b08ae66f35ad
('5708b732-4e85-4a67-9e42-2aecacb66193', '90dc7007-4f5a-4374-9429-d76af0c9c571', 'a1a7f344-3e3a-456a-b06e-f45e834f8071', 16, 1, NULL, NULL, NOW(), NOW()),
-- 4d18ecd9-5ffb-46a2-b56e-b0cfaef18c37 
('35d52695-124e-453d-98ca-a6c3261deaaf', '8e0bf2ca-efc0-417d-abb4-b75ef0e15034', 'dca1fb28-6625-4574-b533-83799252ab12', 17, 1, NULL, NULL, NOW(), NOW()),
-- f51628d3-d0a1-4440-996f-f4c6450195c0 
('1996d98c-c542-4eb0-abd9-334ce1757c63', 'c1a30e8b-e2a4-46ab-a6ce-0b2d71ba695e', 'e0b20727-8bb6-4c0c-8532-12b2ee5f645d', 18, 1, NULL, NULL, NOW(), NOW()),
-- f24e27ae-13ec-496c-9c57-68afe65e4cc4 
('b9c6292f-66e1-457a-9f58-a705abd3b2e8', 'c1a30e8b-e2a4-46ab-a6ce-0b2d71ba695e', 'f183a0ef-15fd-420c-a626-16bf0e3c09bb', 19, 1, NULL, NULL, NOW(), NOW()),
-- 22ce4f3a-808c-46a9-ad57-dcec4b172e22 
('716b3fa3-7503-4ca0-b2e7-de6b7c0d1f39', 'c1a30e8b-e2a4-46ab-a6ce-0b2d71ba695e', '2aaedd6a-fa82-45c9-a6b7-a3db0d539199', 20, 1, NULL, NULL, NOW(), NOW()),
-- f0d7813d-734d-4256-8ad3-eb22044132d6 
('182661c5-e930-44ac-b482-7ab22bc7d501', 'c1a30e8b-e2a4-46ab-a6ce-0b2d71ba695e', 'c18f2918-651c-4d23-9cd6-e30eb4cc6fb4', 21, 1, NULL, NULL, NOW(), NOW()),
-- b2e3724a-b7c3-4c0e-bd3b-dcf8ed0c18ec 
('efdec753-a6eb-48a6-ab4a-2b76856b8d20', 'c1a30e8b-e2a4-46ab-a6ce-0b2d71ba695e', '35584e3e-6cdd-4587-a1ef-d4d6799bfb7e', 22, 1, NULL, NULL, NOW(), NOW()),
-- 85501381-f779-45b4-acaa-91d97693d7a6 
('8bc959ea-200b-4377-ad5c-448845210b65', '2a12e860-03b4-462c-bef3-1588ec014674', '7bb169b8-ace1-48ae-99ef-7f8e0fcc84b6', 23, 1, NULL, NULL, NOW(), NOW()),
-- 03433451-9c6f-45b4-b5b4-abe261d783dc 
('3513a9d5-f8b0-4baf-90ef-0b050f155ff5', '732a2781-84df-4e6c-acab-c7b25cf42bb0', '36884fb6-18b7-4657-80f2-45b1123785bc', 24, 1, NULL, NULL, NOW(), NOW()),
-- d98faa09-ddab-4d64-ae0e-e77297c09cec 
('c16c69d8-f419-4f57-a48f-fe3fa2dd982c', '02b1799d-a7cd-42bc-b6c4-2e30ceef6d0e', 'bd28758f-5bd5-43f6-b47c-d5437e0f3d95', 25, 1, NULL, NULL, NOW(), NOW()),
-- 8059b8d9-c9b8-4cd1-b953-2c360af5827a 
('dd86b2e9-95ed-48e7-8b82-73f0cc7fb3cb', '02b1799d-a7cd-42bc-b6c4-2e30ceef6d0e', '0f73ad1b-0a6e-4c60-ba77-7c17ccb20b97', 26, 1, NULL, NULL, NOW(), NOW()),
-- 25e1acfd-a819-49ef-89d9-877c927c0ee7 
('a81a60ed-9d28-49dc-88c5-ea7c4af8404c', 'b8bb2675-f355-4249-888e-0ae38f570773', '74f9d3fc-ead1-4519-a32c-17f4d800ad54', 27, 1, NULL, NULL, NOW(), NOW());

-- -------------------------------
-- Create records for `xxbdo_checklists_has_areas_estandares_indicadores` v24
--
INSERT INTO `xxbdo_checklists_has_areas_estandares_indicadores` (`xxbdo_checklists_id`, `xxbdo_areas_estandares_indicadores_id`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('f767aea8-988c-4e36-9037-59660573b877', '42236e1b-ff18-4d15-a447-9edf2fac2965', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '396490b2-9acc-4cea-a88d-cfda2f44b481', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '158a5322-5ba1-48cd-a4e4-16f5277b7a31', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '673076d9-74c7-42d1-9f44-6eb4ae37f3ec', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '291bfa4d-cda8-4fa0-869f-859b50bde85f', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'c407cd7a-4e05-440d-bad9-4d3d979730d3', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'f648f814-bc2c-48a3-856d-da2be7857e5a', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '4334201a-dfb3-4fe2-8d60-9e5ce3142200', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '6e054463-6b28-40d0-9fa3-984aa7f2bee4', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'aa78422c-d81b-4d5a-acda-0e55296e2c81', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'e15d57cb-2df6-418b-a25f-d481f597b367', 1, 0, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '3d99be3e-207f-4f59-8907-10284b0e9f19', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '17392fc5-5cb1-44e2-94ee-871d0ef8a3e6', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'd13020a1-1933-40db-98b6-e03ad0a2ef09', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '59b7255e-bf39-4e90-af66-259a37b71839', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '5708b732-4e85-4a67-9e42-2aecacb66193', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '35d52695-124e-453d-98ca-a6c3261deaaf', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '1996d98c-c542-4eb0-abd9-334ce1757c63', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'b9c6292f-66e1-457a-9f58-a705abd3b2e8', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '716b3fa3-7503-4ca0-b2e7-de6b7c0d1f39', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '182661c5-e930-44ac-b482-7ab22bc7d501', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'efdec753-a6eb-48a6-ab4a-2b76856b8d20', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '8bc959ea-200b-4377-ad5c-448845210b65', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', '3513a9d5-f8b0-4baf-90ef-0b050f155ff5', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'c16c69d8-f419-4f57-a48f-fe3fa2dd982c', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'dd86b2e9-95ed-48e7-8b82-73f0cc7fb3cb', 1, 1, NULL, NULL, NOW(), NOW()),
('f767aea8-988c-4e36-9037-59660573b877', 'a81a60ed-9d28-49dc-88c5-ea7c4af8404c', 1, 1, NULL, NULL, NOW(), NOW());

-- ---------------
-- Disable current checklist v23 for all tiendas
UPDATE `xxbdo_checklists_tiendas` 
SET `es_default`=0 
WHERE `xxbdo_checklists_id`='3e50f58c-8634-41ce-93b5-c8bebb8bce46';

-- ---------------------
-- Create records `xxbdo_checklists_tiendas` for v24 from v23
INSERT INTO `xxbdo_checklists_tiendas` 
SELECT 'f767aea8-988c-4e36-9037-59660573b877' AS `xxbdo_checklists_id`, 
`cr_plaza`, 
`cr_tienda`, 
'1' AS `es_default`, 
'1' AS `activo`, 
NULL AS `usuario`, 
NULL AS `ip_address`, 
NOW() AS `fecha_creacion`, 
NOW() AS `fecha_modificacion` 
FROM `xxbdo_checklists_tiendas` 
WHERE `xxbdo_checklists_id`='3e50f58c-8634-41ce-93b5-c8bebb8bce46';

-- ---------------------
-- Create records into `xxbdo_tiendas_has_areas_estandares` for v24
INSERT INTO `xxbdo_tiendas_has_areas_estandares` 
SELECT `xxbdo_tiendas`.`cr_plaza`, 
`xxbdo_tiendas`.`cr_tienda` , 
`xxbdo_checklists_has_areas_estandares`.`xxbdo_checklists_id`, 
`xxbdo_checklists_has_areas_estandares`.`xxbdo_areas_estandares_id`, 
NULL AS `grupos_id`,
1 AS `es_visible`,
1 AS `activo`,
NULL AS `usuario`,
NULL AS `ip_address`,
NULL AS `created_at`,
NULL AS `updated_at` 
FROM `xxbdo_checklists_has_areas_estandares`, 
`xxbdo_tiendas` 
WHERE `xxbdo_checklists_has_areas_estandares`.`xxbdo_checklists_id`='f767aea8-988c-4e36-9037-59660573b877' 
AND `xxbdo_checklists_has_areas_estandares`.`activo`=1 
AND `xxbdo_tiendas`.`activo`=1;

-- ---------------------
-- Create records into `xxbdo_tiendas_has_areas_estandares_indicadores` for v24
INSERT INTO `xxbdo_tiendas_has_areas_estandares_indicadores` 
SELECT `xxbdo_tiendas`.`cr_plaza`, 
`xxbdo_tiendas`.`cr_tienda` , 
`xxbdo_checklists_has_areas_estandares_indicadores`.`xxbdo_checklists_id`, 
`xxbdo_checklists_has_areas_estandares_indicadores`.`xxbdo_areas_estandares_indicadores_id`, 
1 AS `es_visible`,
1 AS `activo`,
NULL AS `usuario`,
NULL AS `ip_address`,
NOW() AS `created_at`,
NOW() AS `updated_at` 
FROM `xxbdo_checklists_has_areas_estandares_indicadores`, 
`xxbdo_tiendas` 
WHERE `xxbdo_checklists_has_areas_estandares_indicadores`.`xxbdo_checklists_id`='f767aea8-988c-4e36-9037-59660573b877' 
AND `xxbdo_checklists_has_areas_estandares_indicadores`.`activo`=1 
AND `xxbdo_tiendas`.`activo`=1;
