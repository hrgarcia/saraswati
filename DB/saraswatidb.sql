-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 05, 2021 at 05:00 AM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 7.3.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `saraswatidb`
--

-- --------------------------------------------------------

--
-- Table structure for table `aprendizajes`
--

CREATE TABLE `aprendizajes` (
  `id` int(50) NOT NULL,
  `descripcion` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `id_materia` int(50) NOT NULL,
  `id_periodo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `aprendizajes`
--

INSERT INTO `aprendizajes` (`id`, `descripcion`, `id_materia`, `id_periodo`) VALUES
(24, 'aprendizaje 1', 1, 1),
(25, 'aprendizaje 2', 1, 1),
(26, 'aprendizaje 3', 1, 1),
(27, 'aprendizaje 4', 1, 1),
(28, 'aprendizaje 5', 1, 1),
(29, 'aprendizaje 5', 1, 1),
(30, 'aprendizaje 6', 1, 1),
(31, 'aprendizaje 7', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `curso`
--

CREATE TABLE `curso` (
  `descripcion` varchar(50) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `curso`
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
-- Table structure for table `estudiante`
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
-- Dumping data for table `estudiante`
--

INSERT INTO `estudiante` (`dni`, `nombre`, `apellido`, `genero`, `fecha_nacimiento`, `legajo`, `email`, `telefono`, `descripcion_curso`, `nombreUsuario`) VALUES
(35311932, 'seven', 'monzon', 'm', '11/10/2002', '12312312', 'seven monzon', '3513327875', 'cuarto año', 'sevemonzon'),
(35311971, 'josue', 'lorenzo', 'm', '08/5/2003', '32132131', 'jouselorenzo@gmail.com', '3511597479', 'sexto año', 'jolorenzo'),
(35321158, 'amelia', 'nieto', 'f', '06/4/2003', '23232324', 'amelianieto@gmail.com', '3514327852', 'sexto año', 'amenieto'),
(35321871, 'lucina', 'romero', 'f', '13/12/2003', '32132131', 'lucinaromero@gmail.com', '3513507449', 'sexto año', 'luromero'),
(43215971, 'juan', 'gomis', 'm', '11/12/2002', '6544322', 'juangomis@gmail.com', '3513507875', 'sexto año', 'jugomis'),
(44785621, 'laia', 'quinteros', 'f', '11/10/2002', '987654', 'laiaquintero@gmail.com', '3511597423', 'sexto año', 'laiaquiros'),
(45215181, 'paola', 'albert', 'f', '13/12/2003', '2131232', 'paolalbert@gmail.com', '3514324762', 'cuarto año', 'paoalbert'),
(45215981, 'juan', 'torre', 'm', '02/1/2003', '567890', 'juantorre@gmail.com', '3513487665', 'sexto año', 'juantorre'),
(88888881, 'kaka', 'estebanez', 'm', '13/12/2003', 'fwawdwa', 'kaka@gmail.com', '323232322', 'sexto año', 'kaestebanez'),
(88888883, 'ian', 'luciano', 'm', '13/12/2003', 'fwawdwa', 'luciano@gmail.com', '323232232', 'cuarto año', 'ianluciano');

-- --------------------------------------------------------

--
-- Table structure for table `estudianteaprendizaje`
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
-- Dumping data for table `estudianteaprendizaje`
--

INSERT INTO `estudianteaprendizaje` (`id`, `descripcion`, `estado`, `estudiante_dni`, `periodo_id`, `materia_id`) VALUES
(103, 'aprendizaje 1', 'proceso', 35311971, 1, 1),
(104, 'aprendizaje 1', 'pendiente', 35321158, 1, 1),
(105, 'aprendizaje 1', 'pendiente', 35321871, 1, 1),
(106, 'aprendizaje 1', 'pendiente', 43215971, 1, 1),
(107, 'aprendizaje 1', 'pendiente', 44785621, 1, 1),
(108, 'aprendizaje 1', 'pendiente', 45215981, 1, 1),
(109, 'aprendizaje 1', 'pendiente', 88888881, 1, 1),
(110, 'aprendizaje 2', 'aprobado', 35311971, 1, 1),
(111, 'aprendizaje 2', 'pendiente', 35321158, 1, 1),
(112, 'aprendizaje 2', 'pendiente', 35321871, 1, 1),
(113, 'aprendizaje 2', 'pendiente', 43215971, 1, 1),
(114, 'aprendizaje 2', 'pendiente', 44785621, 1, 1),
(115, 'aprendizaje 2', 'pendiente', 45215981, 1, 1),
(116, 'aprendizaje 2', 'pendiente', 88888881, 1, 1),
(117, 'aprendizaje 3', 'aprobado', 35311971, 1, 1),
(118, 'aprendizaje 3', 'pendiente', 35321158, 1, 1),
(119, 'aprendizaje 3', 'pendiente', 35321871, 1, 1),
(120, 'aprendizaje 3', 'pendiente', 43215971, 1, 1),
(121, 'aprendizaje 3', 'pendiente', 44785621, 1, 1),
(122, 'aprendizaje 3', 'pendiente', 45215981, 1, 1),
(123, 'aprendizaje 3', 'pendiente', 88888881, 1, 1),
(124, 'aprendizaje 4', 'proceso', 35311971, 1, 1),
(125, 'aprendizaje 4', 'pendiente', 35321158, 1, 1),
(126, 'aprendizaje 4', 'pendiente', 35321871, 1, 1),
(127, 'aprendizaje 4', 'pendiente', 43215971, 1, 1),
(128, 'aprendizaje 4', 'pendiente', 44785621, 1, 1),
(129, 'aprendizaje 4', 'pendiente', 45215981, 1, 1),
(130, 'aprendizaje 4', 'pendiente', 88888881, 1, 1),
(131, 'aprendizaje 5', 'pendiente', 35311971, 1, 1),
(132, 'aprendizaje 5', 'pendiente', 35321158, 1, 1),
(133, 'aprendizaje 5', 'pendiente', 35321871, 1, 1),
(134, 'aprendizaje 5', 'pendiente', 43215971, 1, 1),
(135, 'aprendizaje 5', 'pendiente', 44785621, 1, 1),
(136, 'aprendizaje 5', 'pendiente', 45215981, 1, 1),
(137, 'aprendizaje 5', 'pendiente', 88888881, 1, 1),
(138, 'aprendizaje 5', 'pendiente', 35311971, 1, 1),
(139, 'aprendizaje 5', 'pendiente', 35321158, 1, 1),
(140, 'aprendizaje 5', 'pendiente', 35321871, 1, 1),
(141, 'aprendizaje 5', 'pendiente', 43215971, 1, 1),
(142, 'aprendizaje 5', 'pendiente', 44785621, 1, 1),
(143, 'aprendizaje 5', 'pendiente', 45215981, 1, 1),
(144, 'aprendizaje 5', 'pendiente', 88888881, 1, 1),
(145, 'aprendizaje 6', 'pendiente', 35311971, 1, 1),
(146, 'aprendizaje 6', 'pendiente', 35321158, 1, 1),
(147, 'aprendizaje 6', 'pendiente', 35321871, 1, 1),
(148, 'aprendizaje 6', 'pendiente', 43215971, 1, 1),
(149, 'aprendizaje 6', 'pendiente', 44785621, 1, 1),
(150, 'aprendizaje 6', 'pendiente', 45215981, 1, 1),
(151, 'aprendizaje 6', 'pendiente', 88888881, 1, 1),
(152, 'aprendizaje 7', 'pendiente', 35311971, 1, 1),
(153, 'aprendizaje 7', 'pendiente', 35321158, 1, 1),
(154, 'aprendizaje 7', 'pendiente', 35321871, 1, 1),
(155, 'aprendizaje 7', 'pendiente', 43215971, 1, 1),
(156, 'aprendizaje 7', 'pendiente', 44785621, 1, 1),
(157, 'aprendizaje 7', 'pendiente', 45215981, 1, 1),
(158, 'aprendizaje 7', 'pendiente', 88888881, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `frasesinspiradoras`
--

CREATE TABLE `frasesinspiradoras` (
  `id` int(11) NOT NULL,
  `frase` varchar(155) COLLATE utf8mb4_spanish_ci NOT NULL,
  `autor` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `frasesinspiradoras`
--

INSERT INTO `frasesinspiradoras` (`id`, `frase`, `autor`) VALUES
(1, 'El unico modo de hacer un buen trabajo es amar lo que haces', 'steve jobs'),
(2, 'El dinero no es la clave del éxito; la libertad para poder crear lo es', 'nelson mandela'),
(3, 'La inteligencia consiste no sólo en el conocimiento, sino también en la destreza de aplicar los conocimientos en la práctica', 'aristoteles'),
(4, 'El trabajo duro hace que desaparezcan las arrugas de la mente y el espíritu', 'helena rubinstein '),
(5, 'Cuéntamelo y me olvidaré. enséñamelo y lo recordaré. involúcrame y lo aprenderé', 'benjamin franklin'),
(6, 'Para tener éxito tu deseo de alcanzarlo debe ser mayor que tu miedo al fracaso', 'bill cosby'),
(7, 'sólo podemos ver poco del futuro, pero lo suficiete para darnos cuenta de que hay mucho que hacer', 'alan turing'),
(8, 'Hay hombres que de su ciencia tienen la cabeza llena; Hay sabios de todas menas, mas digo sin ser muy ducho. Es mejor que aprender mucho el aprender cosas ', 'julio cortazar'),
(9, 'La vida es tan corta y el oficio de vivir tan difícil, que cuando uno empieza a aprenderlo, ya hay que morirse', 'juan gelman');

-- --------------------------------------------------------

--
-- Table structure for table `materia`
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
-- Dumping data for table `materia`
--

INSERT INTO `materia` (`id`, `nombreMateria`, `imagen`, `horasCatedra`, `profesor_usuario`, `curso_descripcion`) VALUES
(1, 'programación 4', './images/espacios/sexto_año/programacion_4.jpg', '72', 'hrgarcia', 'sexto año'),
(2, 'fvt', '/public/images/estructura.jpg', '13', 'lmazzola', 'sexto año'),
(11, 'programacion 3', '/images/espacios/quinto_año/programacion_3.jpg', '65', 'hrgarcia', 'quinto año'),
(12, 'robotica', '/images/espacios/quinto_año/robotica.jpg', '32', 'hrgarcia', 'quinto año'),
(13, 'estructuras de almacenamiento de datos I', '/images/espacios/tercer_año/estructuras_de_almacenamiento_de_datos_I.jpg', '43', 'hrgarcia', 'tercer año'),
(14, 'programacion 1', '/images/espacios/tercer_año/programacion_1.jpg', '53', 'hrgarcia', 'tercer año'),
(17, 'estructuras y almacenamiento de datos II', '/images/espacios/cuarto_año/estructuras_y_almacenamiento_de_datos_II.jpg', '32', 'hrgarcia', 'cuarto año'),
(18, 'programacion 5', '/images/espacios/quinto_año/robotica.jpg', '32', 'hrgarcia', 'sexto año');

-- --------------------------------------------------------

--
-- Table structure for table `nota`
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
  `nota_definitiva` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `id_materia` int(11) NOT NULL,
  `descripcion_curso` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `dni_alumno` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `nota`
--

INSERT INTO `nota` (`id`, `nota1`, `nota2`, `nota3`, `nota4`, `nota5`, `nota6`, `nota7`, `nota8`, `nota_definitiva`, `id_materia`, `descripcion_curso`, `dni_alumno`) VALUES
(51, '6', '3', '8', '6', '1', '6', '8', '9', '10', 1, 'sexto año', 35321158),
(52, '9', '3', '4', '6', '0', '0', '0', '0', '0', 1, 'sexto año', 35321871),
(53, '6', '2', '3', '2', '6', '8', '9', '2', '0', 1, 'sexto año', 88888881),
(54, '10', '10', '10', '10', '10', '9', '8', '7', '10', 1, 'sexto año', 35311971);

-- --------------------------------------------------------

--
-- Table structure for table `periodo`
--

CREATE TABLE `periodo` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `periodo`
--

INSERT INTO `periodo` (`id`, `descripcion`) VALUES
(1, '1er cuatrimestre'),
(2, '2do cuatrimestre');

-- --------------------------------------------------------

--
-- Table structure for table `profesor`
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
-- Dumping data for table `profesor`
--

INSERT INTO `profesor` (`nombreUsuario`, `nombre`, `apellido`, `dni`, `telefono`, `email`, `genero`, `nacimiento`, `ingreso`, `estado`) VALUES
('hrgarcia', 'hector', 'garcia', '23146758', '3513506446', 'dreamallica@gmail.com', 'indefinide', '23/09/2000', '07/03/2015', 'titular'),
('lmazzola', 'lucas', 'mazzola', '23232322', '3514467892', 'lucasmazz@gmail.com', 'indefinido', '23/09/2000', '07/03/2015', 'titular');

-- --------------------------------------------------------

--
-- Table structure for table `rol`
--

CREATE TABLE `rol` (
  `id` int(50) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `nombreUsuario` varchar(50) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `rol`
--

INSERT INTO `rol` (`id`, `nombre`, `nombreUsuario`) VALUES
(5, 'preceptor', 'lmazzola'),
(6, 'profesor', 'hrgarcia'),
(7, 'profesor', 'lmazzola'),
(12, 'administrador', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `tutor`
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
-- Table structure for table `usuario`
--

CREATE TABLE `usuario` (
  `nombreUsuario` varchar(11) COLLATE utf8_spanish_ci NOT NULL,
  `pass` varchar(150) COLLATE utf8_spanish_ci NOT NULL,
  `avatar` varchar(155) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `usuario`
--

INSERT INTO `usuario` (`nombreUsuario`, `pass`, `avatar`) VALUES
('admin', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', '0'),
('amenieto', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', '0'),
('hrgarcia', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', 'avatar_hrgarcia.jpg'),
('ianluciano', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', '0'),
('jolorenzo', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', '0'),
('juantorre', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', '0'),
('jugomis', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', '0'),
('kaestebanez', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', '0'),
('laiaquiros', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', '0'),
('lmazzola', '$2b$10$5wJpY.4Jlc3u7FHuqotgiuaWpDpoksvHY9EHmX6OY.66IlUoP6z5W', '0'),
('luromero', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', '0'),
('paoalbert', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', '0'),
('sevemonzon', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', '0');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `aprendizajes`
--
ALTER TABLE `aprendizajes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_materia` (`id_materia`),
  ADD KEY `id_periodo` (`id_periodo`);

--
-- Indexes for table `curso`
--
ALTER TABLE `curso`
  ADD PRIMARY KEY (`descripcion`);

--
-- Indexes for table `estudiante`
--
ALTER TABLE `estudiante`
  ADD PRIMARY KEY (`dni`),
  ADD KEY `descripcion_curso` (`descripcion_curso`),
  ADD KEY `nombreUsuario` (`nombreUsuario`);

--
-- Indexes for table `estudianteaprendizaje`
--
ALTER TABLE `estudianteaprendizaje`
  ADD PRIMARY KEY (`id`),
  ADD KEY `estudiante_id` (`estudiante_dni`),
  ADD KEY `periodo_id` (`periodo_id`,`materia_id`),
  ADD KEY `materia_id` (`materia_id`);

--
-- Indexes for table `frasesinspiradoras`
--
ALTER TABLE `frasesinspiradoras`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `materia`
--
ALTER TABLE `materia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `profesor_usuario` (`profesor_usuario`),
  ADD KEY `curso_descripcion` (`curso_descripcion`);

--
-- Indexes for table `nota`
--
ALTER TABLE `nota`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_materia` (`id_materia`,`descripcion_curso`,`dni_alumno`),
  ADD KEY `dni_alumno` (`dni_alumno`),
  ADD KEY `descripcion_curso` (`descripcion_curso`);

--
-- Indexes for table `periodo`
--
ALTER TABLE `periodo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `profesor`
--
ALTER TABLE `profesor`
  ADD PRIMARY KEY (`nombreUsuario`);

--
-- Indexes for table `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nombre_usuario` (`nombreUsuario`);

--
-- Indexes for table `tutor`
--
ALTER TABLE `tutor`
  ADD PRIMARY KEY (`dni`),
  ADD KEY `estudiante_dni` (`estudiante_dni`);

--
-- Indexes for table `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`nombreUsuario`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `aprendizajes`
--
ALTER TABLE `aprendizajes`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `estudianteaprendizaje`
--
ALTER TABLE `estudianteaprendizaje`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=159;

--
-- AUTO_INCREMENT for table `frasesinspiradoras`
--
ALTER TABLE `frasesinspiradoras`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `materia`
--
ALTER TABLE `materia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `nota`
--
ALTER TABLE `nota`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `periodo`
--
ALTER TABLE `periodo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `rol`
--
ALTER TABLE `rol`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `aprendizajes`
--
ALTER TABLE `aprendizajes`
  ADD CONSTRAINT `aprendizajes_ibfk_1` FOREIGN KEY (`id_materia`) REFERENCES `materia` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `aprendizajes_ibfk_2` FOREIGN KEY (`id_periodo`) REFERENCES `periodo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `estudiante`
--
ALTER TABLE `estudiante`
  ADD CONSTRAINT `estudiante_ibfk_1` FOREIGN KEY (`descripcion_curso`) REFERENCES `curso` (`descripcion`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `estudiante_ibfk_2` FOREIGN KEY (`nombreUsuario`) REFERENCES `usuario` (`nombreUsuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `estudianteaprendizaje`
--
ALTER TABLE `estudianteaprendizaje`
  ADD CONSTRAINT `estudianteaprendizaje_ibfk_1` FOREIGN KEY (`estudiante_dni`) REFERENCES `estudiante` (`dni`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `estudianteaprendizaje_ibfk_2` FOREIGN KEY (`periodo_id`) REFERENCES `periodo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `estudianteaprendizaje_ibfk_3` FOREIGN KEY (`materia_id`) REFERENCES `materia` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `materia`
--
ALTER TABLE `materia`
  ADD CONSTRAINT `materia_ibfk_1` FOREIGN KEY (`profesor_usuario`) REFERENCES `profesor` (`nombreUsuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `materia_ibfk_2` FOREIGN KEY (`curso_descripcion`) REFERENCES `curso` (`descripcion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `nota`
--
ALTER TABLE `nota`
  ADD CONSTRAINT `nota_ibfk_2` FOREIGN KEY (`id_materia`) REFERENCES `materia` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `nota_ibfk_3` FOREIGN KEY (`dni_alumno`) REFERENCES `estudiante` (`dni`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `nota_ibfk_4` FOREIGN KEY (`descripcion_curso`) REFERENCES `curso` (`descripcion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `rol`
--
ALTER TABLE `rol`
  ADD CONSTRAINT `rol_ibfk_1` FOREIGN KEY (`nombreUsuario`) REFERENCES `usuario` (`nombreUsuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tutor`
--
ALTER TABLE `tutor`
  ADD CONSTRAINT `tutor_ibfk_1` FOREIGN KEY (`estudiante_dni`) REFERENCES `estudiante` (`dni`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
