
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `xxbdo`
--

USE `xxbdo`;

--
-- Table structure for table `xxbdo_modulos`
--

CREATE TABLE `xxbdo_modulos` (
  `id` varchar(36) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `codigo` varchar(45) DEFAULT NULL,
  `descripcion` text,
  `es_activo` tinyint(4) DEFAULT '0',
  `es_visible` tinyint(4) DEFAULT '0',
  `orden` bigint(20) DEFAULT NULL,
  `activo` tinyint(4) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `xxbdo_modulos`
--

INSERT INTO `xxbdo_modulos` (`id`, `nombre`, `codigo`, `descripcion`, `es_activo`, `es_visible`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('018161c8-922a-477d-8a0d-21e318cd26c4', 'Pendientes', 'pendientes', 'Módulo de Pendientes', 0, 1, 8, 1, NULL, NULL, NOW(), NOW()),
('255a55a3-ae5a-4240-889e-d1c93b8460b7', 'Portales', 'portales', 'Módulo de Portales', 0, 1, 7, 1, NULL, NULL, NOW(), NOW()),
('26580c8b-a7ff-4bf5-a34c-8028068bceac', 'Recepción', 'recepcion', 'Módulo de Recepción', 0, 1, 3, 1, NULL, NULL, NOW(), NOW()),
('417b4991-1a5e-4ae7-ab5d-e58117902607', 'Indicadores', 'indicadores', 'Módulo de Indicadores', 0, 1, 11, 1, NULL, NULL, NOW(), NOW()),
('68e44875-fd0e-4cd1-b048-dacfc20c355f', 'Etiqueteo', 'etiqueteo', 'Módulo de Etiqueteo', 0, 1, 6, 1, NULL, NULL, NOW(), NOW()),
('7223d9dc-e0a4-466b-a023-89a8c56bb327', 'Utensilios', 'utensilios', 'Módulo de Utensilios', 0, 1, 9, 1, NULL, NULL, NOW(), NOW()),
('8031e15a-7096-4430-90ec-6209fbffbcbc', 'Calendario', 'calendario', 'Módulo de Calendario Checklist BDO', 0, 0, 14, 1, NULL, NULL, NOW(), NOW()),
('95909efd-2f72-4389-888c-c3e2dda067dc', 'BDO', 'bdo', 'Módulo de BDO', 0, 1, 4, 1, NULL, NULL, NOW(), NOW()),
('b5209c49-75ca-46af-91d0-a0dfda8b1ea0', 'Corte Z', 'cortez', 'Módulo de Corte Z', 0, 0, 15, 1, NULL, NULL, NOW(), NOW()),
('c21c7557-c726-4bd2-9a99-fa2bd66e5bc0', 'Compra', 'compra', 'Módulo de Órdenes de Compra', 0, 1, 10, 1, NULL, NULL, NOW(), NOW()),
('c99d6077-3a3d-4bca-b39a-ef8ca461bf44', 'Generación', 'generacion', 'Módulo de Generación', 0, 1, 2, 1, NULL, NULL, NOW(), NOW()),
('d3060505-308e-4341-9966-8fcda411b68e', 'Rol de Preinventarios', 'rolpreinv', 'Módulo de Rol de Preinventarios', 0, 1, 12, 1, NULL, NULL, NOW(), NOW()),
('e8686cc6-a3ed-430d-8e5d-1c4d7284b9fa', 'Reclutamiento', 'reclutamiento', 'Módulo de Reclutamiento', 0, 0, 13, 1, NULL, NULL, NOW(), NOW()),
('fb2368e7-242c-490e-84dd-a47a95002473', 'Preinventarios', 'preinv', 'Módulo de Preinventarios', 0, 1, 5, 1, NULL, NULL, NOW(), NOW());

-- --------------------------------------------------------

--
-- Table structure for table `xxbdo_modulos_por_plaza`
--

CREATE TABLE `xxbdo_modulos_por_plaza` (
  `id` varchar(36) NOT NULL,
  `cr_plaza` varchar(36) NOT NULL,
  `xxbdo_modulos_id` varchar(36) NOT NULL,
  `es_activo` tinyint(4) DEFAULT '0',
  `es_visible` tinyint(4) DEFAULT '0',
  `orden` bigint(20) DEFAULT NULL,
  `activo` tinyint(4) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `xxbdo_modulos_por_tienda`
--

CREATE TABLE `xxbdo_modulos_por_tienda` (
  `id` varchar(36) NOT NULL,
  `cr_plaza` varchar(10) NOT NULL,
  `cr_tienda` varchar(10) NOT NULL,
  `xxbdo_modulos_id` varchar(36) NOT NULL,
  `es_activo` tinyint(4) DEFAULT '0',
  `es_visible` tinyint(4) DEFAULT '0',
  `orden` bigint(20) DEFAULT NULL,
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
-- Indexes for table `xxbdo_modulos`
--
ALTER TABLE `xxbdo_modulos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_MODULOS_ORDEN_INDX` (`orden`);

--
-- Indexes for table `xxbdo_modulos_por_plaza`
--
ALTER TABLE `xxbdo_modulos_por_plaza`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `XXBDO_PLAZA_MODULO_INDX` (`cr_plaza`,`xxbdo_modulos_id`),
  ADD KEY `XXBDO_MODULOS_POR_PLAZA_ID_INDX` (`xxbdo_modulos_id`),
  ADD KEY `XXBDO_MODULOS_POR_PLAZA_ORDEN_INDX` (`orden`);

--
-- Indexes for table `xxbdo_modulos_por_tienda`
--
ALTER TABLE `xxbdo_modulos_por_tienda`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `XXBDO_PLAZA_TIENDA_MODULO_INDX` (`cr_plaza`,`cr_tienda`,`xxbdo_modulos_id`),
  ADD KEY `XXBDO_MODULOS_POR_TIENDA_ID_INDX` (`xxbdo_modulos_id`),
  ADD KEY `XXBDO_MODULOS_POR_TIENDA_ORDEN_INDX` (`orden`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `xxbdo_modulos_por_plaza`
--
ALTER TABLE `xxbdo_modulos_por_plaza`
  ADD CONSTRAINT `XXBDO_MODULOS_POR_PLAZA_FK` FOREIGN KEY (`xxbdo_modulos_id`) REFERENCES `xxbdo_modulos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `xxbdo_modulos_por_tienda`
--
ALTER TABLE `xxbdo_modulos_por_tienda`
  ADD CONSTRAINT `XXBDO_MODULOS_POR_TIENDA_FK` FOREIGN KEY (`xxbdo_modulos_id`) REFERENCES `xxbdo_modulos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;


-- Views definition:
CREATE OR REPLACE VIEW vista_xxbdo_modulos  
AS SELECT `xxbdo_modulos`.`id`, 
`xxbdo_modulos`.`nombre`, 
`xxbdo_modulos`.`codigo`, 
`xxbdo_modulos`.`descripcion`, 
IF(`xxbdo_modulos`.`es_activo`,'SI','NO') AS `modulo_activo`, 
IF(`xxbdo_modulos`.`es_visible`,'SI','NO') AS `modulo_visible`,
`xxbdo_modulos`.`es_activo`, 
`xxbdo_modulos`.`es_visible`,
`xxbdo_modulos`.`orden`,
`xxbdo_modulos`.`activo` 
FROM `xxbdo_modulos`;

CREATE OR REPLACE VIEW `vista_xxbdo_modulos_por_plaza` 
AS SELECT `xxbdo_modulos_por_plaza`.`id`, 
`xxbdo_modulos_por_plaza`.`cr_plaza`, 
`xxbdo_modulos`.`nombre` AS `nombre_modulo`, 
`xxbdo_modulos`.`codigo`, 
IF(`xxbdo_modulos_por_plaza`.`es_activo`,'SI','NO') AS `modulo_activo`,
IF(`xxbdo_modulos_por_plaza`.`es_visible`, 'SI', 'NO') AS `modulo_visible`, 
`xxbdo_modulos_por_plaza`.`es_activo`,
`xxbdo_modulos_por_plaza`.`es_visible`,
`xxbdo_modulos_por_plaza`.`orden`,
`xxbdo_modulos_por_plaza`.`activo` 
FROM `xxbdo_modulos_por_plaza`, `xxbdo_modulos` 
WHERE `xxbdo_modulos_por_plaza`.`xxbdo_modulos_id` = `xxbdo_modulos`.`id`;

CREATE OR REPLACE VIEW `vista_xxbdo_modulos_por_tienda` 
AS SELECT `xxbdo_modulos_por_tienda`.`id`, 
`xxbdo_modulos_por_tienda`.`cr_plaza`, 
`xxbdo_modulos_por_tienda`.`cr_tienda`, 
`xxbdo_modulos`.`nombre` AS `nombre_modulo`, 
`xxbdo_modulos`.`codigo`, 
IF(`xxbdo_modulos_por_tienda`.`es_activo`,'SI','NO') AS `modulo_activo`,
IF(`xxbdo_modulos_por_tienda`.`es_visible`, 'SI', 'NO') AS `modulo_visible`, 
`xxbdo_modulos_por_tienda`.`es_activo`,
`xxbdo_modulos_por_tienda`.`es_visible`, 
`xxbdo_modulos_por_tienda`.`orden`, 
`xxbdo_modulos_por_tienda`.`activo` 
FROM `xxbdo_modulos_por_tienda`, `xxbdo_modulos` 
WHERE `xxbdo_modulos_por_tienda`.`xxbdo_modulos_id` = `xxbdo_modulos`.`id`;

SET FOREIGN_KEY_CHECKS=1;
COMMIT;