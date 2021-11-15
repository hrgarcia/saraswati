-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 15-11-2021 a las 02:23:51
-- Versión del servidor: 10.4.21-MariaDB
-- Versión de PHP: 7.3.31

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
  `id_materia` int(50) NOT NULL,
  `id_periodo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `aprendizajes`
--

INSERT INTO `aprendizajes` (`id`, `descripcion`, `id_materia`, `id_periodo`) VALUES
(32, 'dwadaw', 1, 1),
(33, 'dwadawg', 1, 1),
(34, 'dawdawgfgr', 1, 1),
(35, 'dwadwad a', 1, 1);

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
  `descripcion_curso` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `nombreUsuario` varchar(155) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `estudiante`
--

INSERT INTO `estudiante` (`dni`, `nombre`, `apellido`, `genero`, `fecha_nacimiento`, `legajo`, `email`, `telefono`, `descripcion_curso`, `nombreUsuario`) VALUES
(4569047, 'maximo', 'orellano', 'masculino', '02/06/2003', '0110', 'agueroorellano@escuelasproa.edu.ar', '3564512295', 'sexto año', 'agueroorellano'),
(44580035, 'giuliana', 'heredia', 'femenino', '20/08/2003', '0091', 'gaheredia@escuelasproa.edu.ar', '3513416663', 'sexto año', 'gaheredia'),
(44872737, 'denis ', 'iturriza', 'masculino', '15/07/2003', '0092', 'dmiturriza@escuelasproa.edu.ar', '3517537836', 'sexto año', 'dmiturriza'),
(44897788, 'nahuel', 'petrocelli', 'masculino', '09/08/2003', '0101', 'npetrocelli@escuelasproa.edu.ar', '351279610', 'sexto año', 'npetrocelli'),
(44970733, 'lara', 'santillan', 'femenino', '11/08/2003', '0088', 'lsantillan@escuelasproa.edu.ar', '3512334340', 'sexto año', 'lsantillan'),
(45081861, 'fabrizio', 'meloni', 'masculino', '17/11/2003', '0096', 'fmeloni@escuelasproa.edu.ar', '35126323900', 'sexto año', 'fmeloni'),
(45081873, 'santiago', 'ortega', 'masculino', '18/11/2003', '0097', 'saortega@escuelasproa.edu.ar', '35164458', 'sexto año', 'saortega'),
(45083228, 'luciano', 'guzman', 'masculino', '22/11/2003', '0090', 'lguzman@escuelasproa.edu.ar', '3516519107', 'sexto año', 'lguzman'),
(45086251, 'francisco', 'reynoso', 'masculino', '20/10/2003', '0109', 'fnreynoso@escuelasproa.edu.ar', '3517673217', 'sexto año', 'fnreynoso'),
(45086525, 'sofia', 'diaz', 'femenino', '19/11/2003', '0087', 'sbdiaz@escuelasproa.edu.ar', '3517670894', 'sexto año', 'sbdiaz'),
(45154109, 'milena', 'juarez', 'femenino', '06/10/2003', '0093', 'majuarez@escuelasproa.edu.ar', '3517875449', 'sexto año', 'majuarez'),
(45488236, 'morena', 'martinez', 'femenino', '22/11/2003', '0088', 'mgalanmartinez@escuelasproa.edu.ar', '3512151744', 'sexto año', 'mgalanmartinez');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudianteaprendizaje`
--

