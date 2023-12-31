-- IGNORE-ERROR
ALTER TABLE CRL DROP CONSTRAINT FK_CRL_CA1;
-- IGNORE-ERROR
ALTER TABLE CERT DROP CONSTRAINT FK_CERT_CA1;
-- IGNORE-ERROR
ALTER TABLE CERT DROP CONSTRAINT FK_CERT_REQUESTOR1;
-- IGNORE-ERROR
ALTER TABLE CERT DROP CONSTRAINT FK_CERT_PROFILE1;

DROP TABLE IF EXISTS DBSCHEMA;
DROP TABLE IF EXISTS PROFILE;
DROP TABLE IF EXISTS REQUESTOR;
DROP TABLE IF EXISTS CA;
DROP TABLE IF EXISTS CRL;
DROP TABLE IF EXISTS CERT;

-- changeset xipki:1
CREATE TABLE DBSCHEMA (
    NAME VARCHAR2(45) NOT NULL,
    VALUE2 VARCHAR2(100) NOT NULL,
    CONSTRAINT PK_DBSCHEMA PRIMARY KEY (NAME)
);

INSERT INTO DBSCHEMA (NAME, VALUE2) VALUES ('VENDOR', 'XIPKI');
INSERT INTO DBSCHEMA (NAME, VALUE2) VALUES ('VERSION', '8');
INSERT INTO DBSCHEMA (NAME, VALUE2) VALUES ('X500NAME_MAXLEN', '350');

CREATE TABLE PROFILE (
    ID NUMBER(5) NOT NULL,
    NAME VARCHAR2(45) NOT NULL,
    CONSTRAINT PK_PROFILE PRIMARY KEY (ID)
);

COMMENT ON COLUMN PROFILE.NAME IS 'duplication is not permitted';

CREATE TABLE REQUESTOR (
    ID NUMBER(5) NOT NULL,
    NAME VARCHAR2(45) NOT NULL,
    CONSTRAINT PK_REQUESTOR PRIMARY KEY (ID)
);

COMMENT ON COLUMN REQUESTOR.NAME IS 'duplication is not permitted';

CREATE TABLE CA (
    ID NUMBER(5) NOT NULL,
    NAME VARCHAR2(45) NOT NULL,
    SUBJECT VARCHAR2(350) NOT NULL,
    REV_INFO VARCHAR2(200),
    CERT VARCHAR2(6000) NOT NULL,
    CONSTRAINT PK_CA PRIMARY KEY (ID)
);

COMMENT ON COLUMN CA.NAME IS 'duplication is not permitted';
COMMENT ON COLUMN CA.REV_INFO IS 'CA revocation information';

-- changeset xipki:2
CREATE TABLE CRL (
    ID INTEGER NOT NULL,
    CA_ID NUMBER(5) NOT NULL,
    CRL_SCOPE NUMBER(5) NOT NULL,
    CRL_NO NUMBER(38, 0) NOT NULL,
    THISUPDATE NUMBER(38, 0) NOT NULL,
    NEXTUPDATE NUMBER(38, 0),
    DELTACRL NUMBER(5) NOT NULL,
    BASECRL_NO NUMBER(38, 0),
    SHA1 CHAR(28) NOT NULL,
    CRL CLOB NOT NULL,
    CONSTRAINT PK_CRL PRIMARY KEY (ID)
);

COMMENT ON COLUMN CRL.CRL_SCOPE IS 'CRL scope, reserved for future use';
COMMENT ON COLUMN CRL.SHA1 IS 'base64 encoded SHA1 fingerprint of the CRL';

ALTER TABLE CRL ADD CONSTRAINT CONST_CA_CRLNO UNIQUE (CA_ID, CRL_NO);

