SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- delete old test record
DELETE FROM `xxbdo_indicadores` WHERE `xxbdo_indicadores`.`id` = "65ba78bd-2292-4161-8f65-81dfc132dc28";

ALTER TABLE `xxbdo_login_attempts` 
ADD COLUMN `printer_name` VARCHAR(100) NULL DEFAULT NULL AFTER `app_version` ;

UPDATE `xxbdo_roles_en_tienda` SET `nombre` = 'Cajero 2x', `descripcion` = 'Rol Cajero 2x', `visible` = '0', `activo` = '0' WHERE `xxbdo_roles_en_tienda`.`id` = 'aff65697-3d4a-4a25-b989-318f20bc5d22'; 

INSERT INTO `xxbdo_roles_en_tienda` (`id`, `nombre`, `descripcion`, `orden`, `visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('2d242aa5-9dc8-468f-a798-22e75392d63a', 'Cajero 2', 'Cajero 2', 7, 1, 1, NULL, NULL, NOW(), NOW());

DELETE FROM `xxbdo_roles_en_tienda` WHERE `xxbdo_roles_en_tienda`.`id` = 'aff65697-3d4a-4a25-b989-318f20bc5d22';

INSERT INTO `xxbdo_configuracion` (`id`, `modulo`, `parametro`, `valor`, `orden`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('ad8400d9-aa7d-4b25-adb9-ae25921277f4', 'estandares', 'areas_grupos_id_estandares_libres', '86392947-9a57-46c0-a16f-f2f4e5c0745d', 1, 1, 1, NULL, NULL, NOW(), NOW());


SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;