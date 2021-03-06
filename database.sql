SET NAMES utf8mb4;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

-- DROP DATABASE IF EXISTS `tarallo`;
-- CREATE DATABASE `tarallo` DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
-- USE `tarallo`;

CREATE TABLE `Feature` (
	`FeatureID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	`FeatureName` varchar(190)
	COLLATE utf8mb4_unicode_ci NOT NULL,
	`FeatureType` int NOT NULL, -- 0 = text, 1 = number, 2 = "enum"
	INDEX (`FeatureName`),
	UNIQUE KEY (`FeatureName`),
	PRIMARY KEY (`FeatureID`)
)
	ENGINE = InnoDB
	DEFAULT CHARSET = utf8mb4
	COLLATE = utf8mb4_unicode_ci;


CREATE TABLE `Item` (
	`ItemID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	`Code` varchar(190)
	COLLATE utf8mb4_unicode_ci NOT NULL,
	`IsDefault` tinyint(1) NOT NULL,
	`Default` bigint(20) unsigned DEFAULT NULL,
	UNIQUE KEY (`Code`),
	INDEX (`Code`),
	FOREIGN KEY (`Default`) REFERENCES `Item` (`ItemID`)
		ON DELETE SET NULL
		ON UPDATE CASCADE, -- very foreign, it's the same table. I'm not really convinced by that SET NULL, anyway.
	CHECK ((IsDefault = 1 AND `Default` IS NULL) OR IsDefault = 0),
	PRIMARY KEY (`ItemID`)
)
	ENGINE = InnoDB
	DEFAULT CHARSET = utf8mb4
	COLLATE = utf8mb4_unicode_ci;


CREATE TABLE `FeatureValue` (
	`FeatureID` bigint(20) unsigned NOT NULL,
	`ValueEnum` bigint(20) unsigned NOT NULL,
	`ValueText` text NOT NULL,
	PRIMARY KEY (`FeatureID`, `ValueEnum`),
	CONSTRAINT FOREIGN KEY (`FeatureID`) REFERENCES `Feature` (`FeatureID`)
		ON DELETE NO ACTION
		ON UPDATE CASCADE
)
	ENGINE = InnoDB
	DEFAULT CHARSET = utf8mb4
	COLLATE = utf8mb4_unicode_ci;


CREATE TABLE `ItemFeature` (
	`FeatureID` bigint(20) unsigned NOT NULL,
	`ItemID` bigint(20) unsigned NOT NULL,
	`Value` bigint(20) unsigned DEFAULT NULL,
	`ValueEnum` bigint(20) unsigned DEFAULT NULL,
	`ValueText` text DEFAULT NULL,
	PRIMARY KEY (`FeatureID`, `ItemID`),
	KEY `ItemID` (`ItemID`),
	KEY `Value` (`Value`),
	KEY `ValueEnum` (`ValueEnum`),
	-- this doesn't work, for no reason at all
	-- CONSTRAINT `FK_FeatureEnum_FeatureValue` FOREIGN KEY (`ValueEnum`) REFERENCES `FeatureValue` (`ValueEnum`) ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT FOREIGN KEY (`ItemID`) REFERENCES `Item` (`ItemID`)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT FOREIGN KEY (`FeatureID`) REFERENCES `Feature` (`FeatureID`)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	CHECK ((`Value` IS NOT NULL AND `ValueText` IS NULL AND `ValueEnum` IS NULL)
			OR (`Value` IS NULL AND `ValueText` IS NOT NULL AND `ValueEnum` IS NULL)
			OR (`Value` IS NULL AND `ValueText` IS NULL AND `ValueEnum` IS NOT NULL))
)
	ENGINE = InnoDB
	DEFAULT CHARSET = utf8mb4
	COLLATE = utf8mb4_unicode_ci;


