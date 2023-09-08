-- query para ver información de estándares BDO v24:
-- SELECT * FROM `xxbdo_estandares` WHERE xxbdo_version_estandares_id='b794eae6-25c5-4e01-a69b-4a0fc29b259b' ORDER BY `xxbdo_estandares`.`estandar` ASC ;

-- queries para actualizar descripción de estándares según último excel de Óscar:
-- std 1
UPDATE `xxbdo_estandares` 
SET `descripcion` ='1.- <b>Presencia impecable</b>, uniforme oficial limpio y de acuerdo a código de vestimenta, gafete a la vista, botón promocional y/o de entrenamiento en al menos 1 cajero por turno; gorra oficial sólo sí la Plaza lo autoriza.<br><br>
2.- Mostrar una actitud de <b>servicio</b> hacia el cliente, proveedores y compañeros (optimista, proactivo, atento y servicial).<br><br>
3.-No consumo de alimentos en isla, no uso de electrónicos laborando (especial cuidado al estar atendiendo al cliente).' 
WHERE id='10f81bf8-ff1b-415e-8fda-c420f1dbf914';

-- std 2
UPDATE `xxbdo_estandares` 
SET `descripcion` ='1.- Ofrecer un <b>saludo</b> y trato amable al cliente durante su estancia en la tienda, dando prioridad en atenderlo, interrumpiendo actividades que se estén realizando en los dispositivos móviles.<br><br>
2.- <b>Abrir caja adicional</b> al detectar más de tres clientes en fila o si se está cobrando algún servicio financiero, boletos o facturación. Todas las cajas siempre con fondo y con morralla suficiente para recibir billetes de cualquier denominación y/o realizar retiros. Colocar letrero de "caja cerrada" cuando la caja no esté disponible para venta. Si la tienda cuenta con Caja Especializada de Servicios, se deberá de invitar al cliente a dicha caja de pago de servicios.<br><br>
3.- Preguntar al cliente si desea redondear (<b>PRO</b>) y mencionar la institución beneficiada en caso de que pregunte.<br><br>
4.- <b>Negar la venta de alcohol y/o cigarros</b> a menores de edad o fuera del horario permitido por la ley, ante la duda de la edad del cliente, solicitar Identificación Oficial.<br><br>
5.- Siempre intentar realizar cualquier <b>servicio electrónico</b> antes de indicar al cliente que no hay sistema. Informar el monto a pagar incluyendo comisión por servicio.<br><br>
6.- Entregar ticket, <b>agradecer la compra</b> y/o despedirse amablemente y/o invitar al  cliente a regresar de nuevo.<br><br>
7.- Generar y entregar la <b>factura</b> cuando el cliente lo solicite (verificando que los datos son correctos) e informarle que una vez generada la factura en tienda, podrá generar el archivo XML y descargar el archivo PDF en el portal web.<br><br>
8.- Realizar la devolución de productos cuando el cliente así lo desee y resguardar tickets de devolución.<br><br>
9.- Mantener disponibilidad de <b>estacionamiento</b> para nuestros clientes.<br><br>
10.- Cumplir con los <b>horarios de apertura y cierre de tiendas</b> de acuerdo a lo establecido por la Plaza.' 
WHERE id='63dbc878-8105-40d6-8cb9-2acfddce1640';

-- std 4
UPDATE `xxbdo_estandares` 
SET `descripcion` ='1.- Equipo completo de acuerdo a tabulador, todos registrados en SAP/SADEL e IMSS, con <b>ENTIENDA completo</b>. Conocen sus beneficios así como los incentivos.<br><br>
2.- <b>Servicios financieros</b> al menos un cajero habilitado por turno (aplica de 6:00 AM a 10:00 PM) usuario y contraseña sin bloqueos.  Los cajeros habilitados actualmente laboran en la tienda cuentan con la documentación personal vigente.<br><br>
3.- Todos los empleados conocen y están habilitados para cumplir los <b>estándares</b> operativos, cuentan con los dispositivos móviles funcionando correctamente, siempre encendidos y en buen estado.<br><br>
4.- El equipo de tienda conoce y sabe su enfoque de acuerdo a su <b>clasificación</b> de líder, está comprometido con su plan de acción y saben como imprimir sus asignaciones de tareas.' 
WHERE id='390d1816-4beb-4884-b156-10374f142e1b';

