*&---------------------------------------------------------------------*
*& Report YE03_EX004
*&---------------------------------------------------------------------*
*& 반복문 연습
*&---------------------------------------------------------------------*
REPORT YE03_EX004.

PARAMETERS PA_DAN TYPE I.

"PA_DAN이 2부터 9가 아닐때
"IF NOT PA_DAN  BETWEEN 2 AND 9. NOT이 앞에 있어도 똑같은 의미
IF PA_DAN NOT BETWEEN 2 AND 9.
  WRITE '구구단은 2부터 9까지만 입력이 가능합니다.'.
  "로직 중단
  EXIT.
ENDIF.

"여기에 있는 로직은, 위의 IF 조건에 해당되지 않는 경우
DATA GV_RESULT TYPE I.
DO 9 TIMES.
  GV_RESULT = PA_DAN * SY-INDEX.
  WRITE /1 PA_DAN.  "새로운 줄의 첫번째 칸에 PA_DAN을 출력
  WRITE  'X'.       "다음칸에는 'X' 문자를 출력
  WRITE  SY-INDEX.  "다음칸에는 SY-INDEX 문자를 출력
  WRITE  '='.       "다음칸에 '=' 문자를 출력
  WRITE  GV_RESULT. "다음칸에 GV_RESULT를 출력
ENDDO.
