*&---------------------------------------------------------------------*
*& Report YE03_EX001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YE03_EX001.

"SY : 시스템 변수로 다양한 정보를 가지고 있다.

WRITE /15 'DATE of Hire'. "해당 방식은 거의 사용하지 않음
WRITE /15 TEXT-001. "DATE of Hire 고용일 / 이 방식을 대부분 사용함

WRITE 35 SY-DATUM. "오늘 날짜, 현재 일자

WRITE /15 'Manager'(002). "Manager 관리자

WRITE 35 SY-DATUM. "현재 로그인한 사용자 ID