-- std 5
UPDATE `xxbdo_estandares` 
SET `descripcion` ='1.- Contar con mínimo <b>dos empleados por turno</b>, incluyendo al Líder de Tienda.<br><br>
2.- <b>Acompañamiento</b> del Líder de Tienda a empleados nuevos en los primeros 15 días.<br><br>
3.- <b>Salida</b> de turno a tiempo.<br><br>
4.- Cumplir con el rol anual de <b>vacaciones</b>.<br><br>
5.- <b>Balanceo</b> de asignación de tareas (Sem 1 60% ; Sem 2 80% ; Sem 3 100%. ) y/o ATA´s especiales.<br><br>
6.- <b>Descanso</b> semanal.<br><br>
7.- <b>Plan horario</b> acordado previo al inicio de la semana, considerando en lo posible temas del personal.  En el corcho y firmado por los empleados. Se cuenta con un tiempo para tomar los alimentos (sin Chaquetín).<br><br>
8.- Se respeta horario establecido para <b>alimentación</b>.<br><br>
9.- <b>Cargas de trabajo</b> buscando balance.<br><br>
10.- Se paga a tiempo y completo (tiempos extras, días festivos , etc.), mediante <b>tarjeta bancaria</b> proporcionada por plaza.' 
WHERE id='8fb4955e-688a-4e01-bbe4-872218262a1d';

-- std 6a
UPDATE `xxbdo_estandares` 
SET `descripcion` ='1.- <b>Exterior</b> en buen estado. Banqueta, estacionamiento, pasillos, topes, jardinera y equipos limpios. Cajón y rampa para personas con discapacidad señalizado y sin obstrucciones. Sin grafiti, lámparas limpias. Sin publicidad no autorizada. Árboles, jardineras en buen estado y pasto recortado (si aplica).<br><br>
2.- Contenedor y <b>botes de basura</b> limpios con tapa, en buen estado y señalizados como Orgánico e Inorgánico, con bolsa blanca para Inorgánico y negra para Orgánico (si aplica). Bolsas con no más de 3/4 de su capacidad y área sin exceso de basura, derrames y libre de mal olor.<br><br>
3.-<b>Isla</b>. El piso, los muebles y el equipo en general debe estar limpio y los cajones ordenados. Bolsas para el cliente disponibles y ordenadas (Si aplica). Tapete antifatiga en buen estado. Libre de volantes, publicidad y exhibidores no autorizados, objetos personales e información confidencial de la tienda a la vista del cliente.<br><br>
4.- <b>Piso de venta</b> libre de bultos y cajas, mercancía solo en góndolas y exhibidores. Pisos limpios.  Tapete de entrada limpio y en buen estado. La tienda tiene un olor agradable o neutro, se encuentra libre de insectos y/o fauna nociva.<br><br>
5.- <b>Equipamiento</b>: Góndolas (cabeceras, lomo), paletero, hieleras, revisteros, exhibidores en piso de venta y racks para garrafones (incluyendo el espacio entre el piso y la base inferior de ellos) limpios.<br><br>
6.- <b>Frutero</b> limpio incluyendo las charolas, sin derrames de líquidos de frutas o verduras.<br><br>
7.- <b>Baño</b> con olor neutro o agradable. Inodoro, mingitorio, lavamanos, espejo, porta rollo, porta papel de manos y jabonera, paredes, piso y puerta limpios.<br><br>
8.- <b>Bodega</b>. Limpieza. Tarja, paredes, piso, rack, locker y  puertas  limpios. Tener luces de bodega encendidas solo cuando sea necesario. No focos fundidos.<br><br>
9.- Almacenamiento de <b>Químicos de Limpieza</b>. Los químicos de limpieza en uso deberán ser colocados en la canastilla portaquímicos ubicada sobre la tarja de lavado, el resto de químicos (contenedores grandes) deberán ser colocados exclusivamente en el espacio especificado (identificado con una etiqueta). Los químicos deben de permanecer en su envase original.<br><br>
10.- <b>Dispositivos móviles de Tienda</b> no se dejan al alcance del cliente, si no se están usando se mantienen resguardados en el segundo cajón de la isla.' 
WHERE id='5ae71d28-c4f9-4968-a3ce-c60908fc8bdf';

