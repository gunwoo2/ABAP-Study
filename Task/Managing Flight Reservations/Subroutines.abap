*&---------------------------------------------------------------------*
*& Include          ZHWE03_3A_F01 / Subroutines
*&---------------------------------------------------------------------*


*--------------------------------------------------------------------*
*                         Task 3 : Insert Data
*
* 1. SBOOK의 데이터를 기준으로 SPFLI와 SCUSTOM의 데이터를 JOIN 한다.
*    이때, 모든 테이블은 서로 존재하는 데이터만 취급하도록 한다. (INNER JOIN)
* 2. 데이터 검색 시, Selection Screen의 모든 입력필드가 검색조건에 포함 되어야 하며,
*    [체크박스]의 경우 체크 시, SBOOK의 필드 CANCELLED에 대해 조건 없음
*    [체크박스]의 경우 체크 해제 시, SBOOK의 필드 CANCELLED의 값이 공란인 레코드
* 3. 검색된 데이터는 Task 1의 테이블에 저장
*--------------------------------------------------------------------*

" 체크박스가 선택됐을 시, 수행되는 Subroutines
FORM INSERT_CHECKDATA.

  REFRESH GT_ZDETAIL. " Internal Table 초기화

  SELECT A~CARRID     " Airline Code
         A~CONNID     " Flight Connection Number
         A~FLDATE     " Flight date
         A~BOOKID     " Booking number
         A~CUSTOMID   " Customer Number
         A~ORDER_DATE " Booking Date
         A~CANCELLED  " Cancelation flag
         A~CLASS      " Flight Class
         B~COUNTRYFR  " Country Key
         B~CITYFROM   " Departure city
         B~COUNTRYTO  " Country Key
         B~CITYTO     " Arrival city
         C~NAME       " Customer name
         C~FORM       " Form of address
         C~CITY       " City
         C~COUNTRY    " Country Code
         C~REGION     " Region
         A~FORCURAM   " Booking price in foreign currency
         A~FORCURKEY  " Payment currency
         A~LOCCURAM   " Price of booking in local currency of airline
         A~LOCCURKEY  " Local currency of airline

  " SCARR 테이블과 SPFLI 테이블을 공통된 키 필드인 'CARRID'과 'CONNID'를
  " 통해 Inner Join을 수행
  FROM SBOOK AS A
  INNER JOIN SPFLI AS B
  ON A~CARRID EQ B~CARRID AND A~CONNID EQ B~CONNID

  " SCUSTOM의 테이블의 키필드인 ID와 SBOOK의 CUSTOMID를 Inner Join 함
  INNER JOIN SCUSTOM AS C
  ON A~CUSTOMID EQ C~ID

  " Internal Table에 데이터를 삽입. 이때 Corrspondig을 사용하여
  " 일치하는 필드에 데이터를 넣음
  INTO CORRESPONDING FIELDS OF TABLE GT_ZDETAIL

  WHERE A~CARRID IN SO_CAR AND  " SELECT-OPTION의 SO_CAR (Airline)이 조건에 포함
  A~CONNID IN SO_CON AND        " SELECT-OPTION의 SO_CON (Connection Number)이 조건에 포함
  A~FLDATE IN SO_FLD AND        " SELECT-OPTION의 SO_FLD (Flight Date)이 조건에 포함
  A~ORDER_DATE IN SO_POD AND    " SELECT-OPTION의 SO_POD (Posting Date)이 조건에 포함
  B~COUNTRYFR IN SO_COFR AND    " SELECT-OPTION의 SO_COFR (Depart. Coutry)이 조건에 포함
  B~CITYFROM IN SO_CIFR AND     " SELECT-OPTION의 SO_CIFR (Depart. City)이 조건에 포함
  B~COUNTRYTO IN SO_COTO AND    " SELECT-OPTION의 SO_COTO (Arrival Country)이 조건에 포함
  B~CITYTO IN SO_CITO.          " SELECT-OPTION의 SO_CITO (Arrival City)이 조건에 포함

  " 기존에 Insert 시 DB 테이블에 존재하는 데이터를 지우기 위해 선언함.
  DELETE FROM ZDETAIL_E03.
  " Internal Table의 결과 값을 생성한 DB 테이블 (ZDETAIL_E03)에 삽입
  INSERT ZDETAIL_E03 FROM TABLE GT_ZDETAIL.

