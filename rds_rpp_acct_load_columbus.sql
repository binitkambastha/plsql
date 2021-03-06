
WHENEVER OSERROR EXIT 1 ROLLBACK
WHENEVER SQLERROR EXIT 100 ROLLBACK

INSERT into WK_BATCH_TRACKER
(RUN_NO, STEP_NAME, START_TIME, END_TIME, RUN_STATUS, ACTIVE_FLAG)
values (to_char(sysdate,'YYYYMMDD'),'RDS RPP ACCOUNT',systimestamp,NULL,'R','Y');
COMMIT;

TRUNCATE TABLE stg_ACCOUNT_TMP_TBL;

PROMPT "RDS RPP_ACCT: Insert into stg_ACCOUNT_TMP_TBL"

INSERT INTO stg_ACCOUNT_TMP_TBL
(ISN, RPP_ACCOUNT, OP_STATUS, TIMS_TIMESTAMP, ETL_SEQ_CD, Source_ROWID)
SELECT S.ISN, S.RPP_ACCOUNT, S.OP_STATUS, S.TIMS_TIMESTAMP, S.ETL_SEQ_CD,  S.Source_ROWID
FROM ( SELECT RANK() OVER (PARTITION BY S.RPP_ACCOUNT
		   ORDER BY S.RPP_ACCOUNT, S.ISN, S.etl_status_cd, S.ETL_SEQ_CD DESC, S.TIMS_TIMESTAMP DESC) rec_num,
   S.RPP_ACCOUNT, S.ISN, S.OP_STATUS, S.etl_status_cd, S.TIMS_TIMESTAMP, S.ETL_SEQ_CD, S.ROWID AS Source_ROWID
FROM stg_columbus_dtl.TM2_RPP_MASTER@stg_dblink S
WHERE LENGTH(TRIM(S.RPP_ACCOUNT)) > 0
   AND S.etl_status_cd IN (10,20)
   AND tims_timestamp >= (select last_run_date from cfg_batch_run)
   AND tims_timestamp < (select last_run_date + days_to_run from cfg_batch_run)
   AND S.OP_STATUS IN ('INSERT','DELETE','UPDATE','SQL COMPUPDATE')
) S WHERE REC_NUM = 1;

COMMIT;

PROMPT "Delete-Insert RDS_RPP_ACCOUNT_TBL"

DELETE FROM RDS_RPP_ACCOUNT_TBL D WHERE EXISTS ( SELECT 1
FROM stg_ACCOUNT_TMP_TBL T WHERE D.RPP_ACCOUNT = T.RPP_ACCOUNT);

