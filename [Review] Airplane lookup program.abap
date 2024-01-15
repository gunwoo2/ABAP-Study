*&---------------------------------------------------------------------*
*& Report ZHWE03_REVIEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZHWE03_REVIEW MESSAGE-ID ZTEST03_MSG.


* 전역변수
DATA: BEGIN OF GS_DATA,
        CARRID    TYPE SCARR-CARRID,
        CARRNAME  TYPE SCARR-CARRNAME,
        CONNID    TYPE SPFLI-CONNID,
        FLDATE    TYPE SFLIGHT-FLDATE,
        COUNTRYFR TYPE SPFLI-COUNTRYFR,
        CITYFROM  TYPE SPFLI-CITYFROM,
        AIRPFROM  TYPE SPFLI-AIRPFROM,
        AIRPFROM_NAME TYPE SAIRPORT-NAME,
        COUNTRYTO TYPE SPFLI-COUNTRYTO,
        CITYTO    TYPE SPFLI-CITYTO,
        AIRPTO    TYPE SPFLI-AIRPTO,
        AIRPTO_NAME TYPE SAIRPORT-NAME,
        FLTIME    TYPE SPFLI-FLTIME,
        PRICE     TYPE SFLIGHT-PRICE,
        CURRENCY  TYPE SFLIGHT-CURRENCY,
        SEATSMAX  TYPE SFLIGHT-SEATSMAX,
        SEATSOCC  TYPE SFLIGHT-SEATSOCC,
      END OF GS_DATA.

DATA GT_DATA LIKE TABLE OF GS_DATA.


* Task 1
* 좋은 사례
PARAMETERS: PA_CITYF TYPE SPFLI-CITYFROM.   " 출발도시
*PARAMETERS: P_CITYFR TYPE SPFLI-CITYFROM.

PARAMETERS: PA_CITYT TYPE SPFLI-CITYTO,     " 도착도시
            PA_FDATE TYPE SFLIGHT-FLDATE.   " 비행일자

* 좋지 않다.
**PARAMETERS: CITYFROM TYPE SPFLI-CITYFROM.

* SELECT-OPTIONS은 반드시 선언할 때 변수로 선언된다.
DATA: GV_CARRID TYPE SPFLI-CARRID.
SELECT-OPTIONS SO_CARID FOR GV_CARRID.

" Radio Button은 Type이 문자 1자리로 고정되어 있다.
PARAMETERS: PA_RA1 RADIOBUTTON GROUP RAG1,
            PA_RA2 RADIOBUTTON GROUP RAG1,
            PA_RA3 RADIOBUTTON GROUP RAG1.


*--------------------------------------------------------------------*
*                      AT SELECTION-SCRREN
*--------------------------------------------------------------------*
* Task 2
AT SELECTION-SCREEN.

  DATA LS_SPFLI TYPE SPFLI.

  " 입력받은 출발도시와 도착도시가 DB Table에 실제로 존재하는
  " 여행상품인지 점검하기 위해 Flight Connection 테이블을 조회한다.

" Aggregate Function - Special Case 2
  SELECT COUNT(*)
    FROM SPFLI
    WHERE CITYFROM EQ PA_CITYF
     AND CITYTO   EQ PA_CITYT.  " 조건에 해당되는 한 줄만 조회

  " sy-dbcnt = 검색된 데이터 수
  " sy-subrc = 검색 성공 여부
  IF SY-DBCNT EQ 0.
    " 에러
  ENDIF.

  SELECT SINGLE *
    FROM SPFLI
    INTO LS_SPFLI
   WHERE CITYFROM EQ PA_CITYF
     AND CITYTO   EQ PA_CITYT.  " 조건에 해당되는 한 줄만 조회

  " Select 문의 검색결과가 없을 경우
  IF SY-SUBRC NE 0.
*    MESSAGE E~~~ " 에러 메시지는 AT SELECTION-SCREEN에서 입력값 점검에
    " 주로 사용된다.

    " Text Symbol (X)  / Message Class (X)
*    MESSAGE 'No flight schedule was found' TYPE 'E'.

    " Text Symbol
    MESSAGE TEXT-E01 TYPE 'E'.

    " REPORT ZHWE00_2_REVIEW. 프로그램의 선언부가 좌측과 같은 경우
    MESSAGE E005(ZMSG_E00). " No flight schedule was found


    " REPORT ZHWE03_REVIEW MESSAGE-ID ZMSG_E00. 프로그램의 선언부가 좌측과 같은 경우
    MESSAGE E005. " No flight schedule was found

  ENDIF.


*--------------------------------------------------------------------*
*                      START-OF-SELECTION.
*--------------------------------------------------------------------*

START-OF-SELECTION.

* 데이터를 조회할 테이블
*•  SCARR: 항공사 테이블
*•  SPFLI: 항공편 테이블
*•  SFLIGHT: 비행일정 테이블
*•  SAIRPORT: 공항정보 테이블

* 1. scarr 만 조회
*  SELECT CARRID CARRNAME
*    FROM SCARR
*    INTO TABLE GT_DATA
*   WHERE CARRID IN SO_CARID.

  " Selction Screen에서 출발도시, 도착도시, 비행일자, 항공사ID

*--------------------------------------------------------------------*
*--------------------------------------------------------------------*

