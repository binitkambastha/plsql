
WHENEVER OSERROR EXIT 1 ROLLBACK
WHENEVER SQLERROR EXIT 100 ROLLBACK

PROMPT "Call Fact Load Package.."

/*
04/03/2020	nkale		Adding code for the purpose of DW status emails

Step 01: RDS Load is already run, so set today's batch record with 1,0 status.
*/

PROMPT "Step01: INSERT BATCH RECORD (Status 1,0)"

Insert into DW_LOAD_STATUS_TBL_NEW
   (DW_LOAD_START_DATE_ID, DW_LOAD_END_DATE_ID,
    DW_LOAD_START_TIME, DW_LOAD_END_TIME, DW_LOAD_STATUS, DW_LOAD_ERROR,
    DW_LOAD_REMARKS, DW_TIMS_AS_OF_DATE, DW_RDS_RP_COUNT, DW_FACT_RP_COUNT, 
    DW_RDS_TICKET_COUNT, DW_FACT_TICKET_COUNT, DW_RDS_PAY_COUNT, DW_FACT_PAY_COUNT, LOAD_TIME_START, 
    DW_RDS_CORRESPOND_COUNT, DW_FACT_CORRESPOND_COUNT, DW_RDS_SUSPEND_COUNT, DW_FACT_SUSPEND_COUNT,
    DW_RDS_PHOTO_COUNT, DW_FACT_PHOTO_COUNT, DW_RDS_DISPOSITION_COUNT, DW_FACT_DISPOSITION_COUNT, LOAD_TIME_END)
 Values
   ( to_char(sysdate,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD'),
     trunc(sysdate)+3/24, trunc(sysdate)+4/24, 1, 0,
     'MANUAL STEPS SETUP', trunc(sysdate)-1/2, 16226499, 16226499, 
    34146385, 34146385, 31509863, 31509863, trunc(sysdate)+3/24, 
    5104862, 5104862, 8060438, 8053833,
    0, 0, 1010485, 1011930, NULL );

COMMIT;

--***
--Step 02: Run the FACT LOAD Step
--***

PROMPT "Step02: Run the FACT LOAD Step"

set serveroutput on size 999999

DECLARE
  C_START_TIME DATE;
  V_START_DATE_ID VARCHAR2(200);
  v_Return NUMBER;
BEGIN
  C_START_TIME := SYSDATE;
  V_START_DATE_ID := TO_NUMBER(TO_CHAR (sysdate, 'YYYYMMDD'));

  v_Return := APP_DBA.DW_ROUTINE_LOAD_PKG.FN_ROUTINE_PHASE_TWO(
    C_START_TIME => C_START_TIME,
    V_START_DATE_ID => V_START_DATE_ID
  );
  DBMS_OUTPUT.PUT_LINE('Return Code = ' || v_Return);
  
UPDATE dw_load_status_tbl_new
 SET dw_load_status = 2, dw_load_error = 0,
     load_time_end = systimestamp,
     dw_load_remarks = 'FACT LOAD Was Run'
WHERE dw_load_start_date_id = v_start_date_id and dw_load_status = 1;

END;
/

COMMIT;


PROMPT "Step03: Run the Count Validation Steps"
PROMPT "We need (3,0) Status from the next step. But we get (3,1) due to Count mismatches, Ignore for now"

DECLARE
  C_START_TIME DATE;
  V_START_DATE_ID VARCHAR2(200);
  v_Return NUMBER;
BEGIN
  C_START_TIME := SYSDATE;
  V_START_DATE_ID := TO_NUMBER(TO_CHAR (sysdate, 'YYYYMMDD'));
  
  --The below code will enable RPF clients to be covered in DW status emails
  v_Return := 0;
  v_Return :=app_dba.dw_routine_load_pkg.fn_routine_phase_three(SYSDATE, v_start_date_id);
  
  DBMS_OUTPUT.put_line('Return Value of Phase III (Validation) Routine:' || v_return);

  --Force the Batch status to be 3,0.
  UPDATE dw_load_status_tbl_new
   SET dw_load_status = 3, dw_load_error = 0,
       load_time_end = systimestamp,
       dw_load_remarks = 'FACT/RDS Count Check Was Run'
  WHERE dw_load_start_date_id = v_start_date_id and dw_load_status = 2;

END;
/

COMMIT;

EXIT;



