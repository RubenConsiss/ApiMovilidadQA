
ALTER TABLE `xxbdo_tarjetas_status` 
ADD COLUMN `es_default` TINYINT(4) NULL DEFAULT 0 AFTER `orden`;

UPDATE `xxbdo_tarjetas_status` 
SET `es_default` = '1' 
WHERE `xxbdo_tarjetas_status`.`id` = '4857a6dd-10ed-4a4a-90ea-e8722bb3a9a7'; 