CREATE TABLE `estudianteaprendizaje` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `estado` varchar(13) COLLATE utf8mb4_spanish_ci NOT NULL,
  `estudiante_dni` int(11) NOT NULL,
  `periodo_id` int(11) NOT NULL,
  `materia_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `estudianteaprendizaje`
--

INSERT INTO `estudianteaprendizaje` (`id`, `descripcion`, `estado`, `estudiante_dni`, `periodo_id`, `materia_id`) VALUES
(159, 'dwadaw', 'pendiente', 4569047, 1, 1),
(160, 'dwadaw', 'pendiente', 44580035, 1, 1),
(161, 'dwadaw', 'pendiente', 44872737, 1, 1),
(162, 'dwadaw', 'pendiente', 44897788, 1, 1),
(163, 'dwadaw', 'pendiente', 44970733, 1, 1),
(164, 'dwadaw', 'pendiente', 45081861, 1, 1),
(165, 'dwadaw', 'pendiente', 45081873, 1, 1),
(166, 'dwadaw', 'pendiente', 45083228, 1, 1),
(167, 'dwadaw', 'pendiente', 45086251, 1, 1),
(168, 'dwadaw', 'pendiente', 45086525, 1, 1),
(169, 'dwadaw', 'pendiente', 45154109, 1, 1),
(170, 'dwadaw', 'pendiente', 45488236, 1, 1),
(171, 'dwadawg', 'pendiente', 4569047, 1, 1),
(172, 'dwadawg', 'pendiente', 44580035, 1, 1),
(173, 'dwadawg', 'pendiente', 44872737, 1, 1),
(174, 'dwadawg', 'pendiente', 44897788, 1, 1),
(175, 'dwadawg', 'pendiente', 44970733, 1, 1),
(176, 'dwadawg', 'pendiente', 45081861, 1, 1),
(177, 'dwadawg', 'pendiente', 45081873, 1, 1),
(178, 'dwadawg', 'pendiente', 45083228, 1, 1),
(179, 'dwadawg', 'pendiente', 45086251, 1, 1),
(180, 'dwadawg', 'pendiente', 45086525, 1, 1),
(181, 'dwadawg', 'pendiente', 45154109, 1, 1),
(182, 'dwadawg', 'pendiente', 45488236, 1, 1),
(183, 'dawdawgfgr', 'pendiente', 4569047, 1, 1),
(184, 'dawdawgfgr', 'pendiente', 44580035, 1, 1),
(185, 'dawdawgfgr', 'pendiente', 44872737, 1, 1),
(186, 'dawdawgfgr', 'pendiente', 44897788, 1, 1),
(187, 'dawdawgfgr', 'pendiente', 44970733, 1, 1),
(188, 'dawdawgfgr', 'pendiente', 45081861, 1, 1),
(189, 'dawdawgfgr', 'pendiente', 45081873, 1, 1),
(190, 'dawdawgfgr', 'pendiente', 45083228, 1, 1),
(191, 'dawdawgfgr', 'pendiente', 45086251, 1, 1),
(192, 'dawdawgfgr', 'pendiente', 45086525, 1, 1),
(193, 'dawdawgfgr', 'pendiente', 45154109, 1, 1),
(194, 'dawdawgfgr', 'pendiente', 45488236, 1, 1),
(195, 'dwadwad a', 'pendiente', 4569047, 1, 1),
(196, 'dwadwad a', 'pendiente', 44580035, 1, 1),
(197, 'dwadwad a', 'pendiente', 44872737, 1, 1),
(198, 'dwadwad a', 'pendiente', 44897788, 1, 1),
(199, 'dwadwad a', 'pendiente', 44970733, 1, 1),
(200, 'dwadwad a', 'pendiente', 45081861, 1, 1),
(201, 'dwadwad a', 'pendiente', 45081873, 1, 1),
(202, 'dwadwad a', 'pendiente', 45083228, 1, 1),
(203, 'dwadwad a', 'pendiente', 45086251, 1, 1),
(204, 'dwadwad a', 'pendiente', 45086525, 1, 1),
(205, 'dwadwad a', 'pendiente', 45154109, 1, 1),
(206, 'dwadwad a', 'pendiente', 45488236, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historialaprendizajes`
--

