*&---------------------------------------------------------------------*
*& Report ZHWE03_1B
*&---------------------------------------------------------------------*
*& 특정 범위의 누적합 계산하기
*&---------------------------------------------------------------------*
REPORT ZHWE03_1B.

PARAMETERS PA_NUM1 TYPE I.
PARAMETERS PA_NUM2 TYPE I.

DATA GV_A TYPE I.
DATA GV_B LIKE PA_NUM1.
DATA GV_C LIKE PA_NUM2.

MOVE PA_NUM1 TO GV_B.
MOVE PA_NUM2 TO GV_C.

PERFORM PARTIAL_SUM CHANGING GV_A GV_B GV_C.


FORM PARTIAL_SUM CHANGING PV_A TYPE I
                          PV_B TYPE I
                          PV_C TYPE I.

*  DATA PV_C TYPE I.

  IF PV_B < 1 OR PV_C < 1.

"   MESSAGE I001( 권한 문제)
   WRITE / '입력 숫자가 1보다 작습니다'.

  ELSEIF

    PV_B > 100 OR PV_C > 100.

    WRITE / '입력 숫자가 100보다 큽니다'.

  ELSEIF

    PV_B > PV_C.

    WRITE / '시작 정수가 종료 정수보다 큽니다.'.

  ELSE.

      DO  ( PV_C - PV_B + 1 ) TIMES.

          PV_A = PV_A + ( PV_B +  ( SY-INDEX - 1 ) ).
*          PV_A = PV_A +  PV_B +   SY-INDEX - 1.

      ENDDO.

   WRITE : / '특정범위의 누적합 계산 결과 = ', PV_A.

  ENDIF.

ENDFORM.
