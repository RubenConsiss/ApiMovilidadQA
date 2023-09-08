
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

UPDATE `xxbdo_version_estandares` 
SET `activo` = '0' 
WHERE `xxbdo_version_estandares`.`id` = '59c3037c-ee96-4bdb-8125-bec8e1c819bc';

UPDATE `xxbdo_checklists` 
SET `activo` = '0' 
WHERE `xxbdo_checklists`.`id` = '980e98f6-8edb-4c03-87a7-53b286161cb4';

UPDATE `xxbdo_checklists` 
SET `titulo_app` = 'BITACORA v22', 
`activo` = '0' 
WHERE `xxbdo_checklists`.`id` = '980e98f6-8edb-4c03-87a7-53b286161cb4';

ALTER TABLE `xxbdo_checklists` 
ADD COLUMN `titulo_indicadores_app` 
VARCHAR(100) NULL 
DEFAULT NULL 
AFTER `titulo_app`;

UPDATE `xxbdo_checklists` 
SET `titulo_indicadores_app` = 'INDICADORES v23' 
WHERE `xxbdo_checklists`.`id` = '3e50f58c-8634-41ce-93b5-c8bebb8bce46';

ALTER TABLE `xxbdo_version_estandares` 
ADD COLUMN `titulo_app` 
VARCHAR(100) NULL 
DEFAULT NULL 
AFTER `titulo`;

UPDATE `xxbdo_version_estandares` 
SET `titulo_app` = 'Versión 23' 
WHERE `xxbdo_version_estandares`.`id` = '13d772fa-826b-424f-802e-63da4777e33c'; 

UPDATE `xxbdo_version_estandares` 
SET `titulo_app` = 'Versión 24' 
WHERE `xxbdo_version_estandares`.`id` = 'c817b538-1b4d-4901-9181-f89aaeb15171';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
