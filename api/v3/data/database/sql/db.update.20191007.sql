-- phpMyAdmin SQL Dump
-- version 4.8.2
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3307
-- Tiempo de generación: 07-10-2019 a las 13:20:13
-- Versión del servidor: 5.7.23
-- Versión de PHP: 7.1.21

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Base de datos: `xxbdo_production_201907031031_2`
--

--
-- Volcado de datos para la tabla `xxbdo_configuracion`
--

INSERT INTO `xxbdo_configuracion` (`id`, `modulo`, `parametro`, `valor`, `orden`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('88480b66-a38e-4905-a4c4-16e1c9c8bd85', 'utensilios', 'numero_meses_vista_inicial_checklist_utensilios', '6', NULL, 1, 1, NULL, NULL, '2019-10-07 13:00:00', '2019-10-07 13:00:00'),
('e6174c19-30ed-490f-bcde-624a0b40107e', 'utensilios', 'dia_limite_mensual_envio_checklist_utensilios', '7', NULL, 1, 1, NULL, NULL, '2019-10-07 13:00:00', '2019-10-07 13:00:00');


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xxbdo_checklist_utensilios`
--

CREATE TABLE `xxbdo_checklist_utensilios` (
  `id` varchar(36) NOT NULL,
  `cr_plaza` varchar(10) NOT NULL,
  `cr_tienda` varchar(10) NOT NULL,
  `fecha_respuesta` date NOT NULL,
  `xxbdo_utensilios_id` varchar(36) NOT NULL,
  `mes` int(11) DEFAULT NULL,
  `año` int(11) DEFAULT NULL,
  `respuesta` varchar(2) DEFAULT NULL,
  `activo` tinyint(4) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `xxbdo_checklist_utensilios`
--

INSERT INTO `xxbdo_checklist_utensilios` (`id`, `cr_plaza`, `cr_tienda`, `fecha_respuesta`, `xxbdo_utensilios_id`, `mes`, `año`, `respuesta`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('0b450df8-f772-4527-96d9-15d308247ea1', '10MDA', '50JAI', '2019-07-06', 'da049c82-928b-4000-a4c2-62ca4edff221', 7, 2019, NULL, 1, NULL, NULL, '2019-07-06 23:30:00', '2019-07-06 23:30:00'),
('1a022e1e-6413-46eb-90ab-ac5a26b14e87', '10MDA', '50JAI', '2019-07-06', '28550540-74f9-4c8a-9de9-9d5df5d50080', 7, 2019, NULL, 1, NULL, NULL, '2019-07-06 23:30:00', '2019-07-06 23:30:00'),
('30bff281-fa48-437f-aff6-fbf5056b5630', '10MDA', '50JAI', '2019-07-06', '0ab0adfc-f9ae-469c-8762-0dba68af7025', 7, 2019, NULL, 1, NULL, NULL, '2019-07-06 23:30:00', '2019-07-06 23:30:00'),
('4d34b4d5-40d4-4fd3-912a-4ced440fb882', '10MDA', '50JAI', '2019-07-06', '3aa980c9-c18c-460f-b516-8dd65d4d9f8b', 7, 2019, NULL, 1, NULL, NULL, '2019-07-06 23:30:00', '2019-07-06 23:30:00'),
('6e2127fd-6f6d-4f3f-8c98-057fb5703193', '10MDA', '50JAI', '2019-07-06', '5219e0c1-2282-40b6-812d-f45581aeb72a', 7, 2019, NULL, 1, NULL, NULL, '2019-07-06 23:30:00', '2019-07-06 23:30:00'),
('897e7e90-a55b-4459-b817-296a912f59c5', '10MDA', '50JAI', '2019-07-06', '8bfcb753-fad2-406f-be52-f36096c6f559', 7, 2019, NULL, 1, NULL, NULL, '2019-07-06 23:30:00', '2019-07-06 23:30:00'),
('a5a65191-f3c3-4692-acd0-a0a06924f8a8', '10MDA', '50JAI', '2019-07-06', '3a37e70d-f78e-404b-9fbb-ba519401bc10', 7, 2019, NULL, 1, NULL, NULL, '2019-07-06 23:30:00', '2019-07-06 23:30:00'),
('be3d2192-fed2-4a4e-b4e0-f7c0fe4ee56e', '10MDA', '50JAI', '2019-07-06', '3469b4a5-8523-4912-9681-cbbbb4d27dc8', 7, 2019, NULL, 1, NULL, NULL, '2019-07-06 23:30:00', '2019-07-06 23:30:00'),
('bef3ed22-209b-4716-8c7b-d83312d1fb49', '10MDA', '50JAI', '2019-07-06', '04cb9735-5f3b-4d67-9256-a61bd4cf7fc2', 7, 2019, NULL, 1, NULL, NULL, '2019-07-06 23:30:00', '2019-07-06 23:30:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xxbdo_checklist_utensilios_folios`
--

CREATE TABLE `xxbdo_checklist_utensilios_folios` (
  `id` varchar(36) NOT NULL,
  `xxbdo_checklist_utensilios_id` varchar(36) NOT NULL,
  `folio` varchar(50) NOT NULL,
  `comentario` text,
  `activo` tinyint(4) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xxbdo_utensilios`
--

CREATE TABLE `xxbdo_utensilios` (
  `id` varchar(36) NOT NULL,
  `xxbdo_utensilios_categorias_id` varchar(36) NOT NULL,
  `cr_plaza` varchar(10) DEFAULT NULL,
  `cr_tienda` varchar(10) DEFAULT NULL,
  `tipo` char(1) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `orden` int(11) DEFAULT NULL,
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

--
-- Volcado de datos para la tabla `xxbdo_utensilios`
--

INSERT INTO `xxbdo_utensilios` (`id`, `xxbdo_utensilios_categorias_id`, `cr_plaza`, `cr_tienda`, `tipo`, `nombre`, `descripcion`, `orden`, `seleccionable`, `foto`, `codigo`, `via_de_solicitud`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('04cb9735-5f3b-4d67-9256-a61bd4cf7fc2', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, '', 'Utensilio', 'Texto descripcion del utensilio', 1, 1, NULL, NULL, NULL, 1, NULL, NULL, '2019-08-14 11:00:00', '2019-08-14 11:00:00'),
('0ab0adfc-f9ae-469c-8762-0dba68af7025', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, '', 'Cepillo para limpieza de termo', 'Cepillo para limpieza de termo', 2, 1, NULL, NULL, NULL, 1, NULL, NULL, '2019-08-14 22:05:51', '2019-08-14 22:05:51'),
('28550540-74f9-4c8a-9de9-9d5df5d50080', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, '', 'Contenedor para café', 'Contenedor para café', 3, 1, NULL, NULL, NULL, 1, NULL, NULL, '2019-08-14 15:00:00', '2019-08-14 15:00:00'),
('3a37e70d-f78e-404b-9fbb-ba519401bc10', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, '', 'Utensilio', 'Utensilio', 1, 1, NULL, NULL, NULL, 1, NULL, NULL, '2019-08-15 13:00:00', '2019-08-15 13:00:00'),
('3aa980c9-c18c-460f-b516-8dd65d4d9f8b', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, '', 'Utensilio 2', 'Texto de ayuda utensilio 2', 2, 1, NULL, NULL, NULL, 1, NULL, NULL, '2019-08-14 21:00:00', '2019-08-14 21:00:00'),
('5219e0c1-2282-40b6-812d-f45581aeb72a', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, '', 'Caja para café con tres cajones', 'Resguardar bolsas de café en uso', 1, 1, NULL, '5428', 'ATL > Mercadeo > Equipamiento > Utensilios de comida rápida > Solicitud de utensilio de comida rápida sin Stock en plaza > caja para café con 3 cajones', 1, NULL, NULL, '2019-08-14 13:00:00', '2019-08-14 13:00:00'),
('da049c82-928b-4000-a4c2-62ca4edff221', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, '', 'Utensilio 2', 'Utensilio 2', 2, 1, NULL, NULL, NULL, 1, NULL, NULL, '2019-08-15 12:00:00', '2019-08-15 13:00:00');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `xxbdo_checklist_utensilios`
--
ALTER TABLE `xxbdo_checklist_utensilios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_CHKLST_UTNSLS_UTNSLS_ID_INDX` (`xxbdo_utensilios_id`);

--
-- Indices de la tabla `xxbdo_checklist_utensilios_folios`
--
ALTER TABLE `xxbdo_checklist_utensilios_folios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_CHKLST_UTNSLS_FLS_UTNSLS_ID_INDX` (`xxbdo_checklist_utensilios_id`);

--
-- Indices de la tabla `xxbdo_utensilios`
--
ALTER TABLE `xxbdo_utensilios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_UTENSILIOS_CATEGORIAS_ID_IDX` (`xxbdo_utensilios_categorias_id`),
  ADD KEY `XXBDO_UTNSLS_PLAZA_TIENDA_IDX` (`cr_plaza`,`cr_tienda`),
  ADD KEY `XXBDO_UTNSLS_TIPO_IDX` (`tipo`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `xxbdo_checklist_utensilios`
--
ALTER TABLE `xxbdo_checklist_utensilios`
  ADD CONSTRAINT `XXBDO_CHKLST_UTNSLS_UTNSLS_ID_FK` FOREIGN KEY (`xxbdo_utensilios_id`) REFERENCES `xxbdo_utensilios` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `xxbdo_checklist_utensilios_folios`
--
ALTER TABLE `xxbdo_checklist_utensilios_folios`
  ADD CONSTRAINT `XXBDO_CHKLST_UTNSLS_FLS_UTNSLS_ID_FK` FOREIGN KEY (`xxbdo_checklist_utensilios_id`) REFERENCES `xxbdo_checklist_utensilios` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `xxbdo_utensilios`
--
ALTER TABLE `xxbdo_utensilios`
  ADD CONSTRAINT `XXBDO_UTENSILIOS_CATEGORIAS_ID_FK` FOREIGN KEY (`xxbdo_utensilios_categorias_id`) REFERENCES `xxbdo_utensilios_categorias` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
SET FOREIGN_KEY_CHECKS=1;
COMMIT;
