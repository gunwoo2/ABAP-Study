*&---------------------------------------------------------------------*
*& Report  BC402_DBT_DISTINCT
*&
*&---------------------------------------------------------------------*
*& Exercise 34 Request Ordered and Condensed Datasets from the DB
*&
*&---------------------------------------------------------------------*

REPORT zbc402_e03_distinct.

CLASS lcl_customer DEFINITION.

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          iv_customid TYPE scustom-id
        RAISING
          cx_bc402_no_data.

    METHODS:
      display.


  PRIVATE SECTION.

    TYPES: ty_discount TYPE p LENGTH 3 DECIMALS 2.

    TYPES: BEGIN OF ty_s_booking,
             carrid    TYPE bc402_scus_book-carrid,
             connid    TYPE bc402_scus_book-connid,
             fldate    TYPE bc402_scus_book-fldate,
             bookid    TYPE bc402_scus_book-bookid,
             cityfrom  TYPE bc402_scus_book-cityfrom,
             cityto    TYPE bc402_scus_book-cityto,
             class     TYPE c LENGTH 10,
             forcuram  TYPE bc402_scus_book-forcuram,
             forcurkey TYPE bc402_scus_book-forcurkey,
             discount  TYPE bc402_scus_book-forcuram,
           END OF ty_s_booking.


    TYPES: BEGIN OF ty_s_sums,
             forcuram  TYPE sbook-forcuram,
             forcurkey TYPE sbook-forcurkey,
           END OF ty_s_sums.

    TYPES: BEGIN OF ty_s_travelags,
             agencynum TYPE bc402_scus_book-agencynum,
             name      TYPE bc402_scus_book-name,
             city      TYPE bc402_scus_book-city,
           END OF ty_s_travelags.

    TYPES:
      ty_t_sums      TYPE SORTED TABLE OF ty_s_sums
                           WITH UNIQUE KEY forcurkey,

      ty_t_bookings  TYPE STANDARD TABLE OF ty_s_booking
                           WITH NON-UNIQUE KEY
                           carrid connid fldate bookid,

      ty_t_travelags TYPE STANDARD TABLE OF ty_s_travelags
                           WITH NON-UNIQUE KEY agencynum.

    DATA:
      mv_customid  TYPE scustom-id,
      mv_full_name TYPE string,
      mv_discount  TYPE ty_discount.

    DATA:
      mt_bookings TYPE ty_t_bookings,
      mt_sums     TYPE ty_t_sums,
      mt_agencies TYPE ty_t_travelags.

    METHODS:
      set_customer
        IMPORTING
          iv_customid TYPE scustom-id,

      set_bookings,

      set_sums,

      set_agencies.

    CLASS-METHODS:
      check_customer_exists
        IMPORTING
          iv_customid      TYPE scustom-id
        RETURNING
          VALUE(rv_exists) TYPE abap_bool.


ENDCLASS.

CLASS lcl_customer IMPLEMENTATION.

  METHOD constructor.

    IF check_customer_exists( iv_customid ) <> abap_true.
      RAISE EXCEPTION TYPE cx_bc402_no_data.
    ENDIF.

    set_customer( iv_customid ).

    set_bookings( ).

    set_agencies( ).

    set_sums( ).

  ENDMETHOD.

  METHOD check_customer_exists.

    DATA lv_id TYPE scustom-id.

    rv_exists = abap_false.

    SELECT SINGLE id FROM scustom
                     INTO lv_id
                     WHERE id = iv_customid.
    IF sy-subrc EQ 0.
      rv_exists = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD set_customer.

    CONSTANTS lc_factor TYPE p LENGTH 3 DECIMALS 2 VALUE '0.01'.

    TYPES:
      BEGIN OF lty_s_cust,
        id       TYPE scustom-id,
        form     TYPE scustom-form,
        name     TYPE scustom-name,
        discount TYPE scustom-discount,
      END OF lty_s_cust.

    DATA ls_cust TYPE lty_s_cust.

    SELECT SINGLE id form name discount
             FROM scustom
             INTO ls_cust
                    WHERE id = iv_customid.

    mv_customid  = ls_cust-id.
    mv_full_name = ls_cust-form && ` ` && ls_cust-name.
    mv_discount  = ls_cust-discount * lc_factor.

  ENDMETHOD.

  METHOD set_bookings.

    SELECT FROM bc402_scus_book
         FIELDS carrid,
                connid,
                fldate,
                bookid,
                cityfrom,
                cityto,
                class,
                forcuram,
                forcurkey
          WHERE customid = @mv_customid
            AND cancelled <> 'X'
     INTO TABLE @mt_bookings.

    LOOP AT mt_bookings ASSIGNING FIELD-SYMBOL(<ls_booking>).
