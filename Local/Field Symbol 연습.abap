*&---------------------------------------------------------------------*
*& Report YE00_EX032
*&---------------------------------------------------------------------*
*& Field Symbol 연습 1
*&---------------------------------------------------------------------*
REPORT YE03_EX032.

INCLUDE YE03_EX032_TOP.
*INCLUDE YE00_EX032_TOP. " 전역변수
INCLUDE YE03_EX032_SCR.
*INCLUDE YE00_EX032_SCR. " Selection Screen
INCLUDE YE03_EX032_F01.
*INCLUDE YE00_EX032_F01. " FORM Subroutines

INITIALIZATION.

AT SELECTION-SCREEN.

START-OF-SELECTION.

  IF PA_TAB IS INITIAL.
    " 팝업 메시지 + 오류 처럼 보임
    MESSAGE '테이블 이름이 없습니다.' TYPE 'I' DISPLAY LIKE 'E'.
  ELSE.

    CASE PA_TAB.
      WHEN 'SCARR'.
        " GT_SCARR 을 <FS_TAB>가 가리키도록 한다.
        " 즉, <FS_TAB> 는 GT_SCARR 와 동일한 변수를 가리키는 이름이 된다.
        ASSIGN GT_SCARR TO <FS_TAB>.
      WHEN 'SPFLI'.
        " GT_SPFLI 를 <FS_TAB>가 가리키도록 한다.
        ASSIGN GT_SPFLI TO <FS_TAB>.
      WHEN 'SFLIGHT'.
        " GT_SFLIGHT를 <FS_TAB>가 가리키도록 한다.
        ASSIGN GT_SFLIGHT TO <FS_TAB>.
      WHEN 'SBOOK'.
        " GT_SBOOK을 <FS_TAB>가 가리키도록 한다.
        ASSIGN GT_SBOOK TO <FS_TAB>.
    ENDCASE.

    IF <FS_TAB> IS ASSIGNED. " <FS_TAB>가 무언가 가리키고 있다면,
      " <FS_TAB> 은 반드시 어떤 Internal Table을 가리켜야 한다.
      SELECT * FROM (PA_TAB) UP TO 100 ROWS INTO TABLE <FS_TAB>.

      " 해당 데이터를 SALV로 출력한다.
      PERFORM DISPLAY_SALV USING <FS_TAB>.
    ELSE.
      " <FS_TAB>이 아무것도 가리키고 있지 않다면,
      " 위의 CASE 문에서 WHEN 에 해당되는 경우가 없었다라는 뜻이므로
      " PA_TAB 에 잘못된 테이블이름을 입력했다 라는 뜻이 된다.
      " 팝업 메시지 + 오류 처럼
      MESSAGE '테이블 이름이 잘못되었습니다.' TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.

  ENDIF.

*&---------------------------------------------------------------------*
*& Include          YE00_EX032_TOP
*&---------------------------------------------------------------------*

" TABLE OF 뒤의 데이터 타입을 여러 줄 쌓을 수 있는 형태의 변수
DATA GT_SCARR   TYPE TABLE OF SCARR.
DATA GT_SPFLI   TYPE TABLE OF SPFLI.
DATA GT_SFLIGHT TYPE TABLE OF SFLIGHT.
DATA GT_SBOOK   TYPE TABLE OF SBOOK.

" REF TO 뒤에 나오는 클래스 객체를 가리킬 수 있는 형태의 변수
DATA GO_SALV    TYPE REF TO CL_SALV_TABLE.
DATA GX_SMSG    TYPE REF TO CX_SALV_MSG.

" Internal Table 중 Standard 만 취급하는 Field Symbol
" Field Symbol 이란 변수를 선언하면서 생성된 공간에 또다른 이름으로
" 부여가 가능한 형태의 특수한 데이터 타입
FIELD-SYMBOLS <FS_TAB> TYPE STANDARD TABLE.

*&---------------------------------------------------------------------*
*& Include          YE00_EX032_SCR
*&---------------------------------------------------------------------*

PARAMETERS PA_TAB TYPE TABNAME. " 문자 30자리

*&---------------------------------------------------------------------*
*& Include          YE00_EX032_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form DISPLAY_SALV
*&---------------------------------------------------------------------*
FORM DISPLAY_SALV  USING PT_DATA TYPE STANDARD TABLE.

  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = GO_SALV " Basis Class Simple ALV Tables
        CHANGING
          T_TABLE      = PT_DATA.

      CALL METHOD GO_SALV->DISPLAY. " ALV를 화면에 출력한다.

    CATCH CX_SALV_MSG INTO GX_SMSG. " ALV: General Error Class with Message
      " Exception Class 의 객체를 GX_SMSG 참조변수로 넘겨받아
      " 해당 참조변수를 통해 Instance Method인 GET_TEXT를 호출하여
      " 오류 메시지를 가져와 화면에 출력한다.
      DATA LV_MSG TYPE STRING.
      LV_MSG = GX_SMSG->GET_TEXT( ).
      " 팝업 메시지로 출력 + 에러 처럼
      MESSAGE LV_MSG TYPE 'I' DISPLAY LIKE 'E'.
  ENDTRY.
ENDFORM.
