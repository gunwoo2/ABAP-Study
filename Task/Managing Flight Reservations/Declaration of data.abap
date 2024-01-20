*&---------------------------------------------------------------------*
*& Include          ZHWE03_3A_TOP
*&---------------------------------------------------------------------*

TABLES: SPFLI, SBOOK, SCUSTOM, SFLIGHT. "4개의 테이블 선언

DATA: GT_ZDETAIL TYPE TABLE OF ZDETAIL_E03, " ZDETAIL_E03 타입의 Internal Table 선언
      GS_ZDETAIL TYPE ZDETAIL_E03.          " ZDETAIL_E03 타입의 Work Area 선언
CONSTANTS GC_MARK VALUE 'X'.                " 체크박스 체크 시 비교하기 위한 값을 상수로 선언

*--------------------------------------------------------------------*
*                         Task 2
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK BL1 " 블록, 블록 타이틀, 프레임 생성
  WITH FRAME TITLE TEXT-BL1.        " TEXT-BL1 = Execute Mode

  SELECTION-SCREEN BEGIN OF LINE.   " 가로 한 라인으로 출력

    PARAMETERS PA_RAD1 RADIOBUTTON GROUP RG1 DEFAULT 'X'.       " 라디오버튼 그룹 지정, 디폴트 지정
    SELECTION-SCREEN COMMENT 02(20) TEXT-001 FOR FIELD PA_RAD1. "Insert Data

    PARAMETERS PA_RAD2 RADIOBUTTON GROUP RG1.                   " 라디오버튼 그룹 지정
    SELECTION-SCREEN COMMENT 27(20) TEXT-002 FOR FIELD PA_RAD2. "Select Data

    PARAMETERS PA_RAD3 RADIOBUTTON GROUP RG1.                   " 라디오버튼 그룹 지정
    SELECTION-SCREEN COMMENT 52(20) TEXT-003 FOR FIELD PA_RAD3. " Delete Data

  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK BL1.

*SELECTION-SCREEN SKIP 1.  " 한줄 띄우기
*--------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK BL2 " 블록, 블록 타이틀, 프레임 생성
  WITH FRAME TITLE TEXT-BL2.        " TEXT-BL2 = Selection Options

  SELECT-OPTIONS: SO_CAR FOR SBOOK-CARRID,        " AIRLINE
                  SO_CON FOR SBOOK-CONNID,        " Connection Number
                  SO_FLD FOR SBOOK-FLDATE,      " Flight Date
                  SO_POD FOR SBOOK-ORDER_DATE.    " Posting Date

SELECTION-SCREEN END OF BLOCK BL2.
*SELECTION-SCREEN SKIP 1. " 한줄 띄우기
*--------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK BL3 " 블록, 블록 타이틀, 프레임 생성
  WITH FRAME TITLE TEXT-BL3.        " TEXT-BL3 = Additional Options

  SELECT-OPTIONS: SO_COFR FOR SPFLI-COUNTRYFR NO INTERVALS NO-EXTENSION, " Depart. Coutry, high 제거, multiple selection 제거
                  SO_CIFR FOR SPFLI-CITYFROM NO INTERVALS NO-EXTENSION,  " Depart. City, high 제거, multiple selection 제거
                  SO_COTO FOR SPFLI-COUNTRYTO NO INTERVALS NO-EXTENSION, " Arrival Country, high 제거, multiple selection 제거
                  SO_CITO FOR SPFLI-CITYTO NO INTERVALS NO-EXTENSION.    " Arrival City, high 제거, multiple selection 제거


  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS PA_BOOK AS CHECKBOX. " 체크박스 PA_BOOK 생성
    SELECTION-SCREEN COMMENT 2(30) TEXT-S02 FOR FIELD PA_BOOK. " Text-S02 = Include cancelled book
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK BL3.
