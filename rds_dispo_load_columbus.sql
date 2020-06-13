
WHENEVER OSERROR EXIT 1 ROLLBACK
WHENEVER SQLERROR EXIT 100 ROLLBACK

INSERT into WK_BATCH_TRACKER
(RUN_NO, STEP_NAME, START_TIME, END_TIME, RUN_STATUS, ACTIVE_FLAG)
values (to_char(sysdate,'YYYYMMDD'),'RDS DISPO',systimestamp,NULL,'R','Y');
COMMIT;

TRUNCATE TABLE  stg_rds_disposition_tbl reuse storage;

PROMPT "RDS DISPO: Insert into stg_rds_disposition_tbl"
INSERT INTO stg_rds_disposition_tbl
		( 
			DISP_NUMBER, 
			DISP_HEAR_DISPOSITN, 
			DISP_DISPO_PROCESS_DTE, 
			DISP_DISPO_PROCESS_TIME, 
			DISP_HEARING_OFFICER, 
			DISP_FINE_AMOUNT, 
			DISP_PENALTY_1,    
			DISP_PENALTY_2,
			DISP_PENALTY_3, 
			DISP_PENALTY_4, 
			DISP_PENALTY_5, 
			DISP_HEARING_CLERK,
			DISP_HEARING_DATE,
			DISP_PLEA_CODE, 
			DISP_REDUCTION_AMOUNT, 
			DISP_DISPOSITION_DATE, 
			DISP_DISPOSITION_CLERK, 
			DISP_DISPOSITION_BATCH, 
			DISP_VIOLATION_CODE, 
			DISP_SPEED_ACTUAL, 
			DISP_TIMS_DATE_TIME,
			DISP_RDS_UPDATE_DATE
		)
	select  
		TICKET_NUMBER,
		DISP_HEAR_DISPOSITN,
		DISP_DISPO_PROCESS_DTE, 
		DISP_DISPO_PROCESS_TIME, 
		DISP_HEARING_OFFICER, 
		DISP_FINE_AMOUNT, 
		DISP_PENALTY_1,    
		DISP_PENALTY_2,
		DISP_PENALTY_3, 
		DISP_PENALTY_4, 
		DISP_PENALTY_5, 
		DISP_HEARING_CLERK,
		DISP_HEARING_DATE,
		DISP_PLEA_CODE, 
		DISP_REDUCTION_AMOUNT, 
		DISP_DISPOSITION_DATE, 
		DISP_DISPOSITION_CLERK, 
		DISP_DISPOSITION_BATCH, 
		DISP_VIOLATION_CODE, 
		DISP_SPEED_ACTUAL, 
		tims_timestamp,
		SYSTIMESTAMP
