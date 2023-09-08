
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

UPDATE `xxbdo_version_estandares` SET `activo` = '0' WHERE `xxbdo_version_estandares`.`id` = '59c3037c-ee96-4bdb-8125-bec8e1c819bc';

UPDATE `xxbdo_checklists` SET `titulo_app` = 'BITACORA v22', `activo` = '0' WHERE `xxbdo_checklists`.`id` = '980e98f6-8edb-4c03-87a7-53b286161cb4';

ALTER TABLE `xxbdo_checklists` 
ADD COLUMN `titulo_indicadores_app` 
VARCHAR(100) NULL 
DEFAULT NULL 
AFTER `titulo_app`;

UPDATE `xxbdo_checklists` 
SET `titulo_indicadores_app` = 'INDICADORES v23' 
WHERE `xxbdo_checklists`.`id` = '3e50f58c-8634-41ce-93b5-c8bebb8bce46';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
