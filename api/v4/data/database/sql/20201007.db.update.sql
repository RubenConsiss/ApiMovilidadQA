
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE `xxbdo_evop_configuracion` (
  `id` varchar(36) NOT NULL,
  `xxbdo_checklists_id` varchar(36) NOT NULL,
  `opcion` varchar(50) NOT NULL,
  `minimo` int NOT NULL DEFAULT '0',
  `maximo` int NOT NULL DEFAULT '0',
  `xxbdo_colores_id` varchar(36) NOT NULL,
  `es_activo` tinyint DEFAULT '1',
  `orden` bigint DEFAULT '0',
  `activo` tinyint DEFAULT '1',
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `xxbdo_evop_configuracion`
--

INSERT INTO `xxbdo_evop_configuracion` VALUES('0f996ded-a846-4f23-b891-6b7ba0aef5c9', 'c98336f8-cf56-4a30-909a-42b592928219', 'promedios_totales', 85, 90, '5b7c4ad7-b291-4a7c-8892-6079d64af9aa', 1, 2, 1, NULL, NULL, '2020-09-22 13:04:52', '2020-09-22 13:04:52');
INSERT INTO `xxbdo_evop_configuracion` VALUES('57dc1fbd-aeb3-4570-ac8b-f1d385341538', 'c98336f8-cf56-4a30-909a-42b592928219', 'promedios_totales', 0, 79, '586a2916-98aa-44cc-8afa-a1d1200d70d7', 1, 4, 1, NULL, NULL, '2020-09-22 13:11:31', '2020-09-22 13:11:31');
INSERT INTO `xxbdo_evop_configuracion` VALUES('6699413b-5179-4c44-a716-145a5ec4a6fc', 'c98336f8-cf56-4a30-909a-42b592928219', 'promedios_totales', 91, 100, '4274355c-2a84-4817-97fb-d4cf72d11f75', 1, 1, 1, NULL, NULL, '2020-09-22 13:04:52', '2020-09-22 13:04:52');
INSERT INTO `xxbdo_evop_configuracion` VALUES('6b4fe3ee-ee34-4f15-8276-ebc0ae428945', 'c98336f8-cf56-4a30-909a-42b592928219', 'semaforizacion_fallas', 1, 4, 'f26993e4-323a-44fe-adcd-bf7a63247cee', 1, 2, 1, NULL, NULL, '2020-09-22 13:11:31', '2020-09-22 13:11:31');
INSERT INTO `xxbdo_evop_configuracion` VALUES('b74a63d1-042a-447a-b4aa-f269611de3c8', 'c98336f8-cf56-4a30-909a-42b592928219', 'promedios_totales', 80, 84, 'f26993e4-323a-44fe-adcd-bf7a63247cee', 1, 3, 1, NULL, NULL, '2020-09-22 13:11:31', '2020-09-22 13:11:31');
INSERT INTO `xxbdo_evop_configuracion` VALUES('c8dd0b73-4a7e-4f08-9fd9-544a8683cde9', 'c98336f8-cf56-4a30-909a-42b592928219', 'semaforizacion_fallas', 5, 5, '586a2916-98aa-44cc-8afa-a1d1200d70d7', 1, 1, 1, NULL, NULL, '2020-09-22 13:11:31', '2020-09-22 13:11:31');
INSERT INTO `xxbdo_evop_configuracion` VALUES('d4bb8e4d-08b6-46e4-befa-652c884a1c02', 'c98336f8-cf56-4a30-909a-42b592928219', 'semaforizacion_fallas', 0, 0, '4274355c-2a84-4817-97fb-d4cf72d11f75', 1, 3, 1, NULL, NULL, '2020-09-22 13:11:31', '2020-09-22 13:11:31');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `xxbdo_evop_configuracion`
--
ALTER TABLE `xxbdo_evop_configuracion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_EVOP_CNFG_COLORES_ID_INDX` (`xxbdo_colores_id`),
  ADD KEY `XXBDO_EVOP_CNFG_CHECKLISTS_ID_INDX` (`xxbdo_checklists_id`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `xxbdo_evop_configuracion`
--
ALTER TABLE `xxbdo_evop_configuracion`
  ADD CONSTRAINT `XXBDO_EVOP_CNFG_COLORES_ID_FK` FOREIGN KEY (`xxbdo_colores_id`) REFERENCES `xxbdo_colores` (`id`);
SET FOREIGN_KEY_CHECKS=1;
COMMIT;