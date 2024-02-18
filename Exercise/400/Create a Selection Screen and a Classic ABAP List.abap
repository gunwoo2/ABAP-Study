*&---------------------------------------------------------------------*
*& Report  BC400_RPT_REP_A
*&
*&---------------------------------------------------------------------*
*& Exercise 30 Create a Selection Screen and a Classic ABAP List
*&
*&---------------------------------------------------------------------*
REPORT  ZBC400_E03_REP_A.

DATA:
  GT_FLIGHTS TYPE BC400_T_FLIGHTS,
  GS_FLIGHT  TYPE BC400_S_FLIGHT.

PARAMETERS:
     PA_CAR TYPE BC400_S_FLIGHT-CARRID.
*     pa_con TYPE bc400_s_flight-connid.


SELECT-OPTIONS
    SO_CON FOR GS_FLIGHT-CONNID.


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

TRY.
    CALL METHOD CL_BC400_FLIGHTMODEL=>GET_FLIGHTS_RANGE
      EXPORTING
        IV_CARRID  = PA_CAR
        IT_CONNID  = SO_CON[]
      IMPORTING
        ET_FLIGHTS = GT_FLIGHTS.
  CATCH CX_BC400_NO_DATA.
    WRITE / TEXT-E01. "검색된 결과가 없습니다.
     CATCH CX_BC400_NO_AUTH.
    WRITE / TEXT-E02. "조회 권한이 없습니다.

ENDTRY.


*CATCH CX_BC400_NO_DATA. " No Data for Selection
*CATCH CX_BC400_NO_AUTH. " No Authorization for Airline.

LOOP AT GT_FLIGHTS INTO GS_FLIGHT.

  IF GS_FLIGHT-PERCENTAGE >= 80.

      WRITE / ICON_GREEN_LIGHT.

  ELSEIF

    GS_FLIGHT-PERCENTAGE >= 30.
    WRITE / ICON_YELLOW_LIGHT.

  ELSE.

    WRITE / ICON_RED_LIGHT.

  ENDIF.

  " 각 라인 별 첫번째 칸에 신호등이 표시됨

  WRITE:   GS_FLIGHT-CARRID COLOR COL_KEY, "CARRID 필드에 색상
           GS_FLIGHT-CONNID COLOR COL_KEY,
           GS_FLIGHT-FLDATE COLOR COL_KEY,
           GS_FLIGHT-SEATSMAX,
           GS_FLIGHT-SEATSOCC,
           GS_FLIGHT-PERCENTAGE.

ENDLOOP.
