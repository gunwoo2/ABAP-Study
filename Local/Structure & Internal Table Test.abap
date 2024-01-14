*&---------------------------------------------------------------------*
*& Report YE03_EX008
*&---------------------------------------------------------------------*
*& Structure 와 Internal Table 연습
*&---------------------------------------------------------------------*
REPORT YE03_EX008.

"1. ABAP Dictionary에서 Structure로 선언된 Data Type을 이용한다.
DATA GS_1 TYPE BC400_S_FLIGHT.

" 2. Local Type을 이용해 Structure를 선언한다.
TYPES: BEGIN OF TS_1,
         CARRID TYPE BC400_S_FLIGHT-CARRID,
       END OF TS_1.

DATA GS_2 TYPE TS_1.

" 3. 변수 선언과 동시에 Structure의 Component를 작성한다.
" 가장 많이 쓰는 방법
DATA: BEGIN OF GS_3,
        CARRID TYPE BC400_S_FLIGHT-CARRID,
      END OF GS_3.

* ----------------------------------------------------------*
*      Internal Table 선언 방법
* ----------------------------------------------------------*

" 1. ABAP Dictionary 에 있는 Table Type를 사용하는 방법
" 가끔씩 쓰이는 문법 구조
DATA GT_1 TYPE BC400_T_FLIGHTS.


" 2. ABAP Dictionary 에 Table Type은 없지만 Structure 가 있는 경우
" gt_2는 거의 사용하지 않고 gt_3가 그나마 가끔 쓰임
DATA GT_2 TYPE TABLE OF BC400_S_FLIGHT. "Standard Internal Table (약식 표현,  대세
DATA GT_3 TYPE STANDARD TABLE OF BC400_S_FLIGHT "Standard 를 직접적으로 표현
WITH NON-UNIQUE KEY CARRID CONNID FLDATE. "중복허용된 키필드 추가


" 3. 프로그램에서 선언한 Structure 변수를 이용해서 Internal Table을 선언하는 방법
" 가장 선호하시는 방법
DATA GT_4 LIKE TABLE OF GS_1. "변수 GS_1의 필드 구성과 동일한 Internal Table이 생성된다.
DATA GT_4B LIKE SORTED TABLE OF GS_1 "Internal Table이 standard 가 아닌 sorted 방식인 경우
      WITH UNIQUE KEY CARRID CONNID FLDATE. "중복을 허용하지 않는 키필드로 구성



" 4. 옛문법) Internal Table 선언과 동시에 필드를 구성하는 방법 (With Header Line)
DATA: BEGIN OF GT_5 OCCURS 0,
        CARRID TYPE  BC400_S_FLIGHT-CARRID,
        CONNID TYPE  BC400_S_FLIGHT-CONNID,
      END OF GT_5. "이 Internal Table은 Field가 2개 존재함
"이 선언방법은 Internal Table 반드시 Standard로만 사용이 가능
" 그리고 Key Field를 지정할 방법이 없음.



*BREAK-POINT. "디버기 모드가 아니더라도 이 문장을 만나면, 디버깅 모드가 됨
*GS_1-CARRID = 'AA'.
*GS_1-CONNID = '0017'.
*GS_1-FLDATE = '20201107'.
*
*APPEND GS_1 TO GT_1.
*
*BREAK-POINT. "디버기 모드가 아니더라도 이 문장을 만나면, 디버깅 모드가 됨

DATA GT_CARR TYPE TABLE OF SCARR.
DATA GS_CARR TYPE SCARR.

SELECT * FROM SCARR INTO TABLE GT_CARR.

LOOP AT GT_CARR INTO GS_CARR.
  WRITE : / GS_CARR-CARRID,
        GS_CARR-CARRNAME,
        GS_CARR-CURRCODE,
        40 GS_CARR-URL.
ENDLOOP.
