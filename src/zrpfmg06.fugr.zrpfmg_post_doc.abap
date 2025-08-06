FUNCTION zrpfmg_post_doc .
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(I_POST_TYPE) TYPE  RFPDO-RFBIFUNCT DEFAULT 'C'
*"     VALUE(I_BDC_MODE) TYPE  RFPDO-ALLGAZMD DEFAULT 'N'
*"     VALUE(I_MESSAGE) TYPE  EMSG_KZ_MS DEFAULT ' '
*"     VALUE(I_FB_TYPE) TYPE  CHAR01 DEFAULT 'A'
*"     VALUE(I_SIMULATION) TYPE  CHAR01 OPTIONAL
*"     VALUE(I_GROUP) LIKE  BGR00-GROUP DEFAULT 'FI-DOC'
*"     VALUE(I_AFLE) TYPE  AFLE_FILE_FORMAT DEFAULT 'X'
*"  EXPORTING
*"     VALUE(E_BUKRS) LIKE  BKPF-BUKRS
*"     VALUE(E_BELNR) LIKE  BKPF-BELNR
*"     VALUE(E_GJAHR) LIKE  BKPF-GJAHR
*"     VALUE(E_SUBRC) TYPE  SY-SUBRC
*"  TABLES
*"      T_BBKPF STRUCTURE  BBKPF
*"      T_BBSEG STRUCTURE  BBSEG OPTIONAL
*"      T_BBTAX STRUCTURE  BBTAX OPTIONAL
*"      T_BWITH STRUCTURE  BWITH OPTIONAL
*"      T_BSELK STRUCTURE  BSELK OPTIONAL
*"      T_BSELP STRUCTURE  BSELP OPTIONAL
*"      T_BSELP2 STRUCTURE  ZRPFZS_BSELP2 OPTIONAL
*"      T_MESSTAB STRUCTURE  FIMSG OPTIONAL
*"----------------------------------------------------------------------


** PA 데이타(RKE_시리즈)는 회사마다 다르므로 LZFI_POSTINGF01에서 해당회사의
**  PA구조에 맞게 수정해줘야 한다.
**  PA기표시는 PA항목뿐 아니라 RKE_BUKRS에 회사코드를 넣어야 PA로 기표된다.
* BSEG/코딩블럭에 필드를 추가한 경우
*  LZRPFGL01F01 FORM fill_ftpost_with_bbseg_data_1 에 로직 추가필요
* 헤더에 필드를 추가한 경우 FORM fill_ftpost_with_bbkpf_data1 에 로직 추가 필요.
*   Global data declarations
* 여러 계정을 반제할 경우
* I_SET_OFF = 'X'를 지정하고
* I_BSELP 에 STYPE에 계정유형,TBNAM(10)는 계정코드, 20자리이후 SPGL지시자를 지정한다.
* 부분반제일 경우 I_BSELP2 에 지정하고 OPT = 'P',, PARTIAL_TYPE = ‘P' 를 지정한다.
*"----------------------------------------------------------------------

*AFLE: map the correspoding flat file into the right structure
***********************************************************************
  mo_extended_components = NEW #( ).
  mo_afle_mapper = NEW #( io_extended_components = mo_extended_components ).
  IF i_afle NE 'X'.
    mo_afle_mapper->initialize( iv_is_short =  abap_true ).
  ELSE.
    mo_afle_mapper->initialize( iv_is_short =  abap_false ).
  ENDIF.
************************************************************************

  CLEAR : e_belnr, t_messtab[], t_messtab.
  CLEAR : g_belnr, g_bukrs, g_gjahr.

** 호출하는 TCODE를 매개변수에 저장한다. -->전표생성시 헤더에 대체시킴
  SET PARAMETER ID 'ZTCODE' FIELD sy-tcode.


* 미승인전표일 경우는 TCODE에 FBV1 지정
  IF i_fb_type = 'P'.
    LOOP AT t_bbkpf.
      t_bbkpf-tcode = 'FBV1'.
      MODIFY t_bbkpf.
    ENDLOOP.
  ENDIF.

* 반제절차 AUGLV 디폴트값 지정
  LOOP AT t_bbkpf WHERE tcode = 'FB05' AND auglv IS INITIAL.
    t_bbkpf-auglv = 'UMBUCHNG'.
    MODIFY t_bbkpf.
  ENDLOOP.

*
  IF i_fb_type = 'A' OR i_fb_type = 'P'.
    CLEAR: e_belnr, it_fimsg, it_fimsg[].

* Simulation
    g_simulation = i_simulation.

    g_group = i_group.

* 사용자 세팅에 맞게 금액포멧 변경
    PERFORM convert_amount TABLES t_bbseg t_bbtax t_bwith t_bselp2.

* AR/AP라인에 코스트 오브젝트 들어오면 지우기
    PERFORM delete_arap_kostl TABLES t_bbkpf t_bbseg.

