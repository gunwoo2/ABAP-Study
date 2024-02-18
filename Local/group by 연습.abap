*&---------------------------------------------------------------------*
*& Include          YE00_EX024F01
*&---------------------------------------------------------------------*

* Main 부분은 생략함. 

*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  " 항공사의 항공편의 출발도시와 도착도시별
  " 최대좌석수 합계와
  " 예약좌석수 합계와
  " 해당 데이터의 갯수 를 조회하는 SELECT 문
  SELECT A~CARRID
         A~CONNID
         A~CITYFROM
         A~CITYTO
         SUM( B~SEATSMAX )
         SUM( B~SEATSOCC )
         COUNT(*)
    FROM SPFLI   AS A
    JOIN SFLIGHT AS B ON B~CARRID EQ A~CARRID
                     AND B~CONNID EQ A~CONNID
    INTO TABLE GT_DATA
   GROUP BY A~CARRID
            A~CONNID
            A~CITYFROM
            A~CITYTO.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .

  DATA LV_LINES TYPE I.

  " Internal Table 분석하는 키워드로
  " LINES 를 적으면 뒤에 등장하는 숫자 변수에게
  " 현재 Internal Table이 보유한 데이터의 개수를 전달한다.
  DESCRIBE TABLE GT_DATA LINES LV_LINES.

  " & 건의 데이터가 검색되었습니다.
  MESSAGE S033 WITH LV_LINES.

  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

* 1. 컨테이너 참조변수로부터 객체를 생성한다. => CREATE OBJECT
* 2. ALV 참조변수로부터 객체를 생성한다.      => CREATE OBJECT

  CREATE OBJECT GO_CONTAINER
    EXPORTING
      CONTAINER_NAME = 'MY_CONTROL_AREA'  " Name of the Screen CustCtrl
    EXCEPTIONS
      OTHERS         = 1.

  IF SY-SUBRC <> 0. " 컨테이너 생성 중 SY-SUBRC 가 0 이 아닌 값인 경우
    " 생성 과정 중 오류가 발생했음을 의미한다.
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.

    " 메시지클래스 ZTEST03_MSG 의 020 번 메시지를 오류 메시지로 출력한다.
    MESSAGE E023. " Custom Container 생성 중 오류가 발생했습니다.
  ENDIF.

  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT = GO_CONTAINER " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF SY-SUBRC <> 0. " ALV 생성 중 SY-SUBRC 가 0 이 아닌 값의 경우
    " 생성 과정 중 오류가 발생했음을 의미한다.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.

    " 메시지클래스 ZTEST03_MSG 의 021 번 메세지를 오류 메시지로 출력한다.
    MESSAGE E024. " ALV Grid 생성 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  GS_LAYOUT-SEL_MODE   = 'D'.     " 셀단위 자유롭게 선택가능
  GS_LAYOUT-CWIDTH_OPT = ABAP_ON. " 열넓이 최적화
  GS_LAYOUT-ZEBRA      = ABAP_ON. " 얼룩 처리

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

  " ALV 에서 1번째 출력 필드는 CARRID 이다
  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'CARRID' .
  GS_FIELDCAT-COL_POS = 1.
  GS_FIELDCAT-REF_TABLE = 'SPFLI'.
*  GS_FIELDCAT-REF_FIELD = " => 생략가능 왜? FIELDNAME 이랑 REF_FIELD랑 같은 값이라서
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  " ALV 에서 2번째 출력 필드는 CONNID 이다
  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'CONNID' .
  GS_FIELDCAT-COL_POS = 2.
  GS_FIELDCAT-REF_TABLE = 'SPFLI'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  " ALV 에서 3번째 출력 필드는 CITYFROM 이다
  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'CITYFROM' .
  GS_FIELDCAT-COL_POS = 3.
  GS_FIELDCAT-REF_TABLE = 'SPFLI'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  " ALV 에서 4번째 출력 필드는 CITYTO 이다
  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'CITYTO ' .
  GS_FIELDCAT-COL_POS = 4.
  GS_FIELDCAT-REF_TABLE = 'SPFLI'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  " ALV 에서 5번째 출력 필드는 SEATSMAX 이다
  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'SEATSMAX' .
  GS_FIELDCAT-COL_POS = 5.
  GS_FIELDCAT-REF_TABLE = 'SFLIGHT'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  " ALV 에서 6번째 출력 필드는 SEATSOCC 이다
  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'SEATSOCC' .
  GS_FIELDCAT-COL_POS = 6.
  GS_FIELDCAT-REF_TABLE = 'SFLIGHT'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  " ALV 에서 7번째 출력 필드는 CARRID 이다
  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'COUNT ' .
  GS_FIELDCAT-COL_POS = 7.
  GS_FIELDCAT-ROLLNAME = 'ZEX_COUNT_E00_REVIEW'.
  GS_FIELDCAT-COLTEXT = '비행횟수'(F01).
  APPEND GS_FIELDCAT TO GT_FIELDCAT.


*  PERFORM APPEND_FIELDCAT USING

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  GS_VARIANT-REPORT = SY-REPID.
  GV_SAVE = 'A'.

  CALL METHOD GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*      I_STRUCTURE_NAME =                  " Internal Output Table Structure Name
      IS_VARIANT       = GS_VARIANT         " Layout
      I_SAVE           = GV_SAVE          " Save Layout
      I_DEFAULT        = 'X'              " Default Display Variant
      IS_LAYOUT        = GS_LAYOUT        " Layout
    CHANGING
      IT_OUTTAB                     = GT_DATA       " Output Table
      IT_FIELDCATALOG               = GT_FIELDCAT                 " Field Catalog
*      IT_SORT                       =                  " Sort Criteria
*      IT_FILTER                     =                  " Filter Criteria
*    EXCEPTIONS
*      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
*      PROGRAM_ERROR                 = 2                " Program Errors
*      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
*      OTHERS                        = 4
    .
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
