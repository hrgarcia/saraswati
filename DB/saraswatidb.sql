/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: aprendizajes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `aprendizajes` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `id_materia` int(50) NOT NULL,
  `id_periodo` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_materia` (`id_materia`),
  KEY `id_periodo` (`id_periodo`),
  CONSTRAINT `aprendizajes_ibfk_1` FOREIGN KEY (`id_materia`) REFERENCES `materia` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `aprendizajes_ibfk_2` FOREIGN KEY (`id_periodo`) REFERENCES `periodo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 32 DEFAULT CHARSET = utf8 COLLATE = utf8_spanish_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: curso
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `curso` (
  `descripcion` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`descripcion`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_spanish_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: estudiante
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `estudiante` (
  `dni` int(8) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `apellido` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `genero` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `fecha_nacimiento` varchar(55) COLLATE utf8_spanish_ci NOT NULL,
  `legajo` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `email` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `telefono` varchar(13) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion_curso` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `nombreUsuario` varchar(155) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`dni`),
  KEY `descripcion_curso` (`descripcion_curso`),
  KEY `nombreUsuario` (`nombreUsuario`),
  CONSTRAINT `estudiante_ibfk_1` FOREIGN KEY (`descripcion_curso`) REFERENCES `curso` (`descripcion`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `estudiante_ibfk_2` FOREIGN KEY (`nombreUsuario`) REFERENCES `usuario` (`nombreUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_spanish_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: estudianteaprendizaje
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `estudianteaprendizaje` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `estado` varchar(13) COLLATE utf8mb4_spanish_ci NOT NULL,
  `estudiante_dni` int(11) NOT NULL,
  `periodo_id` int(11) NOT NULL,
  `materia_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `estudiante_id` (`estudiante_dni`),
  KEY `periodo_id` (`periodo_id`, `materia_id`),
  KEY `materia_id` (`materia_id`),
  CONSTRAINT `estudianteaprendizaje_ibfk_1` FOREIGN KEY (`estudiante_dni`) REFERENCES `estudiante` (`dni`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `estudianteaprendizaje_ibfk_2` FOREIGN KEY (`periodo_id`) REFERENCES `periodo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `estudianteaprendizaje_ibfk_3` FOREIGN KEY (`materia_id`) REFERENCES `materia` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 159 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: materia
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `materia` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombreMateria` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `imagen` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `horasCatedra` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `profesor_usuario` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `curso_descripcion` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profesor_usuario` (`profesor_usuario`),
  KEY `curso_descripcion` (`curso_descripcion`),
  CONSTRAINT `materia_ibfk_1` FOREIGN KEY (`profesor_usuario`) REFERENCES `profesor` (`nombreUsuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `materia_ibfk_2` FOREIGN KEY (`curso_descripcion`) REFERENCES `curso` (`descripcion`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 19 DEFAULT CHARSET = utf8 COLLATE = utf8_spanish_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: nota
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `nota` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nota1` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nota2` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nota3` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nota4` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nota_definitiva` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `id_materia` int(11) NOT NULL,
  `id_periodo` int(11) NOT NULL,
  `descripcion_curso` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `dni_alumno` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_materia` (
  `id_materia`,
  `id_periodo`,
  `descripcion_curso`,
  `dni_alumno`
  ),
  KEY `id_periodo` (`id_periodo`),
  KEY `dni_alumno` (`dni_alumno`),
  KEY `descripcion_curso` (`descripcion_curso`),
  CONSTRAINT `nota_ibfk_1` FOREIGN KEY (`id_periodo`) REFERENCES `periodo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `nota_ibfk_2` FOREIGN KEY (`id_materia`) REFERENCES `materia` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `nota_ibfk_3` FOREIGN KEY (`dni_alumno`) REFERENCES `estudiante` (`dni`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `nota_ibfk_4` FOREIGN KEY (`descripcion_curso`) REFERENCES `curso` (`descripcion`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 40 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: periodo
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `periodo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: profesor
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `profesor` (
  `nombreUsuario` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `apellido` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `dni` varchar(8) COLLATE utf8_spanish_ci NOT NULL,
  `telefono` varchar(40) COLLATE utf8_spanish_ci NOT NULL,
  `email` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `genero` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `nacimiento` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `ingreso` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `estado` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`nombreUsuario`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_spanish_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: rol
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `rol` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `nombreUsuario` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nombre_usuario` (`nombreUsuario`),
  CONSTRAINT `rol_ibfk_1` FOREIGN KEY (`nombreUsuario`) REFERENCES `usuario` (`nombreUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 13 DEFAULT CHARSET = utf8 COLLATE = utf8_spanish_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: tutor
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `tutor` (
  `dni` int(8) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `apellido` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `telefono` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `celular` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `email` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `estudiante_dni` int(8) NOT NULL,
  PRIMARY KEY (`dni`),
  KEY `estudiante_dni` (`estudiante_dni`),
  CONSTRAINT `tutor_ibfk_1` FOREIGN KEY (`estudiante_dni`) REFERENCES `estudiante` (`dni`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_spanish_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: usuario
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `usuario` (
  `nombreUsuario` varchar(11) COLLATE utf8_spanish_ci NOT NULL,
  `pass` varchar(150) COLLATE utf8_spanish_ci NOT NULL,
  `avatar` int(11) NOT NULL,
  PRIMARY KEY (`nombreUsuario`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_spanish_ci;

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: aprendizajes
# ------------------------------------------------------------

INSERT INTO
  `aprendizajes` (`id`, `descripcion`, `id_materia`, `id_periodo`)
VALUES
  (24, 'aprendizaje 1', 1, 1);
INSERT INTO
  `aprendizajes` (`id`, `descripcion`, `id_materia`, `id_periodo`)
VALUES
  (25, 'aprendizaje 2', 1, 1);
INSERT INTO
  `aprendizajes` (`id`, `descripcion`, `id_materia`, `id_periodo`)
VALUES
  (26, 'aprendizaje 3', 1, 1);
INSERT INTO
  `aprendizajes` (`id`, `descripcion`, `id_materia`, `id_periodo`)
VALUES
  (27, 'aprendizaje 4', 1, 1);
INSERT INTO
  `aprendizajes` (`id`, `descripcion`, `id_materia`, `id_periodo`)
VALUES
  (28, 'aprendizaje 5', 1, 1);
INSERT INTO
  `aprendizajes` (`id`, `descripcion`, `id_materia`, `id_periodo`)
VALUES
  (29, 'aprendizaje 5', 1, 1);
INSERT INTO
  `aprendizajes` (`id`, `descripcion`, `id_materia`, `id_periodo`)
VALUES
  (30, 'aprendizaje 6', 1, 1);
INSERT INTO
  `aprendizajes` (`id`, `descripcion`, `id_materia`, `id_periodo`)
VALUES
  (31, 'aprendizaje 7', 1, 1);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: curso
# ------------------------------------------------------------

INSERT INTO
  `curso` (`descripcion`)
VALUES
  ('cuarto año');
INSERT INTO
  `curso` (`descripcion`)
VALUES
  ('primer año');
INSERT INTO
  `curso` (`descripcion`)
VALUES
  ('quinto año');
INSERT INTO
  `curso` (`descripcion`)
VALUES
  ('segundo año');
INSERT INTO
  `curso` (`descripcion`)
VALUES
  ('sexto año');
INSERT INTO
  `curso` (`descripcion`)
VALUES
  ('tercer año');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: estudiante
# ------------------------------------------------------------

INSERT INTO
  `estudiante` (
    `dni`,
    `nombre`,
    `apellido`,
    `genero`,
    `fecha_nacimiento`,
    `legajo`,
    `email`,
    `telefono`,
    `descripcion_curso`,
    `nombreUsuario`
  )
VALUES
  (
    35311932,
    'seven',
    'monzon',
    'm',
    '11/10/2002',
    '12312312',
    'seven monzon',
    '3513327875',
    'cuarto año',
    'sevemonzon'
  );
INSERT INTO
  `estudiante` (
    `dni`,
    `nombre`,
    `apellido`,
    `genero`,
    `fecha_nacimiento`,
    `legajo`,
    `email`,
    `telefono`,
    `descripcion_curso`,
    `nombreUsuario`
  )
VALUES
  (
    35311971,
    'josue',
    'lorenzo',
    'm',
    '08/5/2003',
    '32132131',
    'jouselorenzo@gmail.com',
    '3511597479',
    'sexto año',
    'jolorenzo'
  );
INSERT INTO
  `estudiante` (
    `dni`,
    `nombre`,
    `apellido`,
    `genero`,
    `fecha_nacimiento`,
    `legajo`,
    `email`,
    `telefono`,
    `descripcion_curso`,
    `nombreUsuario`
  )
VALUES
  (
    35321158,
    'amelia',
    'nieto',
    'f',
    '06/4/2003',
    '23232324',
    'amelianieto@gmail.com',
    '3514327852',
    'sexto año',
    'amenieto'
  );
INSERT INTO
  `estudiante` (
    `dni`,
    `nombre`,
    `apellido`,
    `genero`,
    `fecha_nacimiento`,
    `legajo`,
    `email`,
    `telefono`,
    `descripcion_curso`,
    `nombreUsuario`
  )
VALUES
  (
    35321871,
    'lucina',
    'romero',
    'f',
    '13/12/2003',
    '32132131',
    'lucinaromero@gmail.com',
    '3513507449',
    'sexto año',
    'luromero'
  );
INSERT INTO
  `estudiante` (
    `dni`,
    `nombre`,
    `apellido`,
    `genero`,
    `fecha_nacimiento`,
    `legajo`,
    `email`,
    `telefono`,
    `descripcion_curso`,
    `nombreUsuario`
  )
VALUES
  (
    43215971,
    'juan',
    'gomis',
    'm',
    '11/12/2002',
    '6544322',
    'juangomis@gmail.com',
    '3513507875',
    'sexto año',
    'jugomis'
  );
INSERT INTO
  `estudiante` (
    `dni`,
    `nombre`,
    `apellido`,
    `genero`,
    `fecha_nacimiento`,
    `legajo`,
    `email`,
    `telefono`,
    `descripcion_curso`,
    `nombreUsuario`
  )
VALUES
  (
    44785621,
    'laia',
    'quinteros',
    'f',
    '11/10/2002',
    '987654',
    'laiaquintero@gmail.com',
    '3511597423',
    'sexto año',
    'laiaquiros'
  );
INSERT INTO
  `estudiante` (
    `dni`,
    `nombre`,
    `apellido`,
    `genero`,
    `fecha_nacimiento`,
    `legajo`,
    `email`,
    `telefono`,
    `descripcion_curso`,
    `nombreUsuario`
  )
VALUES
  (
    45215181,
    'paola',
    'albert',
    'f',
    '13/12/2003',
    '2131232',
    'paolalbert@gmail.com',
    '3514324762',
    'cuarto año',
    'paoalbert'
  );
INSERT INTO
  `estudiante` (
    `dni`,
    `nombre`,
    `apellido`,
    `genero`,
    `fecha_nacimiento`,
    `legajo`,
    `email`,
    `telefono`,
    `descripcion_curso`,
    `nombreUsuario`
  )
VALUES
  (
    45215981,
    'juan',
    'torre',
    'm',
    '02/1/2003',
    '567890',
    'juantorre@gmail.com',
    '3513487665',
    'sexto año',
    'juantorre'
  );
INSERT INTO
  `estudiante` (
    `dni`,
    `nombre`,
    `apellido`,
    `genero`,
    `fecha_nacimiento`,
    `legajo`,
    `email`,
    `telefono`,
    `descripcion_curso`,
    `nombreUsuario`
  )
VALUES
  (
    88888881,
    'kaka',
    'estebanez',
    'm',
    '13/12/2003',
    'fwawdwa',
    'kaka@gmail.com',
    '323232322',
    'sexto año',
    'kaestebanez'
  );
INSERT INTO
  `estudiante` (
    `dni`,
    `nombre`,
    `apellido`,
    `genero`,
    `fecha_nacimiento`,
    `legajo`,
    `email`,
    `telefono`,
    `descripcion_curso`,
    `nombreUsuario`
  )
VALUES
  (
    88888883,
    'ian',
    'luciano',
    'm',
    '13/12/2003',
    'fwawdwa',
    'luciano@gmail.com',
    '323232232',
    'cuarto año',
    'ianluciano'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: estudianteaprendizaje
# ------------------------------------------------------------

INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (103, 'aprendizaje 1', 'proceso', 35311971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (104, 'aprendizaje 1', 'pendiente', 35321158, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (105, 'aprendizaje 1', 'pendiente', 35321871, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (106, 'aprendizaje 1', 'pendiente', 43215971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (107, 'aprendizaje 1', 'pendiente', 44785621, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (108, 'aprendizaje 1', 'pendiente', 45215981, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (109, 'aprendizaje 1', 'pendiente', 88888881, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (110, 'aprendizaje 2', 'aprobado', 35311971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (111, 'aprendizaje 2', 'pendiente', 35321158, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (112, 'aprendizaje 2', 'pendiente', 35321871, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (113, 'aprendizaje 2', 'pendiente', 43215971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (114, 'aprendizaje 2', 'pendiente', 44785621, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (115, 'aprendizaje 2', 'pendiente', 45215981, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (116, 'aprendizaje 2', 'pendiente', 88888881, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (117, 'aprendizaje 3', 'aprobado', 35311971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (118, 'aprendizaje 3', 'pendiente', 35321158, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (119, 'aprendizaje 3', 'pendiente', 35321871, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (120, 'aprendizaje 3', 'pendiente', 43215971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (121, 'aprendizaje 3', 'pendiente', 44785621, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (122, 'aprendizaje 3', 'pendiente', 45215981, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (123, 'aprendizaje 3', 'pendiente', 88888881, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (124, 'aprendizaje 4', 'proceso', 35311971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (125, 'aprendizaje 4', 'pendiente', 35321158, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (126, 'aprendizaje 4', 'pendiente', 35321871, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (127, 'aprendizaje 4', 'pendiente', 43215971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (128, 'aprendizaje 4', 'pendiente', 44785621, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (129, 'aprendizaje 4', 'pendiente', 45215981, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (130, 'aprendizaje 4', 'pendiente', 88888881, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (131, 'aprendizaje 5', 'pendiente', 35311971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (132, 'aprendizaje 5', 'pendiente', 35321158, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (133, 'aprendizaje 5', 'pendiente', 35321871, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (134, 'aprendizaje 5', 'pendiente', 43215971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (135, 'aprendizaje 5', 'pendiente', 44785621, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (136, 'aprendizaje 5', 'pendiente', 45215981, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (137, 'aprendizaje 5', 'pendiente', 88888881, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (138, 'aprendizaje 5', 'pendiente', 35311971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (139, 'aprendizaje 5', 'pendiente', 35321158, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (140, 'aprendizaje 5', 'pendiente', 35321871, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (141, 'aprendizaje 5', 'pendiente', 43215971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (142, 'aprendizaje 5', 'pendiente', 44785621, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (143, 'aprendizaje 5', 'pendiente', 45215981, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (144, 'aprendizaje 5', 'pendiente', 88888881, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (145, 'aprendizaje 6', 'pendiente', 35311971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (146, 'aprendizaje 6', 'pendiente', 35321158, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (147, 'aprendizaje 6', 'pendiente', 35321871, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (148, 'aprendizaje 6', 'pendiente', 43215971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (149, 'aprendizaje 6', 'pendiente', 44785621, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (150, 'aprendizaje 6', 'pendiente', 45215981, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (151, 'aprendizaje 6', 'pendiente', 88888881, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (152, 'aprendizaje 7', 'pendiente', 35311971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (153, 'aprendizaje 7', 'pendiente', 35321158, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (154, 'aprendizaje 7', 'pendiente', 35321871, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (155, 'aprendizaje 7', 'pendiente', 43215971, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (156, 'aprendizaje 7', 'pendiente', 44785621, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (157, 'aprendizaje 7', 'pendiente', 45215981, 1, 1);
INSERT INTO
  `estudianteaprendizaje` (
    `id`,
    `descripcion`,
    `estado`,
    `estudiante_dni`,
    `periodo_id`,
    `materia_id`
  )
VALUES
  (158, 'aprendizaje 7', 'pendiente', 88888881, 1, 1);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: materia
# ------------------------------------------------------------

INSERT INTO
  `materia` (
    `id`,
    `nombreMateria`,
    `imagen`,
    `horasCatedra`,
    `profesor_usuario`,
    `curso_descripcion`
  )
VALUES
  (
    1,
    'programación 4',
    './images/espacios/sexto_año/programacion_4.jpg',
    '72',
    'hrgarcia',
    'sexto año'
  );
INSERT INTO
  `materia` (
    `id`,
    `nombreMateria`,
    `imagen`,
    `horasCatedra`,
    `profesor_usuario`,
    `curso_descripcion`
  )
VALUES
  (
    2,
    'fvt',
    '/public/images/estructura.jpg',
    '13',
    'lmazzola',
    'sexto año'
  );
INSERT INTO
  `materia` (
    `id`,
    `nombreMateria`,
    `imagen`,
    `horasCatedra`,
    `profesor_usuario`,
    `curso_descripcion`
  )
VALUES
  (
    11,
    'programacion 3',
    '/images/espacios/quinto_año/programacion_3.jpg',
    '65',
    'hrgarcia',
    'quinto año'
  );
INSERT INTO
  `materia` (
    `id`,
    `nombreMateria`,
    `imagen`,
    `horasCatedra`,
    `profesor_usuario`,
    `curso_descripcion`
  )
VALUES
  (
    12,
    'robotica',
    '/images/espacios/quinto_año/robotica.jpg',
    '32',
    'hrgarcia',
    'quinto año'
  );
INSERT INTO
  `materia` (
    `id`,
    `nombreMateria`,
    `imagen`,
    `horasCatedra`,
    `profesor_usuario`,
    `curso_descripcion`
  )
VALUES
  (
    13,
    'estructuras de almacenamiento de datos I',
    '/images/espacios/tercer_año/estructuras_de_almacenamiento_de_datos_I.jpg',
    '43',
    'hrgarcia',
    'tercer año'
  );
INSERT INTO
  `materia` (
    `id`,
    `nombreMateria`,
    `imagen`,
    `horasCatedra`,
    `profesor_usuario`,
    `curso_descripcion`
  )
VALUES
  (
    14,
    'programacion 1',
    '/images/espacios/tercer_año/programacion_1.jpg',
    '53',
    'hrgarcia',
    'tercer año'
  );
INSERT INTO
  `materia` (
    `id`,
    `nombreMateria`,
    `imagen`,
    `horasCatedra`,
    `profesor_usuario`,
    `curso_descripcion`
  )
VALUES
  (
    17,
    'estructuras y almacenamiento de datos II',
    '/images/espacios/cuarto_año/estructuras_y_almacenamiento_de_datos_II.jpg',
    '32',
    'hrgarcia',
    'cuarto año'
  );
INSERT INTO
  `materia` (
    `id`,
    `nombreMateria`,
    `imagen`,
    `horasCatedra`,
    `profesor_usuario`,
    `curso_descripcion`
  )
VALUES
  (
    18,
    'programacion 5',
    '/images/espacios/quinto_año/robotica.jpg',
    '32',
    'hrgarcia',
    'sexto año'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: nota
# ------------------------------------------------------------

INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (
    16,
    '10',
    '10',
    '10',
    '10',
    '10',
    1,
    1,
    'sexto año',
    35321158
  );
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (17, '8', '8', '8', '8', '8', 1, 1, 'sexto año', 35321871);
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (18, '7', '7', '7', '7', '7', 1, 1, 'sexto año', 43215971);
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (19, '6', '6', '6', '6', '6', 1, 1, 'sexto año', 35311971);
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (20, '7', '7', '7', '7', '7', 1, 1, 'sexto año', 44785621);
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (21, '8', '8', '8', '8', '8', 1, 1, 'sexto año', 45215981);
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (22, '9', '9', '9', '9', '9', 1, 1, 'sexto año', 88888881);
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (
    23,
    '9',
    '9',
    '9',
    '9',
    '9',
    17,
    1,
    'cuarto año',
    35311932
  );
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (
    24,
    '10',
    '10',
    '10',
    '10',
    '10',
    17,
    1,
    'cuarto año',
    45215181
  );
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (
    25,
    '5',
    '5',
    '5',
    '5',
    '5',
    17,
    1,
    'cuarto año',
    88888883
  );
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (
    33,
    '10',
    '10',
    '10',
    '10',
    '10',
    2,
    1,
    'sexto año',
    35321158
  );
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (34, '8', '8', '8', '8', '8', 2, 1, 'sexto año', 35321871);
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (35, '7', '7', '7', '7', '7', 2, 1, 'sexto año', 43215971);
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (36, '6', '6', '6', '6', '6', 2, 1, 'sexto año', 35311971);
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (37, '7', '7', '7', '7', '7', 2, 1, 'sexto año', 44785621);
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (38, '8', '8', '8', '8', '8', 2, 1, 'sexto año', 45215981);
INSERT INTO
  `nota` (
    `id`,
    `nota1`,
    `nota2`,
    `nota3`,
    `nota4`,
    `nota_definitiva`,
    `id_materia`,
    `id_periodo`,
    `descripcion_curso`,
    `dni_alumno`
  )
VALUES
  (39, '9', '9', '9', '9', '9', 2, 1, 'sexto año', 88888881);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: periodo
# ------------------------------------------------------------

INSERT INTO
  `periodo` (`id`, `descripcion`)
VALUES
  (1, '1er cuatrimestre');
INSERT INTO
  `periodo` (`id`, `descripcion`)
VALUES
  (2, '2do cuatrimestre');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: profesor
# ------------------------------------------------------------

INSERT INTO
  `profesor` (
    `nombreUsuario`,
    `nombre`,
    `apellido`,
    `dni`,
    `telefono`,
    `email`,
    `genero`,
    `nacimiento`,
    `ingreso`,
    `estado`
  )
VALUES
  (
    'hrgarcia',
    'hector',
    'garcia',
    '23146758',
    '3513506446',
    'dreamallica@gmail.com',
    'indefinide',
    '23/09/2000',
    '07/03/2015',
    'titular'
  );
INSERT INTO
  `profesor` (
    `nombreUsuario`,
    `nombre`,
    `apellido`,
    `dni`,
    `telefono`,
    `email`,
    `genero`,
    `nacimiento`,
    `ingreso`,
    `estado`
  )
VALUES
  (
    'lmazzola',
    'lucas',
    'mazzola',
    '23232322',
    '3514467892',
    'lucasmazz@gmail.com',
    'indefinido',
    '23/09/2000',
    '07/03/2015',
    'titular'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: rol
# ------------------------------------------------------------

INSERT INTO
  `rol` (`id`, `nombre`, `nombreUsuario`)
VALUES
  (5, 'preceptor', 'lmazzola');
INSERT INTO
  `rol` (`id`, `nombre`, `nombreUsuario`)
VALUES
  (6, 'profesor', 'hrgarcia');
INSERT INTO
  `rol` (`id`, `nombre`, `nombreUsuario`)
VALUES
  (7, 'profesor', 'lmazzola');
INSERT INTO
  `rol` (`id`, `nombre`, `nombreUsuario`)
VALUES
  (12, 'administrador', 'admin');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: tutor
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: usuario
# ------------------------------------------------------------

INSERT INTO
  `usuario` (`nombreUsuario`, `pass`, `avatar`)
VALUES
  (
    'admin',
    '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.',
    0
  );
INSERT INTO
  `usuario` (`nombreUsuario`, `pass`, `avatar`)
VALUES
  (
    'amenieto',
    '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.',
    0
  );
INSERT INTO
  `usuario` (`nombreUsuario`, `pass`, `avatar`)
VALUES
  (
    'hrgarcia',
    '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.',
    0
  );
INSERT INTO
  `usuario` (`nombreUsuario`, `pass`, `avatar`)
VALUES
  (
    'ianluciano',
    '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.',
    0
  );
INSERT INTO
  `usuario` (`nombreUsuario`, `pass`, `avatar`)
VALUES
  (
    'jolorenzo',
    '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.',
    0
  );
INSERT INTO
  `usuario` (`nombreUsuario`, `pass`, `avatar`)
VALUES
  (
    'juantorre',
    '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.',
    0
  );
INSERT INTO
  `usuario` (`nombreUsuario`, `pass`, `avatar`)
VALUES
  (
    'jugomis',
    '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.',
    0
  );
INSERT INTO
  `usuario` (`nombreUsuario`, `pass`, `avatar`)
VALUES
  (
    'kaestebanez',
    '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.',
    0
  );
INSERT INTO
  `usuario` (`nombreUsuario`, `pass`, `avatar`)
VALUES
  (
    'laiaquiros',
    '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.',
    0
  );
INSERT INTO
  `usuario` (`nombreUsuario`, `pass`, `avatar`)
VALUES
  (
    'lmazzola',
    '$2b$10$5wJpY.4Jlc3u7FHuqotgiuaWpDpoksvHY9EHmX6OY.66IlUoP6z5W',
    0
  );
INSERT INTO
  `usuario` (`nombreUsuario`, `pass`, `avatar`)
VALUES
  (
    'luromero',
    '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.',
    0
  );
INSERT INTO
  `usuario` (`nombreUsuario`, `pass`, `avatar`)
VALUES
  (
    'paoalbert',
    '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.',
    0
  );
INSERT INTO
  `usuario` (`nombreUsuario`, `pass`, `avatar`)
VALUES
  (
    'sevemonzon',
    '$2b$10$.nN/lf7L.NAQMq2YPgmeLO4GCEUo3eSpjNGTAXTtkcRtaCW/dsof.',
    0
  );

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
