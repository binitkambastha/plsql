WHENEVER OSERROR EXIT 1 ROLLBACK
WHENEVER SQLERROR EXIT 100 ROLLBACK

INSERT into WK_BATCH_TRACKER
(RUN_NO, STEP_NAME, START_TIME, END_TIME, RUN_STATUS, ACTIVE_FLAG)
values (to_char(sysdate,'YYYYMMDD'),'RDS CORRESP',systimestamp,NULL,'R','Y');
COMMIT;

TRUNCATE TABLE  stg_rds_correspondence_tbl reuse storage;

PROMPT "RDS CORRESP: Insert into stg_rds_correspondence_tbl"

INSERT INTO stg_rds_correspondence_tbl
		( 
			COR_TICKET_NUMBER, 
			COR_PROCESS_DATE, 
			COR_PROCESS_TIME, 
			COR_TYPE, 
			COR_LETTER_TYPE, 
			COR_CLERK_ID , 
			COR_SENT_IND,
			COR_COMMENTS , 
			COR_TIMS_DATE_TIME,
			COR_RDS_DATE_TIME
		)
select  TICKET_NUMBER, COR_PROCESS_DATE, COR_PROCESS_TIME, CORR_TYPE, 
		LETTER_TYPE, COR_CLERK_ID , CORR_SENT_IND, COR_COMMENTS , 
		tims_timestamp,SYSTIMESTAMP
from (  select RANK () over (partition by  TICKET_NUMBER,COR_PROCESS_DATE,
		COR_PROCESS_TIME, CORR_TYPE  
		order by tims_timestamp desc, etl_seq_cd DESC) rec_no,
		TICKET_NUMBER,COR_PROCESS_DATE,COR_PROCESS_TIME, CORR_TYPE, LETTER_TYPE, 
		COR_CLERK_ID,CORR_SENT_IND,COR_COMMENTS, tims_timestamp,SYSTIMESTAMP 
	FROM  
	(SELECT
	    TICKET_NUMBER, 
        TO_DATE(CASE WHEN batch_date IN (0,9999999) THEN 1950365 ELSE 9999999-batch_date END,'YYYYDDD') COR_PROCESS_DATE,
        24000 - BATCH_TIME COR_PROCESS_TIME, 
		CORR_TYPE , 
		LETTER_TYPE , 
		CLERK_ID COR_CLERK_ID , 
		CORR_SENT_IND , 
		COMMENTS_DATA COR_COMMENTS ,
		tims_timestamp, 
		SYSTIMESTAMP,
		etl_seq_cd
	    from todays_tm2_ticket_hist t
		WHERE 
		trans_code LIKE '15_' 
		AND TICKET_NUMBER > '0' 
		AND CORR_TYPE > 0 
		AND NVL(batch_date, 0) <> 0
		AND OP_STATUS      IN ( 'INSERT', 'UPDATE', 'SQL COMPUPDATE','PK UPDATE')
AND t.tims_timestamp >= (select last_run_date  from cfg_batch_run)
AND t.tims_timestamp < (select last_run_date + days_to_run from cfg_batch_run)
    UNION 
	    SELECT 
			TICK_NUMBER, 
			TO_DATE(CASE WHEN NVL(CORR_DATE,0) = 0 THEN 1950365 else CORR_DATE END,'YYYYDDD') COR_PROCESS_DATE,
			CORR_TIME , 
			CORR_TYPE , 
			LETTER_TYPE , 
			CORR_CLERK ,
			CORR_SENT_IND,
			S.corr_email_address COMMENTS_DATA,
			tims_timestamp, 
			SYSTIMESTAMP,
			etl_seq_cd
	    from todays_catchup_tick_segment2 S
		WHERE 
			TICK_NUMBER > '0' 
			AND CORR_DATE > '0' 
			AND CORR_TIME > 0 
			AND CORR_TYPE > 0
			AND OP_STATUS IN ( 'INSERT', 'UPDATE', 'SQL COMPUPDATE','PK UPDATE')
AND s.tims_timestamp >= (select last_run_date from cfg_batch_run)
AND s.tims_timestamp < (select last_run_date + days_to_run from cfg_batch_run)
)) where rec_no = 1;
    
COMMIT;

PROMPT "Delete-Insert rds_correspondence_tbl"

delete from rds_correspondence_tbl where ( COR_TICKET_NUMBER,COR_PROCESS_DATE,COR_PROCESS_TIME, COR_TYPE) IN 
( select COR_TICKET_NUMBER,COR_PROCESS_DATE,COR_PROCESS_TIME, COR_TYPE from stg_rds_correspondence_tbl );

insert into rds_correspondence_tbl
	( 
		COR_TICKET_NUMBER, 
		COR_PROCESS_DATE, 
		COR_PROCESS_TIME, 
		COR_TYPE, 
		COR_LETTER_TYPE, 
		COR_CLERK_ID , 
		COR_SENT_IND,
        COR_COMMENTS,
		cor_tims_date_time,
		cor_RDS_DATE_TIME 
	)
select  COR_TICKET_NUMBER, 
		COR_PROCESS_DATE, 
		COR_PROCESS_TIME, 
		COR_TYPE, 
		COR_LETTER_TYPE, 
		COR_CLERK_ID , 
		COR_SENT_IND,
		COR_COMMENTS, 
		cor_tims_date_time, 
		cor_RDS_DATE_TIME from stg_rds_correspondence_tbl;

COMMIT;

PROMPT "Update staus steps.."

UPDATE todays_catchup_tick_segment2 
SET ETL_STATUS_CD = 18 WHERE ETL_STATUS_CD = 17;
COMMIT;

UPDATE todays_tm2_ticket_hist 
SET ETL_STATUS_CD = 20 WHERE ETL_STATUS_CD = 15 and trans_code LIKE '15_' AND TICKET_NUMBER > '0' AND corr_type > '0' AND NVL(batch_date, 0) <> 0;
COMMIT;

UPDATE stg_columbus_dtl.TM2_TICKET_HISTORY@stg_dblink 
SET ETL_STATUS_CD = 20 WHERE ETL_STATUS_CD = 15 and trans_code LIKE '15_' AND TICKET_NUMBER > '0' AND corr_type > '0' AND NVL(batch_date, 0) <> 0;
COMMIT;

UPDATE stg_columbus_dtl.TICK_SEGMENT@stg_dblink
SET ETL_STATUS_CD = 45 WHERE ETL_STATUS_CD = 15 and tick_number in (select cor_ticket_number from stg_rds_correspondence_tbl);
COMMIT;

update WK_BATCH_TRACKER set end_time=systimestamp, run_status='Y' where STEP_NAME='RDS CORRESP';
COMMIT;



EXIT;

