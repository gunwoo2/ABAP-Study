*&---------------------------------------------------------------------*
*& Include          MZHWE03_4_E03TOP
*&---------------------------------------------------------------------*
PROGRAM SAPMZHWE03_4 MESSAGE-ID ZTEST03_MSG.

*--------------------------------------------------------------------*
* 프로그램 내에서 사용하는 테이블과 동일한 이름의 Dictionary Structure
*--------------------------------------------------------------------*
* Task 1-1
TABLES: SDYN_BOOK,  " 항공 예약 정보
        SPFLI,      " 헝공 스케줄 정보
        SFLIGHT,    " 항공 운항 정보
        SBOOK,      " 비행 예약 정보
        SCUSTOM,    " 항공 고객 정보
        STRAVELAG,  " 여행 에이전시 정보
        SAIRPORT,   " 공항 정보
        T005T.      " 국가 정보

*--------------------------------------------------------------------*
* 프로그램 작동에 필요한 기본적인 변수 선언
*--------------------------------------------------------------------*
DATA: OK_CODE TYPE SY-UCOMM, " 시스템 변수인 User Command를 받기 위해 선언
      DYNNR   TYPE SY-DYNNR. " 현재 Screen 번호를 받기 위해 선언
CONTROLS MY_TABSTRIP TYPE TABSTRIP. " 화면의 Tabstrip과 연동할 제어변수 선언


*--------------------------------------------------------------------*
* 각 탭 별 조회를 위해 선언한 변수들
*--------------------------------------------------------------------*
DATA: GS_CUSTOM             TYPE SCUSTOM, " 13번 서브스크린에서 조회하기
                                          " 위해 스트럭처 선언
      GS_SBOOK              TYPE SBOOK,   " 입력값이 옳바른지 검증하기 위해 선언
      CUSTTYPE_TEXT TYPE C LENGTH 50, " B/P customer의 Fixed Value
                                               " 내역을 조회하기 위해 선언
      CLASS_TEXT    TYPE C LENGTH 50. " Class의 Fixed Value
                                               " 내역을 조회하기 위해 선언

* 120번 서브 스크린에서 조회하기 위해 아래와 같은 변수를 선언
DATA: LANDXFR  TYPE T005T-LANDX,  " 출발 국가명
      LANDXTO  TYPE T005T-LANDX,  " 도착 국가명
      AIRPFRID TYPE SAIRPORT-ID,  " 출발 공항명
      AIRPTOID TYPE SAIRPORT-ID.  " 도착 공항명

* 110번 서브 스크린에서 조회하기 위해 스트럭처 선언
* 이때 각 각의 필드의 타입은 3개 테이블의 필드를 참조 (SBOOK, SCUSTOM, STRAVELAG)
DATA: BEGIN OF GS_BOOKING_INFO,
        CUSTOMID   TYPE SBOOK-CUSTOMID,     " 고객 ID
        NAME       TYPE SCUSTOM-NAME,       " 고객명
        CUSTTYPE   TYPE SBOOK-CUSTTYPE,     " 고객타입
        CLASS      TYPE SBOOK-CLASS,        " 고객 클래스
        LUGGWEIGHT TYPE SBOOK-LUGGWEIGHT,   " 짐 무게
        WUNIT      TYPE SBOOK-WUNIT,        " 단위
        FORCURAM   TYPE SBOOK-FORCURAM,     " 비용
        FORCURKEY  TYPE SBOOK-FORCURKEY,    " 금액 단위
        AGENCYNUM  TYPE SBOOK-AGENCYNUM,    " 여행사번호
        AGENCYNAME TYPE STRAVELAG-NAME,     " 여행사명
        TELEPHONE  TYPE STRAVELAG-TELEPHONE," 고객 전화번호
        CANCELLED  TYPE SBOOK-CANCELLED,    " 취소 플래그
        RESERVED   TYPE SBOOK-RESERVED,     " 예약 플래그
      END OF GS_BOOKING_INFO.

* 120번 서브 스크린에서 조회하기 위해 스트럭처 선언
DATA: BEGIN OF GS_FLIGHT_INFO,
        PLANETYPE TYPE SFLIGHT-PLANETYPE,   " 항공기 타입
        FLTIME    TYPE SPFLI-FLTIME,        " 비행 시간
        DISTANCE  TYPE SPFLI-DISTANCE,      " 비행 거리
        DISTID    TYPE SPFLI-DISTID,        " 거리 단위
        COUNTRYFR TYPE SPFLI-COUNTRYFR,     " 출발 국가
        LANDXFR   TYPE T005T-LANDX,         " 출발 국가 풀네임
        CITYFROM  TYPE SPFLI-CITYFROM,      " 출발 도시
        AIRPFROM  TYPE SPFLI-AIRPFROM,      " 출발 공항
        AIRPFRID  TYPE SAIRPORT-ID,         " 출발 공항 풀네임
        DEPTIME   TYPE SPFLI-DEPTIME,       " 출발 시간
        COUNTRYTO TYPE SPFLI-COUNTRYTO,     " 도착 국가
        LANDXTO   TYPE T005T-LANDX,         " 도착 국가 풀네임
        CITYTO    TYPE SPFLI-CITYTO,        " 도착 도시
        AIRPTO    TYPE SPFLI-AIRPTO,        " 도착 공항
        AIRPTOID  TYPE SAIRPORT-ID,         " 도착 공항 풀네임
        ARRTIME   TYPE SPFLI-ARRTIME,       " 도착 시간
      END OF GS_FLIGHT_INFO.

*--------------------------------------------------------------------*
* 아이콘을 위해 선언한 변수들
*--------------------------------------------------------------------*
* Task 1-3
DATA: ICON_RESULT TYPE C LENGTH 100,  " 아이콘 함수의 값을 받기 위해 선언
      GV_RESULT   TYPE C.            " 'X' 값을 받기 위해 선언한 변수

CONSTANTS: GC_RETURN TYPE C VALUE 'X'. " 'X' 를 갖는 상수 선언