* Readable text for booking class
      CASE <ls_booking>-class.
        WHEN 'Y'.
          <ls_booking>-class = 'Economy'.
        WHEN 'C'.
          <ls_booking>-class = 'Business'.
        WHEN 'F'.
          <ls_booking>-class = 'First'.
      ENDCASE.

* calculate discount
      <ls_booking>-discount = <ls_booking>-forcuram * mv_discount.
    ENDLOOP.

  ENDMETHOD.

  METHOD set_agencies.

  " 여행사 정보를 DB로 부터 가져오기 위한 Method
  " 여행사 정보는 MT_AGENCIES에 보관한다.
  " 데이터베이스 뷰 BC402_SCUS_BOOK 을 통해서 데이터를 가져온다.
  " 여행사 정보는 중복되지 말아야하며, 이름 기준으로 정렬한다.

  " Attribute MT_AGENCIES 는 어떤 변수이고, 어떻게 구성되어 있는가
  " MT_AGENCIES : Standard Internal Table이거, Field는 3개
  " agencynum, name, city 라는 필드로 구성됨

  SELECT DISTINCT "가져온 데이터의 중복을 제거
      AGENCYNUM NAME CITY " 3개의 필드
    FROM BC402_SCUS_BOOK " DATABASE VIEW
    INTO TABLE MT_AGENCIES
    WHERE CUSTOMID EQ MV_CUSTOMID " 클래스에 보관된 고객번호와 동일한
                                  " 여행정보를 가져온다.

    ORDER BY NAME. " 여행사 이름 기준으로 정렬


  ENDMETHOD.

  METHOD set_sums.



  ENDMETHOD.

  METHOD display.

    DATA:
      ls_bookings LIKE LINE OF mt_bookings,
      ls_sum      LIKE LINE OF mt_sums,
      ls_agency   LIKE LINE OF mt_agencies.

    DATA lv_text TYPE string.

    CONCATENATE TEXT-wcm
                mv_full_name
           INTO lv_text
           SEPARATED BY space.

    CONDENSE lv_text.

    WRITE: / lv_text.
    SKIP.

    WRITE / TEXT-lob.
    ULINE.
    SKIP.

    LOOP AT mt_bookings INTO ls_bookings.
      WRITE: /
         ls_bookings-bookid,
         ls_bookings-carrid RIGHT-JUSTIFIED,
         ls_bookings-connid,
         ls_bookings-fldate,
         ls_bookings-cityfrom RIGHT-JUSTIFIED,
         '->',
         ls_bookings-cityto,
         ls_bookings-class,
         ls_bookings-forcuram CURRENCY ls_bookings-forcurkey,
         ls_bookings-forcurkey,
         TEXT-dis,
         ls_bookings-discount CURRENCY ls_bookings-forcurkey LEFT-JUSTIFIED.



    ENDLOOP.
    SKIP 2.

    WRITE: / TEXT-sum.
    ULINE.
    SKIP.

    LOOP AT mt_sums INTO ls_sum.
      WRITE: /
        ls_sum-forcuram CURRENCY ls_sum-forcurkey,
        ls_sum-forcurkey.
    ENDLOOP.
    SKIP 2.

    WRITE / TEXT-tag.
    ULINE.
    SKIP.

    LOOP AT mt_agencies INTO ls_agency.
      WRITE: /
        ls_agency-name,
        ls_agency-city.
    ENDLOOP.


  ENDMETHOD.

ENDCLASS.

DATA lo_customer TYPE REF TO lcl_customer.

PARAMETERS:
  pa_cust TYPE sbook-customid DEFAULT '00000001'.

START-OF-SELECTION.

  TRY.
      CREATE OBJECT lo_customer
        EXPORTING
          iv_customid = pa_cust.
      .

      lo_customer->display( ).

    CATCH cx_bc402_no_data INTO DATA(gx_no_data) .    "
      MESSAGE gx_no_data TYPE 'E'.

  ENDTRY.
