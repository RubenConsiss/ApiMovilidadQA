SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

USE `xxbdo_fr08`;

DROP TABLE `xxbdo_evaluacion_indicadores`;
-- `ALTER TABLE ``xxbdo_evaluacion_indicadores`` DROP INDEX ``XXBDO_EVAL_INDS_RANGO_FECHAS_IDX``;`
-- `ALTER TABLE ``xxbdo_evaluacion_indicadores`` DROP INDEX ``XXBDO_EVAL_IND_INDICADORES_ID_IDX``;`
-- `ALTER TABLE ``xxbdo_evaluacion_indicadores`` DROP INDEX ``XXBDO_EVAL_IND_CHECKLISTS_ID_IDX``;`
-- `ALTER TABLE ``xxbdo_evaluacion_indicadores`` DROP INDEX ``XXBDO_EVAL_IND_AREAS_STDS_ID_IDX``;`

DROP TABLE `xxbdo_indicadores`;
DROP TABLE `xxbdo_tiendas_adopta`;
DROP TABLE `xxbdo_tiendas_adopta_fed`;
DROP TABLE `xxbdo_tiendas_tmp`;

ALTER TABLE `xxbdo_areas_estandares` ADD `activo` BOOLEAN NULL DEFAULT TRUE AFTER `dias_activos`;

