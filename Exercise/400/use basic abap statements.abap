*&---------------------------------------------------------------------*
*& Report ZBC400_E03_COMPUTE
*&---------------------------------------------------------------------*
*& Exercise 14 use basic abap statements
*&---------------------------------------------------------------------*
REPORT ZBC400_E03_COMPUTE.

PARAMETERS: PA_INT1 TYPE I,
            PA_OP   TYPE C,
            PA_INT2 TYPE I.
            "PA_OP   TYPE C.

DATA GV_RESULT TYPE P LENGTH 16 DECIMALS 2.

CASE PA_OP.
  WHEN '+'.
    GV_RESULT = PA_INT1 + PA_INT2.
  WHEN '-'.
    GV_RESULT = PA_INT1 - PA_INT2.
  WHEN '*'.
    GV_RESULT = PA_INT1 * PA_INT2.
  WHEN '/'.
    IF PA_INT2 EQ 0. "분모가 0인 경우에는 나눗셈을 할 수 없다.
     WRITE (30) TEXT-E01.
*    WRITE  '분모가 0인 경우에는 나눗셈을 할 수 없습니다.'.
    ELSE.
    GV_RESULT = PA_INT1 / PA_INT2.
    ENDIF.
  WHEN OTHERS.
     MESSAGE I001(YE03_MSG) WITH TEXT-E02.
*    MESSAGE I007(YE03_MSG).
*    WRITE (30) TEXT-E02.
*    WRITE '사칙연산 기호만 입력이 가능합니다'.
    EXIT. "프로그램 중단
ENDCASE.

  WRITE: TEXT-M01,
         GV_RESULT.
* WRITE: '계산 결과 = ', GV_RESULT.
