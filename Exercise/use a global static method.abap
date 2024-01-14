*&---------------------------------------------------------------------*
*& Report  ZBC400_E03_GLOBAL_CLASS_1
*&
*&---------------------------------------------------------------------*
*&
*& Simple calculator + percentage(FUNCTION)
*& + power(global static method)
*&---------------------------------------------------------------------*
REPORT  ZBC400_E03_GLOBAL_CLASS_1.

PARAMETERS:
  PA_INT1 TYPE I, " 분자
  PA_OP   TYPE C LENGTH 1,
  PA_INT2 TYPE I. " 분모

DATA GV_RESULT TYPE P LENGTH 16 DECIMALS 2.
DATA E01.

IF ( PA_OP = '+' OR
     PA_OP = '-' OR
     PA_OP = '*' OR
    ( PA_OP = '/' AND PA_INT2 <> 0 ) OR
     PA_OP = '%'  OR
     PA_OP = 'P' ). "제곱 계산을 위해 P 라는 연산자 추가

  CASE PA_OP.
    WHEN '+'.
      GV_RESULT = PA_INT1 + PA_INT2.
    WHEN '-'.
      GV_RESULT = PA_INT1 - PA_INT2.
    WHEN '*'.
      GV_RESULT = PA_INT1 * PA_INT2.
    WHEN '/'.
      GV_RESULT = PA_INT1 / PA_INT2.
    WHEN '%'.
*      PERFORM CALC_PERCENTAGE USING PA_INT1
*                                    PA_INT2
*                           CHANGING GV_RESULT.

      CALL FUNCTION 'Z_BC400_E99_COMP_PERCENTAGE'
        EXPORTING
          IV_ACT           = PA_INT1                 " Current Value for Percentage Calculation
          IV_MAX           = PA_INT2                 " Maximum Value for Exponent Calculation
        IMPORTING
          EV_PERCENTAGE    = GV_RESULT                " Result of Percentage Calculation with Two Decimal Places
        EXCEPTIONS
          DIVISION_BY_ZERO = 1                " 분모가 0으로 오류가 발생
          OTHERS           = 2.



      CASE SY-SUBRC.

        WHEN 0.
        WHEN 1. " EXCEPTIONS DIVISION_BY_ZERO 발생
          WRITE / TEXT-E01.
          EXIT.
        WHEN 2. " 알 수 없는 없는 오류 발생
          WRITE / TEXT-E04.
          EXIT.
      ENDCASE.


    WHEN 'P'.

      TRY.
          CALL METHOD CL_BC400_COMPUTE=>GET_POWER
            EXPORTING
              IV_BASE   = PA_INT1                 " Base Value for Power Calculation
              IV_POWER  = PA_INT2                 " Exponent for Power Calculation
            IMPORTING
              EV_RESULT = GV_RESULT.                 " Result of Calculation with Two Decimal Places
        CATCH CX_BC400_POWER_TOO_HIGH.  " The maximum value for the exponent is 4
          WRITE / '제곱수는 4까지만 입력하세요'(E02).
          EXIT.
        CATCH CX_BC400_RESULT_TOO_HIGH. " Result of calculation too high for result variable
          WRITE / '계산 결과가 너무 큽니다.'(E03).
          EXIT.
      ENDTRY.


*      CALL FUNCTION 'BC400_MOS_POWER'
*      "함수에 PA_INT1 과 PA_INT2의 값을 전달한다
*        EXPORTING
*          IV_BASE               = PA_INT1    " Base Number for Exponent Calculation
*          IV_POWER              = PA_INT2    " Exponent for Power Calculation
*        "함수가 끝난 뒤에 결과 EV_RESULT를 GV_RESULT로 가져온다
*        IMPORTING "IMPORTING은 대입이 왼쪽에서 오른쪽으로 대입 (특이케이스)
*          EV_RESULT             = GV_RESULT                 " Result of Calculation with Two Decimal Places
*        EXCEPTIONS
*          POWER_VALUE_TOO_HIGH  = 1                " Exponent too hight (>4)
*          RESULT_VALUE_TOO_HIGH = 2                " Result too high
*          OTHERS                = 3
*        .
*
*   ENDCASE.
*
*      CASE SY-SUBRC.
*
*        WHEN 0. "0은 항상 정상적인 결과로 마쳤을 때
*        WHEN 1. "Exception POWER_VALUE_TOO_HIGH 가 발생함
*          WRITE / '제곱수는 4까지만 입력하세요'(E02).
*          EXIT. "진행을 중단. 아래 RESULT 가 출력되는 WRITE 문을 실행하지 않기 위해
*        WHEN 2. "Exception RESULT_VALUE_TOO_HIGH 가 발생함
*          WRITE / '계산 결과가 너무 큽니다.'(E03).
*          EXIT. "1과 동일하게 진행을 중단
*        WHEN 3. "Exception OTHERS 가 발생함
*                "CALL FUNCTION 에서 작성하지 않은 남은 모든 오류를 전부
*                "OTHERS로 취급한다.
*          WRITE /'미확인 에러가 발생했습니다.'(E04).
*          EXIT. "1과 2와 동일하게 진행을 중단.
*
*
  ENDCASE.

  WRITE: 'Result:'(RES), GV_RESULT.

ELSEIF PA_OP = '/' AND PA_INT2 = 0.

  WRITE 'No division by zero!'(DBZ).

ELSE.

  WRITE 'Invalid operator!'(IOP).

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