INSERT INTO RDS_RPP_ACCOUNT_TBL
( RPP_ACCOUNT, RPP_DISTRICT, RPP_BLOCK, RPP_STREET_NUMBER,
RPP_STREET_SUB_NUMBER, RPP_STREET_PREFIX, RPP_STREET_SUFFIX, RPP_STREET_POST_SUFFIX,
RPP_STREET_INT_NUMBER, RPP_APT_NUMBER, RPP_ZIP_CODE, RPP_MAIL_TO_NAME,
RPP_MAIL_TO_STREET, RPP_MAIL_TO_CITY, RPP_MAIL_TO_STATE, RPP_MAIL_TO_ZIP,
RPP_ACCOUNT_ESTAB_DATE,RPP_ACCOUNT_TYPE, RPP_ACCOUNT_STATUS, RPP_ACCOUNT_STATUS_DATE,
RPP_EMAIL_ADDRESS, RPP_PHONE_NUMBER,
RPP_PERMIT_CODE_1, RPP_PERMIT_COUNT_1, RPP_PERMIT_CODE_2, RPP_PERMIT_COUNT_2,
RPP_PERMIT_CODE_3, RPP_PERMIT_COUNT_3, RPP_PERMIT_CODE_4, RPP_PERMIT_COUNT_4,
RPP_PERMIT_CODE_5, RPP_PERMIT_COUNT_5, rpp_tims_date_time, rpp_rds_update_date )
SELECT RPP.RPP_ACCOUNT, RPP_DISTRICT, RPP_BLOCK, RPP_STREET_NUMBER,
RPP_STREET_SUB_NUMBER, RPP_STREET_PREFIX, RPP_STREET_SUFFIX, RPP_STREET_POST_SUFFIX,
RPP_STREET_INT_NUMBER, RPP_APT_NUMBER, RPP_ZIP_CODE, RPP_MAIL_TO_NAME,
RPP_MAIL_TO_STREET, RPP_MAIL_TO_CITY, RPP_MAIL_TO_STATE, RPP_MAIL_TO_ZIP,
TO_DATE(CASE WHEN RPP.RPP_ACCOUNT_ESTAB_DATE IN (0,99999999) THEN 19501231 ELSE RPP.RPP_ACCOUNT_ESTAB_DATE END,'YYYYMMDD') AS RPP_ACCOUNT_ESTAB_DATE,
RPP_ACCOUNT_TYPE, RPP_ACCOUNT_STATUS,
TO_DATE(CASE WHEN RPP.RPP_ACCOUNT_STATUS_DATE IN (0,99999999) THEN 19501231 ELSE RPP.RPP_ACCOUNT_STATUS_DATE END,'YYYYMMDD') AS RPP_ACCOUNT_STATUS_DATE,
RPP_MAIL_ADDRESS, RPP_PHONE_NUMBER,
CODE_01.IT_CODE AS RPP_PERMIT_CODE_1, CODE_01.IT_COUNT AS RPP_PERMIT_COUNT_1,
CODE_02.IT_CODE AS RPP_PERMIT_CODE_2, CODE_02.IT_COUNT AS RPP_PERMIT_COUNT_2,
CODE_03.IT_CODE AS RPP_PERMIT_CODE_3, CODE_03.IT_COUNT AS RPP_PERMIT_COUNT_3,
CODE_04.IT_CODE AS RPP_PERMIT_CODE_4, CODE_04.IT_COUNT AS RPP_PERMIT_COUNT_4,
CODE_05.IT_CODE AS RPP_PERMIT_CODE_5, CODE_05.IT_COUNT AS RPP_PERMIT_COUNT_5,
T.tims_timestamp, systimestamp
FROM stg_columbus_dtl.TM2_RPP_MASTER@stg_dblink RPP JOIN stg_ACCOUNT_TMP_TBL T
ON RPP.ROWID = T.SOURCE_ROWID
AND rpp.tims_timestamp >= (select last_run_date from cfg_batch_run)
AND rpp.tims_timestamp < (select last_run_date + days_to_run from cfg_batch_run) 
LEFT OUTER JOIN
( SELECT ISN, IDX, IT_CODE, IT_COUNT
FROM stg_columbus_dtl.RPP_ACTIVE_COUNTS@stg_dblink
WHERE IT_CODE ='A' ) CODE_01
ON RPP.ISN = CODE_01.ISN
AND SUBSTR(RPP.PERMIT_TYPE, 1 , 1)  = SUBSTR(CODE_01.IT_CODE, 1 , 1 )
LEFT OUTER JOIN
( SELECT ISN, IDX, IT_CODE, IT_COUNT
FROM stg_columbus_dtl.RPP_ACTIVE_COUNTS@stg_dblink
WHERE IT_CODE ='G' ) CODE_02
ON RPP.ISN = CODE_02.ISN
AND SUBSTR(RPP.PERMIT_TYPE, 1 , 1)  = SUBSTR(CODE_02.IT_CODE, 1 , 1 )
LEFT OUTER JOIN
( SELECT ISN, IDX, IT_CODE, IT_COUNT
FROM stg_columbus_dtl.RPP_ACTIVE_COUNTS@stg_dblink
WHERE IT_CODE ='V' ) CODE_03
ON RPP.ISN = CODE_03.ISN
AND SUBSTR(RPP.PERMIT_TYPE, 1 , 1)  = SUBSTR(CODE_03.IT_CODE, 1 , 1 )
LEFT OUTER JOIN
( SELECT ISN, IDX, IT_CODE, IT_COUNT
FROM stg_columbus_dtl.RPP_ACTIVE_COUNTS@stg_dblink
WHERE IT_CODE ='R' ) CODE_04
ON RPP.ISN = CODE_04.ISN
AND SUBSTR(RPP.PERMIT_TYPE, 1 , 1)  = SUBSTR(CODE_04.IT_CODE, 1 , 1 )
LEFT OUTER JOIN
( SELECT ISN, IDX, IT_CODE, IT_COUNT
FROM stg_columbus_dtl.RPP_ACTIVE_COUNTS@stg_dblink
WHERE IT_CODE ='T' ) CODE_05
ON RPP.ISN = CODE_05.ISN
AND SUBSTR(RPP.PERMIT_TYPE, 1 , 1)  = SUBSTR(CODE_05.IT_CODE, 1 , 1 );

COMMIT;

PROMPT "Update status at source"

UPDATE stg_columbus_dtl.TM2_RPP_MASTER@stg_dblink S
SET ETL_STATUS_CD = 20
WHERE EXISTS (SELECT 1
      FROM stg_ACCOUNT_TMP_TBL T
      WHERE S.RPP_ACCOUNT = T.RPP_ACCOUNT
      );

COMMIT;


--***Validation*** the below 2 table counts should match
select count(1), count(distinct RPP_ACCOUNT) from stg_columbus.TM2_RPP_MASTER@stg_dblink
where RPP_ACCOUNT > 0 
   AND tims_timestamp >= (select last_run_date from cfg_batch_run)
   AND tims_timestamp < (select last_run_date + days_to_run from cfg_batch_run);

select count(1) from RDS_RPP_ACCOUNT_TBL where rpp_rds_update_date > trunc(sysdate);

update WK_BATCH_TRACKER set end_time=systimestamp, run_status='Y' where STEP_NAME='RDS RPP ACCOUNT';
COMMIT;

EXIT;
