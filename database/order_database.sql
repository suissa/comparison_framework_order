SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `pedidos` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `pedidos` ;

-- -----------------------------------------------------
-- Table `pedidos`.`user`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pedidos`.`user` (
  `iduser` INT NOT NULL AUTO_INCREMENT ,
  `email` VARCHAR(100) NOT NULL ,
  `pass` VARCHAR(200) NOT NULL ,
  `date_created` DATETIME NOT NULL ,
  `name` VARCHAR(100) NOT NULL ,
  PRIMARY KEY (`iduser`) ,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pedidos`.`client`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pedidos`.`client` (
  `idclient` INT NOT NULL ,
  `user_iduser` INT NOT NULL ,
  `sex` CHAR(1) NOT NULL ,
  `birth_date` DATE NOT NULL ,
  PRIMARY KEY (`idclient`) ,
  INDEX `fk_client_user1` (`user_iduser` ASC) ,
  CONSTRAINT `fk_client_user1`
    FOREIGN KEY (`user_iduser` )
    REFERENCES `pedidos`.`user` (`iduser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pedidos`.`admin`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pedidos`.`admin` (
  `idadmin` INT NOT NULL ,
  `user_iduser` INT NOT NULL ,
  `responsability` VARCHAR(80) NOT NULL ,
  PRIMARY KEY (`idadmin`) ,
  INDEX `fk_admin_user` (`user_iduser` ASC) ,
  CONSTRAINT `fk_admin_user`
    FOREIGN KEY (`user_iduser` )
    REFERENCES `pedidos`.`user` (`iduser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pedidos`.`payment`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pedidos`.`payment` (
  `idpayment` INT NOT NULL ,
  `type` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`idpayment`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pedidos`.`country`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pedidos`.`country` (
  `idcountry` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(100) NULL ,
  PRIMARY KEY (`idcountry`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pedidos`.`state`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pedidos`.`state` (
  `idstate` INT NOT NULL ,
  `name` VARCHAR(100) NOT NULL ,
  `country_idcountry` INT NOT NULL ,
  PRIMARY KEY (`idstate`) ,
  INDEX `fk_state_country1` (`country_idcountry` ASC) ,
  CONSTRAINT `fk_state_country1`
    FOREIGN KEY (`country_idcountry` )
    REFERENCES `pedidos`.`country` (`idcountry` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pedidos`.`city`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pedidos`.`city` (
  `idcity` INT NOT NULL ,
  `name` VARCHAR(100) NOT NULL ,
  `state_idstate` INT NOT NULL ,
  PRIMARY KEY (`idcity`) ,
  INDEX `fk_city_state1` (`state_idstate` ASC) ,
  CONSTRAINT `fk_city_state1`
    FOREIGN KEY (`state_idstate` )
    REFERENCES `pedidos`.`state` (`idstate` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pedidos`.`address`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pedidos`.`address` (
  `idaddress` INT NOT NULL ,
  `client_idclient` INT NOT NULL ,
  `city_idcity` INT NOT NULL ,
  `street` VARCHAR(100) NOT NULL ,
  `number` VARCHAR(8) NOT NULL ,
  `complement` VARCHAR(45) NULL ,
  `district` VARCHAR(80) NOT NULL ,
  `zip_code` VARCHAR(10) NOT NULL ,
  PRIMARY KEY (`idaddress`) ,
  INDEX `fk_address_client1` (`client_idclient` ASC) ,
  INDEX `fk_address_city1` (`city_idcity` ASC) ,
  CONSTRAINT `fk_address_client1`
    FOREIGN KEY (`client_idclient` )
    REFERENCES `pedidos`.`client` (`idclient` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_address_city1`
    FOREIGN KEY (`city_idcity` )
    REFERENCES `pedidos`.`city` (`idcity` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pedidos`.`deliver_address`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pedidos`.`deliver_address` (
  `iddeliver_address` INT NOT NULL ,
  `address_idaddress` INT NOT NULL ,
  PRIMARY KEY (`iddeliver_address`) ,
  INDEX `fk_deliver_address_address1` (`address_idaddress` ASC) ,
  CONSTRAINT `fk_deliver_address_address1`
    FOREIGN KEY (`address_idaddress` )
    REFERENCES `pedidos`.`address` (`idaddress` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pedidos`.`order`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pedidos`.`order` (
  `idorder` INT NOT NULL ,
  `client_idclient` INT NOT NULL ,
  `payment_idpayment` INT NOT NULL ,
  `deliver_address_iddeliver_address` INT NOT NULL ,
  PRIMARY KEY (`idorder`) ,
  INDEX `fk_order_client1` (`client_idclient` ASC) ,
  INDEX `fk_order_payment1` (`payment_idpayment` ASC) ,
  INDEX `fk_order_deliver_address1` (`deliver_address_iddeliver_address` ASC) ,
  CONSTRAINT `fk_order_client1`
    FOREIGN KEY (`client_idclient` )
    REFERENCES `pedidos`.`client` (`idclient` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_payment1`
    FOREIGN KEY (`payment_idpayment` )
    REFERENCES `pedidos`.`payment` (`idpayment` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_deliver_address1`
    FOREIGN KEY (`deliver_address_iddeliver_address` )
    REFERENCES `pedidos`.`deliver_address` (`iddeliver_address` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pedidos`.`category`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pedidos`.`category` (
  `idcategory` INT NOT NULL ,
  `name` VARCHAR(80) NOT NULL ,
  PRIMARY KEY (`idcategory`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pedidos`.`product`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pedidos`.`product` (
  `idproduct` INT NOT NULL ,
  `category_idcategory` INT NOT NULL ,
  `name` VARCHAR(80) NOT NULL ,
  `price` DECIMAL(7,2)  NOT NULL ,
  `weight` VARCHAR(45) NULL COMMENT 'weight = gram' ,
  `discount_value` DECIMAL(7,2)  NULL ,
  `discount_percentage` INT NULL ,
  PRIMARY KEY (`idproduct`) ,
  INDEX `fk_product_category1` (`category_idcategory` ASC) ,
  CONSTRAINT `fk_product_category1`
    FOREIGN KEY (`category_idcategory` )
    REFERENCES `pedidos`.`category` (`idcategory` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pedidos`.`order_items`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pedidos`.`order_items` (
  `idorder_items` INT NOT NULL ,
  `product_idproduct` INT NOT NULL ,
  `order_idorder` INT NOT NULL ,
  PRIMARY KEY (`idorder_items`) ,
  INDEX `fk_order_items_product1` (`product_idproduct` ASC) ,
  INDEX `fk_order_items_order1` (`order_idorder` ASC) ,
  CONSTRAINT `fk_order_items_product1`
    FOREIGN KEY (`product_idproduct` )
    REFERENCES `pedidos`.`product` (`idproduct` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_items_order1`
    FOREIGN KEY (`order_idorder` )
    REFERENCES `pedidos`.`order` (`idorder` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