ENDFORM.


" 체크박스가 미 선택됐을 시, 수행되는 Subroutines
FORM INSERT_NOCHECKDATA.

  REFRESH GT_ZDETAIL. " Internal Table 초기화

  SELECT A~CARRID     " Airline Code
         A~CONNID     " Flight Connection Number
         A~FLDATE     " Flight date
         A~BOOKID     " Booking number
         A~CUSTOMID   " Customer Number
         A~ORDER_DATE " Booking Date
         A~CANCELLED  " Cancelation flag
         A~CLASS      " Flight Class
         B~COUNTRYFR  " Country Key
         B~CITYFROM   " Departure city
         B~COUNTRYTO  " Country Key
         B~CITYTO     " Arrival city
         C~NAME       " Customer name
         C~FORM       " Form of address
         C~CITY       " City
         C~COUNTRY    " Country Code
         C~REGION     " Region
         A~FORCURAM   " Booking price in foreign currency
         A~FORCURKEY  " Payment currency
         A~LOCCURAM   " Price of booking in local currency of airline
         A~LOCCURKEY  " Local currency of airline

  " WHERE의 한가지 조건을 제외하고 위와 동일함
  FROM SBOOK AS A
  INNER JOIN SPFLI AS B
  ON A~CARRID EQ B~CARRID AND A~CONNID EQ B~CONNID

  INNER JOIN SCUSTOM AS C
  ON A~CUSTOMID EQ C~ID

  INTO CORRESPONDING FIELDS OF TABLE GT_ZDETAIL


  WHERE A~CARRID IN SO_CAR AND
  A~CONNID IN SO_CON AND
  A~FLDATE IN SO_FLD AND
  A~ORDER_DATE IN SO_POD AND
  B~COUNTRYFR IN SO_COFR AND
  B~CITYFROM IN SO_CIFR AND
  B~COUNTRYTO IN SO_COTO AND
  B~CITYTO IN SO_CITO AND
  A~CANCELLED NE GC_MARK. " GC_MARK는 상수로써 'X'의 값을 가짐. 따라서
                          " CANCELLED의 값이 공란인 레코드만을 조회하기 위해
                          " CANCELLED 필드에서 'X' 가 아닌 값만 조회될 수
                          " 있도록 조건을 추가함.

  " 기존에 Insert 시 DB 테이블에 존재하는 데이터를 지우기 위해 선언함.
  DELETE FROM ZDETAIL_E03.
  " Internal Table의 결과 값을 생성한 DB 테이블 (ZDETAIL_E03)에 삽입.
  INSERT ZDETAIL_E03 FROM TABLE GT_ZDETAIL.


ENDFORM.