* 2. SPFLI 만 조회
*SELECT CARRID " CARRNAME 은 없음
*       CONNID
*       COUNTRYFR CITYFROM AIRPFROM
*       COUNTRYTO CITYTO   AIRPTO
*       FLTIME
*  FROM SPFLI
*  INTO CORRESPONDING FIELDS OF TABLE GT_DATA
* WHERE CARRID   IN SO_CARID
*   AND CITYFROM EQ PA_CITYF
*   AND CITYTO   EQ PA_CITYT.


*--------------------------------------------------------------------*
*--------------------------------------------------------------------*

* 3. SFLIGHT 만 조회
  DATA LV_FLDATE_TO TYPE SFLIGHT-FLDATE.
  LV_FLDATE_TO = PA_FDATE + 89. " 최대 90일 이내

***SELECT CARRID CONNID FLDATE " KEY FIELDS
***       PRICE CURRENCY       " Airfare
***       SEATSMAX SEATSOCC    " Seats
***  FROM SFLIGHT
***  INTO CORRESPONDING FIELDS OF TABLE GT_DATA
*** WHERE CARRID   IN SO_CARID
***   " 입력된 비행일자로부터 최대 90일 이내로 범위 조회
***   AND FLDATE   BETWEEN PA_FDATE AND LV_FLDATE_TO
***
***   " 잔여좌석이 있는 레코드 검색
***   AND SEATSMAX NE SFLIGHT~SEATSOCC   " 최대 100 <> 예약 98 잔여 2
***   AND SEATSMAX GT SFLIGHT~SEATSOCC.  " 최대 100  > 예약 98
****   AND ( SEATSMAX - SFLIGHT~SEATSOCC ) > 0.


*--------------------------------------------------------------------*
*--------------------------------------------------------------------*

* 4. SCARR & SPFLI & SFLIGHT 를 JOIN 으로 연결해서 한번에 조회하기
*    SAIRPORT 는 LEFT OUTER JOIN 으로 연결하여 데이터를 조회한다.
  SELECT A~CARRID A~CARRNAME
         B~CONNID
         C~FLDATE

         B~COUNTRYFR B~CITYFROM B~AIRPFROM   D~NAME AS AIRPFROM_NAME
         B~COUNTRYTO B~CITYTO   B~AIRPTO     D~NAME AS AIRPTO_NAME
         B~FLTIME

         C~PRICE    C~CURRENCY
         C~SEATSMAX C~SEATSOCC

    FROM SCARR   AS A
         " Join조건에 해당되는 데이터만 조회가능
         INNER JOIN SPFLI   AS B ON A~CARRID EQ B~CARRID " A의 모든 키필드 또는 B의 모든 키필드

         INNER JOIN SFLIGHT AS C ON A~CARRID EQ C~CARRID
                                AND B~CONNID EQ C~CONNID

         " 왼쪽 테이블의 키필드: CARRID(A,B,C), CONNID(B,C), FLDATE(C)
         " 오른쪽 테이블의 키필드: ID(D)

         "출발공항과 관련된 공항정보는 D 테이블로 연결
         LEFT OUTER JOIN SAIRPORT AS D ON B~AIRPFROM EQ D~ID " 출발 공항 연결

         " 도착공항과 관련된 공항정보는 E 테이블로 연결
         LEFT OUTER JOIN SAIRPORT AS E ON B~AIRPTO EQ E~ID " 도착 공항 연결

    INTO CORRESPONDING FIELDS OF TABLE GT_DATA

   WHERE A~CARRID IN SO_CARID
*    AND B~CARRID IN SO_CARID
*    AND C~CARRID IN SO_CARID
     AND B~CITYFROM EQ PA_CITYF
     AND B~CITYTO   EQ PA_CITYT

* 입력된 비행일자로부터 최대 90일 이내로 범위 조회
     AND C~FLDATE   BETWEEN PA_FDATE AND LV_FLDATE_TO

* 잔여좌석이 있는 레코드 검색
     AND C~SEATSMAX NE C~SEATSOCC   " 최대 100 <> 예약 98 잔여 2
*    AND C~SEATSMAX GT C~SEATSOCC  " 최대 100  > 예약 98
     .


* Task 3 : 데이터 조회

CASE ABAP_ON.

  WHEN PA_RA1.
     SORT GT_DATA BY FLDATE.

  WHEN PA_RA2.
     SORT GT_DATA BY FLTIME.

  WHEN PA_RA3.
     SORT GT_DATA BY PRICE.

ENDCASE.


* Task 4 : 데이터 출력

* 데이터을 출력할 필드
*•  SCARR : Airline Code
*•  SCARR : Airline Name
*•  Flight Connection Number
*•  Flight Date
*•  Departure ~ [ Country, City, Airport ID & Name ] ( 출발관련 필드들 )
*•  Arrival ~ [ Country, City, Airport ID & Name ] ( 도착관련 필드들 )
*•  Flight Time
*•  Airfare
*•  Maximum capacity in economy class
*•  Occupied seats in economy class

    " SALV를 위한 Local 변수 선언
    DATA LO_ALV TYPE REF TO CL_SALV_TABLE.

    TRY.
        CALL METHOD CL_SALV_TABLE=>FACTORY
          IMPORTING
            R_SALV_TABLE = LO_ALV
          CHANGING
            T_TABLE      = GT_DATA.

        CALL METHOD LO_ALV->DISPLAY.
      CATCH CX_SALV_MSG. " ALV: General Error Class with Message
    ENDTRY.
