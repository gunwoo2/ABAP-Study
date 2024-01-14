*&---------------------------------------------------------------------*
*& Report ZHWE03_2
*&---------------------------------------------------------------------*
*& [HW] 비행기 타기 ACA5-03 (continue)
*&---------------------------------------------------------------------*
REPORT ZHWE03_2.

*--------------------------------------------------------------------*
* 출발도시, 도착도시, 비행일자를 입력 받은 3개의 Parameter 생성
* 항공사 ID를 입력 받는 1개의 Select-Option 생성하라
*--------------------------------------------------------------------*
* 비행일자 기준, 이동시간 기준, 이동비용 기준으로 졍렬된 데이터가
* 출력될 수 있도록 3개의 Radio Button 생성하라
*--------------------------------------------------------------------*
TABLES: SPFLI, SCARR, SFLIGHT, SAIRPORT. "4개의 테이블 선언


* 3개의 Parameter 생성 및 1개의 Select-Option 생성
* 이때 디자인과 가독성을 위해 생성한 값들을 BLOCK을 통해 그룹핑 함
SELECTION-SCREEN BEGIN OF BLOCK BL1
  WITH FRAME TITLE TEXT-BL1.
  PARAMETERS : P_CITYFR TYPE SPFLI-CITYFROM,   " 출발 도시
               P_CITYTO TYPE SPFLI-CITYTO,     " 도착 도시
               P_FLDATE TYPE SFLIGHT-FLDATE.   " 비행 일자

  " 항공사 ID를 SPFLI 테이블의 CARRID 필드를 통해 Select-Option으로 받음
  SELECT-OPTIONS
      SO_CAR FOR SPFLI-CARRID. "

SELECTION-SCREEN END OF BLOCK BL1.

SELECTION-SCREEN SKIP 1.                    " 한줄 띄우기

" 비행일자, 이동시간, 이동비용 기준으로 정렬된 데이터가 출력되게 하기 위해
" 3개의 라디오 버튼을 생성함. 이때 첫번째 버튼을 디폴트 값으로 설정
SELECTION-SCREEN BEGIN OF BLOCK BL2
  WITH FRAME TITLE TEXT-BL2.

  PARAMETERS PA_RAD1 RADIOBUTTON GROUP RG1 DEFAULT 'X'. "비행일자 기준

  PARAMETERS PA_RAD2 RADIOBUTTON GROUP RG1 .            "이동시간 기준

  PARAMETERS PA_RAD3 RADIOBUTTON GROUP RG1.             "이동비용 기준

SELECTION-SCREEN END OF BLOCK BL2.

*제공된 조건을 만족하는 필드를 생성하기 위해 스트럭쳐 생성.
*이때 각 각의 필드의 타입은 4개 테이블의 필드를 참조
TYPES: BEGIN OF TY_FLIGHT,
         CARRID    TYPE SCARR-CARRID,     " 항공사 코드
         CARRNAME  TYPE SCARR-CARRNAME,   " 항공사 이름
         CONNID    TYPE SPFLI-CONNID,     " 항공편
         FLDATE    TYPE SFLIGHT-FLDATE,   " 비행일자
         COUNTRYFR TYPE SPFLI-COUNTRYFR,  " 출발 국가
         CITYFROM  TYPE SPFLI-CITYFROM,   " 출발 도시
         PORTFRID  TYPE SAIRPORT-ID,      " 출발 공항ID
         PORTFRNA  TYPE SAIRPORT-NAME,    " 출발 공항명
         COUNTRYTO TYPE SPFLI-COUNTRYTO,  " 도착 국가 "
         CITYTO    TYPE SPFLI-CITYTO,     " 도착 도시
         PORTTOID  TYPE SAIRPORT-ID,      " 도착 공항ID
         PORTTONA  TYPE SAIRPORT-NAME,    " 도착 공항명
         FLTIME    TYPE SPFLI-FLTIME,     " 비행시간
         PRICE     TYPE SFLIGHT-PRICE,    " 운임료
         SEATSMAX  TYPE SFLIGHT-SEATSMAX, " 비행 간 최대 좌석수
         SEATSOCC  TYPE SFLIGHT-SEATSOCC, " 예약된 좌석 수
         RSEATS    TYPE ZSEAT,            " 잔여 좌석
       END OF TY_FLIGHT.


