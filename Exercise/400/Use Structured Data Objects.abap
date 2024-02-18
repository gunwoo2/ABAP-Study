*&---------------------------------------------------------------------*
*& Report ZBC400_E03_STRUCTURE
*&---------------------------------------------------------------------*
*& Exercise 23 Use Structured Data Objects
*&---------------------------------------------------------------------*
REPORT ZBC400_E03_STRUCTURE.

"STRUCTURE에서 특정 COMPONET를 참조하여
"SELECTION SCREEN의 PARAMETERS 를 선언
PARAMETERS: PA_CAR  TYPE BC400_S_FLIGHT-CARRID,
            PA_CON  TYPE  BC400_S_FLIGHT-CONNID,
            PA_DATE TYPE BC400_S_FLIGHT-FLDATE.

"STRUCTURE 변수 선언
DATA: GS_CARRIER TYPE BC400_S_CARRIER,
      GS_FLIGHT  TYPE BC400_S_FLIGHT.

 " 동일한 이름을 가진 Component 끼리의 값전달이 발생한다.
    " MOVE-CORRESPONDING 은 이름이 다른 Component 에게
    " 영향을 끼치지 않는다. ( 값을 그대로 보존시킴 )
TYPES: BEGIN OF TY_CARRIERFLIGHT,
         CARRID     TYPE BC400_S_CARRIER-CARRID,
         CARRNAME   TYPE BC400_S_CARRIER-CARRNAME,
         CURRCODE   TYPE BC400_S_CARRIER-CURRCODE,
         URL        TYPE BC400_S_CARRIER-URL,
         CONNID     TYPE BC400_S_FLIGHT-CONNID,
         FLDATE     TYPE BC400_S_FLIGHT-FLDATE,
         SEATSMAX   TYPE BC400_S_FLIGHT-SEATSMAX,
         SEATSOCC   TYPE BC400_S_FLIGHT-SEATSOCC,
         PERCENTAGE TYPE BC400_S_FLIGHT-PERCENTAGE,

       END OF TY_CARRIERFLIGHT.

"정의된 LOCAL STRUCTURE TYPE을 이용해 STRUCTURE 변수를 선언한다.
DATA GS_CARRIERFLIGHT TYPE TY_CARRIERFLIGHT.

TRY.
    CALL METHOD CL_BC400_FLIGHTMODEL=>GET_CARRIER
      EXPORTING
        IV_CARRID  = PA_CAR                " Airline Code
      IMPORTING
        ES_CARRIER = GS_CARRIER.                " Airline Carrier

    "항공사ID와 항공편번호와 비행일자를 전달하여
    "해당 비행일정 관련 정보를 GS_FLIGHT에 보관
    CALL METHOD CL_BC400_FLIGHTMODEL=>GET_FLIGHT
      EXPORTING
        IV_CARRID = PA_CAR                " Airline Code
        IV_CONNID = PA_CON              " Flight Connection Number
        IV_FLDATE = PA_DATE               " Flight Date
      IMPORTING
        ES_FLIGHT = GS_FLIGHT.                " Flight time

"동일한 이름을 가진 COMPONENT 끼리의 값 전달이 발생한다.
" MOVE-CORRESPONDING 은 이름이 다른 COMPONENT
    MOVE-CORRESPONDING GS_CARRIER TO GS_CARRIERFLIGHT.
    MOVE-CORRESPONDING gs_Flight TO GS_CARRIERFLIGHT.

    WRITE: /'항공사ID:',
    20 GS_CARRIERFLIGHT-CARRID,
    "새로운 줄의 첫번째 칸에 '항공사명:'을 출력한다.

    /1 '항공사명:',
    20 GS_CARRIERFLIGHT-CARRNAME, "20번째 칸에 출력

    /1 '통화코드:',
    20 GS_CARRIERFLIGHT-CURRCODE, "20번째 칸에 출력

    /1 'URL:',
    20 GS_CARRIERFLIGHT-URL, "20번째 칸에 출력

    /1 '항공편번호:',
    20 GS_CARRIERFLIGHT-CONNID, "20번째 칸에 출력

    /1 '비행일자:',
    20 GS_CARRIERFLIGHT-FLDATE, "20번째 칸에 출력

    /1 '최대 좌석수:',
    20 GS_CARRIERFLIGHT-SEATSMAX LEFT-JUSTIFIED, "20번째 칸에 출력

    /1 '예약 좌석수:',
    20 GS_CARRIERFLIGHT-SEATSOCC LEFT-JUSTIFIED, "20번째 칸에 출력

    /1 '예약율:',
    20 GS_CARRIERFLIGHT-PERCENTAGE, '%'. "20번째 칸에 출력

" 에외처리 부분
  CATCH CX_BC400_NO_DATA. " No Data for Selection
    WRITE / '입력하신 항공사는 존재하지 않습니다.'(E01).
  CATCH CX_BC400_NO_AUTH. " No Authorization for Airline
    WRITE / '입력하신 항공사를 조회할 권한이 없습니다.'(E02).

ENDTRY.

" WRITE : '항공사명:', GS_CARRIER.