-- std 6b
UPDATE `xxbdo_estandares` 
SET `descripcion` ='1.- <b>Exterior</b> en buen estado. Banqueta, estacionamiento, pasillos, topes, jardinera y equipos limpios. Cajón y rampa para personas con discapacidad señalizado y sin obstrucciones. Sin grafiti, lámparas limpias. Sin publicidad no autorizada. Árboles, jardineras en buen estado y pasto recortado (si aplica).<br><br>
2.- Contenedor y <b>botes de basura</b> limpios con tapa, en buen estado y señalizados como Orgánico e Inorgánico, con bolsa blanca para Inorgánico y negra para Orgánico (si aplica). Bolsas con no más de 3/4 de su capacidad y área sin exceso de basura, derrames y libre de mal olor.<br><br>
3.-<b>Isla</b>. El piso, los muebles y el equipo en general debe estar limpio y los cajones ordenados. Bolsas para el cliente disponibles y ordenadas (Si aplica). Tapete antifatiga en buen estado. Libre de volantes, publicidad y exhibidores no autorizados, objetos personales e información confidencial de la tienda a la vista del cliente.<br><br>
4.- <b>Piso de venta</b> libre de bultos y cajas, mercancía solo en góndolas y exhibidores. Pisos limpios.  Tapete de entrada limpio y en buen estado. La tienda tiene un olor agradable o neutro, se encuentra libre de insectos y/o fauna nociva.<br><br>
5.- <b>Equipamiento</b>: Góndolas (cabeceras, lomo), paletero, hieleras, revisteros, exhibidores en piso de venta y racks para garrafones (incluyendo el espacio entre el piso y la base inferior de ellos) limpios.<br><br>
6.- <b>Frutero</b> limpio incluyendo las charolas, sin derrames de líquidos de frutas o verduras.<br><br>
7.- <b>Baño</b> con olor neutro o agradable. Inodoro, mingitorio, lavamanos, espejo, porta rollo, porta papel de manos y jabonera, paredes, piso y puerta limpios.<br><br>
8.- <b>Bodega</b>. Limpieza. Tarja, paredes, piso, rack, locker y  puertas  limpios. Tener luces de bodega encendidas solo cuando sea necesario. No focos fundidos.<br><br>
9.- Almacenamiento de <b>Químicos de Limpieza</b>. Los químicos de limpieza en uso deberán ser colocados en la canastilla portaquímicos ubicada sobre la tarja de lavado, el resto de químicos (contenedores grandes) deberán ser colocados exclusivamente en el espacio especificado (identificado con una etiqueta). Los químicos deben de permanecer en su envase original.<br><br>
10.- <b>Dispositivos móviles de Tienda</b> no se dejan al alcance del cliente, si no se están usando se mantienen resguardados en el segundo cajón de la isla.' 
WHERE id='7e0ae661-3de5-40af-9047-72e7f2481db7';

-- std 7
UPDATE `xxbdo_estandares` 
SET `descripcion` ='1.- Los <b>planogramas</b> y exhibidores tienen la misma ubicación y tamaño que el <b>mapa de Legos</b> de la Tienda. Los productos colocados como indica la tira de planograma o PROMOXXO, frenteados y fondeados correctamente. En caso de no haber producto, rellenar el hueco con un ASLEP de la misma familia o con  el producto del lado.<br><br>
2.- Los productos ubicados en la charola superior no sobrepasan 10cm del <b>límite de altura</b> de la góndola. Para botanas, abarrotes, vinos y bebidas el limite máximo es 20cm de altura.<br><br>
3.- Contar con exhibidores de piso y hieleras acorde a inventario de espacios.<br><br>
4.- Los productos indicados en la de tira <b>ASLEP</b> están ubicados en charolas de expulsión, exhibidores de remate o mueble definidos por la plaza en piso de venta. Todo articulo que no se pueda colocar deberá tener un folio generado.<br><br>
5.- La <b>rotación de productos</b> debe de basarse en "Lo primero que entra es lo primero que sale, "<b>PEPS</b>".<br><br>
6.- <b>Cigarrera</b> con producto exhibido en todos sus carriles y con su respectiva comunicación de precios en cada artículo. Cuenta con charola promocional. Carriles y copete en buen estado (si aplica).<br><br>
7.- <b>Hieleras</b> con producto de CCM y Modelo (si aplica) con al menos el 50% de su capacidad, excepto viernes, sábado y domingo que debe de ocupar el 100%, exhibido de acuerdo a guía de acomodo (si aplica).<br><br>
8.-  Artículos de <b>paquetería</b> en tienda colocados en el espacio definido en el checkout (si aplica) y con calcomanía especificada, libre de otras mercancías o utensilios.' 
WHERE id='152ce08f-b465-44f8-9560-32e09a67865f';