DATA: GT_SPFLI  TYPE TABLE OF SPFLI, " 입력받은 출발, 도착 도시 간에
      " 여행상품이 존재하지 않을 경우를
      " 체크하기 위한 Internal Table 선언
      GS_FLIGHT TYPE TY_FLIGHT,      " 위에서 선언한 스트럭처 타입을 참조하여
      " 새로운 스트럭처 생성 (Work Area)
      GT_FLIGHT TYPE TABLE OF TY_FLIGHT, " 위에서 선언한 스트럭처 타입을
                                         " 참조하여 Internal Table 선언
      GV_FLDATE TYPE D.              " 90일 이내의 일정을 조회하기 위한
                                     " 전역변수 선언.

GV_FLDATE = P_FLDATE + 90.           " 입력받은 파라미터에 90을 더함.

*--------------------------------------------------------------------*
*                           INITIALIZATION
*--------------------------------------------------------------------*
INITIALIZATION.



*--------------------------------------------------------------------*
*                        AT SELECTION-SCREEN.
* 입력 받은 출발도시와 도착도시 간의 여행 상품이 존재하지 않을 경우,
* 오류 메시지를 출력하라.
*--------------------------------------------------------------------*
  " 여행 상품이 존재하지 않을 경우에 대해 Selection-Screen에서 확인

AT SELECTION-SCREEN.

  " 입력 받은 파라미터 간에 여행 상품 존재하는지 확인
  SELECT    * "CITYFROM CITYTO 만 선택해도 되지만 모든 필드를 선택
            FROM SPFLI
            " 한번에 여러줄을 조회하기위해 스트럭처가 아닌 테이블 사용
            INTO CORRESPONDING FIELDS OF TABLE GT_SPFLI
            " 입력받은 출발, 도착도시의 일정이 Internal 테이블에 존재하지는
            " 확인하기 위해, 아래와 같은 조건을 사용
            WHERE CITYFROM EQ P_CITYFR
  AND CITYTO EQ P_CITYTO.

  " 만약 조회가 되지 않는다면 "No flight schedule was found"라는 오류 메시지
  " 출력. 이때 메시지 클래스를 사용하며, 좌측 하단에 출력되기 위해 'E' 사용
  IF SY-SUBRC <> 0.
    MESSAGE E009(ZTEST03_MSG).
    EXIT.
  ENDIF.


*--------------------------------------------------------------------*
*                        START-OF-SELECTION
* Lefit Outer Join과 Inner Join을 활용하여 4개의 테이블(SCARR, SPFLI
* SFLIGHT, SAIRPORT) 조인하라
*--------------------------------------------------------------------*
* 조인된 테이블을 통해 비행 일정을 조회하라. 단 비행기 일정은 Economy
* 잔여좌석이 있어야 하며, 입력받은 일자 기준 최대 90 이내 일정만 조회해라
*--------------------------------------------------------------------*
* 조회된 결과를 주어진 필드 순서대로 출력하라. 이때 출력은 SALV를
* 사용하여 출력해라
*--------------------------------------------------------------------*
* 또한 선택된 Raido Button에 따라 비행일자 기준, 이동시간 기준,
* 이동비용 기준으로 졍렬된 데이터가 출력되도록 하라
*--------------------------------------------------------------------*
START-OF-SELECTION.

* 선택되는 라디오 버튼에 따라 정렬된 데이터가 출력될 수 있게 Case 문을
* 활용함. 또한 선택 케이스에 따라 해당 Subroutine을 호출함.
  CASE 'X'.

    WHEN PA_RAD1. "비행일자 기준 라디오 버튼이 선택되면 해당 구문 수행
      MESSAGE '비행일자 기준' TYPE 'I'.

      PERFORM SELECT_FLIGHT1.
      PERFORM DISPLAY_FLIGHT1.


    WHEN PA_RAD2. "이동시간 기준 라디오 버튼이 선택되면 해당 구문 수행
      MESSAGE '이동시간 기준' TYPE 'I'.

      PERFORM SELECT_FLIGHT2.
      PERFORM DISPLAY_FLIGHT2.

    WHEN PA_RAD3. "이동비용 기준 라디오 버튼이 선택되면 해당 구문 수행
      MESSAGE '이동비용 기준' TYPE 'I'.

      PERFORM SELECT_FLIGHT3.
      PERFORM DISPLAY_FLIGHT3.


  ENDCASE.

