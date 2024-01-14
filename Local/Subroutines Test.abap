*&---------------------------------------------------------------------*
*& Report YE03_EX005
*&---------------------------------------------------------------------*
*& Subroutines 연습
*&---------------------------------------------------------------------*
REPORT YE03_EX005.

WRITE 'Subroutines 호출 전'.
PERFORM WRITE_LIST.
WRITE 'Subroutines 호출 후'.

ULINE.

WRITE 'Subroutines 두번째 호출 전'.
PERFORM WRITE_LIST.
WRITE 'Subroutines 두번째 호출 후'.



" SUBROUTINES 생성
" FORM 키워드 + SUBROUTINES 이름
FORM WRITE_LIST.

  WRITE 'List of Airlines'.
  SKIP.
  WRITE / 'LH Lufthansa'.
  WRITE / 'AA American Airlines'.
  WRITE / 'UA United Airlines'.
  " SKIP, ULINE (밑줄 그어주기)
  SKIP.
  ULINE.

ENDFORM.
