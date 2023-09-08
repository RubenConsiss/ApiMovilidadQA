
-- Queries para crear modulo de reportes:

-- al correr en BD de pruebas, cambiar a: USE xxbdo_<dbname>;
-- al correr en BD production, USE xxbdo;
USE `xxbdo`;

CREATE TABLE IF NOT EXISTS `xxbdo_reportes_monitor` (
  `id` VARCHAR(36) NOT NULL,
  `xxbdo_reportes_id` VARCHAR(36) NOT NULL,
  `reporte_parametros` TEXT NULL DEFAULT NULL,
  `reporte_inicio` TIMESTAMP NULL DEFAULT NULL,
  `reporte_fin` TIMESTAMP NULL DEFAULT NULL,
  `reporte_status` VARCHAR(50) NULL DEFAULT NULL,
  `reporte_nombre` VARCHAR(100) NOT NULL,
  `activo` TINYINT(4) NULL DEFAULT 1,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_REPORTES_MONITOR_REPORTES_ID_INDX` (`xxbdo_reportes_id` ASC) ,
  CONSTRAINT `XXBDO_REPORTES_MONITOR_REPORTES_ID_FK`
    FOREIGN KEY (`xxbdo_reportes_id`)
    REFERENCES `xxbdo_reportes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `xxbdo_cron_jobs` (
  `id` VARCHAR(36) NOT NULL,
  `job_name` VARCHAR(100) NOT NULL,
  `job_task` TEXT NOT NULL,
  `job_second` VARCHAR(45) NOT NULL,
  `job_minute` VARCHAR(45) NOT NULL,
  `job_hour` VARCHAR(45) NOT NULL,
  `job_day_of_month` VARCHAR(45) NOT NULL,
  `job_month` VARCHAR(45) NOT NULL,
  `job_day_of_week` VARCHAR(45) NOT NULL,
  `is_active` TINYINT(4) NULL DEFAULT NULL,
  `active` TINYINT(4) NULL DEFAULT NULL,
  `username` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `xxbdo_reportes` (
  `id` VARCHAR(36) NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `codigo` VARCHAR(100) NOT NULL,
  `descripcion` TEXT NULL DEFAULT NULL,
  `parametros_default` TEXT NULL DEFAULT NULL,
  `nombre_default` VARCHAR(100) NOT NULL,
  `tipo` VARCHAR(5) NOT NULL,
  `orden` BIGINT(20) NULL DEFAULT 0,
  `es_activo` TINYINT(4) NULL DEFAULT 1,
  `activo` TINYINT(4) NULL DEFAULT 1,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

