*&---------------------------------------------------------------------*
*& Report YE03_EX025
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YE03_EX025.

DATA GT_BDCDATA TYPE TABLE OF BDCDATA.
DATA GS_BDCDATA TYPE BDCDATA.

SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-T01.
  PARAMETERS PA_CAR TYPE SCARR-CARRID OBLIGATORY. "  필수
SELECTION-SCREEN END OF BLOCK B01.

START-OF-SELECTION.


  REFRESH GT_BDCDATA.

  CLEAR GS_BDCDATA.
  GS_BDCDATA-PROGRAM  = 'SAPMYE00_EX004'.
  GS_BDCDATA-DYNPRO   = '0100'.
  GS_BDCDATA-DYNBEGIN = ABAP_ON.
*  GS_BDCDATA-FNAM     =
*  GS_BDCDATA-FVAL     =
  APPEND GS_BDCDATA TO GT_BDCDATA.
* 'SAPMYE00_EX004' / '0100' / ABAP_ON /    /      /

  CLEAR GS_BDCDATA.
*  GS_BDCDATA-PROGRAM  =
*  GS_BDCDATA-DYNPRO   =
*  GS_BDCDATA-DYNBEGIN =
  GS_BDCDATA-FNAM = 'SCARR-CARRID'. " 화면의 입력필드 이름
  GS_BDCDATA-FVAL = PA_CAR.
  APPEND GS_BDCDATA TO GT_BDCDATA.
* 'SAPMYE00_EX004' / '0100' / ABAP_ON /                /        /
*                  /        /         / 'SCARR-CARRID' / PA_CAR /

  CLEAR GS_BDCDATA.
  GS_BDCDATA-FNAM = 'BDC_OKCODE'.
  GS_BDCDATA-FVAL = '/0'.
  APPEND GS_BDCDATA TO GT_BDCDATA.
* 'SAPMYE00_EX004' / '0100' / ABAP_ON /                /        /
*                  /        /         / 'SCARR-CARRID' / PA_CAR /
*                  /        /         / 'BDC_OKCODE'   / '/0'   /

  CALL TRANSACTION 'YE00EX004'
             USING GT_BDCDATA
              MODE 'E'. " A : GT_BDCDATA의 과정을 모두 보여줌
                        " E : GT_BDCDATA의 마지막 과정까지 끝난 모습 OR
                        "     GT_BDCDATA의 과정 중 오류가 발생한 모습
                        " N(Background, 화면에 안보임) 3가지 모드가 있다.