from 
(
  select RANK () over (partition by  TICKET_NUMBER,DISP_HEAR_DISPOSITN,DISP_DISPO_PROCESS_DTE, DISP_DISPO_PROCESS_TIME, DISP_HEARING_OFFICER
	order by tims_timestamp desc, etl_seq_cd DESC) rec_no,
	TICKET_NUMBER,DISP_HEAR_DISPOSITN,DISP_DISPO_PROCESS_DTE, DISP_DISPO_PROCESS_TIME, DISP_HEARING_OFFICER, DISP_FINE_AMOUNT, DISP_PENALTY_1, DISP_PENALTY_2, 
	DISP_PENALTY_3, DISP_PENALTY_4, DISP_PENALTY_5, DISP_HEARING_CLERK,DISP_HEARING_DATE,DISP_PLEA_CODE, DISP_REDUCTION_AMOUNT, 
	DISP_DISPOSITION_DATE, DISP_DISPOSITION_CLERK, DISP_DISPOSITION_BATCH, DISP_VIOLATION_CODE, DISP_SPEED_ACTUAL, tims_timestamp,SYSTIMESTAMP 
  from  (SELECT TICKET_NUMBER, 
		DISP_CODE DISP_HEAR_DISPOSITN, 
            TO_DATE(CASE WHEN DISP_PROCESS_DTE IN (0,9999999) THEN 1950365 ELSE DISP_PROCESS_DTE END,'YYYYDDD') DISP_DISPO_PROCESS_DTE,
            24000 - BATCH_TIME DISP_DISPO_PROCESS_TIME, 
			HEARING_OFFICER DISP_HEARING_OFFICER,
			HEARING_FINE DISP_FINE_AMOUNT, 
			HEARING_PEN1 DISP_PENALTY_1,
			HEARING_PEN2 DISP_PENALTY_2,
			HEARING_PEN3 DISP_PENALTY_3,
			HEARING_PEN4 DISP_PENALTY_4,
			HEARING_PEN5 DISP_PENALTY_5, 
			HEARING_CLERK DISP_HEARING_CLERK,
			TO_DATE(CASE WHEN HEARING_DATE IN (0,9999999) THEN 1950365 ELSE HEARING_DATE END, 'YYYYDDD') DISP_HEARING_DATE, 
			HEARING_PLEA_CODE DISP_PLEA_CODE, 
			HEARING_REDUCE_AMT DISP_REDUCTION_AMOUNT, 
			TO_DATE(CASE WHEN DISP_DTE IN (0,9999999) THEN 1950365 ELSE DISP_DTE END, 'YYYYDDD') DISP_DISPOSITION_DATE, 
			DISP_CLERK DISP_DISPOSITION_CLERK, 
			DISPOSITION_BATCH DISP_DISPOSITION_BATCH,
			PAY_BATCH_NUM DISP_VIOLATION_CODE,
			Null DISP_SPEED_ACTUAL, 
			tims_timestamp , 
			SYSTIMESTAMP,
			etl_seq_cd
	    from todays_tm2_ticket_hist 
	    WHERE trans_code LIKE '07_' 
		AND TICKET_NUMBER > '0' 
		AND BATCH_TIME > 0 
		AND DISP_PROCESS_DTE IS NOT NULL
		AND HEARING_OFFICER > ' ' 
		AND DISP_CODE > 0
		AND OP_STATUS      IN ( 'INSERT', 'UPDATE', 'SQL COMPUPDATE','PK UPDATE')
AND tims_timestamp >= (select last_run_date from cfg_batch_run)
AND tims_timestamp < (select last_run_date + days_to_run from cfg_batch_run) 
	UNION 
	     SELECT 
			S.TICK_NUMBER TICKET_NUMBER, 
			HEAR_DISPOSITN DISP_HEAR_DISPOSITN, 
			TO_DATE(CASE WHEN NVL(DISPO_PROCESS_DTE,0) = 0 THEN 1950365 else DISPO_PROCESS_DTE END,'YYYYDDD') DISP_DISPO_PROCESS_DTE,
            S.DISPO_PROCESS_TIME DISP_DISPO_PROCESS_TIME, 
			S.HEARING_OFFICER DISP_HEARING_OFFICER, 
			S.FINE_AMOUNT DISP_FINE_AMOUNT, 
			S.PENALTY_1 DISP_PENALTY_1,
			S.PENALTY_2 DISP_PENALTY_2,
			S.PENALTY_3 DISP_PENALTY_3,
			S.PENALTY_4 DISP_PENALTY_4,
			S.PENALTY_5 DISP_PENALTY_5, 
			HEARING_CLERK DISP_HEARING_CLERK,
			TO_DATE(CASE WHEN NVL (HEARING_DATE,0) = 0 THEN 1950365 ELSE HEARING_DATE END, 'YYYYDDD') DISP_HEARING_DATE, 
			S.PLEA_CODE DISP_PLEA_CODE, 
			S.REDUCTION_AMOUNT DISP_REDUCTION_AMOUNT, 
			TO_DATE(CASE WHEN NVL (DISPOSITION_DATE,0) = 0 THEN 1950365 ELSE DISPOSITION_DATE END, 'YYYYDDD') DISP_DISPOSITION_DATE,
			S.DISPOSITION_CLERK DISP_DISPOSITION_CLERK, 
			S.DISPOSITION_BATCH DISP_DISPOSITION_BATCH,
			S.VIOLATION_CODE DISP_VIOLATION_CODE,
			SPEED_ACTUAL DISP_SPEED_ACTUAL, 
			Tims_timestamp , 
			SYSTIMESTAMP,
			etl_seq_cd
	from todays_catchup_tick_segment2 S 
		WHERE 	TICK_NUMBER > '0' 
			AND HEAR_DISPOSITN > '0' 
			AND DISPO_PROCESS_DTE > 0 
			AND DISPO_PROCESS_TIME > '0' 
			AND HEARING_OFFICER > ' '
AND s.tims_timestamp >= (select last_run_date from cfg_batch_run)
AND s.tims_timestamp < (select last_run_date + days_to_run from cfg_batch_run) 
			AND OP_STATUS      IN ( 'INSERT', 'UPDATE', 'SQL COMPUPDATE','PK UPDATE')
)) where rec_no = 1;

COMMIT;

PROMPT "Delete-Insert rds_disposition_tbl"

