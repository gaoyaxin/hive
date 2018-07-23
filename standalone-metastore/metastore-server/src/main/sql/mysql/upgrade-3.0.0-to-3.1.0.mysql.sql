SELECT 'Upgrading MetaStore schema from 3.0.0 to 3.1.0' AS ' ';
  
-- HIVE-19440
ALTER TABLE `GLOBAL_PRIVS` ADD `AUTHORIZER` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL;
ALTER TABLE `GLOBAL_PRIVS` DROP INDEX `GLOBALPRIVILEGEINDEX`;
ALTER TABLE `GLOBAL_PRIVS` ADD CONSTRAINT `GLOBALPRIVILEGEINDEX` UNIQUE(`AUTHORIZER`,`PRINCIPAL_NAME`,`PRINCIPAL_TYPE`,`USER_PRIV`,`GRANTOR`,`GRANTOR_TYPE`);

ALTER TABLE `DB_PRIVS` ADD `AUTHORIZER` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL;
ALTER TABLE `DB_PRIVS` DROP INDEX `DBPRIVILEGEINDEX`;
ALTER TABLE `DB_PRIVS` ADD CONSTRAINT `DBPRIVILEGEINDEX` UNIQUE(`AUTHORIZER`,`DB_ID`,`PRINCIPAL_NAME`,`PRINCIPAL_TYPE`,`DB_PRIV`,`GRANTOR`,`GRANTOR_TYPE`);

ALTER TABLE `TBL_PRIVS` ADD `AUTHORIZER` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL;
ALTER TABLE `TBL_PRIVS` DROP INDEX `TABLEPRIVILEGEINDEX`;
ALTER TABLE `TBL_PRIVS` ADD INDEX `TABLEPRIVILEGEINDEX` (`AUTHORIZER`,`TBL_ID`,`PRINCIPAL_NAME`,`PRINCIPAL_TYPE`,`TBL_PRIV`,`GRANTOR`,`GRANTOR_TYPE`);

ALTER TABLE `PART_PRIVS` ADD `AUTHORIZER` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL;
ALTER TABLE `PART_PRIVS` DROP INDEX `PARTPRIVILEGEINDEX`;
ALTER TABLE `PART_PRIVS` ADD INDEX `PARTPRIVILEGEINDEX` (`AUTHORIZER`,`PART_ID`,`PRINCIPAL_NAME`,`PRINCIPAL_TYPE`,`PART_PRIV`,`GRANTOR`,`GRANTOR_TYPE`);

ALTER TABLE `TBL_COL_PRIVS` ADD `AUTHORIZER` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL;
ALTER TABLE `TBL_COL_PRIVS` DROP INDEX `TABLECOLUMNPRIVILEGEINDEX`;
ALTER TABLE `TBL_COL_PRIVS` ADD INDEX `TABLECOLUMNPRIVILEGEINDEX` (`AUTHORIZER`,`TBL_ID`,`COLUMN_NAME`,`PRINCIPAL_NAME`,`PRINCIPAL_TYPE`,`TBL_COL_PRIV`,`GRANTOR`,`GRANTOR_TYPE`);

ALTER TABLE `PART_COL_PRIVS` ADD `AUTHORIZER` varchar(128) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL;
ALTER TABLE `PART_COL_PRIVS` DROP INDEX `PARTITIONCOLUMNPRIVILEGEINDEX`;
ALTER TABLE `PART_COL_PRIVS` ADD INDEX `PARTITIONCOLUMNPRIVILEGEINDEX` (`AUTHORIZER`,`PART_ID`,`COLUMN_NAME`,`PRINCIPAL_NAME`,`PRINCIPAL_TYPE`,`PART_COL_PRIV`,`GRANTOR`,`GRANTOR_TYPE`);

-- HIVE-19340
ALTER TABLE TXNS ADD COLUMN TXN_TYPE int DEFAULT NULL;

CREATE INDEX TAB_COL_STATS_IDX ON TAB_COL_STATS (CAT_NAME, DB_NAME, TABLE_NAME, COLUMN_NAME) USING BTREE;


-- HIVE-19027
-- add column MATERIALIZATION_TIME (bigint) to MV_CREATION_METADATA table
ALTER TABLE `MV_CREATION_METADATA` ADD `MATERIALIZATION_TIME` BIGINT;
UPDATE `MV_CREATION_METADATA` SET `MATERIALIZATION_TIME` = 0;
ALTER TABLE `MV_CREATION_METADATA` MODIFY COLUMN `MATERIALIZATION_TIME` BIGINT NOT NULL;

-- add column CTC_UPDATE_DELETE (char) to COMPLETED_TXN_COMPONENTS table
ALTER TABLE COMPLETED_TXN_COMPONENTS ADD CTC_UPDATE_DELETE char(1);
UPDATE COMPLETED_TXN_COMPONENTS SET CTC_UPDATE_DELETE = 'N';
ALTER TABLE COMPLETED_TXN_COMPONENTS MODIFY COLUMN CTC_UPDATE_DELETE char(1) NOT NULL;

CREATE TABLE MATERIALIZATION_REBUILD_LOCKS (
  MRL_TXN_ID BIGINT NOT NULL,
  MRL_DB_NAME VARCHAR(128) NOT NULL,
  MRL_TBL_NAME VARCHAR(256) NOT NULL,
  MRL_LAST_HEARTBEAT BIGINT NOT NULL,
  PRIMARY KEY(MRL_TXN_ID)
);


-- These lines need to be last.  Insert any changes above.
UPDATE VERSION SET SCHEMA_VERSION='3.1.0', VERSION_COMMENT='Hive release version 3.1.0' where VER_ID=1;
SELECT 'Finished upgrading MetaStore schema from 3.0.0 to 3.1.0' AS ' ';
