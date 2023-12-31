DROP TABLE IF EXISTS DBSCHEMA;
DROP TABLE IF EXISTS AUDIT;
DROP TABLE IF EXISTS INTEGRITY;

-- changeset xipki:1
CREATE TABLE DBSCHEMA (
    NAME VARCHAR(45) NOT NULL,
    VALUE2 VARCHAR(100) NOT NULL,
    CONSTRAINT PK_DBSCHEMA PRIMARY KEY (NAME)
)
COMMENT='database schema information';

INSERT INTO DBSCHEMA (NAME, VALUE2) VALUES ('VENDOR', 'XIPKI');
INSERT INTO DBSCHEMA (NAME, VALUE2) VALUES ('VERSION', '1');
INSERT INTO DBSCHEMA (NAME, VALUE2) VALUES ('MAX_MESSAGE_LEN', '1000');

CREATE TABLE AUDIT (
    SHARD_ID SMALLINT NOT NULL,
    ID BIGINT NOT NULL,
    TIME CHAR(23) NOT NULL COMMENT 'Logging time e.g. 2022.03.06-10:18:35.483',
    LEVEL VARCHAR(5) NOT NULL COMMENT 'DEBUG,INFO,ERROR',
    EVENT_TYPE SMALLINT NOT NULL COMMENT '1 for AuditEvent, 2 for PCIAuditEvent',
    PREVIOUS_ID BIGINT NOT NULL COMMENT 'ID of the previous audit entry. 0 if none.',
    MESSAGE VARCHAR(1000) NOT NULL COMMENT 'log message',
    TAG VARCHAR(100) NOT NULL COMMENT '[algo]:[keyId]:[base64(tag)]'
);

CREATE TABLE INTEGRITY (
    ID SMALLINT NOT NULL,
    TEXT VARCHAR(1000) NOT NULL
);

INSERT INTO INTEGRITY (ID, TEXT) VALUES ('1', '');

