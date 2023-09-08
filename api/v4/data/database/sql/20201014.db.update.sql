-- Nueva categoría de ustensilios
INSERT INTO `xxbdo_utensilios_categorias` (`id`, `nombre`, `descripcion`, `tipo`, `orden`, `visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
('274996ff-5237-494f-808d-6676c05aa5b2', 'HABILITADORES SANITIZACION COVID-19', 'Habilitadores Sanitización COVID-19', 'U', '5', '1', '1', NULL, NULL, NOW(), NOW());

-- Nuevos utensilios dentro de categoría Covid-19
INSERT INTO `xxbdo_utensilios` (`id`, `xxbdo_utensilios_categorias_id`, `cr_plaza`, `cr_tienda`, `tipo`, `nombre`, `descripcion`, `uso`, `orden`, `seleccionable`, `foto`, `codigo`, `via_de_solicitud`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
('6d941f58-e673-4946-a6e9-3486730cbf90', '274996ff-5237-494f-808d-6676c05aa5b2', NULL, NULL, 'U', 'Cubrebocas', 'Cubrebocas (Todo el equipo de tienda)', '', '1', '1', '6e31d020-f379-4473-b881-7a075db51c28.PNG', '-', 'Solicitar a Asesor Tienda', '1', NULL, NULL, NOW(), NOW()),
('96a8a76f-6577-4810-9b6c-2de696051182', '274996ff-5237-494f-808d-6676c05aa5b2', NULL, NULL, 'U', 'Tapete Sanitizante', 'Tapete Sanitizante', '', '2', '1', '92dcae40-cdab-4db6-8546-06755fcdd1bb.PNG', '-', 'Solicitar a Asesor Tienda', '1', NULL, NULL, NOW(), NOW()),
('28120824-1d05-4304-a29c-bbd98099e837', '274996ff-5237-494f-808d-6676c05aa5b2', NULL, NULL, 'U', 'Termómetro', 'Termómetro', '', '3', '1', '3e401725-afc5-4fe1-971f-5764a36c289d.PNG', '-', 'Solicitar a Asesor Tienda', '1', NULL, NULL, NOW(), NOW()),
('6d33d214-d440-42ab-bb04-7daa658260c2', '274996ff-5237-494f-808d-6676c05aa5b2', NULL, NULL, 'U', 'Lentes Protectores', 'Lentes Protectores', '', '4', '1', '58ccee4a-02fe-435f-92ed-256503c7318b.PNG', '-', 'Solicitar a Asesor Tienda', '1', NULL, NULL, NOW(), NOW()),
('934cd6b7-fbb7-4907-a61d-fbc0927db3a2', '274996ff-5237-494f-808d-6676c05aa5b2', NULL, NULL, 'U', 'Careta', 'Careta', '', '5', '1', '25a9f3ef-22cd-491b-a310-fee5d6700c22.PNG', '-', 'Solicitar a Asesor Tienda', '1', NULL, NULL, NOW(), NOW()),
('16dddfc2-7103-4095-a131-c7b6da1c59b7', '274996ff-5237-494f-808d-6676c05aa5b2', NULL, NULL, 'U', 'Gel Antibacterial', 'Gel Antibacterial', '', '6', '1', 'cfc2fed0-eb21-495f-8fbc-5703869e600c.PNG', '-', 'Solicitar a Asesor Tienda', '1', NULL, NULL, NOW(), NOW());

-- Actualizar nombre de estándar 23
UPDATE `xxbdo_estandares` SET `titulo` = 'Rituales de Gestión / Evaluación' WHERE `xxbdo_estandares`.`id` = '9eef3935-d834-46d6-a30f-dd3a0dd7e5ec'; 

-- Borrar estándar 24
DELETE FROM `xxbdo_tiendas_has_areas_estandares` where xxbdo_areas_estandares_id IN ( SELECT id FROM `xxbdo_areas_estandares` where xxbdo_estandares_id IN ( SELECT id FROM `xxbdo_estandares` where xxbdo_version_estandares_id="b794eae6-25c5-4e01-a69b-4a0fc29b259b" and estandar="24" ) );

DELETE FROM `xxbdo_checklists_has_areas_estandares` where xxbdo_areas_estandares_id IN ( SELECT id FROM `xxbdo_areas_estandares` where xxbdo_estandares_id IN ( SELECT id FROM `xxbdo_estandares` where xxbdo_version_estandares_id="b794eae6-25c5-4e01-a69b-4a0fc29b259b" and estandar="24" ) );

DELETE FROM `xxbdo_observaciones` where xxbdo_respuestas_id IN ( SELECT id FROM `xxbdo_respuestas` where xxbdo_areas_estandares_id IN ( SELECT id FROM `xxbdo_areas_estandares` where xxbdo_estandares_id IN ( SELECT id FROM `xxbdo_estandares` where xxbdo_version_estandares_id="b794eae6-25c5-4e01-a69b-4a0fc29b259b" and estandar="24" ) ) ) ;

DELETE FROM `xxbdo_circulo_de_congruencia` where xxbdo_respuestas_id IN ( SELECT id FROM `xxbdo_respuestas` where xxbdo_areas_estandares_id IN ( SELECT id FROM `xxbdo_areas_estandares` where xxbdo_estandares_id IN ( SELECT id FROM `xxbdo_estandares` where xxbdo_version_estandares_id="b794eae6-25c5-4e01-a69b-4a0fc29b259b" and estandar="24" ) ) ) ;

DELETE FROM `xxbdo_respuestas` where xxbdo_areas_estandares_id IN ( SELECT id FROM `xxbdo_areas_estandares` where xxbdo_estandares_id IN ( SELECT id FROM `xxbdo_estandares` where xxbdo_version_estandares_id="b794eae6-25c5-4e01-a69b-4a0fc29b259b" and estandar="24" ) ) ;

DELETE FROM `xxbdo_areas_estandares` where xxbdo_estandares_id IN ( SELECT id FROM `xxbdo_estandares` where xxbdo_version_estandares_id="b794eae6-25c5-4e01-a69b-4a0fc29b259b" and estandar="24" );

DELETE FROM `xxbdo_estandares` where xxbdo_version_estandares_id="b794eae6-25c5-4e01-a69b-4a0fc29b259b" and estandar="24";
