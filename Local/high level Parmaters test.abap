*&---------------------------------------------------------------------*
*& Report YE03_EX010
*&---------------------------------------------------------------------*
*&  Parameters 심화연습
*&---------------------------------------------------------------------*
REPORT YE03_EX010.

" 항공사 ID를 입력할 수 있는 입력필드가 생성됨
PARAMETERS PA_CAR TYPE SCARR-CARRID.

" AS CHECKBOX를 붙이면 문자 1자리만 저장할 수 있는 변수로 생성됨
" 화면에는 체크만 가능한 입력 필드가 생성됨
PARAMETERS PA_CHK1 AS CHECKBOX.
PARAMETERS PA_CHK2 AS CHECKBOX.

" 라디오버튼은 동일한 그룹 내에 하나만 선택이 가능한 타입으로
" 만들어지는 변수는 문자 1자리만 저장 가능.
PARAMETERS PA_RAD1 RADIOBUTTON GROUP RG1. "RG1으로 안묶이면 하나의 그룹으로 안됨
PARAMETERS PA_RAD2 RADIOBUTTON GROUP RG1.
PARAMETERS PA_RAD3 RADIOBUTTON GROUP RG1.


" 체크박스나 라디오 버튼을 선택된 경우 'X' 값을 가지고
" 선택되지 않는 경우는 '' 공백을 가진다.
