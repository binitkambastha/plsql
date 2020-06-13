
WHENEVER OSERROR EXIT 1 ROLLBACK
WHENEVER SQLERROR EXIT 100 ROLLBACK

INSERT into WK_BATCH_TRACKER
(RUN_NO, STEP_NAME, START_TIME, END_TIME, RUN_STATUS, ACTIVE_FLAG)
values (to_char(sysdate,'YYYYMMDD'),'RDS TICKET',systimestamp,NULL,'R','Y');
COMMIT;

truncate table stg_rds_ticket_tbl;
PROMPT "RDS TICKET: Insert into stg_rds_ticket_tbl"

declare
begin
    EXECUTE IMMEDIATE 'INSERT INTO stg_rds_ticket_tbl
      (
        /* 1*/
        TICK_RP_ENTITY_ID,
        TICK_NUMBER,
        TICK_NUMBER_IDX,
        TICK_AMOUNT_DUE,
        TICK_TOTAL_PAID,
        TICK_OPEN_STATUS,
        TICK_SAMPLE_IND,
        TICK_PLATE_STATE,
        TICK_PLATE,
        /* 2*/
        TICK_PLATE_TYPE,
        TICK_EFFECTIVE_DATE,
        TICK_PLATE_YEAR,
        TICK_PLATE_EXP_DATE,
        TICK_SEIZE_IND,
        TICK_BOOT_IND,
        TICK_RENTAL_IND,
        TICK_UNAPPLIED_AMT,
        /* 3*/
        TICK_DATE_OF_BIRTH,
        TICK_INTEREST_DUE,
        TICK_HOLD_REQUEST_DATE,
        TICK_ASSIGN_AGENCY,
        TICK_ASSIGN_DATE,
        TICK_ASSIGN_STATUS,
        TICK_ASSIGN_AMOUNT,
        TICK_SWAP_DATE,
        /* 4*/
        TICK_ISSUE_DATE,
        TICK_BADGE_ISSUED,
        TICK_AGENCY,
        TICK_DIVISION,
        TICK_VIOLATION_CODE,
        TICK_VIOLATION_TYPE,
        TICK_SPEED_ZONE,
        TICK_SPEED_ACTUAL,
        /* 5*/
        TICK_OVERWEIGHT,
        TICK_RADAR_IND,
        TICK_BOOKED_IND,
        TICK_ACCIDENT,
        TICK_HAZARD,
        TICK_FINE_AMOUNT,
        /* 6*/
        TICK_LOCATION,
        TICK_STREET_NO,
        TICK_STREET_DIRECTION,
        TICK_STREET_NAME,
        /* 7*/
        TICK_STREET_SUFFIX,
        TICK_STREET_QUAD,
        TICK_INTERSECT_STREET,
        TICK_ROUTE,
        TICK_PATROL_ZONE,
        TICK_MAKE,
        /* 8*/
        TICK_COLOR,
        TICK_BODY_STYLE,
        TICK_ISSUE_TIME_1,
        TICK_ISSUE_TIME_2,
        TICK_VEHICLE_TYPE,
        TICK_METER,
        TICK_OTHER_VIOLATION_1,
        TICK_OTHER_VIOLATION_2,
        /* 9*/
        TICK_OTHER_VIOLATION_3,
        TICK_JDGMT_STATUS,
        TICK_JDGMT_DATE,
        TICK_JDGMT_DOCKET,
        TICK_GEOCODE_1,
        /*TICK_NEW_GPS_LAT,*/
        TICK_GEOCODE_2,
        /*TICK_NEW_GPS_LONG,*/
        /*10*/
        TICK_POINTS,
        TICK_PROCESS_DATE,
        TICK_BATCH_NUMBER,
        TICK_BATCH_DATE,
        TICK_MICROFILM_NO,
        TICK_BACKLOG_CODE,
        TICK_CITY_REF_NO,
        TICK_ERROR_FLAG_1,
        /*11*/
        TICK_ERROR_FLAG_2,
        TICK_ERROR_FLAG_3,
        TICK_ERROR_FLAG_4,
        TICK_ERROR_FLAG_5,
        TICK_ERROR_FLAG_6,
        TICK_ERROR_FLAG_7,
        TICK_ERROR_FLAG_8,
        TICK_ERROR_FLAG_9,
        /*12*/
        TICK_ERROR_FLAG_10,
        TICK_SPECIAL_IND_1,
        TICK_SPECIAL_IND_2,
        TICK_SPECIAL_IND_3,
        TICK_PENALTY_1,
        TICK_PENALTY_2,
        TICK_PENALTY_3,
        TICK_PENALTY_4,
        /*13*/
        TICK_PENALTY_5,
        TICK_REGISTRY_MAKE,
        TICK_DMV_CONFIRM_DATE,
        TICK_NIXIE_DATE,
        TICK_NIXIE_STATUS,
        TICK_VIN_NUMBER,
        TICK_HOLD_STATUS,
        TICK_HOLD_PROC_DATE,
        /*14*/
        TICK_HOLD_ID_NUMBER,
        TICK_NOTICE_TYPE_1,
        TICK_NOTICE_DATE_1,
        TICK_NOTICE_TYPE_2,
        TICK_NOTICE_DATE_2,
        TICK_NOTICE_TYPE_3,
        TICK_NOTICE_DATE_3,
        TICK_NOTICE_TYPE_4,
        /*15*/
        TICK_NOTICE_DATE_4,
        TICK_NOTICE_TYPE_5,
        TICK_NOTICE_DATE_5,
        TICK_SUSPEND_DATE,
        TICK_SUSPEND_TIME,
        TICK_SUSPEND_CLERK_ID,
        TICK_SUSPEND_CODE,
        TICK_SUSPEND_TIL_DATE,
        /*16*/
        TICK_SUSPEND_PROCESS_DATE,
        TICK_HEARING_OFFICER,
        TICK_HEARING_DATE,
        TICK_HEARING_TIME,
        TICK_HEARING_CLERK,
        TICK_HEARING_PROCESS_DATE,
        TICK_HEARING_PROCESS_TIM,
        /*17*/
        TICK_HEARING_REQUIRED,
        TICK_PLEA_CODE,
        TICK_REDUCTION_AMOUNT,
        TICK_DISPOSITION_CODE,
        TICK_DISPOSITION_DATE,
        TICK_DISPOSITION_CLERK,
        TICK_DISPO_PROCESS_DATE,
        /*18*/
        TICK_DISPO_PROCESS_TIME,
        TICK_CORR_TYPE,
        TICK_LETTER_TYPE,
        TICK_CORR_DATE,
        TICK_CORR_TIME,
        TICK_CORR_CLERK,
        TICK_RENTAL_NAME,
        TICK_RENTAL_ADDRESS_LINE_1,
        /*19*/
        TICK_RENTAL_ADDRESS_LINE_2,
        TICK_RENTAL_COUNTRY,
        TICK_RENTAL_COUNTY,
        TICK_RENTAL_CITY,
        TICK_RENTAL_STATE,
        TICK_RENTAL_ZIP,
        TICK_NAME_REASON,
        TICK_CASE_NO,
        /*20*/
        TICK_ACCIDENT_NO,
        TICK_ARCHIVE_STATUS,
        TICK_REAPPLY_SOURCE,
        TICK_PLATE_COLOR,
        TICK_RMV_PLATE_COLOR,
        TICK_SUB_PLATE_TYPE,
        TICK_RMV_ERROR_CODE,
        TICK_SWAP_IND,
        /*21*/
        TICK_HOLD_REASON,
        TICK_VEHICLE_YEAR,
        TICK_PLATE_COLOR_DEFAULT,
        TICK_RESTORE_IND,
        TICK_IPP_IND,
        TICK_DOCU_NUMBER,
        TICK_LIEN_RESOLVED,
        TICK_REGISTRY_STATUS,
        /*22*/
        TICK_BOOT_EXCLUDE,
        TICK_IPP_ENROLL_AMT,
        TICK_CLIENT_DATE,
        TICK_IPP_DEFAULT_IND,
        TICK_ALT_ISSUE_DATE,
        TICK_CREDIT_BUR_ENROLL_DATE,
        TICK_CREDIT_BUR_STATUS,
        /*23*/
        TICK_CREDIT_BUR_COMMENT,
        TICK_FIRST_NAME,
        TICK_CORR_EMAIL_ADDRESS,
        TICK_CORR_PHONE_NUMBER,
        TICK_RPP_PERMIT_NUMBER,
        TICK_IMAGE_IND,
        TICK_PENALTY_DATE1,
        /*24*/
        TICK_PENALTY_DATE2,
        TICK_PENALTY_DATE3,
        TICK_PENALTY_DATE4,
        TICK_PENALTY_DATE5,
        TICK_DRIVEAWAY_FLAG,
        TICK_VEH_MODEL,
        TICK_VEH_YEAR_MONTH,
        /*25*/
        TICK_HH_PLATE_EXP_DATE,
        TICK_COA_SOURCE,
        TICK_COMMENT_IND,
        tick_tims_date_time 
      )
    SELECT
      /* LINE 1 */
      b.summ_entity_number,	--Using ISN here was incorrect NVL(TS.isn,0), --,
      TS.tick_number,
      NVL(TS.IDX,0),
      TS.AMOUNT_DUE,
      -9999 tick_total_paid, --Calc in FACT
      '||chr(39)||'x'||chr(39)||' tick_open_status,  -- Constant "x"
      TS.SAMPLE_IND,
      SUBSTR(TS.STATE_PLATE,1,2),
      SUBSTR(TS.STATE_PLATE,3,8),
      /* LINE 2 */
      TS.PLATE_TYPE,
      CASE
        WHEN TS.EFFECTIVE_DATE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.EFFECTIVE_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END EFFECTIVE_DATE,
      TS.PLATE_YEAR,
      CASE
        WHEN TS.PLATE_EXP_DATE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.PLATE_EXP_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END PLATE_EXP_DATE,
      TS.SEIZE_IND,
      TS.BOOT_IND,
      TS.RENTAL_IND,
      TS.UNAPPLIED_AMT,
      /* LINE 3 */
      NULL DATE_OF_BIRTH,
      TS.INTEREST_DUE,
      NULL HOLD_REQUEST_DATE,
      TS.ASSIGN_AGENCY,
      NULL ASSIGN_DATE,
      TS.ASSIGN_STATUS,
      TS.ASSIGN_AMOUNT,
      NULL SWAP_DATE,
      /* LINE 4 */
      CASE
        WHEN TS.ISSUE_DATE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.ISSUE_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END ISSUE_DATE,
      TS.BADGE_ISSUED,
      TS.AGENCY,
      TS.DIVISION,
      TS.VIOLATION_CODE,
      TS.VIOLATION_TYPE,
      TS.SPEED_ZONE,
      TS.SPEED_ACTUAL,
      /* LINE 5 */
      TS.OVERWEIGHT,
      TS.RADAR_IND,
      TS.BOOKED_IND,
      TS.ACCIDENT,
      TS.HAZARD,
      TS.FINE_AMOUNT,
      /* LINE 6 */
      TS.location, -- Usually StNumber+StDirection+StName+StSuffix
      -- -99,
      SUBSTR(REGEXP_SUBSTR ( TRIM( REGEXP_SUBSTR ( TS.location, '||chr(39)||'(\S*)(\s)'||chr(39)||', 1, 1) ), '||chr(39)||'^\d+\.?\d*$'||chr(39)||'),1,10) STREET_NO,
      SUBSTR(
      CASE
        WHEN TRIM(REGEXP_SUBSTR (TRIM( REGEXP_SUBSTR(TS.location,'||chr(39)||'[^0-9].*'||chr(39)||') ), '||chr(39)||'(\S*)(\s)'||chr(39)||', 1, 1) ) IN ('||chr(39)||'N'||chr(39)||','||chr(39)||'S'||chr(39)||','||chr(39)||'E'||chr(39)||','||chr(39)||'W'||chr(39)||','||chr(39)||'NORTH'||chr(39)||','||chr(39)||'SOUTH'||chr(39)||','||chr(39)||'EAST'||chr(39)||','||chr(39)||'WEST'||chr(39)||')
        THEN REGEXP_SUBSTR (TRIM( REGEXP_SUBSTR(TS.location,'||chr(39)||'[^0-9].*'||chr(39)||') ), '||chr(39)||'(\S*)(\s)'||chr(39)||', 1, 1)
        ELSE '||chr(39)||'X'||chr(39)||'
      END, 1, 1) STREET_DIRECTION,
      TRIM(CASE
        WHEN TRIM( REGEXP_SUBSTR (TS.location, '||chr(39)||'\s(\w+)$'||chr(39)||') ) IN ('||chr(39)||'ST'||chr(39)||','||chr(39)||'RD'||chr(39)||','||chr(39)||'AVE'||chr(39)||','||chr(39)||'BLVD'||chr(39)||', '||chr(39)||'STREET'||chr(39)||','||chr(39)||'ROAD'||chr(39)||','||chr(39)||'AVENUE'||chr(39)||','||chr(39)||'BOULEVARD'||chr(39)||')
        THEN
          CASE
            WHEN TRIM(REGEXP_SUBSTR (TRIM( REGEXP_SUBSTR(TS.location,'||chr(39)||'[^0-9].*'||chr(39)||') ), '||chr(39)||'(\S*)(\s)'||chr(39)||', 1, 1) ) IN ('||chr(39)||'N'||chr(39)||','||chr(39)||'S'||chr(39)||','||chr(39)||'E'||chr(39)||','||chr(39)||'W'||chr(39)||','||chr(39)||'NORTH'||chr(39)||','||chr(39)||'SOUTH'||chr(39)||','||chr(39)||'EAST'||chr(39)||','||chr(39)||'WEST'||chr(39)||' )
            THEN TRIM( SUBSTR(REGEXP_REPLACE(TRIM(REGEXP_SUBSTR(TS.location,'||chr(39)||'[^0-9].*'||chr(39)||')), '||chr(39)||'\S+\s*$'||chr(39)||','||chr(39)||''||chr(39)||'),2) )
            ELSE REGEXP_REPLACE( TRIM( REGEXP_SUBSTR(TS.location,'||chr(39)||'[^0-9].*'||chr(39)||') ), '||chr(39)||'\S+\s*$'||chr(39)||', '||chr(39)||''||chr(39)||' )
          END
        ELSE
          CASE
            WHEN TRIM(REGEXP_SUBSTR (TRIM( REGEXP_SUBSTR(TS.location,'||chr(39)||'[^0-9].*'||chr(39)||') ), '||chr(39)||'(\S*)(\s)'||chr(39)||', 1, 1) ) IN ('||chr(39)||'N'||chr(39)||','||chr(39)||'S'||chr(39)||','||chr(39)||'E'||chr(39)||','||chr(39)||'W'||chr(39)||','||chr(39)||'NORTH'||chr(39)||','||chr(39)||'SOUTH'||chr(39)||','||chr(39)||'EAST'||chr(39)||','||chr(39)||'WEST'||chr(39)||')
            THEN TRIM(REGEXP_REPLACE(TRIM(REGEXP_SUBSTR(TS.location,'||chr(39)||'[^0-9].*'||chr(39)||') ), regexp_substr( TRIM(REGEXP_SUBSTR(TS.location,'||chr(39)||'[^0-9].*'||chr(39)||') ), '||chr(39)||'^\S+\s'||chr(39)||'), '||chr(39)||''||chr(39)||') )
            ELSE TRIM(REGEXP_SUBSTR(TS.location,'||chr(39)||'[^0-9].*'||chr(39)||') )
          END
      END) STREET_NAME,
      /* LINE 7 */
      SUBSTR(CASE
        WHEN TRIM( REGEXP_SUBSTR (TS.location, '||chr(39)||'\s(\w+)$'||chr(39)||') ) IN ('||chr(39)||'ST'||chr(39)||','||chr(39)||'RD'||chr(39)||','||chr(39)||'AVE'||chr(39)||','||chr(39)||'BLVD'||chr(39)||', '||chr(39)||'STREET'||chr(39)||','||chr(39)||'ROAD'||chr(39)||','||chr(39)||'AVENUE'||chr(39)||','||chr(39)||'BOULEVARD'||chr(39)||')
        THEN TRIM( REGEXP_SUBSTR (TS.location, '||chr(39)||'\s(\w+)$'||chr(39)||') )
      END, 1,5) Street_Suffix,
      CASE
        WHEN TRIM( REGEXP_SUBSTR (TS.location, '||chr(39)||'\s(\w+)$'||chr(39)||') ) IN ('||chr(39)||'NW'||chr(39)||','||chr(39)||'SW'||chr(39)||','||chr(39)||'NE'||chr(39)||','||chr(39)||'SE'||chr(39)||')
        THEN TRIM( REGEXP_SUBSTR (TS.location, '||chr(39)||'\s(\w+)$'||chr(39)||') )
      END Street_Quad,
      '||chr(39)||'LOC5'||chr(39)||' TICK_INTERSECT_STREET,
      TS.ROUTE,
      TS.PATROL_ZONE,
      TS.MAKE,
      /* LINE 8 */
      TS.COLOR,
      TS.BODY_STYLE,
      TS.ISSUE_TIME_1,
      TS.ISSUE_TIME_2,
      TS.VEHICLE_TYPE,
      TS.METER,
      SUBSTR(TS.OTHER_VIOLATION,4,3) tick_other_viol1,
      SUBSTR(TS.OTHER_VIOLATION,10,3) tick_other_viol2,
      /* LINE 9 */
      SUBSTR(TS.OTHER_VIOLATION,13,3) tick_other_viol3,
      SUBSTR(TS.OTHER_VIOLATION,1,1) jugd_status,
      CASE
        WHEN SUBSTR(TS.OTHER_VIOLATION,2,7) IS NULL
        THEN to_date('||chr(39)||'1990365'||chr(39)||','||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE to_date('||chr(39)||'1990365'||chr(39)||','||chr(39)||'YYYYDDD'||chr(39)||')
      END jugd_date,
      SUBSTR(TS.OTHER_VIOLATION,14,2) jugd_docket,
      99999 tick_geocode_1,
      /*TS.LATITUDE, */
      -99999 tick_geocode_2,
      /* TS.LONGITUDE, */
      /* LINE 10 */
      TS.POINTS,
      CASE
        WHEN TS.PROCESS_DATE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.PROCESS_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END PROCESS_DATE,
      TS.BATCH_NUMBER,
      CASE
        WHEN TS.BATCH_DATE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.BATCH_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END BATCH_DATE,
      TS.MICROFILM_NO,
      TS.BACKLOG_CODE,
      TS.CITY_REF_NO,
      SUBSTR(TS.ERROR_FLAGS,1,1),
      /* LINE 11 */
      SUBSTR(TS.ERROR_FLAGS,2,1),
      SUBSTR(TS.ERROR_FLAGS,3,1),
      SUBSTR(TS.ERROR_FLAGS,4,1),
      SUBSTR(TS.ERROR_FLAGS,5,1),
      SUBSTR(TS.ERROR_FLAGS,6,1),
      SUBSTR(TS.ERROR_FLAGS,7,1),
      SUBSTR(TS.ERROR_FLAGS,8,1),
      SUBSTR(TS.ERROR_FLAGS,9,1),
      /* LINE 12 */
      SUBSTR(TS.ERROR_FLAGS,10,1),
      SUBSTR(TS.ERROR_code,1,1) special_ind1,
      SUBSTR(TS.ERROR_code,2,1) special_ind2,
      SUBSTR(TS.invoice_ind,1,1) special_ind3,
      TS.PENALTY_1,
      TS.PENALTY_2,
      TS.PENALTY_3,
      TS.PENALTY_4,
      /* LINE 13 */
      TS.PENALTY_5,
      TS.REGISTRY_MAKE,
      NULL REG_CONFIRM_DTE,
      NULL NIXIE_DATE,
      TS.NIXIE_STATUS,
      TS.VIN_NUMBER,
      TS.HOLD_STATUS,
      CASE
        WHEN TS.HOLD_PROC_DATE BETWEEN 1990001 AND TO_CHAR(sysdate,'||chr(39)||'YYYYDDD'||chr(39)||')
        THEN TO_DATE(TS.HOLD_PROC_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END hold_proc_date,
      /* LINE 14 */
      TS.HOLD_ID_NUMBER,
      TS.NOTICE_TYPE_1,
      CASE
        WHEN TS.NOTICE_DATE_1 BETWEEN 1990001 AND TO_CHAR(sysdate,'||chr(39)||'YYYYDDD'||chr(39)||')
        THEN TO_DATE(TS.NOTICE_DATE_1, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END NOTICE_DATE_1,
      TS.NOTICE_TYPE_2,
      CASE
        WHEN TS.NOTICE_DATE_2 BETWEEN 1990001 AND TO_CHAR(sysdate,'||chr(39)||'YYYYDDD'||chr(39)||')
        THEN TO_DATE(TS.NOTICE_DATE_2, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END NOTICE_DATE_2,
      TS.NOTICE_TYPE_3,
      CASE
        WHEN TS.NOTICE_DATE_3 BETWEEN 1990001 AND TO_CHAR(sysdate,'||chr(39)||'YYYYDDD'||chr(39)||')
        THEN TO_DATE(TS.NOTICE_DATE_3, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END NOTICE_DATE_3,
      TS.NOTICE_TYPE_4,
      /* LINE 15 */
      CASE
        WHEN TS.NOTICE_DATE_4 BETWEEN 1990001 AND TO_CHAR(sysdate,'||chr(39)||'YYYYDDD'||chr(39)||')
        THEN TO_DATE(TS.NOTICE_DATE_4, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END NOTICE_DATE_4,
      TS.NOTICE_TYPE_5,
      CASE
        WHEN TS.NOTICE_DATE_5 BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.NOTICE_DATE_5, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END NOTICE_DATE_5,
      CASE
        WHEN TS.SUSPEND_DATE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.SUSPEND_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END SUSPEND_DATE,
      TS.SUSPEND_TIME,
      TS.SUSPEND_CLRK_ID,
      TS.SUSPEND_CODE,
      CASE
        WHEN SUBSTR(TS.SUSPEND_TIL_DTE,5,3) > 366
        THEN NULL
        WHEN TS.SUSPEND_TIL_DTE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.SUSPEND_TIL_DTE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END SUSPEND_TIL_DTE,
      /* LINE 16 */
      CASE
        WHEN TS.SUSPEND_PROCESS_DTE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.SUSPEND_PROCESS_DTE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END SUSPEND_PROCESS_DTE,
      TS.HEARING_OFFICER,
      CASE
        WHEN TS.HEARING_DATE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.HEARING_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END HEARING_DATE,
      TS.HEARING_TIME,
      TS.HEARING_CLERK,
      CASE
        WHEN TS.HEARING_PROCESS_DTE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.HEARING_PROCESS_DTE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END HEARING_PROCESS_DTE,
      TS.HEARING_PROCESS_TIM,
      /* LINE 17 */
      TS.HEARING_REQUIRED,
      TS.PLEA_CODE,
      TS.REDUCTION_AMOUNT,
      TS.HEAR_DISPOSITN,
      CASE
        WHEN TS.DISPOSITION_DATE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.DISPOSITION_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END DISPOSITION_DATE,
      TS.DISPOSITION_CLERK,
      CASE
        WHEN TS.DISPO_PROCESS_DTE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.DISPO_PROCESS_DTE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END DISPO_PROCESS_DTE,
      /* LINE 18 */
      TS.DISPO_PROCESS_TIME,
      TS.CORR_TYPE,
      TS.LETTER_TYPE,
      CASE
        WHEN TS.CORR_DATE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.CORR_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END CORR_DATE,
      TS.CORR_TIME,
      TS.CORR_CLERK,
      TS.NAME,
      TS.ADDRESS_LINE_1,
      /* LINE 19 */
      TS.ADDRESS_LINE_2,
      TS.COUNTRY,
      '||chr(39)||'CCC'||chr(39)||' county,
      TS.CITY,
      TS.STATE,
      TS.ZIP,
      TS.NAME_REASON,
      TS.CASE_NO,
      /* LINE 20 */
      TS.ACCIDENT_NO,
      TS.ARCHIVE_IND,
      TS.REAPPLY_SOURCE,
      TS.PLATE_COLOR,
      TS.RMV_PLATE_COLOR,
      TS.SUB_PLATE_TYPE,
      TS.RMV_ERROR_CODE,
      TS.SWAP_IND,
      /* LINE 21 */
      TS.HOLD_REASON,
      TS.VEHICLE_YEAR,
      TS.PLATE_COLOR_DEFAULT,
      TS.RESTORE_IND,
      TS.IPP_IND,
      TS.DOCU_NO,
      TS.LIEN_RESOLVED,
      TS.REGISTRY_STATUS,
      /* LINE 22 */
      TS.BOOT_EXCLUDE,
      TS.IPP_ENROLL_AMT,
      CASE
        WHEN TS.CLIENT_DATE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.CLIENT_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END CLIENT_DATE,
      TS.IPP_DEFAULT_IND,
      CASE
        WHEN TS.ALT_ISSUE_DATE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.ALT_ISSUE_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END ALT_ISSUE_DATE,
      CASE
        WHEN TS.CB_ENROLL_DATE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.CB_ENROLL_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END CB_ENROLL_DATE,
      TS.CB_STATUS,
      /* LINE 23 */
      TS.CB_COMMENT,
      TS.FIRST_NAME,
      TS.CORR_EMAIL_ADDRESS,
      TS.CORR_PHONE_NUMBER,
      TS.RPP_PERMIT_NUMBER,
      TS.IMAGE_IND,
      CASE
        WHEN TS.PENALTY_DATE1 BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.PENALTY_DATE1, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END PENALTY_DATE1,
      /* LINE 24 */
      CASE
        WHEN TS.PENALTY_DATE2 BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.PENALTY_DATE2, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END PENALTY_DATE2,
      CASE
        WHEN TS.PENALTY_DATE3 BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.PENALTY_DATE3, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END PENALTY_DATE3,
      CASE
        WHEN TS.PENALTY_DATE4 BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.PENALTY_DATE4, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END PENALTY_DATE4,
      CASE
        WHEN TS.PENALTY_DATE5 BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.PENALTY_DATE5, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END PENALTY_DATE5,
      TS.DRIVEAWAY_FLAG,
      TS.VEH_MODEL,
      TS.VEH_YEAR_MONTH,
      /* LINE 25 */
      CASE
        WHEN TS.HH_PLATE_EXP_DATE BETWEEN 1990001 AND 2050365
        THEN TO_DATE(TS.HH_PLATE_EXP_DATE, '||chr(39)||'YYYYDDD'||chr(39)||')
        ELSE NULL
      END HH_PLATE_EXP_DATE,
      TS.COA_SOURCE,
      TS.COMMENT_IND,
      ts.tims_timestamp
    FROM todays_catchup_tick_segment2 ts, stg_columbus.tm2_ticket_summary@stg_dblink b
    WHERE b.isn = ts.isn AND TS.TICK_NUMBER > '||chr(39)||'0'||chr(39)||'
    ';
end;
/

COMMIT;

PROMPT "Insert into rds_ticket_tbl"

delete /*+ INDEX(a) */ from rds_ticket_tbl a where exists 
	(select 1 from stg_rds_ticket_tbl b where a.tick_number=b.tick_number);

insert into rds_ticket_tbl select * from stg_rds_ticket_tbl;

COMMIT;

update WK_BATCH_TRACKER set end_time=systimestamp, run_status='Y' where STEP_NAME='RDS TICKET';
COMMIT;

EXIT;