*--------------------------------------------------------------------*
*                            Subroutine
*--------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_FLIGHT1 / 비행일자 기준
*&---------------------------------------------------------------------*
FORM SELECT_FLIGHT1 .

  SELECT A~CARRID     " 항공사 코드
         A~CARRNAME   " 항공사 이름
         B~CONNID     " 항공편
         C~FLDATE     " 비행일자
         B~COUNTRYFR  " 출발 국가
         B~CITYFROM   " 출발 도시
         D~ID         " 출발 공항ID
         D~NAME       " 출발 공항명
         B~COUNTRYTO  " 도착 국가 "
         B~CITYTO     " 도착 도시
         D2~ID        " 도착 공항ID
         D2~NAME      " 도착 공항명
         B~FLTIME     " 비행시간
         C~PRICE      " 운임료
         C~SEATSMAX   " 비행 간 최대 좌석수
         C~SEATSOCC   " 예약된 좌석 수

  " SCARR 테이블과 SPFLI 테이블은 CARRID를 통해 Inner Join을 수행
  FROM SCARR AS A
  INNER JOIN SPFLI AS B
  ON A~CARRID = B~CARRID

  " SFLIGHT 테이블 또한 CARRID를 통해 Inner Join을 수행
  INNER JOIN SFLIGHT AS C
  ON A~CARRID = C~CARRID

  " SAIRPORT 테이블의 경우 출발, 도착 공항이 2개가 나와야 하기에
  " 2번의 Left Outer Join을 수행해야함. 공항ID를 통해 Inner Join을 수행
  LEFT OUTER JOIN SAIRPORT AS D
  ON B~AIRPFROM = D~ID

  LEFT OUTER JOIN SAIRPORT AS D2
  ON B~AIRPTO = D2~ID

  " Internal Table에 조인한 결과 값을 저장
  INTO TABLE GT_FLIGHT
  " 아래와 같은 조건을 추가하여 요구사항을 만족함
  WHERE A~CARRID IN SO_CAR AND   "입력 받은 항공사ID만 출력
  C~FLDATE BETWEEN P_FLDATE AND GV_FLDATE " 입력받은 날짜로부터 90일까지 출력
  AND B~CITYFROM = P_CITYFR " 입력받은 출발도시가 있는 경우,
  AND B~CITYTO = P_CITYTO " 입력 받은 도착도시가 있는 경우
  AND C~SEATSMAX <> C~SEATSOCC " 잔여좌석이 존재할 경우
  ORDER BY C~FLDATE ASCENDING. " 비행일자 기준 정렬 (오름차순)

**--------------------------------------------------------------------*
  " 첫줄부터 마지막 줄까지 잔여좌석을 계산하여 기록하기 위해 Loop 사용
  " Internal Table에 들어가있는 값들을 Internal Table의 work area에 저장
  LOOP AT GT_FLIGHT INTO GS_FLIGHT.

    " 잔여좌석(최대 좌석수 - 예약 좌석수)을 RSEATS 필드에 대입
    GS_FLIGHT-RSEATS = GS_FLIGHT-SEATSMAX - GS_FLIGHT-SEATSOCC.
    " 값이 변한 Structure 변수를 Internal Table에 저장
    MODIFY GT_FLIGHT FROM GS_FLIGHT.

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_FLIGHT1 / 비행일자 기준 정렬된 값 출력
*&---------------------------------------------------------------------*

FORM DISPLAY_FLIGHT1 .
  " SALV 를 통해 조회된 결과를 출력
  DATA GO_ALV TYPE REF TO CL_SALV_TABLE.

  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = GO_ALV   " SALV 객체를 받아온다.
        CHANGING
          T_TABLE      = GT_FLIGHT. " 화면에 출력할 데이터(Internal Table) 전달

      CALL METHOD GO_ALV->DISPLAY. " 전달받은 데이터를 화면에 출력함.
    CATCH CX_SALV_MSG. " ALV: General Error Class with Message
  ENDTRY.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form SELECT_FLIGHT2 / 이동시간 기준
*&---------------------------------------------------------------------*
" 해당 코드에 대한 주석은 SELECT_FLIGHT1 와 동일하며,
" 차이점은 Order by 에서 이동시간 기준으로 정렬 되는 것만 다름
FORM SELECT_FLIGHT2 .

  SELECT A~CARRID
           A~CARRNAME
           B~CONNID
           C~FLDATE
           B~COUNTRYFR
           B~CITYFROM
           D~ID
           D~NAME
           B~COUNTRYTO
           B~CITYTO
           D2~ID
           D2~NAME
           B~FLTIME
           C~PRICE
           C~SEATSMAX
           C~SEATSOCC

      FROM SCARR AS A
      INNER JOIN SPFLI AS B
      ON A~CARRID = B~CARRID

      INNER JOIN SFLIGHT AS C
      ON A~CARRID = C~CARRID

      LEFT OUTER JOIN SAIRPORT AS D
      ON B~AIRPFROM = D~ID

      LEFT OUTER JOIN SAIRPORT AS D2
      ON B~AIRPTO = D2~ID

      INTO TABLE GT_FLIGHT
      WHERE A~CARRID IN SO_CAR AND   "입력 받은 항공사ID만 출력
      C~FLDATE BETWEEN P_FLDATE AND GV_FLDATE " 입력받은 날짜로부터 90일까지 출력
      AND B~CITYFROM = P_CITYFR " 입력받은 출발도시가 있는 경우,
      AND B~CITYTO = P_CITYTO " 입력 받은 도착도시가 있는 경우
      AND C~SEATSMAX <> C~SEATSOCC " 잔여좌석이 존재할 경우
      ORDER BY  B~FLTIME ASCENDING. " 이동시간 기준 정렬 (오름차순)

