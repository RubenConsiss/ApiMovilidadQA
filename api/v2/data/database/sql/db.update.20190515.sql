SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

ALTER TABLE `xxbdo_observaciones` 
CHANGE COLUMN `turno_mañana` `turno_mañana` TINYINT(4) NULL DEFAULT NULL ,
ADD INDEX `XXBDO_OBSERVACIONES_RESPUESTAS_IDX` (`xxbdo_respuestas_id` ASC),
DROP INDEX `xxbdo_respuestas_id` ;

ALTER TABLE `xxbdo_version_estandares` 
CHANGE COLUMN `fecha_inicio` `fecha_inicio` DATE NOT NULL ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xxbdo_circulo_de_congruencia`
--

CREATE TABLE `xxbdo_circulo_de_congruencia` (
  `id` varchar(36) NOT NULL,
  `xxbdo_respuestas_id` varchar(36) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `comentario` text,
  `foto` text,
  `activo` tinyint(4) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indices de la tabla `xxbdo_circulo_de_congruencia`
--
ALTER TABLE `xxbdo_circulo_de_congruencia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_CC_RESPUESTAS_ID_IDX` (`xxbdo_respuestas_id`);

--
-- Filtros para la tabla `xxbdo_circulo_de_congruencia`
--
ALTER TABLE `xxbdo_circulo_de_congruencia`
  ADD CONSTRAINT `XXBDO_CC_RESPUESTAS_ID_FK` FOREIGN KEY (`xxbdo_respuestas_id`) REFERENCES `xxbdo_respuestas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

SET FOREIGN_KEY_CHECKS=1;
COMMIT;

