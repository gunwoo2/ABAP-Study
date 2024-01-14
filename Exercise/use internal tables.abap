*&---------------------------------------------------------------------*
*& Report ZBC400_E03_LOOP
*&---------------------------------------------------------------------*
*& Exercise 24 Use Internal Tables
*&---------------------------------------------------------------------*
REPORT ZBC400_E03_LOOP.

*--
* ------------------------------------------- *
* ---------------Task 1---------------------- *
* ------------------------------------------- *
"데이터를 취급하기 위한 Internal Table.
DATA GT_CONNECTIONS TYPE TABLE OF BC400_S_CONNECTION
                    WITH NON-UNIQUE KEY CARRID CONNID.

" 위의 Internal Table을위한 작업공간(work area)이 필요하므로
" Structure (구조체) 변수를 선언한다.
DATA GS_CONNECTIONS LIKE LINE OF GT_CONNECTIONS.

* ------------------------------------------- *
* ---------------Task 2---------------------- *
* ------------------------------------------- *

" => : CLASS=>STATIC METHOD (오직 STATIC만)
" -> : REF 변수->모든 종류의 METHOD
" - : Structure-Field(Component)

TRY.
    " EXPORTING PARAMETERS는 IV_CARRID는 기본 값이 적용된 옵션임.
    " 하여 주석으로 처리하면 기본값이 자동으로 적용되므로,
    " 오류가 발생하지 않는다.
    " (Optional 하지 않으면 오류가 발생할 수 있음)
    CALL METHOD CL_BC400_FLIGHTMODEL=>GET_CONNECTIONS
*     EXPORTING
*       IV_CARRID      = SPACE            " Airline Code "SPACE 가 써있을 경우 OPTIONAL 이기에 필수가 아님
      IMPORTING
        ET_CONNECTIONS = GT_CONNECTIONS.  " Flight Connections

    " 이 아래 로직이 수행되는 경우는 Exception이 발생하지 않는 경우
    " 즉, CX_BC400_NO_DATA 라는 Exception의 발생이 없었다는 뜻
    " GT_CONNECTIONS 에 무언가가 담겨있다는 뜻으로 볼 수 있다.
    LOOP AT GT_CONNECTIONS INTO GS_CONNECTIONS.
      WRITE : / GS_CONNECTIONS-CARRID,
      GS_CONNECTIONS-CONNID,
      GS_CONNECTIONS-CITYFROM,  "출발도시
      GS_CONNECTIONS-AIRPFROM,  "출발공항
      GS_CONNECTIONS-CITYTO,    "도착도시
      GS_CONNECTIONS-AIRPTO,    "도착공항
      GS_CONNECTIONS-FLTIME.    "총 비행시간

    ENDLOOP.

  CATCH CX_BC400_NO_DATA. " No Data for Selection
    WRITE 'No Flight Connection was found.'(E01).
  CATCH CX_BC400_NO_AUTH. " No Authorization for Airline
ENDTRY.
