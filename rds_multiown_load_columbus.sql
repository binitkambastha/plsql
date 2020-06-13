
WHENEVER OSERROR EXIT 1 ROLLBACK
WHENEVER SQLERROR EXIT 100 ROLLBACK

PROMPT "RDS MULTI-OWNER step.."

INSERT into WK_BATCH_TRACKER
(RUN_NO, STEP_NAME, START_TIME, END_TIME, RUN_STATUS, ACTIVE_FLAG)
values (to_char(sysdate,'YYYYMMDD'),'RDS MULTI-OWNER',systimestamp,NULL,'R','Y');
COMMIT;

TRUNCATE TABLE DW_MULTI_OWNER_TMP_TBL;

INSERT INTO DW_MULTI_OWNER_TMP_TBL
        (ISN,MULT_OWNER_PARTY_NUMBER,OP_STATUS,TIMS_TIMESTAMP,ETL_SEQ_CD,SOURCE_ROWID)
        SELECT S.ISN,S.MULT_OWNER_PARTY_NUMBER,S.OP_STATUS,S.TIMS_TIMESTAMP,S.ETL_SEQ_CD,S.SOURCE_ROWID
        FROM ( SELECT RANK() OVER (PARTITION BY TO_NUMBER(TYPE||lpad(owner_id,4,'0')||lpad(fleet_number,3,'0'))
                             ORDER BY S.ISN, S.etl_status_cd, S.ETL_SEQ_CD DESC, S.TIMS_TIMESTAMP DESC) rec_num,
                   TO_NUMBER(S.TYPE||lpad(S.OWNER_ID,4,'0')||lpad(S.Fleet_Number,3,'0')) as MULT_OWNER_PARTY_NUMBER,S.ISN, S.OP_STATUS, S.etl_status_cd, S.TIMS_TIMESTAMP, S.ETL_SEQ_CD, S.ROWID AS Source_ROWID
               FROM STG_COLUMBUS_DTL.TM2_MULTI_OWNER@stg_dblink S
               WHERE LENGTH(TRIM(TO_NUMBER(S.TYPE||lpad(S.OWNER_ID,4,'0')||lpad(S.Fleet_Number,3,'0')))) > 0 
               AND S.etl_status_cd = 10
                   AND S.OP_STATUS IN ( 'INSERT', 'DELETE', 'UPDATE', 'SQL COMPUPDATE','PK UPDATE')
AND s.tims_timestamp >= (select last_run_date from cfg_batch_run)
AND s.tims_timestamp < (select last_run_date + days_to_run from cfg_batch_run) 
             ) S WHERE REC_NUM = 1 ;

PROMPT "Delete-Insert RDS multiowner .."
DELETE FROM RDS_MULTI_OWNER_TBL D
        WHERE EXISTS
        ( SELECT 1
          FROM DW_MULTI_OWNER_TMP_TBL T
          WHERE D.MULT_OWNER_PARTY_NUMBER = T.MULT_OWNER_PARTY_NUMBER
           AND ( T.OP_STATUS = 'INSERT' OR T.OP_STATUS = 'UPDATE' OR T.OP_STATUS = 'SQL COMPUPDATE' OR T.OP_STATUS ='PK UPDATE'));

INSERT INTO RDS_MULTI_OWNER_TBL
        (   MULT_OWNER_PARTY_NUMBER,
            MULT_LAST_NAME,
            MULT_NAME,
            MULT_CONTACT,
            MULT_CONTACT_ADDR1,
            MULT_CONTACT_ADDR2,
            MULT_CONTACT_CITY,
            MULT_CONTACT_STATE,
            MULT_CONTACT_ZIP_CODE,
            MULT_PHONE,
            MULT_EMAIL_ADDRESS,
            MULT_CONTACT2,
            MULT_PHONE2,
            MULT_EMAIL_ADDRESS2,
            MULT_ADDRESS_LINE_1,
            MULT_ADDRESS_LINE_2,
            MULT_COUNTRY,
            MULT_CITY,
            MULT_STATE,
            MULT_ZIP_CODE,
            MULT_STATUS,
            MULT_PROCESSING_RULES,
            MULT_DATE_ADDED,
            MULT_DATE_LAST_CHANGE,
            MULT_DATE_EFFECTIVE,
            MULT_DATE_TERMINATE,
            MULT_CLERK_ID,
            MULT_SPLIT_RULE,
            MULT_IMAGE_IND,
            MULT_ALPHA_FILL_2,
            MULT_NUMERIC_FILL_1,
            MULT_NUMERIC_FILL_2,
            MULT_TIMS_DATE_TIME,
            MULT_RDS_DATE_TIME
        )
          SELECT
            TO_NUMBER(S.TYPE||lpad(S.OWNER_ID,4,'0')||lpad(S.Fleet_Number,3,'0')),
            S.LAST_NAME,
            S.NAME,
            S.CONTACT,
            S.CONTACT_ADDR1,
            S.CONTACT_ADDR2,
            S.CONTACT_CITY,
            S.CONTACT_STATE,
            S.CONTACT_ZIP_CODE,
            S.PHONE,
            S.EMAIL_ADDRESS,
            S.CONTACT2,
            S.PHONE2,
            S.EMAIL_ADDRESS2,
            S.ADDRESS_LINE_1,
            S.ADDRESS_LINE_2,
            S.COUNTRY,
            S.CITY,
            S.STATE,
            S.ZIP_CODE,
            S.STATUS,
            S.PROCESSING_RULES,
            TO_DATE(CASE WHEN S.DATE_ADDED IN (0,9999999) THEN 1950365 ELSE S.DATE_ADDED END,'YYYYDDD') as DATE_ADDED,
            TO_DATE(CASE WHEN S.DATE_LAST_CHANGE IN (0,9999999) THEN 1950365 ELSE S.DATE_LAST_CHANGE END,'YYYYDDD') as DATE_LAST_CHANGE,
            TO_DATE(CASE WHEN S.DATE_EFFECTIVE IN (0,9999999) THEN 1950365 ELSE S.DATE_EFFECTIVE END,'YYYYDDD') as DATE_EFFECTIVE,
            TO_DATE(CASE WHEN S.DATE_TERMINATE IN (0,9999999) THEN 1950365 ELSE S.DATE_TERMINATE END,'YYYYDDD') as DATE_TERMINATE,
            S.CLERK_ID,
            S.SPLIT_RULE,
            S.IMAGE_IND,
            S.ALPHA_FILL_2,
            S.EMAIL_IND,
            S.NUMERIC_FILL_2,
            t.tims_timestamp,
            systimestamp 
          FROM STG_COLUMBUS_DTL.TM2_MULTI_OWNER@stg_dblink S JOIN DW_MULTI_OWNER_TMP_TBL T ON S.ROWID = T.SOURCE_ROWID ;
COMMIT;

PROMPT "Update status..."
UPDATE STG_COLUMBUS_DTL.TM2_MULTI_OWNER@stg_dblink S
          SET ETL_STATUS_CD = 20
          WHERE EXISTS (SELECT 1
                        FROM DW_MULTI_OWNER_TMP_TBL T
                        where S.ROWID = T.SOURCE_ROWID
                        );

COMMIT;

update WK_BATCH_TRACKER set end_time=systimestamp, run_status='Y' where STEP_NAME='RDS MULTI-OWNER';
COMMIT;

EXIT;

