*&---------------------------------------------------------------------*
*& Report YE03_EX006
*&---------------------------------------------------------------------*
*& Subroutines parameters 연습
*&---------------------------------------------------------------------*
REPORT ye03_ex006.

"전역 변수 선언(Global variable)  선언
DATA gv_a TYPE i.
DATA gv_b TYPE i.

"GV_B 에는 10 이라는 숫자를 저장
gv_b = 10.

  WRITE :/ 'A = ', gv_a.
  WRITE :/ 'B = ', gv_b.

  ULINE.

  GV_A = 0.
  GV_B = 10.


*  PERFORM double_value USING  GV_A GV_B.

*  WRITE : / 'CALL BY VALUE AND RESULT 의 수행결과'.
*  WRITE : / 'A = ', GV_A.
*  WRITE : / 'B = ', GV_B.


*  PERFORM double_value_AND_RESULT CHANGING GV_A GV_B.

*  WRITE : / 'CALL BY VALUE AND RESULT 의 수행결과'.
*  WRITE : / 'A = ', GV_A.
*  WRITE : / 'B = ', GV_B.

PERFORM DOUBLE_REFERENCE USING GV_A GV_B.

  WRITE : / 'CALL BY VALUE AND RESULT 의 수행결과'.
  WRITE : / 'A = ', GV_A.
  WRITE : / 'B = ', GV_B.

  " CALL BY REF.에 해당하는 FORM 선언
  FORM DOUBLE_REFERENCE USING PV_A
                              PV_B.

    " B에 있는 값을 2배로 만든 후에 A에 저장한다.
    PV_A = 2 * PV_B.

  ENDFORM.

  " CALL BY VALUE AND RESULT에 해당하는 FORM 선언
  " 아래 FORM 에는 Parameter가 2개 있다. (PV_A, PV_B)
  FORM double_value_AND_RESULT CHANGING VALUE(PV_A)
                                        VALUE(PV_B).

    "B에 있는 값을 2배로 만든 후에 A에 저장한다.
    PV_A = 2 * PV_B.


  ENDFORM.


" CALL BY VALUE에 해당하는 FORM 선언
" 아래 FORM 에는 Parameter가 2개 있다. (PV_A, PV_B)
FORM double_value USING VALUE(pv_a) "Parameter Variable
                        VALUE(pv_b).

  "B에 있는 값을 2배로 만든 후에 A에 저장한다.
  pv_a = 2 * pv_b.

ENDFORM.