CREATE TABLE CERT (
    ID NUMBER(38, 0) NOT NULL,
    CA_ID NUMBER(5) NOT NULL,
    SN VARCHAR2(40) NOT NULL,
    PID NUMBER(5) NOT NULL,
    RID NUMBER(5) NOT NULL,
    FP_S NUMBER(38, 0) NOT NULL,
    FP_SAN NUMBER(38, 0),
    FP_RS NUMBER(38, 0),
    LUPDATE NUMBER(38, 0) NOT NULL,
    NBEFORE NUMBER(38, 0) NOT NULL,
    NAFTER NUMBER(38, 0) NOT NULL,
    REV NUMBER(5) NOT NULL,
    RR NUMBER(5),
    RT NUMBER(38, 0),
    RIT NUMBER(38, 0),
    EE NUMBER(5) NOT NULL,
    SUBJECT VARCHAR2(350) NOT NULL,
    TID VARCHAR2(43),
    CRL_SCOPE NUMBER(5) NOT NULL,
    SHA1 CHAR(28) NOT NULL,
    REQ_SUBJECT VARCHAR2(350),
    CERT VARCHAR2(6000) NOT NULL,
    PRIVATE_KEY VARCHAR2(6000),
    CONSTRAINT PK_CERT PRIMARY KEY (ID)
);

COMMENT ON COLUMN CERT.CA_ID IS 'Issuer (CA) id';
COMMENT ON COLUMN CERT.SN IS 'serial number';
COMMENT ON COLUMN CERT.PID IS 'certificate profile id';
COMMENT ON COLUMN CERT.RID IS 'requestor id';
COMMENT ON COLUMN CERT.FP_S IS 'first 8 bytes of the SHA1 sum of the subject';
COMMENT ON COLUMN CERT.FP_SAN IS 'first 8 bytes of the SHA1 sum of the extension value of SubjectAltNames';
COMMENT ON COLUMN CERT.FP_RS IS 'first 8 bytes of the SHA1 sum of the requested subject';
COMMENT ON COLUMN CERT.LUPDATE IS 'last update, seconds since January 1, 1970, 00:00:00 GMT';
COMMENT ON COLUMN CERT.NBEFORE IS 'notBefore, seconds since January 1, 1970, 00:00:00 GMT';
COMMENT ON COLUMN CERT.NAFTER IS 'notAfter, seconds since January 1, 1970, 00:00:00 GMT';
COMMENT ON COLUMN CERT.REV IS 'whether the certificate is revoked';
COMMENT ON COLUMN CERT.RR IS 'revocation reason';
COMMENT ON COLUMN CERT.RT IS 'revocation time, seconds since January 1, 1970, 00:00:00 GMT';
COMMENT ON COLUMN CERT.RIT IS 'revocation invalidity time, seconds since January 1, 1970, 00:00:00 GMT';
COMMENT ON COLUMN CERT.EE IS 'whether it is an end entity cert';
COMMENT ON COLUMN CERT.TID IS 'base64 encoded transactionId, maximal 256 bit';
COMMENT ON COLUMN CERT.CRL_SCOPE IS 'CRL scope, reserved for future use';
COMMENT ON COLUMN CERT.SHA1 IS 'base64 encoded SHA1 fingerprint of the certificate';
COMMENT ON COLUMN CERT.CERT IS 'Base64 encoded certificate';
COMMENT ON COLUMN CERT.PRIVATE_KEY IS 'Base64-encoded encrypted PKCS#8 private key';

ALTER TABLE CERT ADD CONSTRAINT CONST_CA_SN UNIQUE (CA_ID, SN);
CREATE INDEX IDX_CA_FPS ON CERT(CA_ID, FP_S, FP_SAN);

-- changeset xipki:4
ALTER TABLE CRL ADD CONSTRAINT FK_CRL_CA1 FOREIGN KEY (CA_ID) REFERENCES CA (ID);
ALTER TABLE CERT ADD CONSTRAINT FK_CERT_CA1 FOREIGN KEY (CA_ID) REFERENCES CA (ID);
ALTER TABLE CERT ADD CONSTRAINT FK_CERT_REQUESTOR1 FOREIGN KEY (RID) REFERENCES REQUESTOR (ID);
ALTER TABLE CERT ADD CONSTRAINT FK_CERT_PROFILE1 FOREIGN KEY (PID) REFERENCES PROFILE (ID);

