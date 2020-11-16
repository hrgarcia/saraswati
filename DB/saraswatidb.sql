-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-11-2020 a las 14:08:29
-- Versión del servidor: 10.4.11-MariaDB
-- Versión de PHP: 7.4.5

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
-- Estructura de tabla para la tabla `aprendizajes`
--

CREATE TABLE `aprendizajes` (
  `id` int(50) NOT NULL,
  `descripcion` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `id_materia` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `aprendizajes`
--

INSERT INTO `aprendizajes` (`id`, `descripcion`, `id_materia`) VALUES
(1, 'Manejo de EMMET', 1),
(2, 'Configuracion de entorno en ionic 4', 1),
(3, 'Configuracion de capacitor', 1),
(4, 'Manejo de Camara en capacitor', 1),
(5, 'Administrando contenidos con el sistema de grillas', 1),
(6, 'Utilización de tecnologías nativas con Capacitor', 1),
(7, 'Utilización de componentes de Ionic', 1);

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
('cuarto año'),
('primer año'),
('quinto año'),
('segundo año'),
('sexto año'),
('tercer año');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante`
--

CREATE TABLE `estudiante` (
  `dni` int(8) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `apellido` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `genero` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `fecha_nacimiento` varchar(55) COLLATE utf8_spanish_ci NOT NULL,
  `legajo` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `email` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `telefono` varchar(13) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion_curso` varchar(50) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `estudiante`
--

INSERT INTO `estudiante` (`dni`, `nombre`, `apellido`, `genero`, `fecha_nacimiento`, `legajo`, `email`, `telefono`, `descripcion_curso`) VALUES
(88887, 'kiara', 'berenjena', 'f', '13/12/2003', 'feesfes', 'kiara@gmail.com', '323232', 'sexto año'),
(323232, 'kaka', 'estebanez', 'm', '13/12/2003', 'fesfes', 'kaka@mail.com', '232323', 'sexto año'),
(434343, 'jade', 'yuta', 'f', '13/12/2003', 'kpok,p', 'jade@gmail.com', '0989898', 'sexto año'),
(654654, 'iara', 'lele', 'f', '13/12/2003', 'iojoi', 'iara@gmail.com', '8783728', 'sexto año'),
(999999, 'karol', 'GG', 'f', '13/12/2003', 'bddfr', 'karol@gmail.com', '3232', 'sexto año'),
(3453232, 'jere', 'lomo', 'm', '13/12/2003', 'frfr', 'jere@gmail.com', '3232', 'sexto año'),
(6726372, 'pepe', 'cuarto', 'm', '13/12/2003', 'fekoesps', 'pepe@gmail.com', '323232', 'sexto año'),
(13212311, 'marcos', 'piccotto', 'M', '0000-00-00', 'ñdakñsdk', 'marquitos@gmail.com', '1321241', 'sexto año'),
(31232132, 'juan', 'pereti', 'm', '2002-12-25', 'adwadw', 'juanp@gmail.com', '2323232', 'sexto año'),
(34455129, 'ramon', 'peruti', 'm', '13/12/2003', 'sdawda', 'ramon@gmail.com', '323232', 'sexto año'),
(44475315, 'German', 'Sampaolesi', 'M', '2002-12-25', 'dasjdakldl', 'sampaolesig@gmail.com', '132312312', 'sexto año');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudianteaprendizaje`
--

CREATE TABLE `estudianteaprendizaje` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `estado` varchar(13) COLLATE utf8mb4_spanish_ci NOT NULL,
  `estudiante_dni` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `estudianteaprendizaje`
--

INSERT INTO `estudianteaprendizaje` (`id`, `descripcion`, `estado`, `estudiante_dni`) VALUES
(1, 'Manejo de EMMET', 'pendiente', 44475315),
(2, 'Configuracion de entorno en ionic 4', 'pendiente', 44475315),
(3, 'Configuracion de capacitor', 'pendiente', 44475315),
(4, 'Manejo de Camara en capacitor', 'pendiente', 44475315),
(5, 'Administrando contenidos con el sistema de grillas', 'pendiente', 44475315),
(6, 'Utilización de tecnologías nativas con Capacitor 	', 'proceso', 44475315),
(7, 'Utilización de componentes de Ionic', 'aprobado', 44475315),
(8, 'Manejo de EMMET', 'aprobado', 654654),
(9, 'Configuracion de entorno en ionic 4', 'proceso', 654654);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materia`
--

CREATE TABLE `materia` (
  `id` int(11) NOT NULL,
  `nombreMateria` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `imagen` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `horasCatedra` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `profesor_usuario` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `curso_descripcion` varchar(50) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `materia`
--

INSERT INTO `materia` (`id`, `nombreMateria`, `imagen`, `horasCatedra`, `profesor_usuario`, `curso_descripcion`) VALUES
(1, 'programación 4', './images/espacios/sexto_año/programacion_4.jpg', '72', 'hrgarcia', 'sexto año'),
(2, 'fvt', '/public/images/estructura.jpg', '13', 'lmazzola', 'quinto año'),
(11, 'programacion 3', '/images/espacios/quinto_año/programacion_3.jpg', '65', 'hrgarcia', 'quinto año'),
(12, 'robotica', '/images/espacios/quinto_año/robotica.jpg', '32', 'hrgarcia', 'quinto año'),
(13, 'estructuras de almacenamiento de datos I', '/images/espacios/tercer_año/estructuras_de_almacenamiento_de_datos_I.jpg', '43', 'hrgarcia', 'tercer año'),
(14, 'programacion 1', '/images/espacios/tercer_año/programacion_1.jpg', '53', 'hrgarcia', 'tercer año'),
(17, 'estructuras y almacenamiento de datos II', '/images/espacios/cuarto_año/estructuras_y_almacenamiento_de_datos_II.jpg', '32', 'hrgarcia', 'cuarto año');

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
-- Indices de la tabla `aprendizajes`
--
ALTER TABLE `aprendizajes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_materia` (`id_materia`);

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
-- Indices de la tabla `estudianteaprendizaje`
--
ALTER TABLE `estudianteaprendizaje`
  ADD PRIMARY KEY (`id`),
  ADD KEY `estudiante_id` (`estudiante_dni`);

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
-- AUTO_INCREMENT de la tabla `aprendizajes`
--
ALTER TABLE `aprendizajes`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `estudianteaprendizaje`
--
ALTER TABLE `estudianteaprendizaje`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `materia`
--
ALTER TABLE `materia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `aprendizajes`
--
ALTER TABLE `aprendizajes`
  ADD CONSTRAINT `aprendizajes_ibfk_1` FOREIGN KEY (`id_materia`) REFERENCES `materia` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD CONSTRAINT `estudiante_ibfk_1` FOREIGN KEY (`descripcion_curso`) REFERENCES `curso` (`descripcion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `estudianteaprendizaje`
--
ALTER TABLE `estudianteaprendizaje`
  ADD CONSTRAINT `estudianteaprendizaje_ibfk_1` FOREIGN KEY (`estudiante_dni`) REFERENCES `estudiante` (`dni`) ON DELETE CASCADE ON UPDATE CASCADE;

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
