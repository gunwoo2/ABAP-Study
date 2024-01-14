*&---------------------------------------------------------------------*
*& Report YE03_EX002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YE03_EX002.

*Local 타입의 선언
TYPES TY_CHAR3 TYPE C LENGTH 3.

" DATA ELEMENT : s_carr_id => char 3

" PARAMETERS의 변수 이름은 최대 8자리까지만 (DATA는 아님)
PARAMETERS: PA_LOCAL TYPE TY_CHAR3,
            PA_GLOBA TYPE S_CARR_ID.
