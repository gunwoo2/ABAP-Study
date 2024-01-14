*&---------------------------------------------------------------------*
*& Report  BC400_DOS_COMPUTE
*&
*&---------------------------------------------------------------------*
*&
*& Simple calculator
*&---------------------------------------------------------------------*
REPORT  zbc400_e03_subroutine.

PARAMETERS:
  pa_int1  TYPE i, " 분자
  pa_op    TYPE c LENGTH 1,
  pa_int2  TYPE i. " 분모

DATA gv_result TYPE p LENGTH 16 DECIMALS 2.
DATA e01.

IF ( pa_op = '+' OR
     pa_op = '-' OR
     pa_op = '*' OR
    ( pa_op = '/' AND pa_int2 <> 0 ) OR
     pa_op = '%' ).

  CASE pa_op.
    WHEN '+'.
      gv_result = pa_int1 + pa_int2.
    WHEN '-'.
      gv_result = pa_int1 - pa_int2.
    WHEN '*'.
      gv_result = pa_int1 * pa_int2.
    WHEN '/'.
      gv_result = pa_int1 / pa_int2.
    WHEN '%'.
      PERFORM CALC_PERCENTAGE USING PA_INT1
                                    PA_INT2
                           CHANGING GV_RESULT.
  ENDCASE.

  WRITE: 'Result:'(res), gv_result.

ELSEIF pa_op = '/' AND pa_int2 = 0.

  WRITE 'No division by zero!'(dbz).

ELSE.

  WRITE 'Invalid operator!'(iop).

ENDIF.



  WRITE : / 'CALC_PERCENTAGE 의 수행결과'.

*--------------------------------------------
* FORM
*-------------------------------------------
FORM CALC_PERCENTAGE

  USING
        VALUE(PV_ACT) TYPE I "CALL BY VALUE / LENGTH 16 DECIMALS 2
        VALUE(PV_MAX) TYPE I "CALL BY VALUE
  CHANGING
        VALUE(CV_RESULT) LIKE GV_RESULT. "CALL BY VALUE AND RESULT

  IF PV_MAX = 0.
    WRITE '0으로 나눌 수 없습니다.'(E01).
    ELSE.
      CV_RESULT = PV_ACT * 100 / PV_MAX.
  ENDIF.


ENDFORM.
