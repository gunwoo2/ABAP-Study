*&---------------------------------------------------------------------*
*& Report YE03_EX009
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YE03_EX009.

TABLES SCARR.

  PARAMETERS PA_CAR TYPE SCARR-CARRID.    "단일값(한칸)을 지닌 변수
  SELECT-OPTIONS SO_CAR FOR SCARR-CARRID. "4개의 필드를 지닌 Internal Table
                                          "단일값 검색 가능
                                          "범위 검색 가능
                                          "다양한 조건 사용 가능
                                          "다중  조건 가능
                                          "빈 값일 경우 전체검색 가능
