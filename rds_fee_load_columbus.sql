
WHENEVER OSERROR EXIT 1 ROLLBACK
WHENEVER SQLERROR EXIT 100 ROLLBACK

INSERT into WK_BATCH_TRACKER
(RUN_NO, STEP_NAME, START_TIME, END_TIME, RUN_STATUS, ACTIVE_FLAG)
values (to_char(sysdate,'YYYYMMDD'),'RDS FEE',systimestamp,NULL,'R','Y');

COMMIT;


TRUNCATE TABLE dw_PlateFeesTmp_tbl;

INSERT INTO dw_PlateFeesTmp_tbl
      (
        ISN, FEE_ENTITY_ID, FEE_OCCURANCE, FEE_TYPE,
        OP_STATUS, TIMS_TIMESTAMP, ETL_SEQ_CD, Source_ROWID
      )
    SELECT F.ISN, F.SUMM_ENTITY_NUMBER, F.idx, F.SUMM_FEE_TYPE,
      F.OP_STATUS, F.TIMS_TIMESTAMP, F.ETL_SEQ_CD, F.Source_ROWID
    FROM
      (SELECT RANK() OVER (PARTITION BY S.SUMM_ENTITY_NUMBER, F.idx, F.SUMM_FEE_TYPE 
      		ORDER BY S.SUMM_ENTITY_NUMBER, F.idx, F.SUMM_FEE_TYPE, F.ETL_SEQ_CD DESC, F.TIMS_TIMESTAMP DESC) rec_num,
        F.TIMS_TIMESTAMP, F.ISN, S.SUMM_ENTITY_NUMBER, F.idx, F.SUMM_FEE_TYPE,
        F.OP_STATUS, F.etl_status_cd, F.ETL_SEQ_CD, F.ROWID Source_ROWID
      FROM stg_columbus_dtl.SUMM_PLATE_FEES@stg_dblink F 
      	left outer join stg_columbus.tm2_ticket_summary@stg_dblink S on F.ISN = S.ISN
      WHERE F.TIMS_TIMESTAMP IS NOT NULL
      AND F.ETL_STATUS_CD     = 10
      AND S.SUMM_ENTITY_NUMBER  > 0
      AND F.OP_STATUS IN ( 'INSERT', 'DELETE', 'UPDATE', 'SQL COMPUPDATE')
      AND f.tims_timestamp >= (select last_run_date from cfg_batch_run)
      AND f.tims_timestamp < (select last_run_date + days_to_run from cfg_batch_run)
      ---ORDER BY S.SUMM_ENTITY_NUMBER, F.idx, rec_num
      ) F where rec_num = 1;

DELETE FROM RDS_FEE_TBL D
    WHERE EXISTS
      (SELECT 1 FROM dw_PlateFeesTmp_tbl T
      WHERE (D.FEE_ENTITY_ID =  T.FEE_ENTITY_ID OR D.FEE_ENTITY_ID = T.ISN)
      AND D.FEE_OCCURANCE = T.FEE_OCCURANCE
      AND D.FEE_TYPE = T.FEE_TYPE
      AND  (OP_STATUS = 'DELETE'
         OR OP_STATUS = 'UPDATE'
         OR OP_STATUS = 'INSERT'
         OR OP_STATUS = 'SQL COMPUPDATE')
      );

