*&---------------------------------------------------------------------*
*& Report YE03_EX035
*&---------------------------------------------------------------------*
*& 무슨 테이블이던 전부 데이터를 조회하는 프로그램
*&---------------------------------------------------------------------*
REPORT YE03_EX035.

DATA GO_ALV TYPE REF TO CL_SALV_TABLE.
DATA GR_DATA TYPE REF TO DATA.
FIELD-SYMBOLS <FS_TABLE> TYPE STANDARD TABLE.

PARAMETERS PA_TABNM TYPE TABNAME OBLIGATORY.


START-OF-SELECTION.

  CREATE DATA GR_DATA TYPE TABLE OF (PA_TABNM).
  ASSIGN GR_DATA->* TO <FS_TABLE>.

  SELECT * FROM (PA_TABNM) UP TO 100 ROWS " 최대 100줄
    INTO TABLE <FS_TABLE>.

  CALL METHOD CL_SALV_TABLE=>FACTORY
    IMPORTING
      R_SALV_TABLE = GO_ALV                         " Basis Class Simple ALV Tables
    CHANGING
      T_TABLE      = <FS_TABLE>.


  CALL METHOD GO_ALV->DISPLAY.