-- std 8
UPDATE `xxbdo_estandares` 
SET `descripcion` ='1.- Productos <b>limpios</b> y sin empaques alterados, raspados, o maltratados. (Apto para la venta).<br><br>
2.- Producto en frutero se encuentran en buen estado, limpio, sin daño aparente y acomodado adecuadamente; apto para la venta (no sobremaduro).<br><br>
3.- Producto dentro del límite de <b>caducidad</b> establecido en el mismo (retirar los productos un día antes de la fecha de vencimiento, a menos que tenga la leyenda "Fresco hasta") y los más próximos a caducar colocados al frente o más cerca del cliente. Los caducos retirarlos y colocarlos en contenedor de merma (aplica para todos los productos).En los productos que solo contengan la caducidad en mes y año, retirar el último día del mes indicado en de la etiqueta. Retirar los productos perecederos que no tengan etiqueta de caducidad.  Insumos de café y alimentos no caducos.<br><br>
4.- Productos sin <b>señales de deterioro</b> como hongos o resequedad, mal olor o color.<br><br>
5.-  <b>Temperatura de equipos</b>. Cámara de conservación de "Refrescos y lácteos" (2 a 5 ºC) o (36 - 41 °F), cámara de conservación de "hielo" (-10 a -7 ºC), cámara fría o "cervecero"  (de 0 a 2 °C)  a excepción de las siguientes plazas: (de 2 a 5 ºC)  en Obregón, Nogales, Monterrey, Saltillo, Allende, Laguna, Piedras Negras, Monclova, Culiacán, La Paz, Los Mochis, Reynosa, Laredo, Matamoros y Cd. Juárez. De ( -2 a 0 ) para plaza Mexicali . Salchichonero a una temperatura de 2 a 6 ºC o 35 a 42 °F. Para equipos de comida rápida consultar Anexo FF.' 
WHERE id='942567f1-9891-4cf1-bdb9-eafb8339f0e3';

-- std 9
UPDATE `xxbdo_estandares` 
SET `descripcion` ='1.- <b>Etiquetas actualizadas</b> corresponde al producto exhibido y muestra el precio correcto, completamente legible (no decolorada) y no rota.<br><br>
2.- Si el producto es más pequeño que la etiqueta ó los productos son de la misma presentación mismo sabor se coloca al menos <b>una etiqueta para todos los frentes.</b><br><br>
3.- Etiquetas <b>colocadas</b> en porta etiquetas o holders institucionales y ambos en buen estado. No colocar etiquetas en la rejillas frontales del koxka.<br><br>
4.- <b>Preciadores</b> del canasto, de vinos y licores, exhibidores de telefonía y tecnología colocados frente al producto que hace referencia.<br><br>
5.- Producto que aplique con preciador de <b>remate</b> oficial.<br><br>
6.- Productos con misma presentación pero diferente sabor, deben tener el <b>mismo precio</b>.<br><br>
7.- Productos de <b>cerveza</b> que apliquen con etiqueta de precio multi-unidad y su etiqueta de precios individual. Si el producto tiene solo un frente, colocar etiqueta de precio individual.' 
WHERE id='6bcfaf2f-40a7-44bf-b554-d07c644196b9';

-- std 10
UPDATE `xxbdo_estandares` 
SET `descripcion` ='Todos los conceptos de <b>Fast Food Alimentos y Bebidas</b> que aplican para la tienda se ejecutan según lo definido en base al <b>Anexo a Estándares de Fast Food</b>.<br><br>
1.- Todos los equipos de Fast Food limpios interna y externamente, con vestido y piezas completas y en buen estado.<br><br>
2.- <b>Limpieza</b> del piso, panel duela (si aplica), muebles de comida rápida y café. Botes de basura con bolsa no más de 3/4 de su capacidad y señalizados como Orgánico e Inorgánico, con bolsa blanca para Inorgánico y negra para Orgánico (si aplica). Área libre de malos olores y fauna nociva.<br><br>
3.- <b>Utensilios</b> disponibles, limpios y en buen estado.' 
WHERE id='fc921750-4a86-4c65-a663-b3d9ac0fa155';

