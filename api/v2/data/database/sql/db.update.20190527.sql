-- queries para arreglar tienda 10HER/50JRJ

INSERT INTO `xxbdo_tiendas_has_areas_estandares` SELECT '10HER' AS plaza, '50JRJ' AS tienda,`xxbdo_checklists_id`, `xxbdo_areas_estandares_id`, `grupos_id`, `es_visible`, `activo`, `usuario`, `ip_address`, NOW(), NOW() FROM `xxbdo_tiendas_has_areas_estandares` WHERE `cr_plaza` LIKE '10HER' AND `cr_tienda` LIKE '50E5D' ;

insert into `xxbdo_tiendas_has_areas_estandares_indicadores` SELECT '10HER' as plaza, '50JRJ' as tienda, `xxbdo_checklists_id`, `xxbdo_areas_estandares_indicadores_id`, `es_visible`, `activo`, `usuario`, `ip_address`, NOW(), NOW() FROM `xxbdo_tiendas_has_areas_estandares_indicadores` WHERE `cr_plaza` LIKE '10HER' AND `cr_tienda` LIKE '50E5D' ;

