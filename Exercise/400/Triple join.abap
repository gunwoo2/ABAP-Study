*&---------------------------------------------------------------------*
*& Report  ZBC402_DBT_3JOIN
*&---------------------------------------------------------------------*
*& Execrise 36 Triple join
*&---------------------------------------------------------------------*

REPORT  zbc402_e03_3join.

TYPES: BEGIN OF gty_s_booking,
         carrid     TYPE sbook-carrid,
         connid     TYPE sbook-connid,
         fldate     TYPE sbook-fldate,
         bookid     TYPE sbook-bookid,
         customid   TYPE sbook-customid,
         agencynum  TYPE sbook-agencynum,

         " JOIN을 통해 한번에 여러개의 테이블에서 데이터를 조회하므로,
         " 해당 데이터들을 담기 위한 필드를 추가
         CUSTOMNAME TYPE SCUSTOM-NAME,
         CARRNAME   TYPE SCARR-CARRNAME,
         AGENCYNAME TYPE STRAVELAG-NAME,
         AGENCYCITY TYPE STRAVELAG-CITY,
      END OF gty_s_booking.

TYPES:
   gty_t_bookings TYPE STANDARD TABLE OF gty_s_booking
                       WITH NON-UNIQUE KEY
                       carrid connid fldate bookid.

DATA:
  gt_bookings TYPE gty_t_bookings, "테이블 타입
  gs_booking  TYPE gty_s_booking. " 스트럭처 타입

DATA:
  gv_custname   TYPE scustom-name,
  gv_carrname   TYPE scarr-carrname,
  gv_agencyname TYPE stravelag-name,
  gv_agencycity TYPE stravelag-city.

FIELD-SYMBOLS:
  <fs_booking> LIKE LINE OF gt_bookings.

SELECT-OPTIONS :
      so_agy FOR gs_booking-agencynum DEFAULT '100',
      so_cus FOR gs_booking-customid,
      so_fld FOR gs_booking-fldate.

*--------------------------------------------------------------------*

START-OF-SELECTION.


  SELECT a~carrid a~connid a~fldate a~bookid
         a~customid a~agencynum
         B~NAME C~CARRNAME D~NAME D~CITY
         FROM sbook as a INNER JOIN SCUSTOM AS B
                                 ON A~CUSTOMID EQ B~ID

                         INNER JOIN SCARR AS C
                                 ON A~CARRID EQ C~CARRID

                         " 여행사를 끼고 예약할 수도, 안끼고 예약할 수 도 있기때문에
                         " LEFT OUTHER 조인을 해야됨
                         LEFT OUTER JOIN STRAVELAG AS D
                                 ON A~AGENCYNUM EQ D~AGENCYNUM


    " SBOOK과 SCUSTOM과 SCARR과 STRAVELAG에서 필요한 필드를 전부
*    저장할 수 있는 Internal Table로 확장
         INTO TABLE gt_bookings

         WHERE a~agencynum IN so_agy AND
               a~customid  IN so_cus AND
               a~fldate    IN so_fld AND
               a~cancelled <> 'X'.

*--------------------------------------------------------------------*
  LOOP AT gt_bookings ASSIGNING <fs_booking>.

***    SELECT SINGLE name FROM scustom INTO gv_custname
***           WHERE id = <fs_booking>-customid.
***
***" 항공사id로 항공사이름을 출력
***    SELECT SINGLE carrname FROM scarr
***           INTO gv_carrname
***           WHERE carrid = <fs_booking>-carrid.
***
***    SELECT SINGLE name city FROM stravelag
***           INTO (gv_agencyname, gv_agencycity)
***           WHERE agencynum = <fs_booking>-agencynum.
***
***    IF sy-subrc <> 0.
***      CLEAR:
***         gv_agencyname,
***         gv_agencycity.
***    ENDIF.

    WRITE: /
        <fs_booking>-carrid,
        <fs_booking>-carrNAME,   "gv_carrname,
        <fs_booking>-connid,
        <fs_booking>-fldate,
        <fs_booking>-bookid,
        <fs_booking>-CUSTOMNAME,"     gv_custname,
        <fs_booking>-AGENCYNAME,"     gv_agencyname,
        <fs_booking>-AGENCYCITY."     gv_agencycity.

  ENDLOOP.