INSERT
    INTO RDS_FEE_TBL
      (
        FEE_ENTITY_ID,
        FEE_OCCURANCE,
        FEE_TYPE,
        FEE_AMOUNT,
        FEE_DATE,
        FEE_AMT_PAID,
        FEE_DEPOSIT_DATE,
        FEE_ACCOUNT_NO,
        FEE_PAY_METHOD,
        FEE_SEQ_NUM,
        FEE_REDUCTION,
        FEE_TIMS_DATE_TIME,
        FEE_RDS_DATE_TIME,
        FEE_TIME,
        FEE_EVENT_TYPE,
        FEE_PAID_USERID,
        FEE_PAID_TIME,
        FEE_PAID_TYPE,
        FEE_PAID_PROCDTE,
        FEE_PAID_MORE,
        FEE_DISPOSITION,
        FEE_DISPO_DATE,
        FEE_DISPO_TIME,
        FEE_DISPO_USERID,
        FEE_DISPO_PLEA,
        FEE_DISPO_PROCDTE,
        FEE_DISPO_MORE,
        FEE_IPP_IND,
        FEE_PAY_BATCH_NO
      )
    SELECT T.FEE_ENTITY_ID,
      F.idx,
      F.SUMM_FEE_TYPE,
      F.AMOUNT,
      TO_DATE(CASE
        WHEN F.SUMM_FEE_DATE = 0 OR F.SUMM_FEE_DATE IS NULL OR length(F.SUMM_FEE_DATE) < 7
        THEN 1990365
        WHEN TO_NUMBER(SUBSTR(F.SUMM_FEE_DATE,5,3)) > 366 OR TO_NUMBER(SUBSTR(F.SUMM_FEE_DATE,5,3)) = 000
        THEN 1990365
        ELSE F.SUMM_FEE_DATE
      END,'YYYYDDD'),
      F.AMT_PAID,
      TO_DATE(
      CASE
        WHEN F.deposit_dte = 0 OR F.deposit_dte IS NULL OR length(F.deposit_dte) < 7
        THEN 1990365
        WHEN TO_NUMBER(SUBSTR(F.deposit_dte,5,3)) > 366 OR TO_NUMBER(SUBSTR(F.deposit_dte,5,3)) = 000
        THEN 1990365
        ELSE F.deposit_dte
      END,'YYYYDDD'),
      F.ACCOUNT_NO,
      F.PAY_METHOD,
      F.SEQ_NUM,
      F.REDUCTION,
      t.tims_timestamp,
      systimestamp,     --rds
      F.SUMM_FEE_TIME,
      F.EVENT_TYPE,
      F.PAID_USERID,
      F.PAID_TIME,
      F.PAID_TYPE,
      TO_DATE(
      CASE
        WHEN F.PAID_PROCDTE = 0 OR F.PAID_PROCDTE IS NULL OR length(F.PAID_PROCDTE) < 7
        THEN 1990365
        WHEN TO_NUMBER(SUBSTR(F.PAID_PROCDTE,5,3)) > 366 OR TO_NUMBER(SUBSTR(F.PAID_PROCDTE,5,3)) = 000
        THEN 1990365
        ELSE F.PAID_PROCDTE
      END,'YYYYDDD'),
      F.PAID_MORE,
      DISPOSITION,
      TO_DATE(
      CASE
        WHEN F.DISPO_DATE = 0 OR F.DISPO_DATE IS NULL OR length(F.DISPO_DATE) < 7
        THEN 1990365
        WHEN TO_NUMBER(SUBSTR(F.DISPO_DATE,5,3)) > 366 OR TO_NUMBER(SUBSTR(F.DISPO_DATE,5,3)) = 000
        THEN 1990365
        ELSE F.DISPO_DATE
      END,'YYYYDDD'),
      F.DISPO_TIME,
      F.DISPO_USERID,
      F.DISPO_PLEA,
      TO_DATE(
      CASE
        WHEN F.DISPO_PROCDTE = 0 OR F.DISPO_PROCDTE IS NULL OR length(F.DISPO_PROCDTE) < 7
        THEN 1990365
        WHEN TO_NUMBER(SUBSTR(F.DISPO_PROCDTE,5,3)) > 366 OR TO_NUMBER(SUBSTR(F.DISPO_PROCDTE,5,3)) = 000
        THEN 1990365
        ELSE F.DISPO_PROCDTE
      END,'YYYYDDD'),
      F.DISPO_MORE,
      F.IPP_IND,
      F.PAY_BATCH_NO
    FROM stg_columbus_dtl.SUMM_PLATE_FEES@stg_dblink F, dw_PlateFeesTmp_tbl T
    WHERE F.ROWID = T.Source_ROWID
    AND f.tims_timestamp >= (select last_run_date from cfg_batch_run)
    AND f.tims_timestamp < (select last_run_date + days_to_run from cfg_batch_run);
    
COMMIT;

UPDATE stg_columbus_dtl.SUMM_PLATE_FEES@stg_dblink S
    SET ETL_STATUS_CD = 20
    WHERE EXISTS (SELECT 1 FROM dw_PlateFeesTmp_tbl T
      WHERE S.ROWID = T.Source_ROWID);

COMMIT;

--select FEE_RDS_DATE_TIME,count(*) from RDS_FEE_TBL where FEE_RDS_DATE_TIME > trunc(sysdate)-2 group by FEE_RDS_DATE_TIME ;

select TRUNC(FEE_RDS_DATE_TIME),count(1) from RDS_FEE_TBL
where FEE_RDS_DATE_TIME > (select last_run_date from cfg_batch_run) AND FEE_RDS_DATE_TIME < SYSDATE
GROUP BY TRUNC(FEE_RDS_DATE_TIME);

update WK_BATCH_TRACKER set end_time=systimestamp, run_status='Y' where STEP_NAME='RDS FEE';
COMMIT;

EXIT;


