*&---------------------------------------------------------------------*
*& Report  ZBC400_E00_REP_B
*&
*&---------------------------------------------------------------------*
*& Exercise 31 Implement Events of ABAP Reports
*&---------------------------------------------------------------------*
REPORT  ZBC400_E00_REP_B.

DATA:
  GT_FLIGHTS TYPE BC400_T_FLIGHTS,
  GS_FLIGHT  TYPE BC400_S_FLIGHT.

PARAMETERS:
     PA_CAR TYPE BC400_S_FLIGHT-CARRID.
*     pa_con TYPE bc400_s_flight-connid.

SELECT-OPTIONS
     SO_CON FOR GS_FLIGHT-CONNID.


INITIALIZATION.
  " 프로그램의 초기설정 ( 예: 변수 초기값 )

  PA_CAR = 'LH'.

AT SELECTION-SCREEN.
  " Selection Screen에서 입력값 점검 등을 담당한다.
  TRY.
      CALL METHOD CL_BC400_FLIGHTMODEL=>CHECK_AUTHORITY
        EXPORTING
          IV_CARRID   = PA_CAR  " Airline Code
          IV_ACTIVITY = '03'.    " Activity
    CATCH CX_BC400_NO_AUTH. " No Authorization for Airline
      " at selection screen 안에서 error 타입의 메시지를
      " 출력하면, 반드시 selection screen이 재차 출력된다.
      MESSAGE E046(BC400) WITH PA_CAR.
  ENDTRY.

START-OF-SELECTION.
  " Selection Screen에서 실행버튼을 눌렀을 때 AT SELECTION-
  " SCREEN 이벤트에서 에러 메시지(MESSAGE ennn)가 발생하지
  " 않았으면 START-OF-SELECTION 이벤트를 호출한다.

  TRY.
      CALL METHOD CL_BC400_FLIGHTMODEL=>GET_FLIGHTS_RANGE
        EXPORTING
          IV_CARRID  = PA_CAR
          IT_CONNID  = SO_CON[]  " Range Table for Flight Number
        IMPORTING
          ET_FLIGHTS = GT_FLIGHTS.      " Flight times
    CATCH CX_BC400_NO_DATA. " No Data for Selection
      WRITE / TEXT-E01. " 검색된 결과가 없습니다.
    CATCH CX_BC400_NO_AUTH. " No Authorization for Airline
      WRITE / TEXT-E02. " 조회권한이 없습니다.
  ENDTRY.


***TRY.
***    CALL METHOD cl_bc400_flightmodel=>get_flights
***      EXPORTING
***        iv_carrid  = pa_car
***        iv_connid  = pa_con
***      IMPORTING
***        et_flights = gt_flights.
***  CATCH cx_bc400_no_data.
***    WRITE / 'No flights for the specified connection'.
***ENDTRY.

  LOOP AT GT_FLIGHTS INTO GS_FLIGHT.

    " 각 라인별 첫번째 칸에 신호등이 표시된다.
    " 예약율이 80% 이상 초록불
    " 예약율이 30% 이상 노란불
    " 예약율이 30% 미만( 위의 조건 해당안될 때 ) 빨간불
    IF GS_FLIGHT-PERCENTAGE >= 80.
      WRITE / ICON_GREEN_LIGHT.
    ELSEIF GS_FLIGHT-PERCENTAGE >= 30.
      WRITE / ICON_YELLOW_LIGHT.
    ELSE.
      WRITE / ICON_RED_LIGHT.
    ENDIF.

    WRITE:   GS_FLIGHT-CARRID COLOR COL_KEY,
             GS_FLIGHT-CONNID COLOR COL_KEY,
             GS_FLIGHT-FLDATE COLOR COL_KEY,
             GS_FLIGHT-SEATSMAX,
             GS_FLIGHT-SEATSOCC,
             GS_FLIGHT-PERCENTAGE.

  ENDLOOP.