*--------------------------------------------------------------------*
*                         Task 4 : Select Data
*
* 1. SALV를 사용하여 DB 테이블 (ZDETAIL_E03)을 출력
* 2. 데이터 검색 시, Selection Screen의 모든 입력필드가 검색조건에 포함 되어야 하며,
*    [체크박스]의 경우 체크 시, SBOOK의 필드 CANCELLED에 대해 조건 없음
*    [체크박스]의 경우 체크 해제 시, SBOOK의 필드 CANCELLED의 값이 공란인 레코드
*--------------------------------------------------------------------*
FORM SELECT_DATA.

  REFRESH GT_ZDETAIL. " Internal Table 초기화

  " 체크박스가 체크되었다는 것은 PA_BOOK에 'X' 값이 입력되었다는 의미
  " CG_MARK는 상수로 'X'를 선언해놨으니, 체크 박스가 선택되면
  " PA_BOOK과 GC_MARK의 값이 같기에 아래의 조건문이 수행됨.
  IF PA_BOOK EQ GC_MARK. " 체크박스 선택 시

    SELECT *                          " 모든 필드 SELECT
      FROM ZDETAIL_E03                " ZDETAIL_E03 테이블로부터 데이터를 가져옴
      INTO CORRESPONDING FIELDS OF TABLE GT_ZDETAIL " 가져온 데이터를 Internal Table 에 삽입
      WHERE CARRID IN SO_CAR AND      " SELECT-OPTION의 SO_CAR (Airline)이 조건에 포함
            CONNID IN SO_CON AND      " SELECT-OPTION의 SO_CON (Connection Number)이 조건에 포함
            FLDATE IN SO_FLD AND      " SELECT-OPTION의 SO_FLD (Flight Date)이 조건에 포함
            ORDER_DATE IN SO_POD AND  " SELECT-OPTION의 SO_POD (Posting Date)이 조건에 포함
            COUNTRYFR IN SO_COFR AND  " SELECT-OPTION의 SO_COFR (Depart. Coutry)이 조건에 포함
            CITYFROM IN SO_CIFR AND   " SELECT-OPTION의 SO_CIFR (Depart. City)이 조건에 포함
            COUNTRYTO IN SO_COTO AND  " SELECT-OPTION의 SO_COTO (Arrival Country)이 조건에 포함
            CITYTO IN SO_CITO.        " SELECT-OPTION의 SO_CITO (Arrival City)이 조건에 포함


  ELSEIF
    PA_BOOK NE GC_MARK. " 체크박스 미 선택 시


    " SELECT 문에 대한 설명은 위와 동일하며 WHERE 절의 하나의 조건만 상이함
    SELECT *
      FROM ZDETAIL_E03
       INTO CORRESPONDING FIELDS OF TABLE GT_ZDETAIL
      WHERE CARRID IN SO_CAR AND
            CONNID IN SO_CON AND
            FLDATE IN SO_FLD AND
            ORDER_DATE IN SO_POD AND
            COUNTRYFR IN SO_COFR AND
            CITYFROM IN SO_CIFR AND
            COUNTRYTO IN SO_COTO AND
            CITYTO IN SO_CITO AND
            CANCELLED NE 'X'. " CANCELLED 필드의 값이 'X' 이 아닌거만
                              " 즉, 해당 필드가 공란인 것만 조회

  ENDIF.

  " 'Delete' 라디오 버튼이 수행되면, DB 테이블에 데이터가 모두 삭제됨.
  " 그 후 Insert를 수행하지 않고 Select 버튼을 수행 시,
  " DB 테이블에 존재하는 데이터가 없기에 Internal Table로 가져오는 데이터가 없음.
  " 즉 출력되는 데이터가 존재하지 않음.
  " 따라서 사용자에게 데이터가 없다는 것을 효과적으로 알리기 위해 아래의 코드를 추가함
  " E011 = "조회되는 데이터가 없습니다.
  " 이때 'E'를 활용하여 에러 메시지 발생 시, 프로세스를 중단.
  IF GT_ZDETAIL IS INITIAL AND PA_RAD2 EQ 'X'.

    MESSAGE E011(ZTEST03_MSG). "조회되는 데이터가 없습니다.

  ENDIF.
ENDFORM.


*--------------------------------------------------------------------*
* SALV 출력 함수
*--------------------------------------------------------------------*
FORM DISPLAY_DATA.

  DATA LO_ALV TYPE REF TO CL_SALV_TABLE.

  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = LO_ALV
        CHANGING
          T_TABLE      = GT_ZDETAIL.

      CALL METHOD LO_ALV->DISPLAY.
    CATCH CX_SALV_MSG. " ALV: General Error Class with Message
  ENDTRY.


ENDFORM.

*--------------------------------------------------------------------*
*                         Task 5 : Delete All Data
*
* 1. Task 1의 테이블의 모든 데이터를 삭제한다.
*--------------------------------------------------------------------*

FORM DELETE_DATA.

  DELETE FROM ZDETAIL_E03. " DB Table의 모든 데이터를 삭제

ENDFORM.
*--------------------------------------------------------------------*
