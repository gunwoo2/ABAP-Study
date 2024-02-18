*&---------------------------------------------------------------------*
*& Report YE00_EX030
*&---------------------------------------------------------------------*
*& Class-Based Exception 연습
*& 클래스 기반의 예외처리 연습
*&---------------------------------------------------------------------*
REPORT YE03_EX030.

DATA GT_SPFLI TYPE TABLE OF SPFLI.
DATA GO_SALV  TYPE REF TO CL_SALV_TABLE.

START-OF-SELECTION.
  " Database Table SPFLI 에서 모든 데이터를 전부 가져와
  " Internal Table GT_SPFLI 에 키필드 기준으로 정렬해서 담는다.
  SELECT * FROM SPFLI INTO TABLE GT_SPFLI ORDER BY PRIMARY KEY.

  " Exception Class 를 참조하는 참조변수
  DATA LX_SALV_MSG TYPE REF TO CX_SALV_MSG.

  TRY.
      " FACTORY 메소드는 Static Method다. 왜?
      " 클래스로 호출하니까
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = GO_SALV " Basis Class Simple ALV Tables
        CHANGING
          T_TABLE      = GT_SPFLI.

      " DISPLAY 메소드는 Instance Method다.
      CALL METHOD GO_SALV->DISPLAY.
    CATCH CX_SALV_MSG INTO LX_SALV_MSG. " ALV: General Error Class with Message
      " Exception이 발생한 클래스 객체를 가리키기 위해 into 참조변수
      " 문법을 추가로 더 작성할 수 있다.
      DATA LV_MSG TYPE STRING.
      " 오류 메시지의 내용을 LV_MSG에 기록한다.
      CALL METHOD LX_SALV_MSG->GET_TEXT
        RECEIVING
          RESULT = LV_MSG.

      MESSAGE LV_MSG TYPE 'I'.
**      MESSAGE '이 오류는 ~~~한 상황입니다.' TYPE 'I'.
  ENDTRY.
