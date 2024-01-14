*&---------------------------------------------------------------------*
*& Report YE00_EX012
*&---------------------------------------------------------------------*
*& Internal Table 연습 - ABAP Dictionary
*&---------------------------------------------------------------------*
REPORT YE00_EX012.

* Global ABAP Dictionary Type을 이용한 itab 생성
* Header Line이 없는 경우

* Internal Table 선언
DATA GT_CARR TYPE SORTED TABLE OF SCARR
             WITH UNIQUE KEY CARRID.

*DATA GT_PFLI TYPE STANDARD TABLE OF SPFLI
*             WITH NON-UNIQUE KEY CARRID CONNID.

* Structure 변수를 이용해서 Internal Table을 선언
DATA: BEGIN OF GS_PFLI,
        CARRID   TYPE SPFLI-CARRID,
        CONNID   TYPE SPFLI-CONNID,
        CITYFROM TYPE SPFLI-CITYFROM,
        CITYTO   TYPE SPFLI-CITYTO,
      END OF GS_PFLI.

DATA GT_PFLI   LIKE TABLE OF GS_PFLI
               WITH NON-UNIQUE KEY CARRID CONNID.

***DATA GT_FLIGHT TYPE TABLE OF SFLIGHT.


PARAMETERS P_RA1 RADIOBUTTON GROUP RAG1.  " TABLE SCARR 출력
PARAMETERS P_RA2 RADIOBUTTON GROUP RAG1.  " TABLE SPFLI 출력


" Selection Screen 에서 실행버튼을 누른 뒤에 작동하는 로직

START-OF-SELECTION.

  CASE 'X'.

    WHEN P_RA1.
      MESSAGE '라디오 버튼 1번을 눌렀을 때' TYPE 'I'.

      PERFORM SELECT_SCARR.
      PERFORM DISPLAY_SCARR.

    WHEN P_RA2.
      MESSAGE '라디오 버튼 2번을 눌렀을 때' TYPE 'I'.

      PERFORM SELECT_SPFLI.
      PERFORM DISPLAY_SPFLI.

  ENDCASE.

  MESSAGE '어느 라디오 버튼을 선택하든 실행된다.' TYPE 'I'.

  " 부모님이 식탁에 수저를 놓으라 할 때
  " 집에 있는 모든 수저를 다 꺼내놓느냐
  " 식사할 사람만큼의 수저만 꺼내놓느냐
*&---------------------------------------------------------------------*
*& Form SELECT_SCARR
*&---------------------------------------------------------------------*
FORM SELECT_SCARR .
* Database Table에서 Records를 가져온다.
  SELECT * " 모든 필드의 데이터를 전부 가져온다.
    FROM SCARR
  INTO TABLE GT_CARR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_SCARR
*&---------------------------------------------------------------------*
FORM DISPLAY_SCARR .

  CALL METHOD CL_DEMO_OUTPUT=>DISPLAY
    EXPORTING
      DATA = GT_CARR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_SPFLI
*&---------------------------------------------------------------------*
FORM SELECT_SPFLI .

  " 필요한 필드만 데이터를 가져온다.
  SELECT CARRID CONNID CITYFROM CITYTO
    FROM SPFLI
  INTO CORRESPONDING FIELDS OF TABLE GT_PFLI.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_SPFLI
*&---------------------------------------------------------------------*
FORM DISPLAY_SPFLI .

  " SALV 를 이용해서 데이터를 출력하는 방법
  " 클래스의 메소드를 이용해서 출력
  DATA GO_ALV TYPE REF TO CL_SALV_TABLE.
  " GO 의 G는 GLOBAL 이고, O는 OBJECT 를 의미한다.
  " OBJECT는 클래스를 이용해서 생성된 객체를 의미한다.
  " 객체란??? 클래스라는 설계도를 이용해서
  " 생성된 결과물이라고 간단하게 생각하자.
  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = GO_ALV   " SALV 객체를 받아온다.
        CHANGING
          T_TABLE      = GT_PFLI. " 화면에 출력할 데이터(Internal Table) 전달

      CALL METHOD GO_ALV->DISPLAY. " 전달받은 데이터를 화면에 출력함.
    CATCH CX_SALV_MSG. " ALV: General Error Class with Message
  ENDTRY.

ENDFORM.
