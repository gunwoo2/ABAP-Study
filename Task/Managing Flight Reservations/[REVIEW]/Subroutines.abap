*&---------------------------------------------------------------------*
*& Include          ZHWE03_REVIEW_3AF01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form INSERT_DATA
*&---------------------------------------------------------------------*
FORM INSERT_DATA .


  CASE PA_INCL.
    WHEN ABAP_ON.

      SELECT A~MANDT A~CARRID A~CONNID A~FLDATE A~BOOKID
             A~CUSTOMID A~ORDER_DATE A~CANCELLED A~CLASS
             B~COUNTRYFR B~CITYFROM B~COUNTRYTO B~CITYTO
             C~NAME C~FORM C~CITY C~COUNTRY C~REGION
             A~FORCURAM A~FORCURKEY
             A~LOCCURAM A~LOCCURKEY

        FROM SBOOK AS A " INNER JOIN의 INNER 는 생략이 가능
        JOIN SPFLI AS B   ON B~CARRID EQ A~CARRID
                         AND B~CONNID EQ A~CONNID
        JOIN SCUSTOM AS C ON C~ID     EQ A~CUSTOMID
        INTO TABLE GT_DETAIL " Array Fetch
       WHERE B~CARRID IN SO_CAR
         AND B~CONNID IN SO_CON
         AND A~FLDATE IN SO_DAT
         AND A~ORDER_DATE IN SO_ODT
         AND B~COUNTRYFR IN SO_CTRF
         AND B~CITYFROM  IN SO_CITF
         AND B~COUNTRYTO IN SO_CTRT
         AND B~CITYTO    IN SO_CITT.

    WHEN ABAP_OFF.

      SELECT A~MANDT A~CARRID A~CONNID A~FLDATE A~BOOKID
             A~CUSTOMID A~ORDER_DATE A~CANCELLED A~CLASS
             B~COUNTRYFR B~CITYFROM B~COUNTRYTO B~CITYTO
             C~NAME C~FORM C~CITY C~COUNTRY C~REGION
             A~FORCURAM A~FORCURKEY
             A~LOCCURAM A~LOCCURKEY

        FROM SBOOK AS A " INNER JOIN의 INNER 는 생략이 가능
        JOIN SPFLI AS B   ON B~CARRID EQ A~CARRID
                         AND B~CONNID EQ A~CONNID
        JOIN SCUSTOM AS C ON C~ID     EQ A~CUSTOMID
        INTO TABLE GT_DETAIL " Array Fetch
       WHERE B~CARRID IN SO_CAR
         AND B~CONNID IN SO_CON
         AND A~FLDATE IN SO_DAT
         AND A~ORDER_DATE IN SO_ODT
         AND B~COUNTRYFR IN SO_CTRF
         AND B~CITYFROM  IN SO_CITF
         AND B~COUNTRYTO IN SO_CTRT
         AND B~CITYTO    IN SO_CITT
         AND A~CANCELLED EQ SPACE.    " Include 체크박스 미선택시
                                      " 취소된 예약건은 제외하고 조회

      " Include 체크박스 미선택시 위처럼 where절에 cancelled 를 공란인지
      " 점검하는 로직을 추가하지 않고, 아래처럼 cancelled가 'X'인 값만
      " 삭제하여 취소된 예약건을 제외하도록 할 수도 있다.
*      DELETE GT_DETAIL WHERE CANCELLED EQ ABAP_ON.  " 비추천
  ENDCASE.


  DELETE FROM ZDETAIL_E03_REV.                 " 기존 데이터를 삭제하고
  INSERT ZDETAIL_E03_REV FROM TABLE GT_DETAIL. " 신규 데이터를 생성해라

  IF SY-SUBRC EQ 0.
    " TEXT-M01: 입력하신 조건으로 데이터가 성공적으로 생성되었습니다.
    MESSAGE TEXT-M01 TYPE 'S'.
    COMMIT WORK AND WAIT.
    " 데이터베이스 테이블에 변경사항 확정처리
  ELSE.
    " TEXT-E01: 데이터 생성 과정 중 오류가 발생했습니다.
    MESSAGE TEXT-E01 TYPE 'S' DISPLAY LIKE 'E'.
    ROLLBACK WORK.
    " 데이터베이스 테이블에 변경사항 복원처리
  ENDIF.

**  " 키필드 기준으로 데이터가 존재하면 수정하고
**  " 신규 데이터이면 생성한다.
**  MODIFY ZDETAIL_E00_REV FROM TABLE GT_DETAIL. " 느리다.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  " Internal Table 초기화
  REFRESH GT_DETAIL.

  IF PA_INCL EQ ABAP_ON.
    SELECT *
      FROM ZDETAIL_E03_REV
      INTO TABLE GT_DETAIL
     WHERE CARRID     IN SO_CAR
       AND CONNID     IN SO_CON
       AND FLDATE     IN SO_DAT
       AND ORDER_DATE IN SO_ODT
       AND COUNTRYFR  IN SO_CTRF
       AND CITYFROM   IN SO_CITF
       AND COUNTRYTO  IN SO_CTRT
       AND CITYTO     IN SO_CITT.
  ELSE.

    SELECT *
      FROM ZDETAIL_E03_REV
      INTO TABLE GT_DETAIL
     WHERE CARRID     IN SO_CAR
       AND CONNID     IN SO_CON
       AND FLDATE     IN SO_DAT
       AND ORDER_DATE IN SO_ODT
       AND COUNTRYFR  IN SO_CTRF
       AND CITYFROM   IN SO_CITF
       AND COUNTRYTO  IN SO_CTRT
       AND CITYTO     IN SO_CITT
       AND CANCELLED  EQ SPACE.   " [ 취소된 예약건도 포함 ] 하는 체크박스를
                                  " 선택하지 않았을 경우 취소된 예약건은
                                  " 포함하지 않겠다라는 뜻이므로,
                                  " 유효한 예약건만 조회하기 위해
                                  " CANCELLED 필드에 공백인 데이터만 조회

  ENDIF.


  DATA LO_ALV TYPE REF TO CL_SALV_TABLE.

  TRY .
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE   = LO_ALV
        CHANGING
          T_TABLE        = GT_DETAIL.

      CALL METHOD LO_ALV->DISPLAY.

    CATCH CX_SALV_MSG. " ALV: General Error Class with Message
  ENDTRY.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETE_DATA
* DELETE 뒤에는 SUBRC 를 잘 점검하지를 않음
*&---------------------------------------------------------------------*

FORM DELETE_DATA .

  DELETE FROM ZDETAIL_E03_REV.
  COMMIT WORK.

  " TEXT-M02: 데이터가 성공적으로 삭제되었습니다.
  MESSAGE TEXT-M02 TYPE 'S'.

ENDFORM.