ALTER TABLE `xxbdo_checklists` ADD `fecha_inicio` DATE NULL AFTER `descripcion`, 
ADD `fecha_fin` DATE NULL AFTER `fecha_inicio`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xxbdo_checklists_has_areas_estandares`
--
CREATE TABLE `xxbdo_checklists_has_areas_estandares` (
  `xxbdo_checklists_id` varchar(36) NOT NULL,
  `xxbdo_areas_estandares_id` varchar(36) NOT NULL,
  `es_visible` tinyint(4) DEFAULT '1',
  `activo` tinyint(4) DEFAULT '1',
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `xxbdo_checklists_has_areas_estandares`
--
INSERT INTO `xxbdo_checklists_has_areas_estandares` (`xxbdo_checklists_id`, `xxbdo_areas_estandares_id`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('92252664-6baa-4040-ac34-49bc375c7559', '00062a5f-c646-4845-bfbf-93918fbffaad', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '0058a7a6-3249-4460-ac4e-c02720764d29', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', '04a1a2a7-46ad-4062-905e-c4e8678a0c30', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', '0cc53190-31ab-4c22-aeaf-b99f942f5f02', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '12c3fbc4-d016-4c69-89fe-c5fe1f29175e', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '14cf6b5f-45a7-4564-b515-fca0de4d6152', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '3079d111-f116-4845-8eb5-85b759b92e4f', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '30cdb8b4-d614-4f42-a804-2f378d1e940d', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '385aafdb-2d04-424e-af65-918b5057295d', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '3f36624d-56d0-487e-bad7-fdabf644f027', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', '45d5522e-6c37-4a7a-b1ee-c57cd38e583b', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '5a6f7661-afb3-497a-8e39-10d176cc42bb', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', '5c9d2919-3d35-407c-98b5-9595cda76b7b', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '6e1b34ef-2eee-41f4-a1d0-79227af1de5d', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '70f6862d-80ea-462b-b7fb-bb2eadaf9b16', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', '7257ae89-4f0e-42d6-8c37-fd24600f8c09', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', '755301b8-093b-4efa-b41c-fc5824305771', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', '76700dcc-1701-4594-9301-0c210bc3566e', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', '792084de-6819-4666-9f81-111618fc03e6', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', '80b6c335-19ba-4379-8cb1-ff948a339161', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', '833fdd2c-6741-414c-b341-21d90eba134d', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '87af5596-f2e0-409b-b757-bcaa2f7d0a0d', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8a4b9e51-197d-4725-b42e-aeca39598b2a', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', '8bcfa94f-29a5-4fa2-9c3e-86d5868a326a', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', '8be02a3d-595e-49c9-bf18-64eb0d75ab73', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8c5843a4-4ee9-4a9c-a497-e880a0029a95', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8fe04362-c309-4549-8d50-9b25a8e364c7', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '9825f468-d2cc-4805-ab47-804cea7e659e', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', '9f008329-cf47-47c2-9be7-afbfd19e2931', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', 'a08a3da8-6c98-45b7-b169-93b82001b0a7', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'acc00d84-4e1d-4ad9-be75-a84ac091ccc6', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', 'b10609ef-645c-4fb3-baac-8cd6d7a5ab60', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'b4ab76e8-8f54-4104-8685-d051a4ed8358', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'bc37070e-525d-4900-8732-c5b90c60f5b3', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', 'bd6378f9-09e2-4a87-b7ca-1e43eae9a4d5', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', 'be045a08-2c90-4019-95ee-f019d3516996', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'c580fa9e-b53f-4cdd-820c-f98e85dedbe2', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'd1479d38-2e91-4d90-982d-794b3e9dc5df', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', 'd293bf34-e983-46f8-a872-76c7f5f900b9', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'd45bb2af-8d7a-4797-a2aa-103e83481145', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', 'd5d463ed-6eaa-490d-8cf0-03a0c030fe02', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', 'e3dc6aa2-9baf-491f-8391-59f31794d519', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', 'e637cbba-3777-4b56-ada3-cbb11d9eea3b', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f33edcf7-8d8d-4049-a26f-1770bd0b197d', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('92252664-6baa-4040-ac34-49bc375c7559', 'f61fa4d4-48d9-4f35-9614-76ee3ff41c66', 1, 1, NULL, NULL, '2018-11-28 05:38:16', '2018-11-28 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f62ca608-cfac-4b65-8168-36bf5bb5277d', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'fe1fc85a-03bf-463c-849a-68d9a9c88f97', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'fe70e125-ab5d-400d-8bc9-00acf4727a66', 1, 1, NULL, NULL, '2018-11-10 05:38:16', '2018-11-10 05:38:16');

--
-- Indices de la tabla `xxbdo_checklists_has_areas_estandares`
--
ALTER TABLE `xxbdo_checklists_has_areas_estandares`
  ADD PRIMARY KEY (`xxbdo_areas_estandares_id`,`xxbdo_checklists_id`),
  ADD KEY `XXBDO_CHECKLISTS_HAS_AREAS_STDS_ID_IDX` (`xxbdo_areas_estandares_id`),
  ADD KEY `XXBDO_CHECKLISTS_HAS_CHKLSTS_ID_IDX` (`xxbdo_checklists_id`);

--
-- Filtros para la tabla `xxbdo_checklists_has_areas_estandares`
--
ALTER TABLE `xxbdo_checklists_has_areas_estandares`
  ADD CONSTRAINT `XXBDO_CHECKLISTS_HAS_AREAS_STDS_ID_FK` FOREIGN KEY (`xxbdo_areas_estandares_id`) REFERENCES `xxbdo_areas_estandares` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `XXBDO_CHECKLISTS_HAS_CHKLSTS_ID_FK` FOREIGN KEY (`xxbdo_checklists_id`) REFERENCES `xxbdo_checklists` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `xxbdo_checklists_tiendas` DROP `id`;

ALTER TABLE `xxbdo_checklists_tiendas` ADD `es_default` BOOLEAN NULL DEFAULT FALSE AFTER `cr_tienda`;

ALTER TABLE `xxbdo_checklists_tiendas` DROP INDEX `XXBDO_CHECKLISTS_TIENDAS_PLAZA_TIENDA_IDX`;

ALTER TABLE `xxbdo_checklists_tiendas` 
CHANGE `cr_plaza` `cr_plaza` VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, 
CHANGE `cr_tienda` `cr_tienda` VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

ALTER TABLE `xxbdo_checklists_tiendas` ADD PRIMARY KEY (`xxbdo_checklists_id`, `cr_plaza`, `cr_tienda`);

ALTER TABLE `xxbdo_checklists_tiendas` DROP INDEX `XXBDO_CHECKLISTS_TIENDAS_IDX`;

--
-- Filtros para la tabla `xxbdo_checklists_tiendas`
--
ALTER TABLE `xxbdo_checklists_tiendas`
  ADD CONSTRAINT `XXBDO_CHECKLISTS_TIENDAS_CHECKLISTS_ID_FK` FOREIGN KEY (`xxbdo_checklists_id`) REFERENCES `xxbdo_checklists` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `xxbdo_observaciones` CHANGE `accion_responsable_fecha` `accion` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;

ALTER TABLE `xxbdo_observaciones` ADD `accion_responsable` TEXT NULL AFTER `accion`, 
ADD `accion_fecha` DATE NULL AFTER `accion_responsable`;

ALTER TABLE `xxbdo_observaciones` CHANGE `ajuste_ata` `requiere_ajuste_ata` TINYINT(4) NULL DEFAULT NULL;

ALTER TABLE `xxbdo_observaciones` CHANGE `hay_seguimiento` `realizaron_plan_accion` TINYINT(4) NULL DEFAULT NULL;

ALTER TABLE `xxbdo_observaciones` CHANGE `es_cierre_efectiva` `resolvio_problema` TINYINT(4) NULL DEFAULT NULL;

ALTER TABLE `xxbdo_observaciones` ADD `observacion` TEXT NULL AFTER `resolvio_problema`;

ALTER TABLE `xxbdo_observaciones` ADD `turno_tarde` BOOLEAN NULL AFTER `turno`, 
ADD `turno_noche` BOOLEAN NULL AFTER `turno_tarde`;

UPDATE `xxbdo_observaciones` SET `turno_tarde`=(IF(`turno`='T', 1, 0)), 
`turno_noche`=(IF(`turno`='N', 1, 0));

UPDATE `xxbdo_observaciones` SET `turno`=(IF(`turno`='M', 1, 0));

ALTER TABLE `xxbdo_observaciones` CHANGE `turno` `turno_mañana` BOOLEAN NULL DEFAULT NULL;

--
-- Estructura de tabla para la tabla `xxbdo_tiendas_has_areas_estandares`
--

CREATE TABLE `xxbdo_tiendas_has_areas_estandares` (
  `cr_plaza` varchar(10) NOT NULL,
  `cr_tienda` varchar(10) NOT NULL,
  `xxbdo_checklists_id` varchar(36) NOT NULL,
  `xxbdo_areas_estandares_id` varchar(36) NOT NULL,
  `grupos_id` varchar(36) DEFAULT NULL,
  `es_visible` tinyint(4) DEFAULT '1',
  `activo` tinyint(4) DEFAULT '1',
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `xxbdo_tiendas_has_areas_estandares`
--

INSERT INTO `xxbdo_tiendas_has_areas_estandares` (`cr_plaza`, `cr_tienda`, `xxbdo_checklists_id`, `xxbdo_areas_estandares_id`, `grupos_id`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '0058a7a6-3249-4460-ac4e-c02720764d29', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '12c3fbc4-d016-4c69-89fe-c5fe1f29175e', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '14cf6b5f-45a7-4564-b515-fca0de4d6152', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '3079d111-f116-4845-8eb5-85b759b92e4f', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '30cdb8b4-d614-4f42-a804-2f378d1e940d', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '385aafdb-2d04-424e-af65-918b5057295d', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '3f36624d-56d0-487e-bad7-fdabf644f027', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '5a6f7661-afb3-497a-8e39-10d176cc42bb', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '6e1b34ef-2eee-41f4-a1d0-79227af1de5d', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '70f6862d-80ea-462b-b7fb-bb2eadaf9b16', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '87af5596-f2e0-409b-b757-bcaa2f7d0a0d', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8a4b9e51-197d-4725-b42e-aeca39598b2a', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8c5843a4-4ee9-4a9c-a497-e880a0029a95', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8fe04362-c309-4549-8d50-9b25a8e364c7', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '9825f468-d2cc-4805-ab47-804cea7e659e', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'acc00d84-4e1d-4ad9-be75-a84ac091ccc6', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'b4ab76e8-8f54-4104-8685-d051a4ed8358', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'bc37070e-525d-4900-8732-c5b90c60f5b3', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'c580fa9e-b53f-4cdd-820c-f98e85dedbe2', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'd1479d38-2e91-4d90-982d-794b3e9dc5df', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'd45bb2af-8d7a-4797-a2aa-103e83481145', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f33edcf7-8d8d-4049-a26f-1770bd0b197d', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f62ca608-cfac-4b65-8168-36bf5bb5277d', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'fe1fc85a-03bf-463c-849a-68d9a9c88f97', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'fe70e125-ab5d-400d-8bc9-00acf4727a66', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '00062a5f-c646-4845-bfbf-93918fbffaad', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '04a1a2a7-46ad-4062-905e-c4e8678a0c30', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '0cc53190-31ab-4c22-aeaf-b99f942f5f02', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '45d5522e-6c37-4a7a-b1ee-c57cd38e583b', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '5c9d2919-3d35-407c-98b5-9595cda76b7b', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '7257ae89-4f0e-42d6-8c37-fd24600f8c09', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '755301b8-093b-4efa-b41c-fc5824305771', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '76700dcc-1701-4594-9301-0c210bc3566e', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '792084de-6819-4666-9f81-111618fc03e6', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '80b6c335-19ba-4379-8cb1-ff948a339161', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '833fdd2c-6741-414c-b341-21d90eba134d', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '8bcfa94f-29a5-4fa2-9c3e-86d5868a326a', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '8be02a3d-595e-49c9-bf18-64eb0d75ab73', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', '9f008329-cf47-47c2-9be7-afbfd19e2931', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', 'a08a3da8-6c98-45b7-b169-93b82001b0a7', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', 'b10609ef-645c-4fb3-baac-8cd6d7a5ab60', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', 'bd6378f9-09e2-4a87-b7ca-1e43eae9a4d5', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', 'be045a08-2c90-4019-95ee-f019d3516996', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', 'd293bf34-e983-46f8-a872-76c7f5f900b9', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', 'd5d463ed-6eaa-490d-8cf0-03a0c030fe02', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', 'e3dc6aa2-9baf-491f-8391-59f31794d519', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', 'e637cbba-3777-4b56-ada3-cbb11d9eea3b', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50AMV', '92252664-6baa-4040-ac34-49bc375c7559', 'f61fa4d4-48d9-4f35-9614-76ee3ff41c66', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '0058a7a6-3249-4460-ac4e-c02720764d29', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '12c3fbc4-d016-4c69-89fe-c5fe1f29175e', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '14cf6b5f-45a7-4564-b515-fca0de4d6152', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '3079d111-f116-4845-8eb5-85b759b92e4f', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '30cdb8b4-d614-4f42-a804-2f378d1e940d', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '385aafdb-2d04-424e-af65-918b5057295d', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '3f36624d-56d0-487e-bad7-fdabf644f027', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '5a6f7661-afb3-497a-8e39-10d176cc42bb', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '6e1b34ef-2eee-41f4-a1d0-79227af1de5d', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '70f6862d-80ea-462b-b7fb-bb2eadaf9b16', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '87af5596-f2e0-409b-b757-bcaa2f7d0a0d', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8a4b9e51-197d-4725-b42e-aeca39598b2a', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8c5843a4-4ee9-4a9c-a497-e880a0029a95', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8fe04362-c309-4549-8d50-9b25a8e364c7', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '9825f468-d2cc-4805-ab47-804cea7e659e', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'acc00d84-4e1d-4ad9-be75-a84ac091ccc6', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'b4ab76e8-8f54-4104-8685-d051a4ed8358', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'bc37070e-525d-4900-8732-c5b90c60f5b3', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'c580fa9e-b53f-4cdd-820c-f98e85dedbe2', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'd1479d38-2e91-4d90-982d-794b3e9dc5df', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'd45bb2af-8d7a-4797-a2aa-103e83481145', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f33edcf7-8d8d-4049-a26f-1770bd0b197d', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f62ca608-cfac-4b65-8168-36bf5bb5277d', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'fe1fc85a-03bf-463c-849a-68d9a9c88f97', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50BI0', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'fe70e125-ab5d-400d-8bc9-00acf4727a66', NULL, 1, 1, 'azlara@hotmail.com', '::ffff:127.0.0.1', '2018-11-30 17:56:08', '2018-11-30 17:56:08'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '0058a7a6-3249-4460-ac4e-c02720764d29', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '12c3fbc4-d016-4c69-89fe-c5fe1f29175e', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '14cf6b5f-45a7-4564-b515-fca0de4d6152', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '3079d111-f116-4845-8eb5-85b759b92e4f', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '30cdb8b4-d614-4f42-a804-2f378d1e940d', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '385aafdb-2d04-424e-af65-918b5057295d', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '3f36624d-56d0-487e-bad7-fdabf644f027', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '5a6f7661-afb3-497a-8e39-10d176cc42bb', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '6e1b34ef-2eee-41f4-a1d0-79227af1de5d', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '70f6862d-80ea-462b-b7fb-bb2eadaf9b16', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '87af5596-f2e0-409b-b757-bcaa2f7d0a0d', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8a4b9e51-197d-4725-b42e-aeca39598b2a', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8c5843a4-4ee9-4a9c-a497-e880a0029a95', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8fe04362-c309-4549-8d50-9b25a8e364c7', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '9825f468-d2cc-4805-ab47-804cea7e659e', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'acc00d84-4e1d-4ad9-be75-a84ac091ccc6', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'b4ab76e8-8f54-4104-8685-d051a4ed8358', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'bc37070e-525d-4900-8732-c5b90c60f5b3', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'c580fa9e-b53f-4cdd-820c-f98e85dedbe2', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'd1479d38-2e91-4d90-982d-794b3e9dc5df', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'd45bb2af-8d7a-4797-a2aa-103e83481145', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f33edcf7-8d8d-4049-a26f-1770bd0b197d', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f62ca608-cfac-4b65-8168-36bf5bb5277d', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'fe1fc85a-03bf-463c-849a-68d9a9c88f97', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'fe70e125-ab5d-400d-8bc9-00acf4727a66', NULL, 1, 1, NULL, NULL, '2018-11-10 11:38:16', '2018-11-10 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '00062a5f-c646-4845-bfbf-93918fbffaad', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '04a1a2a7-46ad-4062-905e-c4e8678a0c30', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '0cc53190-31ab-4c22-aeaf-b99f942f5f02', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '45d5522e-6c37-4a7a-b1ee-c57cd38e583b', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '5c9d2919-3d35-407c-98b5-9595cda76b7b', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '7257ae89-4f0e-42d6-8c37-fd24600f8c09', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '755301b8-093b-4efa-b41c-fc5824305771', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '76700dcc-1701-4594-9301-0c210bc3566e', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '792084de-6819-4666-9f81-111618fc03e6', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '80b6c335-19ba-4379-8cb1-ff948a339161', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '833fdd2c-6741-414c-b341-21d90eba134d', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '8bcfa94f-29a5-4fa2-9c3e-86d5868a326a', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '8be02a3d-595e-49c9-bf18-64eb0d75ab73', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', '9f008329-cf47-47c2-9be7-afbfd19e2931', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', 'a08a3da8-6c98-45b7-b169-93b82001b0a7', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', 'b10609ef-645c-4fb3-baac-8cd6d7a5ab60', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', 'bd6378f9-09e2-4a87-b7ca-1e43eae9a4d5', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', 'be045a08-2c90-4019-95ee-f019d3516996', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', 'd293bf34-e983-46f8-a872-76c7f5f900b9', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', 'd5d463ed-6eaa-490d-8cf0-03a0c030fe02', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', 'e3dc6aa2-9baf-491f-8391-59f31794d519', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', 'e637cbba-3777-4b56-ada3-cbb11d9eea3b', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16'),
('10MON', '50EDI', '92252664-6baa-4040-ac34-49bc375c7559', 'f61fa4d4-48d9-4f35-9614-76ee3ff41c66', NULL, 1, 1, NULL, NULL, '2018-11-28 11:38:16', '2018-11-28 11:38:16');

--
-- Indices de la tabla `xxbdo_tiendas_has_areas_estandares`
--
ALTER TABLE `xxbdo_tiendas_has_areas_estandares`
  ADD PRIMARY KEY (`cr_plaza`,`cr_tienda`,`xxbdo_checklists_id`,`xxbdo_areas_estandares_id`),
  ADD KEY `XXBDO_TIENDAS_HAS_CHECKLISTS_ID_IDX` (`xxbdo_checklists_id`),
  ADD KEY `XXBDO_TIENDAS_HAS_AREAS_STDS_ID_IDX` (`xxbdo_areas_estandares_id`),
  ADD KEY `XXBDO_TIENDAS_HAS_AREAS_STDS_GRUPOS_ID_IDX` (`grupos_id`);

--
-- Filtros para la tabla `xxbdo_tiendas_has_areas_estandares`
--
ALTER TABLE `xxbdo_tiendas_has_areas_estandares`
  ADD CONSTRAINT `XXBDO_TIENDAS_HAS_AREAS_STDS_FK` FOREIGN KEY (`xxbdo_areas_estandares_id`) REFERENCES `xxbdo_areas_estandares` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `XXBDO_TIENDAS_HAS_CHECKLISTS_FK` FOREIGN KEY (`xxbdo_checklists_id`) REFERENCES `xxbdo_checklists` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `xxbdo_version_estandares` ADD `fecha_inicio` DATE NULL AFTER `es_default`, 
ADD `fecha_fin` DATE NULL AFTER `fecha_inicio`;

SET FOREIGN_KEY_CHECKS=1;
COMMIT;
