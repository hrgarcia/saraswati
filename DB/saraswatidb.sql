-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 10-09-2020 a las 22:45:48
-- Versión del servidor: 10.4.14-MariaDB
-- Versión de PHP: 7.4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `saraswatidb`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `curso`
--

CREATE TABLE `curso` (
  `descripcion` varchar(50) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `curso`
--

INSERT INTO `curso` (`descripcion`) VALUES
('aprendiendo a programar'),
('formacion para la vida y el trabajo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante`
--

CREATE TABLE `estudiante` (
  `dni` int(8) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `apellido` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `genero` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `legajo` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `email` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `telefono` int(10) NOT NULL,
  `descripcion_curso` varchar(50) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materia`
--

CREATE TABLE `materia` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `imagen` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `horasCatedra` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `profesor_usuario` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `curso_descripcion` varchar(50) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `materia`
--

INSERT INTO `materia` (`id`, `nombre`, `imagen`, `horasCatedra`, `profesor_usuario`, `curso_descripcion`) VALUES
(1, 'programación 1', '0', '72', 'hrgarcia', 'aprendiendo a programar'),
(2, 'fvt', '0', '13', 'lmazzola', 'formacion para la vida y el trabajo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesor`
--

CREATE TABLE `profesor` (
  `usuario` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `apellido` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `dni` varchar(8) COLLATE utf8_spanish_ci NOT NULL,
  `telefono` varchar(40) COLLATE utf8_spanish_ci NOT NULL,
  `email` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `genero` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `nacimiento` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `ingreso` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `estado` varchar(50) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `profesor`
--

INSERT INTO `profesor` (`usuario`, `nombre`, `apellido`, `dni`, `telefono`, `email`, `genero`, `nacimiento`, `ingreso`, `estado`) VALUES
('hrgarcia', 'hector', 'garcia', '23146758', '3514467884', 'dreamallica@gmail.com', 'masculino', '23/09/2000', '07/03/2015', 'titular'),
('lmazzola', 'lucas', 'mazzola', '23232322', '3514467884', 'lucasmazz@gmail.com', 'masculino', '23/09/2000', '07/03/2015', 'titular');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id` int(50) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `nombreUsuario` varchar(50) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id`, `nombre`, `nombreUsuario`) VALUES
(5, 'preceptor', 'lmazzola'),
(6, 'profesor', 'hrgarcia'),
(7, 'profesor', 'lmazzola');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `nombreUsuario` varchar(11) COLLATE utf8_spanish_ci NOT NULL,
  `pass` varchar(150) COLLATE utf8_spanish_ci NOT NULL,
  `avatar` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`nombreUsuario`, `pass`, `avatar`) VALUES
('hrgarcia', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', 0),
('lmazzola', '$2b$10$5wJpY.4Jlc3u7FHuqotgiuaWpDpoksvHY9EHmX6OY.66IlUoP6z5W', 0);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `curso`
--
ALTER TABLE `curso`
  ADD PRIMARY KEY (`descripcion`);

--
-- Indices de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD PRIMARY KEY (`dni`),
  ADD KEY `descripcion_curso` (`descripcion_curso`);

--
-- Indices de la tabla `materia`
--
ALTER TABLE `materia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `profesor_usuario` (`profesor_usuario`),
  ADD KEY `curso_descripcion` (`curso_descripcion`);

--
-- Indices de la tabla `profesor`
--
ALTER TABLE `profesor`
  ADD PRIMARY KEY (`usuario`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nombre_usuario` (`nombreUsuario`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`nombreUsuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `materia`
--
ALTER TABLE `materia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD CONSTRAINT `estudiante_ibfk_1` FOREIGN KEY (`descripcion_curso`) REFERENCES `curso` (`descripcion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `materia`
--
ALTER TABLE `materia`
  ADD CONSTRAINT `materia_ibfk_1` FOREIGN KEY (`profesor_usuario`) REFERENCES `profesor` (`usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `materia_ibfk_2` FOREIGN KEY (`curso_descripcion`) REFERENCES `curso` (`descripcion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `rol`
--
ALTER TABLE `rol`
  ADD CONSTRAINT `rol_ibfk_1` FOREIGN KEY (`nombreUsuario`) REFERENCES `usuario` (`nombreUsuario`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
