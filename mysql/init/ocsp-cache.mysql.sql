/*
 Navicat Premium Data Transfer

 Source Server         : xipki-mysql
 Source Server Type    : MySQL
 Source Server Version : 50743 (5.7.43)
 Source Host           : localhost:9876
 Source Schema         : ocspcache

 Target Server Type    : MySQL
 Target Server Version : 50743 (5.7.43)
 File Encoding         : 65001

 Date: 06/09/2023 23:15:11
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE database if NOT EXISTS `ocspcache` default character set utf8mb4 collate utf8mb4_unicode_ci;
USE ocspcache;

-- ----------------------------
-- Table structure for ISSUER
-- ----------------------------
DROP TABLE IF EXISTS `ISSUER`;
CREATE TABLE `ISSUER`
(
    `ID`   int(11)                                                        NOT NULL,
    `S1C`  char(28) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci      NOT NULL COMMENT 'base64 encoded SHA1 sum of the certificate',
    `CERT` varchar(6000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ISSUER
-- ----------------------------

-- ----------------------------
-- Table structure for OCSP
-- ----------------------------
DROP TABLE IF EXISTS `OCSP`;
CREATE TABLE `OCSP`
(
    `ID`           bigint(20)                                                     NOT NULL,
    `IID`          int(11)                                                        NOT NULL,
    `IDENT`        varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   NOT NULL COMMENT 'Identifier consists of hex(SIG_ALG) | hex(CERTHASH_ALG) | hex(serial number)',
    `GENERATED_AT` bigint(20)                                                     NOT NULL COMMENT 'generatedAt, seconds since January 1, 1970, 00:00:00 GMT',
    `NEXT_UPDATE`  bigint(20)                                                     NOT NULL COMMENT 'next update, seconds since January 1, 1970, 00:00:00 GMT',
    `RESP`         varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Base64 DER-encoded OCSP response',
    PRIMARY KEY (`ID`) USING BTREE,
    INDEX `FK_OCSP_ISSUER1` (`IID`) USING BTREE,
    CONSTRAINT `FK_OCSP_ISSUER1` FOREIGN KEY (`IID`) REFERENCES `ISSUER` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT = 'Only OCSP response without nonce is cached here'
  ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of OCSP
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;