* FBV1 임시전표 전기의 경우는 XPRFG = 'X' (완료로 저장)
    PERFORM save_complete_for_fbv1 TABLES t_bbkpf.
* 366 ~ 375 lines copy of 'RFBIBL01' program
    PERFORM post_init.
* 396 ~ 409 lines copy of 'RFBIBL01' program
    CASE i_post_type.
      WHEN 'B'.
        function = 'B'.
      WHEN 'C'.
        function = 'C'.
        IF sy-batch NE 'X'.
*     MESSAGE A899 WITH 'Bei Call Transaktion muß Report im Batch'.
        ENDIF.
      WHEN 'D'.
        function = 'D'.
        IF sy-batch NE 'X'.
*     MESSAGE A899 WITH 'Bei Fast Input muß Report im Batch laufen'.
        ENDIF.
    ENDCASE.

    SORT : t_bselk BY agkoa,
           t_bselp,
           t_bselp2.
* Add inputed T_BBKPF, T_BBSEG, T_BBTAX to TFILE.I_FB_TYPE
    anz_mode = i_bdc_mode.
    PERFORM get_field_info.
    PERFORM append_tfile_from_bgr00.
    PERFORM append_tfile_from_bbkpf       TABLES t_bbkpf.
    PERFORM append_tfile_from_bbtax       TABLES t_bbkpf t_bbtax.

* 원천세항목 설정
    PERFORM append_tfile_from_bbseg_bwith TABLES t_bbseg t_bwith.

* 반제항목 설정
    PERFORM append_tfile_from_bselk_bselp
                      TABLES t_bbkpf t_bselk t_bselp t_bselp2.

*BSELP2
*STYPE      - 계정유형
*TBNAM      - 계정코드10자리 && Special G/L 1자리
*FELDN_1    - 'BELNR' 값이 입력됨 전표번호
*SLVON_1    - 전표번호 && 회계연도 && 개별항목
*SLBIS_1    - 미입력
*FELDN_2    - 'BUZEI' 값이 입력됨
*SLVON_2    - 전표의 개별항목 번호 값
*SLBIS_2    - 미입력
*SHKZG      - 차변/대변 지시자
*OPNWRBTR   - 전체 금액
*CLRWRBTR   - 부분반제할 금액
*PARTIAL_TYPE - 'P' 로 입력됨
*FIND_INDEX 1 - T021R 테이블에서 BELNR 필드에 해당하는 값이 입력됨
    it_bselp2[] = t_bselp2[].  "부분반제 데이타

* 419 ~ 424 lines copy of 'RFBIBL01' program
    PERFORM loop_at_table_tfile.        "전표기표부분

* MESSAGE APPEND
    PERFORM append_messtab TABLES t_messtab.

* 빈 라인은 삭제.
    DELETE t_messtab WHERE msgid EQ space.

    COMMIT WORK.

    CALL FUNCTION 'DEQUEUE_ALL'.

* 전표번호 리턴
    e_belnr = g_belnr.                  "Document Number
    e_gjahr = g_gjahr.
    e_bukrs = g_bukrs.
    e_subrc = subrc.

    CHECK i_message EQ 'X'.
    CALL FUNCTION 'MESSAGES_INITIALIZE'.
    DATA : lv_cnt   TYPE i,               "Message Count
           lv_arbgb LIKE smesg-arbgb,   "Message ID
           lv_msgty LIKE smesg-msgty.   "Message Type
    LOOP AT t_messtab.
      lv_arbgb = t_messtab-msgid.       "Message ID
      lv_msgty = t_messtab-msgty.       "Message Type
      CALL FUNCTION 'MESSAGE_STORE'
        EXPORTING
          arbgb = lv_arbgb
          msgty = lv_msgty
          msgv1 = t_messtab-msgv1
          msgv2 = t_messtab-msgv2
          msgv3 = t_messtab-msgv3
          msgv4 = t_messtab-msgv4
          txtnr = t_messtab-msgno       "Message Number
          zeile = lv_cnt.
    ENDLOOP.

    IF NOT t_messtab[] IS INITIAL.
      CALL FUNCTION 'MESSAGES_SHOW'
        EXPORTING
          show_linno = space.
    ENDIF.

  ELSEIF i_fb_type = 'B'.  "(미승인(FB50L: 원장항목 가능 )
    g_simulation = i_simulation.
    anz_mode = i_bdc_mode.
* 미승인여부 점검 필드

*    PERFORM BDC_TRANSACTION_FB50L  TABLES T_BBKPF T_BBSEG T_BDCMSG.
** Document Number export
*    E_BELNR = G_BELNR.                  "Document Number
*    E_GJAHR = G_GJAHR.
*    E_BUKRS = G_BUKRS.
*
  ENDIF.


ENDFUNCTION.
