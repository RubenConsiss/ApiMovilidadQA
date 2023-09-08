
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------

--
-- Table structure for table `xxbdo_cron_jobs`
--

CREATE TABLE `xxbdo_cron_jobs` (
  `id` varchar(36) NOT NULL,
  `job_name` varchar(100) NOT NULL,
  `job_task` text NOT NULL,
  `job_second` varchar(45) NOT NULL,
  `job_minute` varchar(45) NOT NULL,
  `job_hour` varchar(45) NOT NULL,
  `job_day_of_month` varchar(45) NOT NULL,
  `job_month` varchar(45) NOT NULL,
  `job_day_of_week` varchar(45) NOT NULL,
  `is_active` tinyint(4) DEFAULT NULL,
  `active` tinyint(4) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Table structure for table `xxbdo_reportes`
--

CREATE TABLE `xxbdo_reportes` (
  `id` varchar(36) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `codigo` varchar(100) NOT NULL,
  `descripcion` text,
  `parametros_default` text,
  `orden` bigint(20) DEFAULT '0',
  `es_activo` tinyint(4) DEFAULT '1',
  `activo` tinyint(4) DEFAULT '1',
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `xxbdo_reportes`
--

INSERT INTO `xxbdo_reportes` VALUES('26c10d13-fdd7-4102-a122-f117f5129a3a', 'Reporte de Uso Semanal Aplicación Movilidad en Tienda', 'RPT_MET_0001', 'Reporte Semanal de uso de la aplicación Movilidad en Tienda', NULL, 1, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_reportes` VALUES('bbbcc707-6597-4ee9-8992-6e1fa92d1f56', 'Reporte Semanal de captura de Checklist BDO plaza Veracruz', 'RPT_MET_0002', 'Reporte Semanal de captura de Checklist BDO plaza Veracruz.', NULL, 2, 1, 1, NULL, NULL, NOW(), NOW());

-- --------------------------------------------------------

--
-- Table structure for table `xxbdo_reportes_monitor`
--

CREATE TABLE `xxbdo_reportes_monitor` (
  `id` varchar(36) NOT NULL,
  `xxbdo_reportes_id` varchar(36) NOT NULL,
  `reporte_parametros` text,
  `reporte_inicio` timestamp NULL DEFAULT NULL,
  `reporte_fin` timestamp NULL DEFAULT NULL,
  `reporte_status` varchar(50) DEFAULT NULL,
  `activo` tinyint(4) DEFAULT '1',
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Indexes for dumped tables
--

--
-- Indexes for table `xxbdo_cron_jobs`
--
ALTER TABLE `xxbdo_cron_jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `xxbdo_reportes`
--
ALTER TABLE `xxbdo_reportes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `xxbdo_reportes_monitor`
--
ALTER TABLE `xxbdo_reportes_monitor`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_REPORTES_MONITOR_REPORTES_ID_INDX` (`xxbdo_reportes_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `xxbdo_reportes_monitor`
--
ALTER TABLE `xxbdo_reportes_monitor`
  ADD CONSTRAINT `XXBDO_REPORTES_MONITOR_REPORTES_ID_FK` FOREIGN KEY (`xxbdo_reportes_id`) REFERENCES `xxbdo_reportes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
SET FOREIGN_KEY_CHECKS=1;
COMMIT;
