
ALTER TABLE `xxbdo_checklists` ADD `titulo_app` VARCHAR(100) NULL AFTER `descripcion`;

UPDATE `xxbdo_checklists` SET `titulo_app` = 'BITACORA v23' WHERE `xxbdo_checklists`.`id` = '3e50f58c-8634-41ce-93b5-c8bebb8bce46';
