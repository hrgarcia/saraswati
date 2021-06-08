-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 04, 2021 at 06:03 PM
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
(88888881, 'kaka', 'estebanez', 'm', '13/12/2003', 'fwawdwa', 'kaka@gmail.com', '323232322', 'sexto año', 'kaestebanez'),
(88888882, 'zaramay', 'calles', 'm', '13/12/2003', 'dwadwa', 'zaramay@gmail.com', '3232323232', 'quinto año', 'zacalles'),
(88888883, 'ian', 'luciano', 'm', '13/12/2003', 'fwawdwa', 'luciano@gmail.com', '323232232', 'cuarto año', 'ianluciano'),
(88888888, 'kiara', 'berenjena', 'f', '13/12/2003', 'fwawdwa', 'kiara@gmail.com', '323232323', 'sexto año', 'kiberenjena');

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
(2, 'fvt', '/public/images/estructura.jpg', '13', 'lmazzola', 'quinto año'),
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
  `nota_definitiva` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `id_materia` int(11) NOT NULL,
  `id_periodo` int(11) NOT NULL,
  `descripcion_curso` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `dni_alumno` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

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
('hrgarcia', 'hector', 'garcia', '23146758', '3514467884', 'dreamallica@gmail.com', 'masculino', '23/09/2000', '07/03/2015', 'titular'),
('lmazzola', 'lucas', 'mazzola', '23232322', '3514467884', 'lucasmazz@gmail.com', 'masculino', '23/09/2000', '07/03/2015', 'titular');

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
(7, 'profesor', 'lmazzola');

-- --------------------------------------------------------

--
-- Table structure for table `tutor`
--

CREATE TABLE `tutor` (
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
  `avatar` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `usuario`
--

INSERT INTO `usuario` (`nombreUsuario`, `pass`, `avatar`) VALUES
('hrgarcia', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', 0),
('ianluciano', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', 0),
('kaestebanez', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', 0),
('kiberenjena', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', 0),
('lmazzola', '$2b$10$5wJpY.4Jlc3u7FHuqotgiuaWpDpoksvHY9EHmX6OY.66IlUoP6z5W', 0),
('zacalles', '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.', 0);

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
  ADD KEY `id_materia` (`id_materia`,`id_periodo`,`descripcion_curso`,`dni_alumno`),
  ADD KEY `id_periodo` (`id_periodo`),
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
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `estudianteaprendizaje`
--
ALTER TABLE `estudianteaprendizaje`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT for table `materia`
--
ALTER TABLE `materia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `nota`
--
ALTER TABLE `nota`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `periodo`
--
ALTER TABLE `periodo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `rol`
--
ALTER TABLE `rol`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

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
  ADD CONSTRAINT `nota_ibfk_1` FOREIGN KEY (`id_periodo`) REFERENCES `periodo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
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
