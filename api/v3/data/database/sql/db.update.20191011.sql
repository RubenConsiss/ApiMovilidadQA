SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------

ALTER TABLE `xxbdo_login_attempts` ADD `app_version` VARCHAR(100) NULL AFTER `dispositivo`;

--
-- Estructura de tabla para la tabla `xxbdo_configuracion`
--

CREATE TABLE `xxbdo_configuracion` (
  `id` varchar(36) NOT NULL,
  `modulo` varchar(100) NOT NULL,
  `parametro` varchar(100) NOT NULL,
  `valor` text,
  `orden` int(11) DEFAULT NULL,
  `es_visible` tinyint(4) DEFAULT NULL,
  `activo` tinyint(4) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `xxbdo_configuracion`
--

INSERT INTO `xxbdo_configuracion` (`id`, `modulo`, `parametro`, `valor`, `orden`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('558f0f16-fcad-404e-9526-007d252e8cbc', 'utensilios', 'num_maximo_utensilios_nuevos_permitidos_por_mes', '3', 3, 1, 1, NULL, NULL, '2019-10-07 13:00:00', '2019-10-07 13:00:00'),
('88480b66-a38e-4905-a4c4-16e1c9c8bd85', 'utensilios', 'numero_meses_vista_inicial_checklist_utensilios', '6', 1, 1, 1, NULL, NULL, '2019-10-07 13:00:00', '2019-10-07 13:00:00'),
('88f85919-4037-4e2b-94ea-27f3f30dc697', 'pendientes', 'numero_dias_visibles_hacia_atras_fecha_seleccionada', '7', 1, 1, 1, NULL, NULL, '2019-10-03 10:00:00', '2019-10-03 13:00:00'),
('ae5feba3-3dea-40d1-bd46-b9440c19464f', 'utensilios', 'num_maximo_de_folios_por_utensilio', '2', 3, 1, 1, NULL, NULL, '2019-10-07 13:00:00', '2019-10-07 13:00:00'),
('e6174c19-30ed-490f-bcde-624a0b40107e', 'utensilios', 'dia_limite_mensual_para_envio_checklist_utensilios', '7', 2, 1, 1, NULL, NULL, '2019-10-07 13:00:00', '2019-10-07 13:00:00');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `xxbdo_configuracion`
--
ALTER TABLE `xxbdo_configuracion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_CONFIG_MOD_PARAM_INDX` (`modulo`,`parametro`);


  
CREATE TABLE `xxbdo_roles_en_tienda` (
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
-- Volcado de datos para la tabla `xxbdo_roles_en_tienda`
--

INSERT INTO `xxbdo_roles_en_tienda` (`id`, `nombre`, `descripcion`, `orden`, `visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('42af79a1-6646-4a47-a13e-9eff84149ebc', 'Encargado 3', 'Encargado 3', 6, 1, 1, NULL, NULL, '2019-10-02 12:00:00', '2019-10-02 14:00:00'),
('5360e586-a3e3-46f7-924f-648d23087d58', 'Piso 3', 'Piso 3', 12, 1, 1, NULL, NULL, '2019-10-02 12:00:00', '2019-10-02 14:00:00'),
('63c3c962-b684-48d7-b2b2-6e236eddb4fa', 'Cajero 3', 'Cajero 3', 9, 1, 1, NULL, NULL, '2019-10-02 12:00:00', '2019-10-02 14:00:00'),
('64b0937d-77dc-4c68-af63-f5332df91466', 'Equipo', 'Equipo', 2, 1, 1, NULL, NULL, '2019-10-02 12:00:00', '2019-10-02 12:00:00'),
('6975ca63-6138-47d0-9456-677bc94b02d7', 'Piso 2', 'Piso 2', 11, 1, 1, NULL, NULL, '2019-10-02 12:00:00', '2019-10-02 14:00:00'),
('6b87c16b-eaaf-488b-bdcd-3f3801c8ef4e', 'Cajero 1', 'Cajero 1', 7, 1, 1, NULL, NULL, '2019-10-02 11:00:00', '2019-10-02 12:00:00'),
('72624c71-2115-4ea6-b6e7-a69d7dfcd7e0', 'Lider', 'Líder', 3, 1, 1, NULL, NULL, '2019-10-02 11:00:00', '2019-10-02 12:00:00'),
('8eb2b5e9-8af6-4ebc-bfa1-81f85e46bce2', 'Piso 1', 'Piso 1', 10, 1, 1, NULL, NULL, '2019-10-02 11:00:00', '2019-10-02 12:00:00'),
('940a7f29-8e22-4005-bee3-372fa2e8d79f', 'Encargado 2', 'Encargado 2', 5, 1, 1, NULL, NULL, '2019-10-02 11:00:00', '2019-10-02 12:00:00'),
('99aaade2-e42d-4f1d-a5f3-d41f9b0271aa', 'Encargado 1', 'Encargado 1', 4, 1, 1, NULL, NULL, '2019-10-02 12:00:00', '2019-10-02 14:00:00'),
('aff65697-3d4a-4a25-b989-318f20bc5d22', 'Cajero 2', 'Cajero 2', 8, 1, 1, NULL, NULL, '2019-10-02 12:00:00', '2019-10-02 14:00:00'),
('b9e0794d-e266-4f1b-815d-fd3177d98f02', 'Todos', 'Todos', 1, 1, 1, NULL, NULL, '2019-10-02 11:00:00', '2019-10-02 11:00:00');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `xxbdo_roles_en_tienda`
--
ALTER TABLE `xxbdo_roles_en_tienda`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `XXBDO_ROLES_EN_TIENDA_NOMBRE_UNQ` (`nombre`);


--
-- Estructura de tabla para la tabla `xxbdo_pendientes`
--

CREATE TABLE `xxbdo_pendientes` (
  `id` varchar(36) NOT NULL,
  `cr_plaza` varchar(10) NOT NULL,
  `cr_tienda` varchar(10) NOT NULL,
  `fecha_compromiso` date NOT NULL,
  `fecha_terminacion` timestamp NULL DEFAULT NULL,
  `registrado_por` varchar(36) NOT NULL,
  `responsable` varchar(36) NOT NULL,
  `descripcion` text,
  `activo` tinyint(4) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `xxbdo_pendientes`
--

INSERT INTO `xxbdo_pendientes` (`id`, `cr_plaza`, `cr_tienda`, `fecha_compromiso`, `fecha_terminacion`, `registrado_por`, `responsable`, `descripcion`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('0aeba632-36a8-4e2f-a5a2-022e580827b0', '10MDA', '50JAI', '2019-10-15', NULL, '99aaade2-e42d-4f1d-a5f3-d41f9b0271aa', '8eb2b5e9-8af6-4ebc-bfa1-81f85e46bce2', 'Quidem aliquid, quisquam malesuada mollit, eos molestias! Labore, ultrices diamlorem! Similique natoque repellat, quis pharetra!', 1, NULL, NULL, '2019-08-12 14:00:00', '2019-08-12 14:00:00'),
('2b16a02d-6829-4d7b-bfb8-9c2d7a4fe7f7', '10MDA', '50JAI', '2019-10-03', NULL, '99aaade2-e42d-4f1d-a5f3-d41f9b0271aa', '8eb2b5e9-8af6-4ebc-bfa1-81f85e46bce2', 'Realizar pendiente que el muchacho no realiza desde hace mucho.', 1, NULL, NULL, '2019-08-12 14:00:00', '2019-08-12 14:00:00'),
('5880b353-a451-47b1-b4d0-4c22f82a5e24', '10MDA', '50JAI', '2019-10-03', '2019-10-03 21:50:00', '99aaade2-e42d-4f1d-a5f3-d41f9b0271aa', '64b0937d-77dc-4c68-af63-f5332df91466', 'Magnam sequi exercitation non montes, tempus, in quis habitant class quisquam!', 1, NULL, NULL, '2019-10-03 14:00:00', '2019-10-03 21:50:00'),
('69fb22a7-a829-4384-9388-aea7e45bb8c0', '10MDA', '50JAI', '2019-10-02', NULL, '6b87c16b-eaaf-488b-bdcd-3f3801c8ef4e', '940a7f29-8e22-4005-bee3-372fa2e8d79f', 'Penatibus, lectus, aliquid, excepturi. Odit? Hic facilisi, quas, optio, odio possimus deleniti minim, diam architecto necessitatibus sem nostra condimentum natoque, odit.', 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2019-10-03 03:01:30', '2019-10-03 03:01:30'),
('942cd4b6-5b06-483a-b237-a99f656bcf22', '10MDA', '50JAI', '2019-10-03', NULL, '99aaade2-e42d-4f1d-a5f3-d41f9b0271aa', '8eb2b5e9-8af6-4ebc-bfa1-81f85e46bce2', 'Quaerat ut? Nec, vitae voluptas? Integer, praesent illum? Atque unde, tempore? Occaecat inventore laboriosam eaque inventore! Pede, minima!', 1, NULL, NULL, '2019-08-12 14:00:00', '2019-08-12 14:00:00'),
('bfe4e62a-2eac-489d-88c5-ba40bec0b73b', '10MDA', '50JAI', '2019-10-02', '2019-10-03 16:15:00', '99aaade2-e42d-4f1d-a5f3-d41f9b0271aa', 'aff65697-3d4a-4a25-b989-318f20bc5d22', 'Dictumst et quidem! Voluptate. Sed, repudiandae itaque minus, euismod lacus, consequatur praesentium.', 1, NULL, NULL, '2019-10-02 13:00:00', '2019-10-03 16:15:00'),
('c1a21ca9-dd68-4a38-93ef-52c890c49a56', '10MDA', '50JAI', '2019-10-18', NULL, '99aaade2-e42d-4f1d-a5f3-d41f9b0271aa', '8eb2b5e9-8af6-4ebc-bfa1-81f85e46bce2', 'Consequatur fusce consequatur nunc massa accusamus aspernatur praesentium dolore! Dolor class lacus suspendisse, vel?', 1, NULL, NULL, '2019-08-12 14:00:00', '2019-08-12 14:00:00'),
('c7caa801-8960-4e1e-84e3-97f7cd7a7bee', '10MDA', '50JAI', '2019-10-03', NULL, '99aaade2-e42d-4f1d-a5f3-d41f9b0271aa', '8eb2b5e9-8af6-4ebc-bfa1-81f85e46bce2', 'Scelerisque mi nostrum iaculis laboris minus eligendi leo commodo, aliquid diamlorem laoreet, praesent, tempore ridiculus?', 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2019-08-13 11:52:19', '2019-10-04 16:57:37'),
('cc5ce548-5406-4ebe-a623-eb19ce7c0864', '10MDA', '50JAI', '2019-10-03', '2019-10-03 22:40:00', '99aaade2-e42d-4f1d-a5f3-d41f9b0271aa', '8eb2b5e9-8af6-4ebc-bfa1-81f85e46bce2', 'Esta es la descripcion actualizada del pendiente que Abundio tiene que realizar.', 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2019-10-03 13:03:52', '2019-10-13 22:40:00');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `xxbdo_pendientes`
--
ALTER TABLE `xxbdo_pendientes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_PENDIENTES_REG_POR_INDX` (`registrado_por`),
  ADD KEY `XXBDO_PENDIENTES_RESP_INDX` (`responsable`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `xxbdo_pendientes`
--
ALTER TABLE `xxbdo_pendientes`
  ADD CONSTRAINT `XXBDO_PENDIENTES_REG_POR_FK` FOREIGN KEY (`registrado_por`) REFERENCES `xxbdo_roles_en_tienda` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `XXBDO_PENDIENTES_RESP_FK` FOREIGN KEY (`responsable`) REFERENCES `xxbdo_roles_en_tienda` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
  
SET FOREIGN_KEY_CHECKS=1;
COMMIT;
