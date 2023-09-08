
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Base de datos: `xxbdo`
--
USE `xxbdo`;
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xxbdo_estandares_alertas`
--

CREATE TABLE `xxbdo_estandares_alertas` (
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
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `xxbdo_estandares_alertas`
--

INSERT INTO `xxbdo_estandares_alertas` (`id`, `xxbdo_estandares_id`, `minimo_fallas`, `es_consecutivo`, `orden`, `es_activa`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('08c832e6-fd71-43d7-9ae9-9d71b1c4eefd', '88622a43-736e-4bdc-87d2-08b0da8ad325', 3, 0, 3, 1, 1, NULL, NULL, NOW(), NOW()),
('13bba40f-6871-4ad3-a8b9-abb800d5838c', 'fc921750-4a86-4c65-a663-b3d9ac0fa155', 3, 0, 3, 1, 1, NULL, NULL, NOW(), NOW()),
('18f2bafa-8884-4d92-a30b-74125324f948', '942567f1-9891-4cf1-bdb9-eafb8339f0e3', 2, 1, 2, 1, 1, NULL, NULL, NOW(), NOW()),
('2f7af981-b06b-4d79-9f7e-7ab022bdfebf', '63dbc878-8105-40d6-8cb9-2acfddce1640', 1, 0, 1, 1, 1, NULL, NULL, NOW(), NOW()),
('4eabd459-c164-4af0-bfee-08d6db5cdc15', '7e0ae661-3de5-40af-9047-72e7f2481db7', 2, 1, 2, 1, 1, NULL, NULL, NOW(), NOW()),
('558d8974-9d23-4777-8a18-672cdda7c692', '6bcfaf2f-40a7-44bf-b554-d07c644196b9', 3, 0, 3, 1, 1, NULL, NULL, NOW(), NOW()),
('5a2fa358-dcae-43ca-a557-3703e863343a', 'f52971ec-e16e-46f7-a1fe-ced9410059b3', 3, 0, 3, 1, 1, NULL, NULL, NOW(), NOW()),
('736f8e3d-7841-4eef-becf-454581d66b79', '10f81bf8-ff1b-415e-8fda-c420f1dbf914', 2, 1, 2, 1, 1, NULL, NULL, NOW(), NOW()),
('767a4d47-da1a-49f8-a395-0e5e3fb5c973', 'b1b19ac7-b4b5-4d82-bd95-9d674f24de3d', 3, 0, 3, 1, 1, NULL, NULL, NOW(), NOW()),
('7e769e8f-1dc9-4b23-b192-ce97c6e8daaf', '5ae71d28-c4f9-4968-a3ce-c60908fc8bdf', 2, 1, 2, 1, 1, NULL, NULL, NOW(), NOW()),
('a49b3b66-d88d-448a-a0a4-5aa4f6c82fa5', '8fb4955e-688a-4e01-bbe4-872218262a1d', 3, 0, 3, 1, 1, NULL, NULL, NOW(), NOW()),
('a9177c5d-a8ec-44e4-9e62-52faa76beb5e', '139e7f1b-ca27-4000-96c2-3e5b4dda3c3e', 3, 0, 3, 1, 1, NULL, NULL, NOW(), NOW()),
('b7f3605c-8737-4754-a93d-c7a5adc94149', '152ce08f-b465-44f8-9560-32e09a67865f', 2, 1, 2, 1, 1, NULL, NULL, NOW(), NOW()),
('f534cb81-2513-428b-b018-c9dde9d783cb', '390d1816-4beb-4884-b156-10374f142e1b', 3, 0, 3, 1, 1, NULL, NULL, NOW(), NOW()),
('fec24c66-2e65-4d33-b1ea-efb58aae4766', 'ff0647e5-6b8a-4e64-83f6-90e986c90fee', 3, 0, 3, 1, 1, NULL, NULL, NOW(), NOW());

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `xxbdo_estandares_alertas`
--
ALTER TABLE `xxbdo_estandares_alertas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `XXBDO_ESTANDARES_ALERTAS_STDS_ID_UNQ` (`xxbdo_estandares_id`),
  ADD KEY `XXBDO_ESTANDARES_ALERTAS_STDS_ID_INDX` (`xxbdo_estandares_id`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `xxbdo_estandares_alertas`
--
ALTER TABLE `xxbdo_estandares_alertas`
  ADD CONSTRAINT `XXBDO_ESTANDARES_ALERTAS_STDS_ID_FK` FOREIGN KEY (`xxbdo_estandares_id`) REFERENCES `xxbdo_estandares` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
SET FOREIGN_KEY_CHECKS=1;
COMMIT;
