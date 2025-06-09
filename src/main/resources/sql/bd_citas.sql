-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 05-06-2025 a las 18:32:02
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `gestor_citas`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `citas`
--

CREATE TABLE `citas` (
  `id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` varchar(5) NOT NULL,
  `paciente_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'PENDIENTE',
  `motivo_cancelacion` text DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `citas`
--

INSERT INTO `citas` (`id`, `fecha`, `hora`, `paciente_id`, `doctor_id`, `estado`, `motivo_cancelacion`, `fecha_creacion`) VALUES
(3, '2025-05-27', '11:00', 3, 3, 'CONFIRMADA', NULL, '2025-06-05 13:30:11'),
(4, '2025-05-27', '15:00', 4, 4, 'PENDIENTE', NULL, '2025-06-05 13:30:11'),
(5, '2025-05-27', '16:00', 5, 5, 'CONFIRMADA', NULL, '2025-06-05 13:30:11'),
(6, '2025-05-27', '17:00', 6, 6, 'PENDIENTE', NULL, '2025-06-05 13:30:11'),
(7, '2025-05-28', '09:00', 7, 7, 'CONFIRMADA', NULL, '2025-06-05 13:30:11'),
(10, '2025-05-28', '15:00', 2, 2, 'CONFIRMADA', NULL, '2025-06-05 13:30:11'),
(11, '2025-05-28', '16:00', 3, 3, 'PENDIENTE', NULL, '2025-06-05 13:30:11'),
(12, '2025-05-28', '17:00', 4, 4, 'CONFIRMADA', NULL, '2025-06-05 13:30:11'),
(19, '2025-06-20', '12:40', 10, 4, 'PROGRAMADA', NULL, '2025-06-05 13:39:11'),
(20, '2025-06-23', '16:00', 6, 7, 'CANCELADA', 'no puede asistir', '2025-06-05 16:14:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `doctores`
--

CREATE TABLE `doctores` (
  `id` int(11) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `dni` varchar(100) NOT NULL,
  `telefono` varchar(9) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `especialidad_id` int(11) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `doctores`
--

INSERT INTO `doctores` (`id`, `nombres`, `apellidos`, `dni`, `telefono`, `email`, `especialidad_id`, `activo`) VALUES
(1, 'Juan Carlos', 'Pérez Rodríguez', '12345678', '987654321', 'dr.perez@clinica.com', 1, 1),
(2, 'María Elena', 'García Torres', '23456789', '987654322', 'dr.garcia@clinica.com', 2, 1),
(3, 'Carlos Alberto', 'López Mendoza', '34567890', '987654323', 'dr.lopez@clinica.com', 3, 1),
(4, 'Roberto José', 'Sánchez Vargas', '45678901', '987654324', 'dr.sanchez@clinica.com', 4, 1),
(5, 'Ana María', 'Martínez Ríos', '56789012', '987654325', 'dra.martinez@clinica.com', 5, 1),
(6, 'Luis Miguel', 'Torres Flores', '67890123', '987654326', 'dr.torres@clinica.com', 6, 1),
(7, 'Carmen Rosa', 'Vargas Díaz', '78901234', '987654327', 'dra.vargas@clinica.com', 7, 1),
(8, 'Pedro Antonio', 'Ramírez Soto', '89012345', '987654328', 'dr.ramirez@clinica.com', 8, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `especialidades`
--

CREATE TABLE `especialidades` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `especialidades`
--

INSERT INTO `especialidades` (`id`, `nombre`, `descripcion`) VALUES
(1, 'Medicina General', 'Atención primaria y general para adultos'),
(2, 'Pediatría', 'Atención médica especializada para niños y adolescentes'),
(3, 'Ginecología', 'Salud reproductiva femenina y atención prenatal'),
(4, 'Cardiología', 'Diagnóstico y tratamiento de enfermedades del corazón'),
(5, 'Dermatología', 'Tratamiento de enfermedades de la piel, cabello y uñas'),
(6, 'Oftalmología', 'Cuidado de la salud visual y ocular'),
(7, 'Ortopedia', 'Tratamiento de lesiones y enfermedades del sistema musculoesquelético'),
(8, 'Neurología', 'Diagnóstico y tratamiento de enfermedades del sistema nervioso');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `horarios`
--

CREATE TABLE `horarios` (
  `id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `dia_semana` varchar(10) NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pacientes`
--

CREATE TABLE `pacientes` (
  `id` int(11) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `dni` varchar(100) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `genero` varchar(1) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pacientes`
--

INSERT INTO `pacientes` (`id`, `nombres`, `apellidos`, `dni`, `fecha_nacimiento`, `genero`, `direccion`, `telefono`, `email`) VALUES
(2, 'María Isabel', 'Rodríguez García', '23456780', '1990-08-22', 'F', 'Calle Tacna 456, Lima', '987654330', 'maria.rodriguez@email.com'),
(3, 'Carlos Eduardo', 'MartÃ­nez gordoooo', '34567891', NULL, NULL, NULL, '987654331', 'carlos.martinez@email.com'),
(4, 'Ana Patricia', 'Sánchez Torres', '45678902', '1988-11-30', 'F', 'Av. La Marina 321, Lima', '987654332', 'ana.sanchez@email.com'),
(5, 'Roberto Carlos', 'Vargas Ramírez', '56789013', '1992-07-18', 'M', 'Calle Los Robles 654, Lima', '987654333', 'roberto.vargas@email.com'),
(6, 'Laura Beatriz', 'Torres Mendoza', '67890124', '1998-04-25', 'F', 'Av. Primavera 987, Lima', '987654334', 'laura.torres@email.com'),
(7, 'Miguel Ángel', 'Ramírez Soto', '78901235', '1983-09-12', 'M', 'Jr. Huancavelica 147, Lima', '987654335', 'miguel.ramirez@email.com'),
(10, 'Juan David', 'Ortiz', '1058353220', NULL, NULL, NULL, '3104780795', 'judaortizchico@gmail.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` varchar(20) NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `ultimo_acceso` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `username`, `password`, `rol`, `activo`, `fecha_creacion`, `ultimo_acceso`) VALUES
(1, 'admin', 'admin123', 'ADMIN', 1, '2025-05-27 20:21:21', '2025-06-05 13:01:05'),
(2, 'recepcionista', 'recepcionista123', 'RECEPCIONISTA', 1, '2025-05-27 20:21:21', NULL),
(3, 'dr.perez', 'dr.perez123', 'DOCTOR', 1, '2025-05-27 20:21:21', '2025-06-04 04:04:18'),
(4, 'dr.garcia', 'dr.garcia123', 'DOCTOR', 1, '2025-05-27 20:21:21', NULL),
(5, 'dr.lopez', 'dr.lopez123', 'DOCTOR', 1, '2025-05-27 20:21:21', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `citas`
--
ALTER TABLE `citas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `paciente_id` (`paciente_id`),
  ADD KEY `doctor_id` (`doctor_id`);

--
-- Indices de la tabla `doctores`
--
ALTER TABLE `doctores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD KEY `especialidad_id` (`especialidad_id`);

--
-- Indices de la tabla `especialidades`
--
ALTER TABLE `especialidades`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `horarios`
--
ALTER TABLE `horarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `doctor_id` (`doctor_id`);

--
-- Indices de la tabla `pacientes`
--
ALTER TABLE `pacientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `dni` (`dni`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `citas`
--
ALTER TABLE `citas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `doctores`
--
ALTER TABLE `doctores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `especialidades`
--
ALTER TABLE `especialidades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `horarios`
--
ALTER TABLE `horarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pacientes`
--
ALTER TABLE `pacientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `citas`
--
ALTER TABLE `citas`
  ADD CONSTRAINT `citas_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `pacientes` (`id`),
  ADD CONSTRAINT `citas_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctores` (`id`);

--
-- Filtros para la tabla `doctores`
--
ALTER TABLE `doctores`
  ADD CONSTRAINT `doctores_ibfk_1` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidades` (`id`);

--
-- Filtros para la tabla `horarios`
--
ALTER TABLE `horarios`
  ADD CONSTRAINT `horarios_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `doctores` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
