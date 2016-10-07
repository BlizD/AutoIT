-- phpMyAdmin SQL Dump
-- version 3.3.10deb1
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Окт 05 2011 г., 16:17
-- Версия сервера: 5.1.54
-- Версия PHP: 5.3.5-1ubuntu7.2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `TaskDB`
--

-- --------------------------------------------------------

--
-- Структура таблицы `Workers`
--

CREATE TABLE IF NOT EXISTS `Workers` (
  `id_Worker` int(3) NOT NULL AUTO_INCREMENT,
  `Name` text,
  `id_Post` int(2) DEFAULT NULL,
  PRIMARY KEY (`id_Worker`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Дамп данных таблицы `Workers`
--

INSERT INTO `Workers` (`id_Worker`, `Name`, `id_Post`) VALUES
(1, 'Рябинина Татьяна', 1),
(2, 'Иванов Антон', 2),
(3, 'Омельчук Сергей', 2),
(4, 'Кучеренко Александр', 2),
(5, 'Лахнов Александр', 3),
(6, 'Чубукин Денис', 3),
(7, 'Пащенко Александр', 3);
