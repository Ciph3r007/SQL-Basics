-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema airline
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `airline` ;

-- -----------------------------------------------------
-- Schema airline
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `airline` DEFAULT CHARACTER SET utf8 ;
USE `airline` ;

-- -----------------------------------------------------
-- Table `airline`.`passengers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airline`.`passengers` ;

CREATE TABLE IF NOT EXISTS `airline`.`passengers` (
  `passenger_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`passenger_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `airline`.`classes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airline`.`classes` ;

CREATE TABLE IF NOT EXISTS `airline`.`classes` (
  `class_id` INT NOT NULL AUTO_INCREMENT,
  `class` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`class_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `airline`.`tickets`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airline`.`tickets` ;

CREATE TABLE IF NOT EXISTS `airline`.`tickets` (
  `ticket_id` INT(10) ZEROFILL NOT NULL AUTO_INCREMENT,
  `passenger_id` INT NOT NULL,
  `class_id` INT NOT NULL,
  `price` DECIMAL(5,2) NOT NULL,
  `confirmation_code` CHAR(6) NOT NULL,
  PRIMARY KEY (`ticket_id`),
  INDEX `fk_tickets_passengers1_idx` (`passenger_id` ASC) VISIBLE,
  INDEX `fk_tickets_classes1_idx` (`class_id` ASC) VISIBLE,
  CONSTRAINT `fk_tickets_passengers`
    FOREIGN KEY (`passenger_id`)
    REFERENCES `airline`.`passengers` (`passenger_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_tickets_classes`
    FOREIGN KEY (`class_id`)
    REFERENCES `airline`.`classes` (`class_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `airline`.`airports`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airline`.`airports` ;

CREATE TABLE IF NOT EXISTS `airline`.`airports` (
  `airport_code` CHAR(3) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `city` VARCHAR(50) NOT NULL,
  `state` CHAR(2) NOT NULL,
  PRIMARY KEY (`airport_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `airline`.`flights`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airline`.`flights` ;

CREATE TABLE IF NOT EXISTS `airline`.`flights` (
  `flight_id` INT NOT NULL AUTO_INCREMENT,
  `departure_time` DATETIME NOT NULL,
  `arrival_time` DATETIME NOT NULL,
  `departure_airport` CHAR(3) NOT NULL,
  `arrival_airport` CHAR(3) NOT NULL,
  `distance_in_miles` INT NOT NULL,
  PRIMARY KEY (`flight_id`),
  INDEX `fk_flight_airports_idx` (`departure_airport` ASC) VISIBLE,
  INDEX `fk_flight_airports1_idx` (`arrival_airport` ASC) VISIBLE,
  CONSTRAINT `fk_flight_airports`
    FOREIGN KEY (`departure_airport`)
    REFERENCES `airline`.`airports` (`airport_code`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_flight_airports1`
    FOREIGN KEY (`arrival_airport`)
    REFERENCES `airline`.`airports` (`airport_code`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `airline`.`routes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airline`.`routes` ;

CREATE TABLE IF NOT EXISTS `airline`.`routes` (
  `ticket_id` INT(10) ZEROFILL NOT NULL,
  `flight_id` INT NOT NULL,
  INDEX `fk_routes_tickets1_idx` (`ticket_id` ASC) VISIBLE,
  INDEX `fk_routes_flights1_idx` (`flight_id` ASC) VISIBLE,
  PRIMARY KEY (`ticket_id`, `flight_id`),
  CONSTRAINT `fk_routes_tickets`
    FOREIGN KEY (`ticket_id`)
    REFERENCES `airline`.`tickets` (`ticket_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_routes_flights`
    FOREIGN KEY (`flight_id`)
    REFERENCES `airline`.`flights` (`flight_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



-- -----------------------------------------------------
-- POPULATING TABLES
-- -----------------------------------------------------
INSERT INTO `airline`.`airports` (`airport_code`, `name`, `city`, `state`) VALUES ('LAX', 'Los Angeles Intl Airport', 'Los Angeles', 'CA');
INSERT INTO `airline`.`airports` (`airport_code`, `name`, `city`, `state`) VALUES ('SFO', 'San Francisco Intl Airport', 'San Francisco', 'CA');

INSERT INTO `airline`.`classes` (`class`) VALUES ('First Class');
INSERT INTO `airline`.`classes` (`class`) VALUES ('Business Class');
INSERT INTO `airline`.`classes` (`class`) VALUES ('Economy Class');

INSERT INTO `airline`.`flights` (`departure_time`, `arrival_time`, `departure_airport`, `arrival_airport`, `distance_in_miles`) VALUES ('2021-04-05 08:20', '2021-04-05 09:35', 'LAX', 'SFO', '236');
INSERT INTO `airline`.`flights` (`departure_time`, `arrival_time`, `departure_airport`, `arrival_airport`, `distance_in_miles`) VALUES ('2021-04-07 14:00', '2021-04-07 15:15', 'SFO', 'LAX', '236');

INSERT INTO `airline`.`passengers` (`first_name`, `last_name`) VALUES ('John', 'Smith');
INSERT INTO `airline`.`passengers` (`first_name`, `last_name`) VALUES ('Jennifer', 'Smith');

INSERT INTO `airline`.`tickets` (`ticket_id`, `passenger_id`, `class_id`, `price`, `confirmation_code`) VALUES ('177200658', '1', '3', '357.60', 'TAEGKX');
INSERT INTO `airline`.`tickets` (`ticket_id`, `passenger_id`, `class_id`, `price`, `confirmation_code`) VALUES ('178410326', '2', '3', '357.60', 'TAEGKX');

INSERT INTO `airline`.`routes` (`ticket_id`, `flight_id`) VALUES ('177200658', '1');
INSERT INTO `airline`.`routes` (`ticket_id`, `flight_id`) VALUES ('177200658', '2');
INSERT INTO `airline`.`routes` (`ticket_id`, `flight_id`) VALUES ('178410326', '1');
INSERT INTO `airline`.`routes` (`ticket_id`, `flight_id`) VALUES ('178410326', '2');

