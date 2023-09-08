
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";
use `xxbdo`;

ALTER TABLE `xxbdo_login_attempts` 
ADD COLUMN `printer_name` VARCHAR(100) NULL DEFAULT NULL AFTER `app_version` ;

INSERT INTO `xxbdo_configuracion` (`id`, `modulo`, `parametro`, `valor`, `orden`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES ('a5569549-4971-433c-be14-584382fd7b74', 'utensilios', 'categoria_utensilios_varios', 'b0860623-1b5b-42fc-9ad9-2445d200fd10', '5', '1', '1', NULL, NULL, NOW(), NOW());

INSERT INTO `xxbdo_configuracion` (`id`, `modulo`, `parametro`, `valor`, `orden`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES ('56433555-6e1e-4db5-b739-dc921218e39f', 'utensilios', 'fecha_inicio_checklist_utensilios', '2019-11-01', '6', '1', '1', NULL, NULL, NOW(), NOW()); 

UPDATE `xxbdo_configuracion` SET `parametro` = 'numero_meses_vista_inicial_tablet_checklist_utensilios' WHERE `xxbdo_configuracion`.`id` = '88480b66-a38e-4905-a4c4-16e1c9c8bd85';

INSERT INTO `xxbdo_configuracion` (`id`, `modulo`, `parametro`, `valor`, `orden`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES ('e309a17b-8021-4299-8760-6da12b965aa3', 'utensilios', 'numero_meses_vista_inicial_web_checklist_utensilios', '8', '1', '1', '1', NULL, NULL, NOW(), NOW());
--
-- Table structure for table `xxbdo_respuestas_utensilios`
--
CREATE TABLE `xxbdo_respuestas_utensilios` (
  `id` varchar(36) NOT NULL,
  `cr_plaza` varchar(10) NOT NULL,
  `cr_tienda` varchar(10) NOT NULL,
  `fecha_respuesta` date NOT NULL,
  `xxbdo_utensilios_id` varchar(36) NOT NULL,
  `mes` int(11) DEFAULT NULL,
  `año` int(11) DEFAULT NULL,
  `respuesta` varchar(2) DEFAULT NULL,
  `folio` varchar(50) DEFAULT NULL,
  `folio_color` varchar(10) DEFAULT NULL,
  `agregado_por` varchar(36) DEFAULT NULL,
  `recibido` timestamp NULL DEFAULT NULL,
  `origen` varchar(2) DEFAULT NULL,
  `activo` tinyint(4) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
--
-- Table structure for table `xxbdo_utensilios`
--
CREATE TABLE `xxbdo_utensilios` (
  `id` varchar(36) NOT NULL,
  `xxbdo_utensilios_categorias_id` varchar(36) NOT NULL,
  `cr_plaza` varchar(10) DEFAULT NULL,
  `cr_tienda` varchar(10) DEFAULT NULL,
  `tipo` char(1) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `uso` text,
  `orden` bigint(20) DEFAULT NULL,
  `seleccionable` tinyint(4) DEFAULT '1',
  `foto` text,
  `codigo` varchar(40) DEFAULT NULL,
  `via_de_solicitud` text,
  `activo` tinyint(4) DEFAULT '1',
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
--
-- Table structure for table `xxbdo_utensilios_categorias`
--
CREATE TABLE `xxbdo_utensilios_categorias` (
  `id` varchar(36) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `orden` int(11) DEFAULT NULL,
  `visible` tinyint(4) DEFAULT NULL,
  `activo` tinyint(4) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `xxbdo_utensilios_categorias`
--
INSERT INTO `xxbdo_utensilios_categorias` (`id`, `nombre`, `descripcion`, `orden`, `visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('0b713f50-055a-4b10-ae40-8239c8426253', 'LIMPIEZA', 'Utensilios de Limpieza', 2, 1, 1, NULL, NULL, NOW(), NOW()),
('55451e2c-b9c1-418c-a444-3392b422aaf7', 'COMIDA RÁPIDA', 'Utensilios de comida rápida', 1, 1, 1, NULL, NULL, NOW(), NOW()),
('7cd81a27-7486-4392-bf1f-8468c13d6ec2', 'HABILITADORES', 'Utensilios habilitadores', 3, 1, 1, NULL, NULL, NOW(), NOW()),
('ac29e1a0-e0a8-4495-b6eb-806a77a36f30', 'PAPELERIA', 'Utensilios de Papelería', 4, 1, 1, NULL, NULL, NOW(), NOW()),
('b0860623-1b5b-42fc-9ad9-2445d200fd10', 'VARIOS', 'Utensilios no catalogados', 1000, 1, 1, NULL, NULL, NOW(), NOW());

ALTER TABLE `xxbdo_utensilios_categorias` 
ADD COLUMN `tipo` CHAR(1) NULL DEFAULT NULL AFTER `descripcion`;

UPDATE `xxbdo_utensilios_categorias` SET `tipo` = 'V' WHERE `xxbdo_utensilios_categorias`.`id` = 'b0860623-1b5b-42fc-9ad9-2445d200fd10'; 

UPDATE `xxbdo_utensilios_categorias` SET `tipo` = 'U' WHERE `xxbdo_utensilios_categorias`.`id` NOT IN('b0860623-1b5b-42fc-9ad9-2445d200fd10'); 

--
-- Dumping data for table `xxbdo_utensilios`
--
INSERT INTO `xxbdo_utensilios` (`id`, `xxbdo_utensilios_categorias_id`, `cr_plaza`, `cr_tienda`, `tipo`, `nombre`, `descripcion`, `uso`, `orden`, `seleccionable`, `foto`, `codigo`, `via_de_solicitud`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('00d18f4c-e71b-4482-82ee-d506922d7fd6', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Corbatín para Termo de café', 'Corbatín para Termo de café\r\n(3)', '', 3, 1, '4f47f977-89c6-43bf-94ed-09480d4ccd48.png', '3', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza', 1, NULL, NULL, NOW(), NOW()),
('0456746e-8592-497d-8f55-f8786c2eff2a', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Letrero de Piso', 'Letrero de Piso\r\n(5044)', '', 9, 1, 'ceadf723-9ffe-4344-ae46-a5b05365baf0.png', '5044', 'Módulo ATL > Operaciones > Solicitud de artículos de limpieza y/o productos químicos> Letrero de piso', 1, NULL, NULL, NOW(), NOW()),
('0ae41263-3af4-4533-9972-dd13625a19a5', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Cubeta sin exprimidor', 'Cubeta sin exprimidor\r\n(18503)', '', 7, 1, '95929a3f-0bf9-47a1-bf78-6e4ec079f005.png', '18503', 'Módulo ATL > Operaciones > Solicitud de artículos de limpieza y/o productos químicos> Cubeta sin exprimidor', 1, NULL, NULL, NOW(), NOW()),
('12b1fa16-6e40-4098-ac11-47362e485bf3', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Tapete de checkout', 'Tapete de checkout\r\n(18634)', '', 23, 1, '607b22d7-92e1-495a-93e6-b0123931f097.png', '18634', 'Módulo ATL> Recursos Humanos> Solicitudes de Habilitadores> Tapete de checkout', 1, NULL, NULL, NOW(), NOW()),
('187a6182-cee1-4af9-93fb-a27987282fab', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Señalización de Basura', 'Señalización de Basura\r\n(12758)', '', 18, 1, '30416b02-9a7a-41ad-be6c-a594f273093b.png', '12758', 'Módulo ATL> Mercadeo> Mercadeo> Señalización Institucional> Piezas sueltas o kit completo> Señalización de Basura', 1, NULL, NULL, NOW(), NOW()),
('2a3300c7-3722-4171-885e-004cf63f16d2', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Cepillo de mano para limpieza de sanitarios', 'Cepillo de mano para limpieza de sanitarios', '', 12, 1, '0ee954d1-318e-4e13-8881-a9b3bc9c57ac.png', '-', 'Kit In & Out Semestral> Cepillo de mano para limpieza de sanitarios', 1, NULL, NULL, NOW(), NOW()),
('2fa0da54-91a5-4e67-b184-ebdda39a8df2', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Membrana para cañonera de vasos de café', 'Membrana para cañonera de vasos de café\r\n(13385)', '', 4, 1, '439ca22f-94f1-465a-97e9-025006c85500.png', '13385', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza> Membrana para cañonera de vasos de café', 1, NULL, NULL, NOW(), NOW()),
('2fa708ec-6a14-4d8d-92f4-f3c19e174a00', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Porta-etiquetas Góndola Central', 'Porta-etiquetas Góndola Central', '', 34, 1, '', '-', 'Módulo ATL> Mercadeo> Equipamiento>Porta-\r\netiquetas y con stock en plaza/Solicitud de manerales de cuarto frío> Porta-etiquetas Góndola Central', 1, NULL, NULL, NOW(), NOW()),
('32f62fb7-0d4b-4b1b-9f9f-517f914cf065', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Portafiltro con tapa', 'Portafiltro con tapa\r\n(6481)', '', 2, 1, '5392acde-fb38-4e8f-b749-0347ac16ce9b.png', '6481', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza', 1, NULL, NULL, NOW(), NOW()),
('382b8c7c-4a38-4a80-8235-c0db5732fc15', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Escoba', 'Escoba', '', 4, 1, '268ff260-7230-4564-a835-637c9ec78219.png', '-', 'Realizar merma para que se envíe vía CEDIS ', 1, NULL, NULL, NOW(), NOW()),
('3eaa4927-cfb2-4800-97da-c844776945aa', 'ac29e1a0-e0a8-4495-b6eb-806a77a36f30', NULL, NULL, 'U', 'Engrapadora', 'Engrapadora', '', 3, 1, '', '-', 'Módulo ATL> Operaciones> Autorización, Seguimiento y Solicitudes en Tienda> Engrapadora', 1, NULL, NULL, NOW(), NOW()),
('4298a0b5-128c-403a-8d7a-004793c9902e', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Recipiente para Jalapeños con tapa', 'Recipiente para Jalapeños con tapa', '', 11, 1, 'aa428871-0752-4e34-8244-d26ead64d1c1.png', '17613', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza> Recipiente para jalapeños con tapa', 1, NULL, NULL, NOW(), NOW()),
('42dd7a20-0cc6-42f8-b442-406f22ae52b8', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Chamarra de cuarto frío', 'Chamarra de cuarto frío\r\n(24431)', '', 22, 1, '87b5be65-3588-4535-a61b-57af7fdff0f3.png', '24431', 'Módulo ATL> Recursos Humanos> Solicitudes de Habilitadores> Chamarra de cuarto frío', 1, NULL, NULL, NOW(), NOW()),
('42e37349-5492-4b9e-819a-067a8515e55a', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Trapo amarillo baños', 'Trapo amarillo baños', '', 1, 1, '8592a8fb-1dd9-4d47-bf8d-93a13d2d1b6c.png', '-', 'Realizar merma para que se envíe vía CEDIS ', 1, NULL, NULL, NOW(), NOW()),
('4b5e1ea4-8197-497f-ae13-2529a9799df6', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Guantes para Hielera', 'Guantes para Hielera\r\n(28552)', '', 26, 1, 'cb279516-b723-4788-95b0-d7c23c3d1a95.png', '28552', 'Módulo ATL> Recursos Humanos> Solicitudes de Habilitadores> Guantes para Hielera', 1, NULL, NULL, NOW(), NOW()),
('4b6165da-3ff5-45f2-86b0-f9bd19684d83', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Contenedor para Café', 'Contenedor para Café\r\n(5429)', '', 6, 1, '5cf11073-0617-4ad5-8747-533298ba9e31.png', '5429', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza> Contenedor para café', 1, NULL, NULL, NOW(), NOW()),
('4ceff05d-0f61-4b1e-9e19-5307ed4628b4', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Esponja azul', 'Esponja azul', '', 10, 1, '8e16a690-7d34-41ef-9d14-8c23d327fced.png', '-', 'Realizar merma para que se envíe vía CEDIS ', 1, NULL, NULL, NOW(), NOW()),
('4ea7955e-d7b1-4cd9-8521-bb15948855ce', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Plumero', 'Plumero\r\n(26942)', '', 28, 1, '4cc9f9a2-3b57-4c10-b71c-5e8a39524569.png', '26942', 'Módulo ATL > Operaciones > Solicitud de artículos de limpieza y/o productos químicos> Plumero', 1, NULL, NULL, NOW(), NOW()),
('4f94c9c1-7a7d-4793-b190-4fe951ed2ad7', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Contenedor para devoluciones', 'Contenedor para devoluciones\r\n(4797)', '', 15, 1, 'bbc0f1e3-035a-4c1a-9117-f5dae4a17362.png', '4797', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza> Contenedor para devoluciones', 1, NULL, NULL, NOW(), NOW()),
('55fb8740-4b84-456a-9c1a-6415a5cfc968', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Tapete de entrada', 'Tapete de entrada\r\n(15564)', '', 20, 1, '3bdaf74b-d3e9-487f-9412-4cbdbcac70ca.png', '15564', 'Módulo ATL> Operaciones> Autorización, Seguimiento y Solicitudes en Tienda> Tapete de entrada', 1, NULL, NULL, NOW(), NOW()),
('5a27f600-0b5e-4602-b0b2-97118138306c', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Porta-etiquetas Checkout', 'Porta-etiquetas Checkout', '', 32, 1, '', '-', 'Módulo ATL> Mercadeo> Equipamiento>Porta-\r\netiquetas y con stock en plaza/Solicitud de manerales de cuarto frío> Porta-etiquetas Checkout', 1, NULL, NULL, NOW(), NOW()),
('5cce419c-c1e0-4d6f-acad-98c6d4ffc2a0', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Señalización de variedad de salchichas', 'Señalización de variedad de salchichas', '', 13, 1, '19dd0d45-d726-4d04-898f-c91491832f6f.png', '-', 'Módulo ATL> Mercadeo> Mercadeo> Señalización Institucional > Piezas sueltas> Reposición Catálogo de ambientación> Señalización de variedad de salchichas', 1, NULL, NULL, NOW(), NOW()),
('6a7d5eca-f41c-4008-89c9-c1dd52cfb29a', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Botella con atomizador', 'Botella con atomizador', 'Dispensar productos de limpieza como jabón o quitachicles', 2, 1, 'd9ff09ce-9561-4d58-aec3-4f591399e3bf.png', '-', 'Kit In & Out Semestral> Botella con atomizador', 1, NULL, NULL, NOW(), NOW()),
('6c7e3a77-a887-439a-9b91-ef7eb6d1a4f9', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Escalera dos peldaños', 'Escalera dos peldaños\r\n(14018)', '', 19, 1, 'cb1e3d56-e040-4337-93ac-b923331b9fdd.png', '14018', 'Módulo ATL> Operaciones> Autorización, Seguimiento y Solicitudes en Tienda> Escalera dos peldaños', 1, NULL, NULL, NOW(), NOW()),
('71b92aa7-e2b2-4a64-9acf-52f878ee2595', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Carro Transportador', 'Carro Transportador\r\n(14029)', '', 25, 1, '45890367-6ff5-4224-be21-9ee936989467.png', '14029', 'Módulo ATL> Operaciones> Autorización, Seguimiento y Solicitudes en Tienda> Carro Transportador', 1, NULL, NULL, NOW(), NOW()),
('754b78a9-e746-49e4-88ea-8202d79f3918', 'ac29e1a0-e0a8-4495-b6eb-806a77a36f30', NULL, NULL, 'U', 'Cintilla Protocolo de Servicio', 'Cintilla Protocolo de Servicio', '', 5, 1, '', '-', 'Módulo ATL> Operaciones> Autorización, Seguimiento y Solicitudes en Tienda> Cintilla Protocolo de Servicio', 1, NULL, NULL, NOW(), NOW()),
('75fe30ed-e779-4ab8-91b1-ad23bfed24bb', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Recipiente para Tomate y Cebolla con tapa', 'Recipiente para Tomate y Cebolla con tapa', '', 10, 1, '251a0952-e13a-436d-9244-c8fb943cd3a5.png', '4865', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza> Recipiente para tomate y cebolla con tapa', 1, NULL, NULL, NOW(), NOW()),
('7a7a2d4f-ffc8-4b12-937f-53fa0ec56aed', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Cucharón para café', 'Cucharón para café\r\n(5432)', '', 5, 1, '6dda3924-9529-4a41-9165-570b64597694.png', '5432', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza> Cucharón para café', 1, NULL, NULL, NOW(), NOW()),
('7d0c5f37-4b28-47c7-96d0-0b7f1f66d944', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Trapo azul comida rápida', 'Trapo azul comida rápida', '', 11, 1, '385c0e2b-c9b3-4668-b7d2-c16505a406f8.png', '-', 'Realizar merma para que se envíe vía CEDIS ', 1, NULL, NULL, NOW(), NOW()),
('8dfa9980-c015-45ad-bf0e-3e7969d92eab', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Pinzas para Roller', 'Pinzas para Roller', '', 14, 1, '5305e9e3-e6d2-4931-b64a-a94ef3f0c0a9.png', '5022', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza> Pinzas para Roller', 1, NULL, NULL, NOW(), NOW()),
('959f4139-c646-49c5-8ea9-a65ece6fc97f', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Navaja de Seguridad', 'Navaja de Seguridad', '', 31, 1, '7131f49d-86a6-43cc-81b4-43d162cdf04a.png', '-', 'Kit In & Out Semestral> Navaja de Seguridad', 1, NULL, NULL, NOW(), NOW()),
('96a4b640-0135-4c9a-8dec-a72290739643', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Bomba para garrafón', 'Bomba para garrafón', '', 30, 1, '', '-', 'Módulo ATL> Recursos Humanos> Solicitudes de Habilitadores> Bomba para garrafón', 1, NULL, NULL, NOW(), NOW()),
('9712632e-0d81-4d6d-8d4b-83161977011d', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Trapo para limpieza general', 'Trapo para limpieza general', '', 3, 1, '65e4a28b-f033-4cf0-b654-9cbe7bcd5174.png', '-', 'Realizar merma para que se envíe vía CEDIS ', 1, NULL, NULL, NOW(), NOW()),
('9941f7ab-c0a8-443d-ab63-bbca43fb0ddf', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Cubeta con exprimidor', 'Cubeta con exprimidor\r\n(5230)', '', 8, 1, '95a2067f-591a-460f-a46a-c6dc43d3d0f2.png', '5230', 'Módulo ATL> Operaciones> Autorización, Seguimiento y Solicitudes en Tienda> Cubeta con exprimidor', 1, NULL, NULL, NOW(), NOW()),
('9976126e-4192-4ffd-a8e4-6e761b24e8f1', 'ac29e1a0-e0a8-4495-b6eb-806a77a36f30', NULL, NULL, 'U', 'Calculadora', 'Calculadora', '', 1, 1, '', '-', 'Módulo ATL> Operaciones> Autorización, Seguimiento y Solicitudes en Tienda> Calculadora', 1, NULL, NULL, NOW(), NOW()),
('ae00034b-1f90-4c5d-b797-0b4d44dc953d', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Jalador para ventanales', 'Jalador para ventanales\r\n(22066)', '', 24, 1, '236a023e-c3c5-426e-a69b-9ab2ffd9977a.png', '22066', 'Módulo ATL> Operaciones> Autorización, Seguimiento y Solicitudes en Tienda> Jalador para ventanales', 1, NULL, NULL, NOW(), NOW()),
('b8122c90-4511-46f0-a900-3622a93ce6fa', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Contenedor para merma', 'Contenedor para merma\r\n(4797)', '', 14, 1, '1d1d44ca-3854-49b1-b73b-4dc9becb7071.png', '4797', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza> Contenedor para merma', 1, NULL, NULL, NOW(), NOW()),
('bae06ebd-01a1-4778-b837-3d74d4a4e1e6', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Recipiente para salchicha con tapa', 'Recipiente para salchicha con tapa', '', 12, 1, 'da8d3b8e-9de6-4101-8574-25b6fe9e8236.png', '4866', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza> Recipiente para salchicha con tapa', 1, NULL, NULL, NOW(), NOW()),
('c06cc136-5a2c-443a-9f15-57e1f4356670', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Pinzas para Pan Dulce', 'Pinzas para Pan Dulce\r\n(2070)', '', 9, 1, 'c51dd6e9-19a4-43b4-900b-cf2fa8e5f237.png', '2070', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza> Pinzas para Pan Dulce', 1, NULL, NULL, NOW(), NOW()),
('c7f96c9e-0466-40ec-aa38-f829ad1142fd', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Porta-etiquetas Cuarto Frio', 'Porta-etiquetas Cuarto Frio', '', 33, 1, '', '-', 'Módulo ATL> Mercadeo> Equipamiento>Porta-\r\netiquetas y con stock en plaza/Solicitud de manerales de cuarto frío> Porta-etiquetas Cuarto Frio', 1, NULL, NULL, NOW(), NOW()),
('c97b1295-e1e9-418e-9316-b400fff7abba', 'ac29e1a0-e0a8-4495-b6eb-806a77a36f30', NULL, NULL, 'U', 'Cojín para Sello', 'Cojín para Sello', '', 2, 1, '', '-', 'Módulo ATL> Operaciones> Autorización, Seguimiento y Solicitudes en Tienda> Cojín para Sello', 1, NULL, NULL, NOW(), NOW()),
('ca1dcac3-de81-4677-8453-ec7388d1bb72', 'ac29e1a0-e0a8-4495-b6eb-806a77a36f30', NULL, NULL, 'U', 'Esponjero', 'Esponjero', '', 4, 1, '', '-', 'Módulo ATL> Operaciones> Autorización, Seguimiento y Solicitudes en Tienda> Esponjero', 1, NULL, NULL, NOW(), NOW()),
('cce2e8a0-beed-4e0a-9dbd-81f3c35eb793', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Porta Bolsas', 'Porta Bolsas', '', 16, 1, '', '-', 'Módulo ATL> Operaciones> Autorización, Seguimiento y Solicitudes en Tienda> Porta Bolsas', 1, NULL, NULL, NOW(), NOW()),
('d1695a82-6494-40f1-a577-2ec4522c39fd', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Cepillo para limpieza de termo', 'Cepillo para limpieza de termo', 'Limpieza de termo', 8, 1, '90ad677b-b8e1-473d-984e-0c9450735336.png', '5430', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza > Cepillo para limpieza de termo', 1, NULL, NULL, NOW(), NOW()),
('d55d46ab-a2c9-4448-ac12-6adc9006e384', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Porta Garrafón', 'Porta Garrafón\r\n(24880)', '', 29, 1, '7404b7db-28fd-4f31-9cbd-4e63bdca82e1.png', '24880', 'Módulo ATL> Recursos Humanos> Solicitudes de Habilitadores> Porta Garrafón', 1, NULL, NULL, NOW(), NOW()),
('d9303e94-63cf-4aeb-910e-5f4667887f91', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Cepillo de mano para limpieza de parrillas y deslizadores', 'Cepillo de mano para limpieza de parrillas y deslizadores\r\n(22483)', '', 13, 1, 'b5708138-5e0e-4d84-80d7-66b6cee787f1.png', '22483', 'Kit In & Out Semestral> Cepillo de mano para limpieza de parrillas y deslizadores', 1, NULL, NULL, NOW(), NOW()),
('da8955f6-62e5-44dc-a886-3cddc15524ab', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Trapeador', 'Trapeador', '', 6, 1, '7cf66654-d199-446e-9981-74b79935608b.png', '-', 'Realizar merma para que se envíe vía CEDIS ', 1, NULL, NULL, NOW(), NOW()),
('dcf1d06f-b41e-40ab-974d-e28991d017a5', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Letrero de caja cerrada', 'Letrero de caja cerrada\r\n(17233)', '', 17, 1, '867d42e0-1e80-488d-a731-67de1d27c5e5.png', '17233', 'Módulo ATL> Mercadeo> Mercadeo> Señalización Institucional> Piezas sueltas o kit completo> Letrero de caja cerrada', 1, NULL, NULL, NOW(), NOW()),
('e26de1f3-9ef5-404a-9ba7-194f452239e2', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Termos para café Clásico, Intenso y Descafeinado', 'Termos para café\r\nClásico  \r\n(11836)\r\nIntenso \r\n(22948)\r\nDescafeinado (14874)', '', 1, 1, '94afd348-0782-44ab-a31b-564088db3b21.png', '11836-22948-14874', 'Módulo ATL> Mercadeo> Equipamiento-Café Mkdeo> Equipamiento Mercadeo> Termos nuevos', 1, NULL, NULL, NOW(), NOW()),
('e90dcdbd-c7ec-4f58-a6b3-757253a7af79', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Caja para café con 3 cajones', 'Caja para café con 3 cajones', 'Resguardar bolsas de café en uso', 7, 1, '08b29c79-bbfa-41f5-94b4-46f109b0a3d5.png', '5428', 'Módulo ATL> Mecardeo> Equipamiento-Utensilios de Cómida Rápida con/sin Stock en Plaza > caja para café con 3 cajones', 1, NULL, NULL, NOW(), NOW()),
('f4d09749-30ca-43e5-bd8f-2ce316938d76', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Recogedor', 'Recogedor\r\n(18494)', '', 5, 1, '4a616e73-3444-4e00-8f04-10dc7b22604a.png', '18494', 'Módulo ATL > Operaciones > Solicitud de artículos de limpieza y/o productos químicos> Recogedor', 1, NULL, NULL, NOW(), NOW()),
('f8c82740-220e-44c7-beff-f4852da616ed', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Espátula quita-chicles', 'Espátula quita-chicles', '', 27, 1, '8f4f2570-0f81-440b-a021-49883ddd4bcd.png', '-', 'Kit In & Out Semestral> Espátula quita-chicles', 1, NULL, NULL, NOW(), NOW()),
('fed65468-e2bf-48ac-8ae9-ec3d4f119aba', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Cucharon para máquina de hielo', 'Cucharon para máquina de hielo\r\n(10275)', '', 21, 1, '6a25b91f-d0b8-4157-a532-e5f402bb17e1.png', '10275', 'Módulo ATL> Mercadeo> Equipamiento-Solicitud de cucharon para hielo> Cucharon para máquina de hielo', 1, NULL, NULL, NOW(), NOW());

-- --------------------------------------------------------
--
-- Table structure for table `xxbdo_utensilios_desactivados`
--
CREATE TABLE `xxbdo_utensilios_desactivados` (
  `id` varchar(36) NOT NULL,
  `xxbdo_utensilios_id` varchar(36) NOT NULL,
  `cr_plaza` varchar(10) DEFAULT NULL,
  `cr_tienda` varchar(10) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `activo` tinyint(4) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `xxbdo_respuestas_utensilios`
--
ALTER TABLE `xxbdo_respuestas_utensilios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_RESPTS_UTNSLS_UTNSLS_ID_INDX` (`xxbdo_utensilios_id`),
  ADD KEY `XXBDO_RESPTS_UTNSLS_RLS_TNDA_INDX` (`agregado_por`),
  ADD KEY `XXBDO_RESPTS_UTNSLS_RESPUESTA_INDX` (`respuesta`);

--
-- Indexes for table `xxbdo_utensilios`
--
ALTER TABLE `xxbdo_utensilios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_UTENSILIOS_CATEGORIAS_ID_IDX` (`xxbdo_utensilios_categorias_id`),
  ADD KEY `XXBDO_UTNSLS_PLAZA_TIENDA_IDX` (`cr_plaza`,`cr_tienda`),
  ADD KEY `XXBDO_UTNSLS_TIPO_INDX` (`tipo`),
  ADD KEY `XXBDO_UTNSLS_TIPO_IDX` (`tipo`);

--
-- Indexes for table `xxbdo_utensilios_categorias`
--
ALTER TABLE `xxbdo_utensilios_categorias`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `NM_UT_UNIQUE` (`nombre`);

--
-- Indexes for table `xxbdo_utensilios_desactivados`
--
ALTER TABLE `xxbdo_utensilios_desactivados`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_UTNLS_DSTVDS_UTENSILIOS_ID_INDX` (`xxbdo_utensilios_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `xxbdo_respuestas_utensilios`
--
ALTER TABLE `xxbdo_respuestas_utensilios`
  ADD CONSTRAINT `XXBDO_RESPTS_UTNLS_ROLES_EN_TIENDA_ID_FK` FOREIGN KEY (`agregado_por`) REFERENCES `xxbdo_roles_en_tienda` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `XXBDO_RESPTS_UTNSLS_UTNSLS_ID_FK` FOREIGN KEY (`xxbdo_utensilios_id`) REFERENCES `xxbdo_utensilios` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `xxbdo_utensilios`
--
ALTER TABLE `xxbdo_utensilios`
  ADD CONSTRAINT `XXBDO_UTENSILIOS_CATEGORIAS_ID_FK` FOREIGN KEY (`xxbdo_utensilios_categorias_id`) REFERENCES `xxbdo_utensilios_categorias` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `xxbdo_utensilios_desactivados`
--
ALTER TABLE `xxbdo_utensilios_desactivados`
  ADD CONSTRAINT `XXBDO_UTNLS_DSTVDS_UTENSILIOS_ID_FK` FOREIGN KEY (`xxbdo_utensilios_id`) REFERENCES `xxbdo_utensilios` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
SET FOREIGN_KEY_CHECKS=1;
COMMIT;