-- std 11
UPDATE `xxbdo_estandares` 
SET `descripcion` ='1.- <b>Resurtido</b> continuo de los producto en el cuarto frio (no más de 3 huecos visibles por puerta).<br><br>
2.- <b>Limpieza</b>: Puertas, techo y marcos de cuarto frío, parrillas, deslizadores, acrílicos, porta etiquetas, puerta de acceso al cuarto frio, cortina hawaiana, piso, paredes interiores y exteriores (sin evidencia de derrames), rack y exhibidores  limpios y en buen estado.<br><br>
3.- <b>Orden</b>: Pisos sin objetos tirados, barrido y trapeado, libre de malos olores. Sólo exhibidores y productos autorizados para el cuarto frío. Carriles bien definidos con acrílicos de acuerdo al tamaño. El producto apilado está dentro del limite permitido (1.5 mts. de altura). No se coloca producto alimenticio directamente sobre el piso.<br><br>
4.- <b>Exhibición visible</b> e iluminada en todo momento. No lámparas fundidas.<br><br>
5.- Buenas prácticas: La cortina de PVC (hawaiana) nunca se encuentra "colgada" o "amarrada". La(s) puerta(s) de acceso al cuarto frío se mantienen bien cerradas. Productos resguardados en el rack de acuerdo a la guía. Alimentos de personal de tienda en su cajonera autorizada. Aplicación del 5S + 1.<br><br>
6.- Al menos el 50% de <b>existencia de  hielo</b> apto para su venta y con buena accesibilidad. No estibar por encima de la línea roja. No escarcha y/o agua escurriendo en piso del contenedor.<br><br>
7.- Existen 2 <b>chamarras</b> en la tienda en buen estado colgadas en el perchero.' 
WHERE id='88622a43-736e-4bdc-87d2-08b0da8ad325';

-- std 12
UPDATE `xxbdo_estandares` 
SET `descripcion` ='1.- Exhibiciones de Piso, Checkout, cabeceras, tiras promocionales  y adicionales con producto de acuerdo al <b>planograma</b> en Promoxxo.<br><br>
2.- El material que se encuentre en tienda debe de ser el <b>oficial</b> y estar <b>vigente</b>.<br><br>
3.- Los materiales <b>POP</b> deben de estar colocados/desplegados correctamente (de acuerdo a  Promoxxo), en buenas condiciones, visibles y sin obstrucciones.<br><br>
4.- Todos los materiales deberán estar pegados con la cinta doble cara que trae el material, en los marcos o portaposters donde corresponden o colgados con cinchos o ventosas si es que aplican. <b>Ningún material debe tener cinta adhesiva</b>, ni grapas.' 
WHERE id='b1b19ac7-b4b5-4d82-bd95-9d674f24de3d';

-- std 13
UPDATE `xxbdo_estandares` 
SET `descripcion` ='1.- Preguntar si se le ofrece "algo más" y/o <b>sugerir</b> promociones o productos de forma constante.<br><br>
2.- <b>Servicios</b> (lo que aplique). Portaboletos de autobús, llaveros para TAE, exhibidor de tecnología y telefonía disponibilidad y exhibición, seguros y disponibilidad tarjetas regalo, prepago y Saldazo que apliquen.<br><br>
3.- Se cuenta con las metas definidas por el Asesor de Tienda para cada indicador y se captura el seguimiento diario de avance al indicador en el <b>TGO</b>. Se analiza diariamente el estatus actual de los Factores Críticos así como las gráficas de seguimiento diario y gráficas de proyección mensual en el Tablero de Gestión Operativa.' 
WHERE id='f52971ec-e16e-46f7-a1fe-ced9410059b3';

-- std 17
UPDATE `xxbdo_estandares` 
SET `descripcion` ='1.- Las carpeta operativa  se encuentra actualizada (aplica según lo comunicado de acuerdo a la última versión), organizada y en buenas condiciones y los puntos que se deban de llenar se llenan tal y como se definió.<br><br>
2.-  Se verifica que los permisos oficiales se encuentren en tienda y vigentes, de acuerdo a la ley local vigente (visibles, donde aplique).<br><br>
3.- Se encuentra en el corcho la tira de artículos del "Inventario en bodega sin exhibición" actualizada (no tiene más de 7 días desde su impresión) y Resumen Operativo del día anterior y actual.<br><br>
4.- Existe el formato de responsable por Lego evaluado correctamente en el corcho operativo. Se agrega la tira de resumen de cambios todos los lunes.' 
WHERE id='504d21a0-28f3-46a6-ae42-62aeb0d37f67';

-- std 24
UPDATE `xxbdo_estandares` SET `detalle` = '' WHERE `xxbdo_estandares`.`id` = 'cc4ac679-6538-4c7d-8656-801c8a48c020';