CREATE TABLE `ItemLocationModification` (
	`ModificationID` bigint(20) unsigned NOT NULL,
	`ItemID` bigint(20) unsigned NOT NULL,
	-- parentFrom is useless if adding an item also creates a new row here: first row is the original parent...
	`ParentTo` bigint(20) unsigned NOT NULL,
	PRIMARY KEY (`ModificationID`, `ItemID`),
	KEY (`ParentTo`),
	CONSTRAINT FOREIGN KEY (`ModificationID`) REFERENCES `Modification` (`ModificationID`)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	CONSTRAINT FOREIGN KEY (`ItemID`) REFERENCES `Item` (`ItemID`)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	CONSTRAINT FOREIGN KEY (`ParentTo`) REFERENCES `Item` (`ItemID`)
		ON DELETE NO ACTION
		ON UPDATE CASCADE
)
	ENGINE = InnoDB
	DEFAULT CHARSET = utf8mb4
	COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `ItemModificationDelete` (
	`ModificationID` bigint(20) unsigned NOT NULL,
	`ItemID` bigint(20) unsigned NOT NULL,
	PRIMARY KEY (`ModificationID`, `ItemID`),
	KEY (`ItemID`),
	CONSTRAINT FOREIGN KEY (`ModificationID`) REFERENCES `Modification` (`ModificationID`)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	CONSTRAINT FOREIGN KEY (`ItemID`) REFERENCES `Item` (`ItemID`)
		ON DELETE NO ACTION
		ON UPDATE CASCADE
)
	ENGINE = InnoDB
	DEFAULT CHARSET = utf8mb4
	COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `ItemModification` (
	`ModificationID` bigint(20) unsigned NOT NULL,
	`ItemID` bigint(20) unsigned NOT NULL,
	PRIMARY KEY (`ModificationID`, `ItemID`),
	KEY (`ItemID`),
	CONSTRAINT FOREIGN KEY (`ModificationID`) REFERENCES `Modification` (`ModificationID`)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	CONSTRAINT FOREIGN KEY (`ItemID`) REFERENCES `Item` (`ItemID`)
		ON DELETE NO ACTION
		ON UPDATE CASCADE
)
	ENGINE = InnoDB
	DEFAULT CHARSET = utf8mb4
	COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `Modification` (
	`ModificationID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	`UserID` bigint(20) unsigned NOT NULL,
	`Date` bigint(20) unsigned NOT NULL,
	`Notes` text COLLATE utf8mb4_unicode_ci,
	PRIMARY KEY (`ModificationID`),
	KEY (`UserID`),
	CONSTRAINT FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`)
		ON DELETE NO ACTION
		ON UPDATE CASCADE
)
	ENGINE = InnoDB
	DEFAULT CHARSET = utf8mb4
	COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `Tree` (
	`AncestorID` bigint(20) unsigned NOT NULL,
	`DescendantID` bigint(20) unsigned NOT NULL,
	`Depth` int(10) unsigned NOT NULL, -- This may need an index
	PRIMARY KEY (`AncestorID`, `DescendantID`),
	CONSTRAINT FOREIGN KEY (`AncestorID`) REFERENCES `Item` (`ItemID`)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	CONSTRAINT FOREIGN KEY (`DescendantID`) REFERENCES `Item` (`ItemID`)
		ON DELETE NO ACTION
		ON UPDATE CASCADE
)
	ENGINE = InnoDB
	DEFAULT CHARSET = utf8mb4
	COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `Codes` (
	`Prefix` varchar(20) NOT NULL,
	`Integer` bigint(20) unsigned NOT NULL DEFAULT 0,
	PRIMARY KEY (`Prefix`)
)
	ENGINE = InnoDB
	DEFAULT CHARSET = utf8mb4
	COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `User` (
	`UserID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	`Name` varchar(190) -- 190 * 4 bytes = 760, less than the apparently random limit of 767 bytes.
	COLLATE utf8mb4_unicode_ci NOT NULL,
	`Password` text COLLATE utf8mb4_unicode_ci NOT NULL,
	`Session` char(32)
	COLLATE utf8mb4_unicode_ci,
	`SessionExpiry` bigint(20),
	`Enabled` tinyint(1) unsigned NOT NULL DEFAULT 0,
	CHECK ((`Session` IS NOT NULL AND `SessionExpiry` IS NOT NULL)
			OR (`Session` IS NULL AND `SessionExpiry` IS NULL)),
	PRIMARY KEY (`UserID`),
	UNIQUE KEY (`Session`),
	UNIQUE KEY (`Name`),
	INDEX (`Name`)
)
	ENGINE = InnoDB
	DEFAULT CHARSET = utf8mb4
	COLLATE = utf8mb4_unicode_ci;
