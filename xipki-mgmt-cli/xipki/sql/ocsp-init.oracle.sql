-- IGNORE-ERROR
ALTER TABLE ISSUER DROP CONSTRAINT FK_ISSUER_CRL1;
-- IGNORE-ERROR
ALTER TABLE CERT DROP CONSTRAINT FK_CERT_ISSUER1;
-- IGNORE-ERROR
ALTER TABLE CERT DROP CONSTRAINT FK_CERT_CRL1;

DROP TABLE IF EXISTS DBSCHEMA;
DROP TABLE IF EXISTS ISSUER;
DROP TABLE IF EXISTS CRL_INFO;
DROP TABLE IF EXISTS CERT;

-- changeset xipki:1
CREATE TABLE DBSCHEMA (
    NAME VARCHAR2(45) NOT NULL,
    VALUE2 VARCHAR2(100) NOT NULL,
    CONSTRAINT PK_DBSCHEMA PRIMARY KEY (NAME)
);

COMMENT ON TABLE DBSCHEMA IS 'database schema information';

INSERT INTO DBSCHEMA (NAME, VALUE2) VALUES ('VENDOR', 'XIPKI');
INSERT INTO DBSCHEMA (NAME, VALUE2) VALUES ('VERSION', '4');
INSERT INTO DBSCHEMA (NAME, VALUE2) VALUES ('X500NAME_MAXLEN', '350');
INSERT INTO DBSCHEMA (NAME, VALUE2) VALUES ('CERTHASH_ALGO', 'SHA256');

CREATE TABLE ISSUER (
    ID NUMBER(5) NOT NULL,
    SUBJECT VARCHAR2(350) NOT NULL,
    NBEFORE NUMBER(38, 0) NOT NULL,
    NAFTER NUMBER(38, 0) NOT NULL,
    S1C CHAR(28) NOT NULL,
    REV_INFO VARCHAR2(200),
    CERT VARCHAR2(6000) NOT NULL,
    CRL_ID INTEGER,
    CONSTRAINT PK_ISSUER PRIMARY KEY (ID)
);

COMMENT ON COLUMN ISSUER.NBEFORE IS 'notBefore of certificate, seconds since January 1, 1970, 00:00:00 GMT';
COMMENT ON COLUMN ISSUER.NAFTER IS 'notAfter of certificate, seconds since January 1, 1970, 00:00:00 GMT';
COMMENT ON COLUMN ISSUER.S1C IS 'base64 enoded SHA1 sum of the certificate';
COMMENT ON COLUMN ISSUER.REV_INFO IS 'CA revocation information';
COMMENT ON COLUMN ISSUER.CRL_ID IS 'CRL ID, only present for entry imported from CRL, and only if exactly one CRL is available for this CA';

CREATE TABLE CRL_INFO (
    ID INTEGER NOT NULL,
    NAME VARCHAR2(100) NOT NULL,
    INFO VARCHAR2(1000) NOT NULL,
    CONSTRAINT PK_CRL_INFO PRIMARY KEY (ID)
);

COMMENT ON COLUMN CRL_INFO.INFO IS 'CRL information';

CREATE TABLE CERT (
    ID NUMBER(38, 0) NOT NULL,
    IID NUMBER(5) NOT NULL,
    SN VARCHAR2(40) NOT NULL,
    CRL_ID INTEGER,
    LUPDATE NUMBER(38, 0) NOT NULL,
    NBEFORE NUMBER(38, 0),
    NAFTER NUMBER(38, 0),
    REV NUMBER(5) NOT NULL,
    RR NUMBER(5),
    RT NUMBER(38, 0),
    RIT NUMBER(38, 0),
    HASH CHAR(86),
    SUBJECT VARCHAR2(350),
    CONSTRAINT PK_CERT PRIMARY KEY (ID)
);

COMMENT ON TABLE CERT IS 'certificate information';
COMMENT ON COLUMN CERT.IID IS 'issuer id';
COMMENT ON COLUMN CERT.SN IS 'serial number';
COMMENT ON COLUMN CERT.CRL_ID IS 'CRL ID, only present for entry imported from CRL';
COMMENT ON COLUMN CERT.LUPDATE IS 'last update of the this database entry, seconds since January 1, 1970, 00:00:00 GMT';
COMMENT ON COLUMN CERT.NBEFORE IS 'notBefore of certificate, seconds since January 1, 1970, 00:00:00 GMT';
COMMENT ON COLUMN CERT.NAFTER IS 'notAfter of certificate, seconds since January 1, 1970, 00:00:00 GMT';
COMMENT ON COLUMN CERT.REV IS 'whether the certificate is revoked';
COMMENT ON COLUMN CERT.RR IS 'revocation reason';
COMMENT ON COLUMN CERT.RT IS 'revocation time, seconds since January 1, 1970, 00:00:00 GMT';
COMMENT ON COLUMN CERT.RIT IS 'revocation invalidity time, seconds since January 1, 1970, 00:00:00 GMT';
COMMENT ON COLUMN CERT.HASH IS 'base64 encoded hash value of the DER encoded certificate. Algorithm is defined by CERTHASH_ALGO in table DBSchema';
COMMENT ON COLUMN CERT.SUBJECT IS 'subject of the certificate';

ALTER TABLE CERT ADD CONSTRAINT CONST_ISSUER_SN UNIQUE (IID, SN);

-- changeset xipki:2
ALTER TABLE CERT ADD CONSTRAINT FK_CERT_ISSUER1
    FOREIGN KEY (IID) REFERENCES ISSUER (ID);

ALTER TABLE CERT ADD CONSTRAINT FK_CERT_CRL1
    FOREIGN KEY (CRL_ID) REFERENCES CRL_INFO (ID);

ALTER TABLE ISSUER ADD CONSTRAINT FK_ISSUER_CRL1
    FOREIGN KEY (CRL_ID) REFERENCES CRL_INFO (ID);

