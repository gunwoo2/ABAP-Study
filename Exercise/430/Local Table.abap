*&---------------------------------------------------------------------*
*& Report ZBC430_E03_LOCAL_TABLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC430_E03_LOCAL_TABLE.
*
* LOCAL TABLE TYPE 이용한 INETERNAL TABLE 생성
* HEADER LINE 이 있는경우
*임의의 데이터를 INTERNAL TABLE에 추가 및 출력

* LOCAL 중 Structure Type 선언
TYPES : BEGIN OF S_TYPE,
          NUM(6)  TYPE C,
          NUM(10) TYPE C,
          NUM(15) TYPE C,
        END OF S_TYPE.

TYPES : BEGIN OF S_TYPE_2,
          NUM TYPE C LENGTH 6,
          NUM TYPE C LENGTH 10,
          NUM TYPE C LENGTH 15,
        END OF S_TYPE_2.



*Internal Table 선언
*DATA : GT_ITAB TYPE TABLE OF S_TYPE
DATA : GT_ITAB TYPE STANDARD TABLE OF S_TYPE

*               INTERNAL TABLE의 KEY FIELD 지정
               WITH NON-UNIQUE KEY NO


         " 3개 필드 중 데이터 구별이 가능하면서
         " 가장 적은 개수의 필드로 구성하는게 베스트다.


         "동일한 이름의 Structure 변수도 생성시키는 옵션
         WITH HEADER LINE.

CLEAR ITAB. " Structure 변수 초기화
CLEAR ITAB[]. " INTERNAL TABLE 변수 초기화

ITAB-NUM = '0001'.
ITAB-NAME = '홍길동'.
ITAB-PHONE = '010-1111-1111'.

*
*위와 같이 데이터가 저장된 STRUCTURE를
* INTERNAL TABLE에 한줄 추가하고 싶을 때
*APPEND 또는 INSERT 키워드를 사용할 수 있다.
APPEND ITAB.    " Structure itab에 있는 한줄을
                "internal table itab의 마지막에
                "한줄 추가하게 된다.


" 현재 itab 에는 num 필드에는 '0001'이
" name 에는 '홍길동'이
" phone 에는 '010-1111-1111' 이 저장되어 있다.
