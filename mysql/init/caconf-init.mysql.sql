/*
 Navicat Premium Data Transfer

 Source Server         : xipki-mysql
 Source Server Type    : MySQL
 Source Server Version : 50743 (5.7.43)
 Source Host           : localhost:9876
 Source Schema         : caconf

 Target Server Type    : MySQL
 Target Server Version : 50743 (5.7.43)
 File Encoding         : 65001

 Date: 06/09/2023 00:26:04
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE database if NOT EXISTS `caconf` default character set utf8mb4 collate utf8mb4_unicode_ci;
USE caconf;

-- ----------------------------
-- Table structure for CA
-- ----------------------------
DROP TABLE IF EXISTS `CA`;
CREATE TABLE `CA`  (
  `ID` smallint(6) NOT NULL,
  `NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'duplication is not permitted',
  `STATUS` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'valid values: active, inactive',
  `NEXT_CRLNO` bigint(20) NULL DEFAULT NULL,
  `CRL_SIGNER_NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `SUBJECT` varchar(350) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `REV_INFO` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'CA revocation information',
  `CERT` varchar(6000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `SIGNER_TYPE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `SIGNER_CONF` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CERTCHAIN` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'Certificate chain without CA\'s certificate',
  `CONF` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `CONST_CA_NAME`(`NAME`) USING BTREE,
  INDEX `FK_CA_CRL_SIGNER1`(`CRL_SIGNER_NAME`) USING BTREE,
  CONSTRAINT `FK_CA_CRL_SIGNER1` FOREIGN KEY (`CRL_SIGNER_NAME`) REFERENCES `SIGNER` (`NAME`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of CA
-- ----------------------------

-- ----------------------------
-- Table structure for CAALIAS
-- ----------------------------
DROP TABLE IF EXISTS `CAALIAS`;
CREATE TABLE `CAALIAS`  (
  `NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CA_ID` smallint(6) NOT NULL,
  PRIMARY KEY (`NAME`) USING BTREE,
  INDEX `FK_CAALIAS_CA1`(`CA_ID`) USING BTREE,
  CONSTRAINT `FK_CAALIAS_CA1` FOREIGN KEY (`CA_ID`) REFERENCES `CA` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of CAALIAS
-- ----------------------------

-- ----------------------------
-- Table structure for CA_HAS_PROFILE
-- ----------------------------
DROP TABLE IF EXISTS `CA_HAS_PROFILE`;
CREATE TABLE `CA_HAS_PROFILE`  (
  `CA_ID` smallint(6) NOT NULL,
  `PROFILE_ID` smallint(6) NOT NULL,
  PRIMARY KEY (`CA_ID`, `PROFILE_ID`) USING BTREE,
  INDEX `FK_CA_HAS_PROFILE_PROFILE1`(`PROFILE_ID`) USING BTREE,
  CONSTRAINT `FK_CA_HAS_PROFILE_CA1` FOREIGN KEY (`CA_ID`) REFERENCES `CA` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_CA_HAS_PROFILE_PROFILE1` FOREIGN KEY (`PROFILE_ID`) REFERENCES `PROFILE` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of CA_HAS_PROFILE
-- ----------------------------

-- ----------------------------
-- Table structure for CA_HAS_PUBLISHER
-- ----------------------------
DROP TABLE IF EXISTS `CA_HAS_PUBLISHER`;
CREATE TABLE `CA_HAS_PUBLISHER`  (
  `CA_ID` smallint(6) NOT NULL,
  `PUBLISHER_ID` smallint(6) NOT NULL,
  PRIMARY KEY (`CA_ID`, `PUBLISHER_ID`) USING BTREE,
  INDEX `FK_CA_HAS_PUBLISHER_PUBLISHER1`(`PUBLISHER_ID`) USING BTREE,
  CONSTRAINT `FK_CA_HAS_PUBLISHER_CA1` FOREIGN KEY (`CA_ID`) REFERENCES `CA` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_CA_HAS_PUBLISHER_PUBLISHER1` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `PUBLISHER` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of CA_HAS_PUBLISHER
-- ----------------------------

-- ----------------------------
-- Table structure for CA_HAS_REQUESTOR
-- ----------------------------
DROP TABLE IF EXISTS `CA_HAS_REQUESTOR`;
CREATE TABLE `CA_HAS_REQUESTOR`  (
  `CA_ID` smallint(6) NOT NULL,
  `REQUESTOR_ID` smallint(6) NOT NULL,
  `PERMISSION` int(11) NULL DEFAULT NULL,
  `PROFILES` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`CA_ID`, `REQUESTOR_ID`) USING BTREE,
  INDEX `FK_CA_HAS_REQUESTOR_REQUESTOR1`(`REQUESTOR_ID`) USING BTREE,
  CONSTRAINT `FK_CA_HAS_REQUESTOR_CA1` FOREIGN KEY (`CA_ID`) REFERENCES `CA` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_CA_HAS_REQUESTOR_REQUESTOR1` FOREIGN KEY (`REQUESTOR_ID`) REFERENCES `REQUESTOR` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of CA_HAS_REQUESTOR
-- ----------------------------

-- ----------------------------
-- Table structure for DBSCHEMA
-- ----------------------------
DROP TABLE IF EXISTS `DBSCHEMA`;
CREATE TABLE `DBSCHEMA`  (
  `NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `VALUE2` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of DBSCHEMA
-- ----------------------------
INSERT INTO `DBSCHEMA` VALUES ('VENDOR', 'XIPKI');
INSERT INTO `DBSCHEMA` VALUES ('VERSION', '8');
INSERT INTO `DBSCHEMA` VALUES ('X500NAME_MAXLEN', '350');

-- ----------------------------
-- Table structure for KEYPAIR_GEN
-- ----------------------------
DROP TABLE IF EXISTS `KEYPAIR_GEN`;
CREATE TABLE `KEYPAIR_GEN`  (
  `NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TYPE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CONF` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of KEYPAIR_GEN
-- ----------------------------
INSERT INTO `KEYPAIR_GEN` VALUES ('software', 'SOFTWARE', NULL);

-- ----------------------------
-- Table structure for PROFILE
-- ----------------------------
DROP TABLE IF EXISTS `PROFILE`;
CREATE TABLE `PROFILE`  (
  `ID` smallint(6) NOT NULL,
  `NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'duplication is not permitted',
  `TYPE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CONF` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'profile data, depends on the type',
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `CONST_PROFILE_NAME`(`NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of PROFILE
-- ----------------------------

-- ----------------------------
-- Table structure for PUBLISHER
-- ----------------------------
DROP TABLE IF EXISTS `PUBLISHER`;
CREATE TABLE `PUBLISHER`  (
  `ID` smallint(6) NOT NULL,
  `NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'duplication is not permitted',
  `TYPE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CONF` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `CONST_PUBLISHER_NAME`(`NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of PUBLISHER
-- ----------------------------

-- ----------------------------
-- Table structure for REQUESTOR
-- ----------------------------
DROP TABLE IF EXISTS `REQUESTOR`;
CREATE TABLE `REQUESTOR`  (
  `ID` smallint(6) NOT NULL,
  `NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TYPE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CONF` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `CONST_REQUESTOR_NAME`(`NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of REQUESTOR
-- ----------------------------

-- ----------------------------
-- Table structure for SIGNER
-- ----------------------------
DROP TABLE IF EXISTS `SIGNER`;
CREATE TABLE `SIGNER`  (
  `NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TYPE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CERT` varchar(6000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `CONF` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of SIGNER
-- ----------------------------

-- ----------------------------
-- Table structure for SYSTEM_EVENT
-- ----------------------------
DROP TABLE IF EXISTS `SYSTEM_EVENT`;
CREATE TABLE `SYSTEM_EVENT`  (
  `NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `EVENT_TIME` bigint(20) NOT NULL COMMENT 'seconds since January 1, 1970, 00:00:00 GMT',
  `EVENT_TIME2` timestamp NULL DEFAULT NULL,
  `EVENT_OWNER` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of SYSTEM_EVENT
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;

