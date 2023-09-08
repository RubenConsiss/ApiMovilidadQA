
ALTER TABLE `xxbdo_observaciones` 
ADD COLUMN `pendiente_agregado` TINYINT(4) NULL 
DEFAULT NULL AFTER `resolvio_problema`;
