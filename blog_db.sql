-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-11-2026 a las 01:38:40
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `blog_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `blog`
--

CREATE TABLE `blog` (
  `id_blog` int(11) NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `desc` varchar(500) DEFAULT NULL,
  `img` varchar(255) DEFAULT NULL,
  `tags` varchar(255) DEFAULT NULL,
  `generos` enum('Romance','Terror','Fantasía','Ciencia Ficción','Aventura y Acción','Adaptaciones Cinematográficas') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `blog`
--

INSERT INTO `blog` (`id_blog`, `titulo`, `desc`, `img`, `tags`, `generos`) VALUES
(1000, 'Orgullo y prejuicio: orgullo, prejuicio y segundas oportunidades', 'Una mirada a cómo Elizabeth y Darcy cuestionan sus primeras impresiones mientras aprenden a conocerse.', 'https://covers.openlibrary.org/b/isbn/9780141439518-L.jpg', 'reseña, clásicos, relaciones', 'Romance'),
(1001, 'Como agua para chocolate: amor entre tradición y deseo', 'La novela combina una historia de amor con recetas y costumbres familiares que influyen en el destino de Tita.', 'https://covers.openlibrary.org/b/isbn/9780385721233-L.jpg', 'reseña, familia, literatura mexicana', 'Romance'),
(1002, 'Yo antes de ti: una historia sobre decisiones y cuidado', 'La relación entre Lou y Will plantea preguntas sobre la autonomía, el acompañamiento y las distintas formas de vivir.', 'https://covers.openlibrary.org/b/id/15163093-L.jpg', 'reseña, drama, amor', 'Romance'),
(1003, 'Drácula: el miedo contado a través de cartas', 'Los diarios, cartas y testimonios construyen una atmósfera inquietante alrededor del conde y quienes lo enfrentan.', 'https://covers.openlibrary.org/b/isbn/9780141439846-L.jpg', 'reseña, vampiros, clásico', 'Terror'),
(1004, 'El hobbit: un viaje que transforma a Bilbo', 'La aventura empieza como una expedición inesperada y convierte a un hobbit hogareño en alguien más valiente.', 'https://covers.openlibrary.org/b/isbn/9780547928227-L.jpg', 'reseña, aventura, Tolkien', 'Fantasía'),
(1005, 'Dune: política y supervivencia en Arrakis', 'La novela combina ecología, poder y profecías en un planeta donde cada recurso define quién puede sobrevivir.', 'https://covers.openlibrary.org/b/isbn/9780441172719-L.jpg', 'reseña, ciencia ficción, ecología', 'Ciencia Ficción');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comentarios`
--

CREATE TABLE `comentarios` (
  `id_com` int(11) NOT NULL,
  `comentario` varchar(500) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `estatus` int(11) NOT NULL DEFAULT 1,
  `usr_id` int(11) NOT NULL,
  `blog_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `comentarios`
--

INSERT INTO `comentarios` (`id_com`, `comentario`, `fecha`, `estatus`, `usr_id`, `blog_id`) VALUES
(1000, 'Me gustó cómo la reseña destaca el cambio de perspectiva de los protagonistas.', '2026-11-04 21:11:54', 1, 1000, 1000),
(1001, 'La relación entre la historia y sus costumbres familiares da mucho para conversar.', '2026-11-04 21:11:54', 1, 1001, 1001),
(1002, 'Es una recomendación interesante para quienes buscan un romance con temas profundos.', '2026-11-04 21:11:54', 1, 1002, 1002),
(1003, 'La estructura de cartas hace que el suspenso se sienta cercano.', '2026-11-04 21:11:54', 1, 1000, 1003),
(1004, 'Bilbo es un personaje entrañable; su transformación es lo mejor del viaje.', '2026-11-04 21:11:54', 1, 1001, 1004),
(1005, 'La relación entre el entorno y el poder vuelve muy actual esta lectura.', '2026-11-04 21:11:54', 1, 1002, 1005),
(1021, 'ghjj', '2026-11-05 04:27:07', 1, 1004, 1002),
(1023, 'hola', '2026-11-05 19:44:39', 1, 1004, 1001);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usr` int(11) NOT NULL,
  `nom_usr` varchar(100) NOT NULL,
  `mail` varchar(150) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `dir_usr` varchar(255) DEFAULT NULL,
  `tip_usu` enum('Administrador','Lector') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usr`, `nom_usr`, `mail`, `pass`, `dir_usr`, `tip_usu`) VALUES
(1, 'Yanet Lázaro Campos', 'lazaroyanet@gmail.com', '123456', 'Calle 1 de enero', 'Administrador'),
(3, 'Adri', 'adrilaz@gmail.com', 'pbkdf2_sha256$600000$df077ca9490b3dd42da1fd65df6ddca5$164573185bff5d52d8a816522f25fd6785130f55b51252e52c6042886f9a30a7', 'calle 3 de febrero', 'Administrador'),
(1000, 'Lucía Rivera', 'lucia.demo@example.com', 'pbkdf2_sha256$600000$848296eb57ac6cefd1dfbcc8c32417c3$ec7e366b61f10327a7b4010fa46383fd910713fa40e7fc225da7f4e14a3c42e5', NULL, 'Administrador'),
(1001, 'Mateo Torres', 'mateo.demo@example.com', 'pbkdf2_sha256$600000$848296eb57ac6cefd1dfbcc8c32417c3$ec7e366b61f10327a7b4010fa46383fd910713fa40e7fc225da7f4e14a3c42e5', NULL, 'Administrador'),
(1002, 'Sofía Luna', 'sofia.demo@example.com', 'pbkdf2_sha256$600000$848296eb57ac6cefd1dfbcc8c32417c3$ec7e366b61f10327a7b4010fa46383fd910713fa40e7fc225da7f4e14a3c42e5', NULL, 'Administrador'),
(1004, 'Yan', 'lazaroyan@gmail.com', 'pbkdf2_sha256$600000$09d3fa537b9400a36985d53711691950$8710a142aac71e63945a5fd46a8a64a3a4c71472eb7169ec66dc25ed0ed87b92', 'bsbsns', 'Administrador');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `blog`
--
ALTER TABLE `blog`
  ADD PRIMARY KEY (`id_blog`);

--
-- Indices de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD PRIMARY KEY (`id_com`),
  ADD KEY `fk_comentarios_usuario` (`usr_id`),
  ADD KEY `fk_comentarios_blog` (`blog_id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usr`),
  ADD UNIQUE KEY `mail` (`mail`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `blog`
--
ALTER TABLE `blog`
  MODIFY `id_blog` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1018;

--
-- AUTO_INCREMENT de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  MODIFY `id_com` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1024;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1005;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD CONSTRAINT `fk_comentarios_blog` FOREIGN KEY (`blog_id`) REFERENCES `blog` (`id_blog`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_comentarios_usuario` FOREIGN KEY (`usr_id`) REFERENCES `usuario` (`id_usr`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
