

                                
                                --
                    -- Índices para tablas volcadas
                    --

                    --
                    -- Indices de la tabla `xxbdo_colores`
                    --
                    ALTER TABLE `xxbdo_colores`
                    ADD PRIMARY KEY (`id`),
                    ADD KEY `XXBDO_COLORES_CHECKLISTS_ID_INDX` (`xxbdo_checklists_id`);

                    --
                    -- Restricciones para tablas volcadas
                    --

                    --
                    -- Filtros para la tabla `xxbdo_colores`
                    --
                    ALTER TABLE `xxbdo_colores`
                    ADD CONSTRAINT `XXBDO_COLORES_CHECKLISTS_ID_FK` FOREIGN KEY (`xxbdo_checklists_id`) REFERENCES `xxbdo_checklists` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;


                    CREATE TABLE `xxbdo_colores` (
                    `id` varchar(36) NOT NULL,
                    `xxbdo_checklists_id` varchar(36) NOT NULL,
                    `nombre` varchar(50) NOT NULL,
                    `hexadecimal` varchar(12) NOT NULL,
                    `es_activo` tinyint(4) DEFAULT '1',
                    `orden` bigint(20) DEFAULT '0',
                    `activo` tinyint(4) DEFAULT NULL,
                    `usuario` varchar(100) DEFAULT NULL,
                    `ip_address` varchar(100) DEFAULT NULL,
                    `fecha_creacion` timestamp NULL DEFAULT NULL,
                    `fecha_modificacion` timestamp NULL DEFAULT NULL
                    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

                    --
                    -- Estructura de tabla para la tabla `xxbdo_estandares_alertas`
                    --

                    CREATE TABLE IF NOT EXISTS `xxbdo_estandares_alertas` (
                    `id` varchar(36) NOT NULL,
                    `xxbdo_estandares_id` varchar(36) NOT NULL,
                    `minimo_fallas` tinyint(4) DEFAULT NULL,
                    `es_consecutivo` tinyint(4) DEFAULT NULL,
                    `orden` tinyint(4) DEFAULT NULL,
                    `es_activa` tinyint(4) DEFAULT NULL,
                    `activo` tinyint(4) DEFAULT NULL,
                    `usuario` varchar(100) DEFAULT NULL,
                    `ip_address` varchar(64) DEFAULT NULL,
                    `fecha_creacion` timestamp NULL DEFAULT NULL,
                    `fecha_modificacion` timestamp NULL DEFAULT NULL,
                    PRIMARY KEY (`id`),
                    UNIQUE KEY `XXBDO_ESTANDARES_ALERTAS_STDS_ID_UNQ` (`xxbdo_estandares_id`),
                    KEY `XXBDO_ESTANDARES_ALERTAS_STDS_ID_INDX` (`xxbdo_estandares_id`)
                    );

                    --
                    -- Restricciones para tablas volcadas
                    --

                    --
                    -- Filtros para la tabla `xxbdo_estandares_alertas`
                    --
                    ALTER TABLE `xxbdo_estandares_alertas`
                    ADD CONSTRAINT `XXBDO_ESTANDARES_ALERTAS_STDS_ID_FK` FOREIGN KEY (`xxbdo_estandares_id`) REFERENCES `xxbdo_estandares` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
                    COMMIT;
                    -- query para clonar tabla estandares_alertas


                    --
                    -- Estructura de tabla para la tabla `xxbdo_colores`
                    --

                    CREATE TABLE IF NOT EXISTS `xxbdo_colores` (
                    `id` varchar(36) NOT NULL,
                    `xxbdo_checklists_id` varchar(36) NOT NULL,
                    `nombre` varchar(50) NOT NULL,
                    `hexadecimal` varchar(12) NOT NULL,
                    `es_activo` tinyint(4) DEFAULT '1',
                    `orden` bigint(20) DEFAULT '0',
                    `activo` tinyint(4) DEFAULT NULL,
                    `usuario` varchar(100) DEFAULT NULL,
                    `ip_address` varchar(100) DEFAULT NULL,
                    `fecha_creacion` timestamp NULL DEFAULT NULL,
                    `fecha_modificacion` timestamp NULL DEFAULT NULL,
                    PRIMARY KEY (`id`),
                    KEY `XXBDO_COLORES_CHECKLISTS_ID_INDX` (`xxbdo_checklists_id`)
                    ); 

                    --
                    -- Restricciones para tablas volcadas
                    --

                    --
                    -- Filtros para la tabla `xxbdo_colores`
                    --
                    ALTER TABLE `xxbdo_colores`
                    ADD CONSTRAINT `XXBDO_COLORES_CHECKLISTS_ID_FK` FOREIGN KEY (`xxbdo_checklists_id`) REFERENCES `xxbdo_checklists` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
                    COMMIT;


                    CREATE TABLE IF NOT EXISTS `xxbdo_evop_configuracion` (
                    `id` varchar(36) NOT NULL,
                    `xxbdo_checklists_id` varchar(36) NOT NULL,
                    `opcion` varchar(50) NOT NULL,
                    `minimo` int(11) NOT NULL DEFAULT '0',
                    `maximo` int(11) NOT NULL DEFAULT '0',
                    `xxbdo_colores_id` varchar(36) NOT NULL,
                    `es_activo` tinyint(4) DEFAULT '1',
                    `orden` bigint(20) DEFAULT '0',
                    `activo` tinyint(4) DEFAULT '1',
                    `usuario` varchar(100) DEFAULT NULL,
                    `ip_address` varchar(64) DEFAULT NULL,
                    `fecha_creacion` timestamp NULL DEFAULT NULL,
                    `fecha_modificacion` timestamp NULL DEFAULT NULL,
                    PRIMARY KEY (`id`),
                    KEY `XXBDO_EVOP_CNFG_COLORES_ID_INDX` (`xxbdo_colores_id`),
                    KEY `XXBDO_EVOP_CNFG_CHECKLISTS_ID_INDX` (`xxbdo_checklists_id`),
                    KEY `XXBDO_EVOP_CNFG_CNSLT_CTLG_INDX` (`xxbdo_checklists_id`,`opcion`,`es_activo`,`orden`,`activo`)
                    );

                    --
                    -- Restricciones para tablas volcadas
                    --

                    --
                    -- Filtros para la tabla `xxbdo_evop_configuracion`
                    --
                    ALTER TABLE `xxbdo_evop_configuracion`
                    ADD CONSTRAINT `XXBDO_EVOP_CNFG_COLORES_ID_FK` FOREIGN KEY (`xxbdo_colores_id`) REFERENCES `xxbdo_colores` (`id`);
                    COMMIT;




                    CREATE TABLE IF NOT EXISTS `xxbdo_evop_drivers` (
                    `id` varchar(36) NOT NULL,
                    `xxbdo_checklists_id` varchar(36) NOT NULL,
                    `nombre` varchar(100) NOT NULL,
                    `es_activo` tinyint(4) DEFAULT '1',
                    `orden` bigint(20) DEFAULT '0',
                    `activo` tinyint(4) DEFAULT '1',
                    `usuario` varchar(100) DEFAULT NULL,
                    `ip_address` varchar(64) DEFAULT NULL,
                    `fecha_creacion` timestamp NULL DEFAULT NULL,
                    `fecha_modificacion` timestamp NULL DEFAULT NULL,
                    PRIMARY KEY (`id`),
                    KEY `XXBDO_EVOP_DRIVERS_CHECKLISTS_ID_INDX` (`xxbdo_checklists_id`),
                    KEY `XXBDO_EVOP_DRIVERS_CNSLT_CTLG_INDX` (`xxbdo_checklists_id`,`es_activo`,`orden`,`activo`)
                    );

                    --
                    -- Restricciones para tablas volcadas
                    --

                    --
                    -- Filtros para la tabla `xxbdo_evop_drivers`
                    --
                    ALTER TABLE `xxbdo_evop_drivers`
                    ADD CONSTRAINT `XXBDO_EVOP_DRIVERS_CHECKLISTS_ID_FK` FOREIGN KEY (`xxbdo_checklists_id`) REFERENCES `xxbdo_checklists` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
                    COMMIT;




                    --
                    -- Estructura de tabla para la tabla `xxbdo_evop_ponderacion_estandares`
                    --

                    CREATE TABLE IF NOT EXISTS `xxbdo_evop_ponderacion_estandares` (
                    `id` varchar(36) NOT NULL,
                    `xxbdo_checklists_id` varchar(36) NOT NULL,
                    `xxbdo_estandares_id` varchar(36) NOT NULL,
                    `xxbdo_evop_drivers_id` varchar(36) NOT NULL,
                    `ponderacion` int(11) NOT NULL DEFAULT '0',
                    `es_activo` tinyint(4) DEFAULT '1',
                    `orden` bigint(20) DEFAULT '0',
                    `activo` tinyint(4) DEFAULT '1',
                    `usuario` varchar(100) DEFAULT NULL,
                    `ip_address` varchar(64) DEFAULT NULL,
                    `fecha_creacion` timestamp NULL DEFAULT NULL,
                    `fecha_modificacion` timestamp NULL DEFAULT NULL,
                    PRIMARY KEY (`id`),
                    KEY `XXBDO_EVOP_PE_DRIVERS_ID_INDX` (`xxbdo_evop_drivers_id`),
                    KEY `XXBDO_EVOP_PE_ESTANDARES_ID_INDX` (`xxbdo_estandares_id`),
                    KEY `XXBDO_EVOP_PE_CHKLISTS_ID_INDX` (`xxbdo_checklists_id`),
                    KEY `XXBDO_EVOP_PE_CNST_CTLG_INDEX` (`xxbdo_checklists_id`,`xxbdo_estandares_id`,`xxbdo_evop_drivers_id`,`es_activo`,`orden`,`activo`)
                    );

                    --
                    -- Restricciones para tablas volcadas
                    --

                    --
                    -- Filtros para la tabla `xxbdo_evop_ponderacion_estandares`
                    --
                    ALTER TABLE `xxbdo_evop_ponderacion_estandares`
                    ADD CONSTRAINT `XXBDO_EVOP_PE_CHKLISTS_ID_FK` FOREIGN KEY (`xxbdo_checklists_id`) REFERENCES `xxbdo_checklists` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
                    ADD CONSTRAINT `XXBDO_EVOP_PE_DRIVERS_ID_FK` FOREIGN KEY (`xxbdo_evop_drivers_id`) REFERENCES `xxbdo_evop_drivers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
                    ADD CONSTRAINT `XXBDO_EVOP_PE_ESTANDARES_ID_FK` FOREIGN KEY (`xxbdo_estandares_id`) REFERENCES `xxbdo_estandares` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
                    COMMIT;




                    --
                    -- Estructura de tabla para la tabla `xxbdo_evop_promedios_drivers`
                    --

                    CREATE TABLE IF NOT EXISTS `xxbdo_evop_promedios_drivers` (
                    `id` varchar(36) NOT NULL,
                    `xxbdo_checklists_id` varchar(36) NOT NULL,
                    `xxbdo_evop_drivers_id` varchar(36) NOT NULL,
                    `minimo` int(11) NOT NULL DEFAULT '0',
                    `maximo` int(11) NOT NULL DEFAULT '0',
                    `xxbdo_colores_id` varchar(36) NOT NULL,
                    `es_activo` tinyint(4) DEFAULT '1',
                    `orden` bigint(20) DEFAULT '0',
                    `activo` tinyint(4) DEFAULT '1',
                    `usuario` varchar(100) DEFAULT NULL,
                    `ip_address` varchar(64) DEFAULT NULL,
                    `fecha_creacion` timestamp NULL DEFAULT NULL,
                    `fecha_modificacion` timestamp NULL DEFAULT NULL,
                    PRIMARY KEY (`id`),
                    KEY `XXBDO_EVOP_PD_DRIVERS_ID_INDX` (`xxbdo_evop_drivers_id`),
                    KEY `XXBDO_EVOP_PD_COLORES_ID_INDX` (`xxbdo_colores_id`),
                    KEY `XXBDO_EVOP_PD_CHKLISTS_ID_INDX` (`xxbdo_checklists_id`),
                    KEY `XXBDO_EVOP_PD_CNSLT_CTLG_INDX` (`id`,`xxbdo_checklists_id`,`xxbdo_evop_drivers_id`,`minimo`,`maximo`)
                    );

                    --
                    -- Restricciones para tablas volcadas
                    --

                    --
                    -- Filtros para la tabla `xxbdo_evop_promedios_drivers`
                    --
                    ALTER TABLE `xxbdo_evop_promedios_drivers`
                    ADD CONSTRAINT `XXBDO_EVOP_PD_CHKLISTS_ID_FK` FOREIGN KEY (`xxbdo_checklists_id`) REFERENCES `xxbdo_checklists` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
                    ADD CONSTRAINT `XXBDO_EVOP_PD_COLORES_ID_FK` FOREIGN KEY (`xxbdo_colores_id`) REFERENCES `xxbdo_colores` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
                    ADD CONSTRAINT `XXBDO_EVOP_PD_DRIVERS_ID_FK` FOREIGN KEY (`xxbdo_evop_drivers_id`) REFERENCES `xxbdo_evop_drivers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
                    COMMIT;

