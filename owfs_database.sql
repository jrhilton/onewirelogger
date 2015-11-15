SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
CREATE DATABASE `owfs` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `owfs`;

CREATE TABLE IF NOT EXISTS `sensor_data` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `insidetemperature1` decimal(3,1) NOT NULL,
  `outsidetemperature1` decimal(3,1) NOT NULL,
  `outsidehumidity1` decimal(4,1) NOT NULL,
  `outsidehumiditytemp1` decimal(3,1) NOT NULL,
  `pressure1` decimal(5,1) NOT NULL,
  `rain1` decimal(8,1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=81063 ;