delete from rds_disposition_tbl where ( DISP_NUMBER,DISP_HEAR_DISPOSITN,DISP_DISPO_PROCESS_DTE, DISP_DISPO_PROCESS_TIME, DISP_HEARING_OFFICER) IN 
( select DISP_NUMBER,DISP_HEAR_DISPOSITN,DISP_DISPO_PROCESS_DTE, DISP_DISPO_PROCESS_TIME, DISP_HEARING_OFFICER from stg_rds_disposition_tbl );

insert into rds_disposition_tbl
	( 
		DISP_NUMBER, 
		DISP_HEAR_DISPOSITN, 
		DISP_DISPO_PROCESS_DTE, 
		DISP_DISPO_PROCESS_TIME, 
		DISP_HEARING_OFFICER, 
		DISP_FINE_AMOUNT , 
		DISP_PENALTY_1,
		DISP_PENALTY_2,
		DISP_PENALTY_3, 
		DISP_PENALTY_4, 
		DISP_PENALTY_5, 
		DISP_HEARING_CLERK, 
		DISP_HEARING_DATE, 
		DISP_PLEA_CODE,
		DISP_REDUCTION_AMOUNT,
		DISP_DISPOSITION_DATE,
		DISP_DISPOSITION_CLERK, 
		DISP_DISPOSITION_BATCH ,
		DISP_VIOLATION_CODE, 
		DISP_SPEED_ACTUAL, 
		DISP_TIMS_DATE_TIME,
		DISP_RDS_UPDATE_DATE
	)
	select  
		DISP_NUMBER, 
		DISP_HEAR_DISPOSITN, 
		DISP_DISPO_PROCESS_DTE, 
		DISP_DISPO_PROCESS_TIME, 
		DISP_HEARING_OFFICER, 
		DISP_FINE_AMOUNT , 
		DISP_PENALTY_1,
		DISP_PENALTY_2,
		DISP_PENALTY_3, 
		DISP_PENALTY_4, 
		DISP_PENALTY_5, 
		DISP_HEARING_CLERK, 
		DISP_HEARING_DATE, 
		DISP_PLEA_CODE, 
		DISP_REDUCTION_AMOUNT,
		DISP_DISPOSITION_DATE,
		DISP_DISPOSITION_CLERK, 
		DISP_DISPOSITION_BATCH ,
		DISP_VIOLATION_CODE, 
		DISP_SPEED_ACTUAL, 
		DISP_TIMS_DATE_TIME,
		DISP_RDS_UPDATE_DATE	from stg_rds_disposition_tbl;

COMMIT;

PROMPT "Basic count check"
select count(1), count(DISP_RDS_UPDATE_DATE), count(disp_tims_date_time) from rds_disposition_tbl
where ( DISP_NUMBER,DISP_HEAR_DISPOSITN, DISP_DISPO_PROCESS_DTE, DISP_DISPO_PROCESS_TIME, DISP_HEARING_OFFICER ) IN
( select  DISP_NUMBER,DISP_HEAR_DISPOSITN, DISP_DISPO_PROCESS_DTE, DISP_DISPO_PROCESS_TIME, DISP_HEARING_OFFICER
from stg_rds_disposition_tbl);

PROMPT "Update status steps.."

UPDATE todays_catchup_tick_segment2 
SET ETL_STATUS_CD = 19 WHERE ETL_STATUS_CD = 18;
commit;

UPDATE todays_tm2_ticket_hist 
SET ETL_STATUS_CD = 20 WHERE ETL_STATUS_CD = 15 and trans_code LIKE '07_' AND TICKET_NUMBER > '0' AND DISP_CODE > '0' AND NVL(DISP_PROCESS_DTE, 0) <> 0 and BATCH_TIME > 0 and HEARING_OFFICER > ' ';
commit;

UPDATE stg_columbus_dtl.TM2_TICKET_HISTORY@stg_dblink 
SET ETL_STATUS_CD = 20 WHERE ETL_STATUS_CD = 15 and trans_code LIKE '07_' AND TICKET_NUMBER > '0' AND DISP_CODE > '0' AND NVL(DISP_PROCESS_DTE, 0) <> 0 and BATCH_TIME > 0 and HEARING_OFFICER > ' ';
commit;

UPDATE stg_columbus_dtl.TICK_SEGMENT@stg_dblink
SET ETL_STATUS_CD = 55 WHERE ETL_STATUS_CD = 15 and tick_number in (select DISP_NUMBER from stg_rds_disposition_tbl);
commit;

update WK_BATCH_TRACKER set end_time=systimestamp, run_status='Y' where STEP_NAME='RDS DISPO';
COMMIT;

EXIT;
