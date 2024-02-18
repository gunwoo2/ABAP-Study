*&---------------------------------------------------------------------*
*& Report YE03_EX015
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YE03_EX015.

PARAMETERS PA_RA1 RADIOBUTTON GROUP RAG1.
PARAMETERS PA_RA2 RADIOBUTTON GROUP RAG1.

" 1100
SELECTION-SCREEN BEGIN OF SCREEN 1100.
  " 이 구간에 선언되는 SELECTION-SCREEN의 문법은 전부 1100번 화면에 속하게 된다.
  " 예) PARMETERS, SELECT-OPTIONS, ...  등등
  PARAMETERS: PA_CAR TYPE SCARR-CARRID.
SELECTION-SCREEN END OF SCREEN 1100.

" 1200
SELECTION-SCREEN BEGIN OF SCREEN 1200.
" 이 구간은 1200 화면에 해당된다.
  " SELECT-OPTIONS은 FOR 뒤에 반드시 변수가 사용되어야 한다.
  " FOR 뒤의 변수에 따라 SO_CAR의 LOW 필드와 HIGH 필드의 타입이 결정된다.
  " LOW 필드는 검색조건의 하한값을 의미한다.
  " HIGH 필드는 검색조건의 상한값을 의미한다.
  " 예) LOW = 10 , HIGH = 20 =>> 10부터 20까지 검색한다.
  SELECT-OPTIONS: SO_CAR FOR PA_CAR.
SELECTION-SCREEN END OF SCREEN 1200.

INITIALIZATION.
" 프로그램 실행 시 최초로 실행되는 이벤트 구간.
" 주로 변수의 초기값을 설정하는데 사용됨
 PA_RA2 = ABAP_ON. " 라디오버튼 1이 선택되도록 한다.

 START-OF-SELECTION.

  " 현재 화면이 화면번호 1000인 경우만 진행.
  CHECK SY-DYNNR EQ 1000.

    " 현재 화면이 화면번호 1000이 아니면 중단한다.
  IF SY-DYNNR NE 1000.
    EXIT.
    ENDIF.

  CASE ABAP_ON.

  WHEN PA_RA1.
    CALL SELECTION-SCREEN 1100.
  WHEN PA_RA2.
    CALL SELECTION-SCREEN 1200.

  ENDCASE.