**--------------------------------------------------------------------*

  LOOP AT GT_FLIGHT INTO GS_FLIGHT.
    GS_FLIGHT-RSEATS = GS_FLIGHT-SEATSMAX - GS_FLIGHT-SEATSOCC.

    MODIFY GT_FLIGHT FROM GS_FLIGHT.

  ENDLOOP.

ENDFORM.



*&---------------------------------------------------------------------*
*& Form DISPLAY_FLIGHT2 / 이동시간 기준 정렬된 값 출력
*&---------------------------------------------------------------------*
" SALV 를 통해 조회된 결과를 출력
FORM DISPLAY_FLIGHT2 .

  DATA GO_ALV TYPE REF TO CL_SALV_TABLE.

  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = GO_ALV   " SALV 객체를 받아옴
        CHANGING
          T_TABLE      = GT_FLIGHT. " 화면에 출력할 데이터(Internal Table) 전달

      CALL METHOD GO_ALV->DISPLAY. " 전달받은 데이터를 화면에 출력
    CATCH CX_SALV_MSG. " ALV: General Error Class with Message
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_FLIGHT3 / 이동비용 기준
*&---------------------------------------------------------------------*
" 해당 코드에 대한 주석은 SELECT_FLIGHT1 와 동일하며,
" 차이점은 Order by 에서 이동비용 기준으로 정렬 되는 것만 다름
FORM SELECT_FLIGHT3 .

  SELECT A~CARRID
       A~CARRNAME
       B~CONNID
       C~FLDATE
       B~COUNTRYFR
       B~CITYFROM
       D~ID
       D~NAME
       B~COUNTRYTO
       B~CITYTO
       D2~ID
       D2~NAME
       B~FLTIME
       C~PRICE
       C~SEATSMAX
       C~SEATSOCC

      FROM SCARR AS A
      INNER JOIN SPFLI AS B
      ON A~CARRID = B~CARRID

      INNER JOIN SFLIGHT AS C
      ON A~CARRID = C~CARRID

      LEFT OUTER JOIN SAIRPORT AS D
      ON B~AIRPFROM = D~ID

      LEFT OUTER JOIN SAIRPORT AS D2
      ON B~AIRPTO = D2~ID

      INTO TABLE GT_FLIGHT
      WHERE A~CARRID IN SO_CAR AND   "입력 받은 항공사ID만 출력
      C~FLDATE BETWEEN P_FLDATE AND GV_FLDATE " 입력받은 날짜로부터 90일까지 출력
      AND B~CITYFROM = P_CITYFR " 입력받은 출발도시가 있는 경우,
      AND B~CITYTO = P_CITYTO " 입력 받은 도착도시가 있는 경우
      AND C~SEATSMAX <> C~SEATSOCC " 잔여좌석이 존재할 경우
      ORDER BY C~PRICE ASCENDING. " 이동비용 기준 정렬 (오름차순)

**--------------------------------------------------------------------*

  LOOP AT GT_FLIGHT INTO GS_FLIGHT.
    GS_FLIGHT-RSEATS = GS_FLIGHT-SEATSMAX - GS_FLIGHT-SEATSOCC.

    MODIFY GT_FLIGHT FROM GS_FLIGHT.

  ENDLOOP.

ENDFORM.



*&---------------------------------------------------------------------*
*& Form DISPLAY_FLIGHT3 / 이동비용 기준 정렬된 값 출력
*&---------------------------------------------------------------------*
" SALV 를 통해 조회된 결과를 출력
FORM DISPLAY_FLIGHT3 .

  DATA GO_ALV TYPE REF TO CL_SALV_TABLE.

  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = GO_ALV   " SALV 객체를 받아온다.
        CHANGING
          T_TABLE      = GT_FLIGHT. " 화면에 출력할 데이터(Internal Table) 전달

      CALL METHOD GO_ALV->DISPLAY. " 전달받은 데이터를 화면에 출력함.
    CATCH CX_SALV_MSG. " ALV: General Error Class with Message
  ENDTRY.

ENDFORM.
