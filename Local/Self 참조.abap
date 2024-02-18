*&---------------------------------------------------------------------*
*& Report YE00_EX033
*&---------------------------------------------------------------------*
*& Self 참조
*&---------------------------------------------------------------------*
REPORT YE03_EX033.


CLASS LCL_CAR DEFINITION.
  PUBLIC SECTION.
    METHODS CONSTRUCTOR IMPORTING IV_NUMBER1 TYPE STRING.
    METHODS SET_NUMBER  IMPORTING IV_NUMBER2  TYPE STRING.

  PRIVATE SECTION.
    DATA MV_NUMBER TYPE STRING.

ENDCLASS.

CLASS LCL_CAR IMPLEMENTATION.
  METHOD CONSTRUCTOR.
    " 객체가 생성되고 자동으로 호출되는 메소드
    " 지금 이 메소드가 실행이 되고 있다면, 이미 객체는 만들어져 있는데,
    " 그 객체를 기준으로 생성자 메소드가 실행되고 있다.
*    ME->SET_NUMBER( IV_NUMBER2 = IV_NUMBER1 ).
    CALL METHOD SET_NUMBER
      EXPORTING
        IV_NUMBER2 = IV_NUMBER1.
  ENDMETHOD.
  METHOD SET_NUMBER.
    MV_NUMBER = IV_NUMBER2.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA LO_CAR  TYPE REF TO LCL_CAR.
  DATA LO_CAR2 TYPE REF TO LCL_CAR.

  CREATE OBJECT LO_CAR
    EXPORTING
      IV_NUMBER1 = '100가1234'.

  CREATE OBJECT LO_CAR2
    EXPORTING
      IV_NUMBER1 = '100나5678'.

  CALL METHOD LO_CAR->SET_NUMBER
    EXPORTING
      IV_NUMBER2 = '200다0000'.
