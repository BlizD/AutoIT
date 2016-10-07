-- phpMyAdmin SQL Dump
-- version 3.3.10deb1
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Ноя 11 2011 г., 12:44
-- Версия сервера: 5.1.54
-- Версия PHP: 5.3.5-1ubuntu7.3

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
-- Структура таблицы `Events`
--

CREATE TABLE IF NOT EXISTS `Events` (
  `id_Event` int(10) NOT NULL AUTO_INCREMENT,
  `ToFrom` int(3) DEFAULT NULL,
  `ToWhom` int(3) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `Description` text,
  `IsRead` int(1) DEFAULT '0',
  `isSend` int(1) DEFAULT '0',
  `id_Task` int(10) DEFAULT NULL,
  PRIMARY KEY (`id_Event`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=991 ;

-- --------------------------------------------------------

--
-- Структура таблицы `Tasks`
--

CREATE TABLE IF NOT EXISTS `Tasks` (
  `id_Task` int(10) NOT NULL AUTO_INCREMENT,
  `Name` text,
  `id_worker` int(3) DEFAULT NULL,
  `id_chief` int(3) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_Task`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=274 ;

-- --------------------------------------------------------

--
-- Структура таблицы `WorkCourse`
--

CREATE TABLE IF NOT EXISTS `WorkCourse` (
  `id_WorkCourse` int(10) NOT NULL AUTO_INCREMENT,
  `id_Task` int(10) DEFAULT NULL,
  `LineNumber` int(10) DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `Description` text,
  `id_Worker` int(3) DEFAULT NULL,
  PRIMARY KEY (`id_WorkCourse`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=484 ;

-- --------------------------------------------------------

--
-- Структура таблицы `Workers`
--

CREATE TABLE IF NOT EXISTS `Workers` (
  `id_Worker` int(3) NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) DEFAULT NULL,
  `Post` text,
  `UserWindows` text,
  `psw` text,
  `email` text,
  `noticeofevents` int(1) DEFAULT NULL,
  PRIMARY KEY (`id_Worker`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;
