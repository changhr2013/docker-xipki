/*
 Navicat Premium Data Transfer

 Source Server         : xipki-mysql
 Source Server Type    : MySQL
 Source Server Version : 50743 (5.7.43)
 Source Host           : localhost:9876
 Source Schema         : ca

 Target Server Type    : MySQL
 Target Server Version : 50743 (5.7.43)
 File Encoding         : 65001

 Date: 06/09/2023 00:20:52
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE database if NOT EXISTS `ca` default character set utf8mb4 collate utf8mb4_unicode_ci;
USE ca;

-- ----------------------------
-- Table structure for CA
-- ----------------------------
DROP TABLE IF EXISTS `CA`;
CREATE TABLE `CA`  (
  `ID` smallint(6) NOT NULL,
  `NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'duplication is not permitted',
  `SUBJECT` varchar(350) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `REV_INFO` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'CA revocation information',
  `CERT` varchar(6000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of CA
-- ----------------------------

-- ----------------------------
-- Table structure for CERT
-- ----------------------------
DROP TABLE IF EXISTS `CERT`;
CREATE TABLE `CERT`  (
  `ID` bigint(20) NOT NULL,
  `CA_ID` smallint(6) NOT NULL COMMENT 'Issuer (CA) id',
  `SN` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'serial number',
  `PID` smallint(6) NOT NULL COMMENT 'certificate profile id',
  `RID` smallint(6) NOT NULL COMMENT 'requestor id',
  `FP_S` bigint(20) NOT NULL COMMENT 'first 8 bytes of the SHA1 sum of the subject',
  `FP_SAN` bigint(20) NULL DEFAULT NULL COMMENT 'first 8 bytes of the SHA1 sum of the extension value of SubjectAltNames',
  `FP_RS` bigint(20) NULL DEFAULT NULL COMMENT 'first 8 bytes of the SHA1 sum of the requested subject',
  `LUPDATE` bigint(20) NOT NULL COMMENT 'last update, seconds since January 1, 1970, 00:00:00 GMT',
  `NBEFORE` bigint(20) NOT NULL COMMENT 'notBefore, seconds since January 1, 1970, 00:00:00 GMT',
  `NAFTER` bigint(20) NOT NULL COMMENT 'notAfter, seconds since January 1, 1970, 00:00:00 GMT',
  `REV` smallint(6) NOT NULL COMMENT 'whether the certificate is revoked',
  `RR` smallint(6) NULL DEFAULT NULL COMMENT 'revocation reason',
  `RT` bigint(20) NULL DEFAULT NULL COMMENT 'revocation time, seconds since January 1, 1970, 00:00:00 GMT',
  `RIT` bigint(20) NULL DEFAULT NULL COMMENT 'revocation invalidity time, seconds since January 1, 1970, 00:00:00 GMT',
  `EE` smallint(6) NOT NULL COMMENT 'whether it is an end entity cert',
  `SUBJECT` varchar(350) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TID` varchar(43) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'base64 encoded transactionId, maximal 256 bit',
  `CRL_SCOPE` smallint(6) NOT NULL COMMENT 'CRL scope, reserved for future use',
  `SHA1` char(28) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'base64 encoded SHA1 fingerprint of the certificate',
  `REQ_SUBJECT` varchar(350) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `CERT` varchar(6000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Base64 encoded certificate',
  `PRIVATE_KEY` varchar(6000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Base64-encoded encrypted PKCS#8 private key',
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `CONST_CA_SN`(`CA_ID`, `SN`) USING BTREE,
  INDEX `IDX_CA_FPS`(`CA_ID`, `FP_S`, `FP_SAN`) USING BTREE,
  INDEX `FK_CERT_REQUESTOR1`(`RID`) USING BTREE,
  INDEX `FK_CERT_PROFILE1`(`PID`) USING BTREE,
  CONSTRAINT `FK_CERT_CA1` FOREIGN KEY (`CA_ID`) REFERENCES `CA` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CERT_PROFILE1` FOREIGN KEY (`PID`) REFERENCES `PROFILE` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CERT_REQUESTOR1` FOREIGN KEY (`RID`) REFERENCES `REQUESTOR` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of CERT
-- ----------------------------

-- ----------------------------
-- Table structure for CRL
-- ----------------------------
DROP TABLE IF EXISTS `CRL`;
CREATE TABLE `CRL`  (
  `ID` int(11) NOT NULL,
  `CA_ID` smallint(6) NOT NULL,
  `CRL_SCOPE` smallint(6) NOT NULL COMMENT 'CRL scope, reserved for future use',
  `CRL_NO` bigint(20) NOT NULL,
  `THISUPDATE` bigint(20) NOT NULL,
  `NEXTUPDATE` bigint(20) NULL DEFAULT NULL,
  `DELTACRL` smallint(6) NOT NULL,
  `BASECRL_NO` bigint(20) NULL DEFAULT NULL,
  `SHA1` char(28) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'base64 encoded SHA1 fingerprint of the CRL',
  `CRL` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `CONST_CA_CRLNO`(`CA_ID`, `CRL_NO`) USING BTREE,
  CONSTRAINT `FK_CRL_CA1` FOREIGN KEY (`CA_ID`) REFERENCES `CA` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of CRL
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
-- Table structure for PROFILE
-- ----------------------------
DROP TABLE IF EXISTS `PROFILE`;
CREATE TABLE `PROFILE`  (
  `ID` smallint(6) NOT NULL,
  `NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'duplication is not permitted',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of PROFILE
-- ----------------------------

-- ----------------------------
-- Table structure for REQUESTOR
-- ----------------------------
DROP TABLE IF EXISTS `REQUESTOR`;
CREATE TABLE `REQUESTOR`  (
  `ID` smallint(6) NOT NULL,
  `NAME` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'duplication is not permitted',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of REQUESTOR
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
