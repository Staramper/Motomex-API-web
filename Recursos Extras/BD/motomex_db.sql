-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Servidor: db:3306
-- Tiempo de generación: 03-06-2026 a las 17:50:46
-- Versión del servidor: 8.0.45
-- Versión de PHP: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `motomex_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `leads`
--

CREATE TABLE `leads` (
  `id` int NOT NULL,
  `nombre` varchar(150) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `estado` varchar(100) DEFAULT NULL,
  `producto_interes` varchar(200) DEFAULT NULL,
  `vehiculo` varchar(100) DEFAULT NULL,
  `anio_vehiculo` varchar(20) DEFAULT NULL,
  `direccion_envio` text,
  `lead_completo` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `leads`
--

INSERT INTO `leads` (`id`, `nombre`, `ciudad`, `estado`, `producto_interes`, `vehiculo`, `anio_vehiculo`, `direccion_envio`, `lead_completo`, `created_at`) VALUES
(1, 'Eduardo Garza', 'Guanajuato', 'Guanajuato', 'Bomba de agua GMB GWH-780', 'Nissan Tsuru', '2018', 'calle Osorio #289, barrio de Codex, Guanajuato', 1, '2026-06-02 17:45:48'),
(2, 'Edgar Venoz', 'Puebla', 'Puebla', 'Amortiguador delantero Monroe M-3245', 'Honda CR-V', '2017', 'Ocampo #243, Barrio Blanco, 65784, casa cafe', 1, '2026-06-03 04:49:05');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int NOT NULL,
  `marca` varchar(100) NOT NULL,
  `modelo` varchar(100) NOT NULL,
  `categoria` varchar(100) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `moneda` varchar(10) DEFAULT 'MXN',
  `ciudad` varchar(100) NOT NULL,
  `estado` varchar(100) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `compatibilidad_general` json DEFAULT NULL,
  `especificaciones` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `marca`, `modelo`, `categoria`, `precio`, `moneda`, `ciudad`, `estado`, `stock`, `compatibilidad_general`, `especificaciones`, `created_at`, `updated_at`) VALUES
(1, 'LTH', 'L-47-650', 'batería automotriz', 2450.00, 'MXN', 'Monterrey', 'Nuevo León', 8, '[\"Nissan Versa\", \"Chevrolet Aveo\", \"Volkswagen Jetta\"]', '{\"voltaje\": \"12V\", \"capacidad\": \"650 amperes de arranque en frío\", \"recomendacion\": \"vehículos compactos y sedanes medianos\", \"nota_compatibilidad\": \"validar el año y versión del vehículo antes de confirmar la venta\"}', '2026-06-02 16:59:58', '2026-06-02 16:59:58'),
(2, 'Bosch', 'BP-1290', 'balatas delanteras', 780.00, 'MXN', 'Guadalajara', 'Jalisco', 15, '[\"Nissan Sentra\", \"Renault Fluence\", \"Nissan Tiida\"]', '{\"material\": \"cerámico de baja generación de ruido\", \"diseño_para\": \"vehículos tipo sedán de uso urbano\", \"recomendacion\": \"conducción diaria en ciudad\"}', '2026-06-02 16:59:58', '2026-06-02 16:59:58'),
(3, 'Monroe', 'M-3245', 'amortiguador', 1350.00, 'MXN', 'Puebla', 'Puebla', 6, '[\"Honda CR-V\", \"Toyota RAV4\", \"Mazda CX-5\"]', '{\"recomendacion\": \"SUVs compactas\", \"tipo_refaccion\": \"suspensión delantera\", \"nota_compatibilidad\": \"dependiendo del año y versión del vehículo\"}', '2026-06-02 16:59:58', '2026-06-02 16:59:58'),
(4, 'Fram', 'PH-6607', 'filtro de aceite', 185.00, 'MXN', 'Ciudad de México', 'Ciudad de México', 42, '[\"Toyota Corolla\", \"Honda Civic\", \"Nissan Sentra\"]', '{\"tipo_mantenimiento\": \"preventivo\", \"motores_compatibles\": \"4 cilindros de cilindrada mediana\", \"nota_compatibilidad\": \"de distintas generaciones\"}', '2026-06-02 16:59:58', '2026-06-02 16:59:58'),
(5, 'Gates', 'T-186', 'banda de distribución', 620.00, 'MXN', 'Querétaro', 'Querétaro', 11, '[\"Volkswagen Polo\", \"Seat Ibiza\", \"Chevrolet Aveo\"]', '{\"componente_sistema\": \"distribución del motor\", \"motores_compatibles\": \"versiones con motor de 1.6 litros\"}', '2026-06-02 16:59:58', '2026-06-02 16:59:58'),
(6, 'GMB', 'GWH-780', 'bomba de agua', 950.00, 'MXN', 'León', 'Guanajuato', 5, '[\"Nissan Tsuru\", \"Nissan Sentra B13\", \"Nissan Platina\"]', '{\"componente_sistema\": \"refrigeración del motor\", \"motores_compatibles\": \"motor GA16\"}', '2026-06-02 16:59:58', '2026-06-02 16:59:58');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `leads`
--
ALTER TABLE `leads`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `modelo` (`modelo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `leads`
--
ALTER TABLE `leads`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