CREATE TABLE `historialaprendizajes` (
  `dni_estudiante` varchar(11) COLLATE utf8mb4_spanish_ci NOT NULL,
  `descripcion` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL,
  `estado` varchar(20) COLLATE utf8mb4_spanish_ci NOT NULL,
  `materia` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `añoLectivo` varchar(15) COLLATE utf8mb4_spanish_ci NOT NULL,
  `id_periodo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `historialaprendizajes`
--

INSERT INTO `historialaprendizajes` (`dni_estudiante`, `descripcion`, `estado`, `materia`, `añoLectivo`, `id_periodo`) VALUES
('44897788', 'variables', 'pendiente', 'programacion 4', '2021', 1),
('44897788', 'unity', 'pendiente', 'programacion 4', '2021', 1),
('44897788', 'unity 3d', 'pendiente', 'programacion 4', '2021', 2),
('44897788', 'funciones recursivas', 'pendiente', 'programacion 4', '2020', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historialmaterias`
--

CREATE TABLE `historialmaterias` (
  `dni_estudiante` int(11) NOT NULL,
  `usuario` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL,
  `notaDefinitiva` int(11) NOT NULL,
  `añoLectivo` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL,
  `id_materia` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `historialmaterias`
--

INSERT INTO `historialmaterias` (`dni_estudiante`, `usuario`, `notaDefinitiva`, `añoLectivo`, `id_materia`) VALUES
(44897788, 'npetrocelli\r\n', 3, '2021', 1),
(44897788, 'npetrocelli', 8, '2020', 1);

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
(1, 'programacion 4', 'sexto_año/programacion_4.jpg', '72', 'hrgarcia', 'sexto año'),
(2, 'fvt', 'sexto_año/formacion_para_la_vida_y_el_trabajo.jpg', '13', 'lmazzola', 'sexto año'),
(11, 'programacion 3', 'quinto_año/programacion_3.jpg', '65', 'hrgarcia', 'quinto año'),
(12, 'robotica', 'quinto_año/robotica.jpg', '32', 'hrgarcia', 'quinto año'),
(13, 'estructuras de almacenamiento de datos I', 'tercer_año/estructuras_de_almacenamiento_de_datos_I.jpg', '43', 'hrgarcia', 'tercer año'),
(14, 'programacion 1', 'tercer_año/programacion_1.jpg', '53', 'hrgarcia', 'tercer año'),
(17, 'estructuras y almacenamiento de datos II', 'cuarto_año/estructuras_y_almacenamiento_de_datos_II.jpg', '32', 'hrgarcia', 'cuarto año'),
(18, 'programacion 5', 'quinto_año/robotica.jpg', '32', 'profeX', 'sexto año'),
(19, 'ciudadania y participacion', 'cuarto_año/ciudadania y participacion.jpg', '12', 'profeX', 'cuarto año'),
(20, 'filosofia', '', '23', 'profeX', 'sexto año'),
(21, 'club de ciencias', '', '25', 'profeX', 'sexto año '),
(22, 'ciudadania y politica', '', '33', 'lbassioviedo', 'sexto año'),
(23, 'testing', '', '29', 'profeX', 'sexto año'),
(24, 'desarrollo de aplicaciones moviles', 'sexto_año/desarrollo_de_aplicaciones_moviles.jpg', '80', 'profeX', 'sexto año'),
(25, 'teatro', '', '12', 'profeX', 'sexto año'),
(26, 'ingles', '', '22', 'profeX', 'sexto año'),
(27, 'lengua y literatura', '', '29', 'profeX', 'sexto año'),
(29, 'formacion para la vida y el trabajo', 'quinto_año/formacion_para_la_vida_y_el_trabajo.jpg', '11', 'lmazzola', 'quinto año'),
(30, 'quimica', '', '15', 'profeX', 'sexto año'),
(31, 'educacion fisica', '', '29', 'profeX', 'sexto año'),
(32, 'club de arte', '', '17', 'profeX', 'sexto año'),
(33, 'club de deportes', '', '8', 'profeX', 'sexto año'),
(34, 'matematica', '', '13', 'profeX', 'sexto año');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nota`
--

CREATE TABLE `nota` (
  `id` int(11) NOT NULL,
  `nota1` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nota2` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nota3` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nota4` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nota5` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nota6` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nota7` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nota8` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nota_definitiva1` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nota_definitiva2` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `id_materia` int(11) NOT NULL,
  `descripcion_curso` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `dni_alumno` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `nota`
--

INSERT INTO `nota` (`id`, `nota1`, `nota2`, `nota3`, `nota4`, `nota5`, `nota6`, `nota7`, `nota8`, `nota_definitiva1`, `nota_definitiva2`, `id_materia`, `descripcion_curso`, `dni_alumno`) VALUES
(2, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 1, 'sexto año', 44897788),
(3, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 2, 'sexto año', 44897788),
(4, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 11, 'sexto año', 44897788),
(5, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 12, 'sexto año', 44897788),
(6, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 13, 'sexto año', 44897788),
(7, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 14, 'sexto año', 44897788),
(8, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 1, 'sexto año', 44970733),
(9, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 2, 'sexto año', 44970733),
(10, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 11, 'sexto año', 44970733),
(11, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 12, 'sexto año', 44970733),
(12, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 1, 'sexto año', 45081861),
(13, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 2, 'sexto año', 45081861),
(14, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 11, 'sexto año', 45081861),
(15, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 12, 'sexto año', 45081861),
(16, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 1, 'sexto año', 45081873),
(17, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 1, 'sexto año', 45083228),
(18, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 1, 'sexto año ', 45086525),
(19, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 1, 'sexto año ', 45154109),
(20, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 1, 'sexto año ', 45488236),
(21, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 1, 'sexto año ', 44872737),
(22, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 1, 'sexto año', 45086251),
(23, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 1, 'sexto año', 44580035),
(24, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 1, 'sexto año', 4569047);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `id` int(50) NOT NULL,
  `titulo` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `fechaEvento` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `fechaLanzamiento` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `tags` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `notificaciones`
--

INSERT INTO `notificaciones` (`id`, `titulo`, `fechaEvento`, `fechaLanzamiento`, `tags`) VALUES
(4, 'dia del niño', '04-10-2021', '2021-10-22', 'celebracion ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `periodo`
--

CREATE TABLE `periodo` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `periodo`
--

INSERT INTO `periodo` (`id`, `descripcion`) VALUES
(1, '1er cuatrimestre'),
(2, '2do cuatrimestre');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `previas`
--

CREATE TABLE `previas` (
  `dni_estudiante` varchar(155) COLLATE utf8mb4_spanish_ci NOT NULL,
  `usuario` varchar(155) COLLATE utf8mb4_spanish_ci NOT NULL,
  `materia` varchar(155) COLLATE utf8mb4_spanish_ci NOT NULL,
  `añoLectivo` varchar(155) COLLATE utf8mb4_spanish_ci NOT NULL,
  `id_materia` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `previas`
--

INSERT INTO `previas` (`dni_estudiante`, `usuario`, `materia`, `añoLectivo`, `id_materia`) VALUES
('44897788', 'npetrocelli', 'programación 4', '2021', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesor`
--

CREATE TABLE `profesor` (
  `nombreUsuario` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
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

INSERT INTO `profesor` (`nombreUsuario`, `nombre`, `apellido`, `dni`, `telefono`, `email`, `genero`, `nacimiento`, `ingreso`, `estado`) VALUES
('amaekawa', 'alejandra', 'maekawa', '30180378', '3512145992', 'amaekawa@escuelasproa.edu.ar', 'femenino', '21/09/1983', '01/04/2014', 'interino'),
('cmendoza', 'camila', 'mendoza', '38594413', '3513871092', 'cmendoza@escuelasproa.edu.ar', 'femenino', '09/04/1995', '01/05/1995', 'interino'),
('dpezzelato', 'daiana', 'pezzelato', '37594703', '3512544303', 'dpezzelato@escuelasproa.edu.ar', 'femenino', '28/04/1993', '04/09/2017', 'interino'),
('flopez', 'florencia', 'lopez', '36604775', '3517036468', 'flopez@escuelasproa.edu.ar', 'femenino', '25/10/1992', '01/05/2016', 'interino'),
('hrgarcia', 'hector', 'garcia', '30883670', '3518151953', 'dreamallica@gmail.com', 'masculino', '30/03/1984', '11/8/2014', 'interino'),
('lacordoba', 'antonella', 'cordoba', '40681016', '3543604045', 'lacordoba@escuelasproa.edu.ar', 'femenino', '26/01/1998', '01/08/2021', 'interino'),
('larasant', 'lara', 'santillan', '12245621', '03512334340', 'larasanti03@hotmail.com', 'femenino', '2021-11-19', '2021-11-23', 'titular'),
('lbassioviedo', 'lucia', 'bassi', '34768104', '3517328429', 'lbassioviedo@escuelasproa.edu.ar', 'femenino', '28/08/1989', '10/03/15', 'interino'),
('lmazzola', 'lucas', 'mazzola', '23232322', '3514467892', 'lucasmazz@gmail.com', 'indefinido', '23/09/2000', '07/03/2015', 'titular'),
('mifernandez', 'micaela', 'fernandez', '33359198', '3585097806', 'mifernandez@escuelasproa.edu.ar', 'femenino', '17/12/1987', '01/07/2018', 'interino'),
('pmartinez', 'patricia', 'martinez', '18397471', '3516568721', 'pmartinez@escuelasproa.edu.ar', 'femenino', '27/11/1967', '01/05/2016', 'interino'),
('profediego', 'diego', 'santillan', '12245621', '03512334340', 'diego03@hotmail.com', 'masculino', '2021-11-25', '2021-11-18', 'titular');

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
(1, 'profesor', 'asd'),
(5, 'preceptor', 'lmazzola'),
(6, 'profesor', 'hrgarcia'),
(7, 'profesor', 'lmazzola'),
(12, 'administrador', 'admin'),
(13, 'profesor', 'profediego'),
(14, 'profesor', 'larasant');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tutor`
--

CREATE TABLE `tutor` (
  `dni` int(8) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `apellido` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `telefono` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `celular` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `email` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `estudiante_dni` int(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `nombreUsuario` varchar(20) COLLATE utf8_spanish_ci NOT NULL,
  `pass` varchar(150) COLLATE utf8_spanish_ci NOT NULL,
  `avatar` varchar(155) COLLATE utf8_spanish_ci NOT NULL,
  `contraseña_cambiada` varchar(50) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`nombreUsuario`, `pass`, `avatar`, `contraseña_cambiada`) VALUES
('admin', '$2b$10$fvHSEyookLoc0IYKLjoLXuq0Xt5jMMMeiILHHYb4MaUHArV1PqZdy', '0', 'true'),
('agueroorellano', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('amaekawa', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('dmiturriza', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('dpezzelato', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('feizenberg', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('flopez', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('fmeloni', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('fnreynoso', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('gaheredia', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO\n\n', '', ''),
('gmavalo', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('hrgarcia', '$2b$10$cKAmCISSlauwz6VXCnqD.O1YGz8ZpspSCg1cahnDKD8.EdbTu8S8.', 'avatar_hrgarcia.jpg', 'true'),
('lacordoba', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('laltamirano', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('larasant', '$2b$10$3jF/FFXx6luh/FgHfltGbOlwuG6EcElsLaYYU6lWDcTZlNRvG3Pe2', '0', '0'),
('lbassioviedo', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('lmazzola', '$2b$10$TvFydFnH7Ut4z9wlP218vOIV.jtKPDhtsRQmD9i2fyEQmdxWWTphK', '0', 'true'),
('lsantillan', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('majuarez', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('mezarate', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('mgalanmartinez', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('mgiannone', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('mifernandez', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('npetrocelli', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('pmartinez', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('profediego', '$2b$10$4AwX0YvF4krbvGzK4Y.Z8eSYa2e6As920VvMQXaYTOMRuOmwnqG/a', '0', '0'),
('saortega', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', ''),
('sbdiaz', '$2b$10$jd5J24SKYWTiH9kWslXOtea69mdctYjAGPKvZOF5sRLEbJODJMPkO', '', '');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `aprendizajes`
--
ALTER TABLE `aprendizajes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_materia` (`id_materia`),
  ADD KEY `id_periodo` (`id_periodo`);

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
  ADD KEY `descripcion_curso` (`descripcion_curso`),
  ADD KEY `nombreUsuario` (`nombreUsuario`);

--
-- Indices de la tabla `estudianteaprendizaje`
--
ALTER TABLE `estudianteaprendizaje`
  ADD PRIMARY KEY (`id`),
  ADD KEY `estudiante_id` (`estudiante_dni`),
  ADD KEY `periodo_id` (`periodo_id`,`materia_id`),
  ADD KEY `materia_id` (`materia_id`);

--
-- Indices de la tabla `materia`
--
ALTER TABLE `materia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `profesor_usuario` (`profesor_usuario`),
  ADD KEY `curso_descripcion` (`curso_descripcion`);

--
-- Indices de la tabla `nota`
--
ALTER TABLE `nota`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_materia` (`id_materia`,`descripcion_curso`,`dni_alumno`),
  ADD KEY `dni_alumno` (`dni_alumno`),
  ADD KEY `descripcion_curso` (`descripcion_curso`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `periodo`
--
ALTER TABLE `periodo`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `profesor`
--
ALTER TABLE `profesor`
  ADD PRIMARY KEY (`nombreUsuario`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nombre_usuario` (`nombreUsuario`);

--
-- Indices de la tabla `tutor`
--
ALTER TABLE `tutor`
  ADD PRIMARY KEY (`dni`),
  ADD KEY `estudiante_dni` (`estudiante_dni`);

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
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT de la tabla `estudianteaprendizaje`
--
ALTER TABLE `estudianteaprendizaje`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=207;

--
-- AUTO_INCREMENT de la tabla `materia`
--
ALTER TABLE `materia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT de la tabla `nota`
--
ALTER TABLE `nota`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
