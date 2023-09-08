
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `xxbdo`
--
USE `xxbdo`;

--
-- Dumping data for table `xxbdo_configuracion`
--

INSERT INTO `xxbdo_configuracion` (`id`, `modulo`, `parametro`, `valor`, `orden`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('513604ed-cb1b-4317-828a-406926f0adef', 'reportes', 'resumenbdo_semaforo_evaluacion_diaria_bdo_warning', '#FFA500', 2, 1, 1, NULL, NULL, NOW(), NOW()),
('80f416d2-ab46-4b95-aaa5-e68c68c46652', 'reportes', 'resumenbdo_semaforo_evaluacion_diaria_bdo_success', '#008000', 1, 1, 1, NULL, NULL, NOW(), NOW()),
('cecb7d4e-9a18-42d3-b65e-6dc88a769d42', 'reportes', 'resumenbdo_semaforo_evaluacion_diaria_bdo_danger', '#FF0000', 3, 1, 1, NULL, NULL, NOW(), NOW());


ALTER TABLE `xxbdo_circulo_de_congruencia` 
ADD `requiere_ajuste_ata` TINYINT NULL DEFAULT NULL 
AFTER `accion_fecha`; 

SET FOREIGN_KEY_CHECKS=1;
COMMIT;