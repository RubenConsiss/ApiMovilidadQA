SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
--
-- Estructura de tabla para la tabla `xxbdo_reportes`
--

CREATE TABLE IF NOT EXISTS `xxbdo_reportes` (
  `id` varchar(36) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `codigo` varchar(100) NOT NULL,
  `descripcion` text,
  `parametros_default` text,
  `nombre_default` varchar(100) NOT NULL,
  `tipo` varchar(5) NOT NULL,
  `orden` bigint(20) DEFAULT '0',
  `es_activo` tinyint(4) DEFAULT '1',
  `activo` tinyint(4) DEFAULT '1',
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `xxbdo_reportes`
--

INSERT INTO `xxbdo_reportes` (`id`, `nombre`, `codigo`, `descripcion`, `parametros_default`, `nombre_default`, `tipo`, `orden`, `es_activo`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('26c10d13-fdd7-4102-a122-f117f5129a3a', 'Reporte de Uso Semanal Aplicación Movilidad en Tienda', 'RPT_MET_0001', 'Reporte Semanal de uso de la aplicación Movilidad en Tienda', NULL, 'Reporte_Uso_Movilidad_En_Tienda_Semana_{num_semana}_{año}', 'csv', 1, 1, 1, NULL, NULL, '2020-11-02 11:46:13', '2020-11-02 11:46:13'),
('bbbcc707-6597-4ee9-8992-6e1fa92d1f56', 'Reporte Semanal de captura de Checklist BDO plaza Veracruz', 'RPT_MET_0002', 'Reporte Semanal de captura de Checklist BDO plaza Veracruz.', NULL, 'Reporte_BDO_plaza_{cr_plaza}_semana_{num_semana}_{año}', 'csv', 2, 1, 1, NULL, NULL, '2020-11-02 11:46:13', '2020-11-02 11:46:13');


--
-- Estructura de tabla para la tabla `xxbdo_cron_jobs`
--

CREATE TABLE IF NOT EXISTS `xxbdo_cron_jobs` (
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
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `xxbdo_cron_jobs`
--

INSERT INTO `xxbdo_cron_jobs` (`id`, `job_name`, `job_task`, `job_second`, `job_minute`, `job_hour`, `job_day_of_month`, `job_month`, `job_day_of_week`, `is_active`, `active`, `username`, `ip_address`, `created_at`, `updated_at`) VALUES
('203b98be-23f8-44bf-a446-59f6bcfe7682', 'REPORTE DE USO MOVILIDAD EN TIENDA', '', '0', '36', '2', '*', '*', 'Tuesday', 0, 1, NULL, NULL, NULL, NULL),
('9440e5cf-695e-43d8-a625-37cfc6fe883e', 'REPORTE DE CAPTURA DE CHECKLIST BDO PLAZA', '', '0', '40', '1', '*', '*', 'Wednesday', 0, 1, NULL, NULL, NULL, NULL);




--
-- Estructura de tabla para la tabla `xxbdo_reportes_monitor`
--

CREATE TABLE IF NOT EXISTS `xxbdo_reportes_monitor` (
  `id` varchar(36) NOT NULL,
  `xxbdo_reportes_id` varchar(36) NOT NULL,
  `reporte_parametros` text,
  `reporte_inicio` timestamp NULL DEFAULT NULL,
  `reporte_fin` timestamp NULL DEFAULT NULL,
  `reporte_status` varchar(50) DEFAULT NULL,
  `reporte_nombre` varchar(100) NOT NULL,
  `activo` tinyint(4) DEFAULT '1',
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `XXBDO_REPORTES_MONITOR_REPORTES_ID_INDX` (`xxbdo_reportes_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `xxbdo_reportes_monitor`
--

--
-- Filtros para la tabla `xxbdo_reportes_monitor`
--
ALTER TABLE `xxbdo_reportes_monitor`
  ADD CONSTRAINT `XXBDO_REPORTES_MONITOR_REPORTES_ID_FK` FOREIGN KEY (`xxbdo_reportes_id`) REFERENCES `xxbdo_reportes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

SET FOREIGN_KEY_CHECKS=1;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;