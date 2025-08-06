FUNCTION ZRPFMG_RESET_DOC .
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     REFERENCE(I_BUKRS) TYPE  BUKRS
*"     REFERENCE(I_BELNR) TYPE  BELNR_D
*"     REFERENCE(I_GJAHR) TYPE  GJAHR
*"     REFERENCE(I_BUDAT) TYPE  BUDAT OPTIONAL
*"     REFERENCE(I_STGRD) TYPE  STGRD
*"  EXPORTING
*"     REFERENCE(E_RESULT) TYPE  AS4FLAG
*"     REFERENCE(E_RBELNR) TYPE  BELNR_D
*"     REFERENCE(ERR_TXT)
*"  EXCEPTIONS
*"      NO_BELNR
*"----------------------------------------------------------------------

  DATA: l_stodt    LIKE bkpf-budat,    "Storno-Buchungsdatum (FBRA+FB08)
        l_stomo    LIKE bkpf-monat,    "Storno-Buchungsperiode (dto)
        l_xerlk(1) TYPE c.             "X Korrespondenz zu erledigen

  DATA it_xaccnt  LIKE rf05r_acct OCCURS 6 WITH HEADER LINE.
  DATA it_yaccnt  LIKE rf05r_acct OCCURS 6 WITH HEADER LINE.

  DATA BEGIN OF it_msg OCCURS 2.
  INCLUDE STRUCTURE fimsg.
  DATA END OF it_msg.

  CLEAR rf05r.
  rf05r-bukrs = i_bukrs.
  rf05r-gjahr = i_gjahr.
  rf05r-augbl = i_belnr.
  rf05r-belnr = ''.
  rf05r-bvorg = ''.
  rf05r-stgrd = i_stgrd.
  rf05r-budat = i_budat.
  rf05r-monat = ''.
  rf05r-ccbtc  = ''.

  CALL FUNCTION 'READ_DOCUMENT_HEADER'
    EXPORTING
      belnr     = rf05r-augbl
      bstat     = space
      bukrs     = rf05r-bukrs
      gjahr     = rf05r-gjahr
      xarch     = space          "keine Suche im Archiv
    IMPORTING
      e_bkpf    = bkpf
    EXCEPTIONS
      exit      = 4
      not_found = 8.

  CASE sy-subrc.
    WHEN 0.
*      PERFORM check_fagl_op.
*      PERFORM berechtigung.
*      rf05r-gjahr = bkpf-gjahr.
*      PERFORM period_check.        " Issue a warning for previous years
*      PERFORM belegnummer_sperren(sapff001)
*        USING rf05r-bukrs rf05r-augbl rf05r-gjahr.

*전표 시뮬레이션
      CALL FUNCTION 'CALL_FB08'          "Simulation des Stornos
        EXPORTING
          i_bukrs      = rf05r-bukrs
          i_belnr      = rf05r-augbl
          i_gjahr      = rf05r-gjahr
          i_stgrd      = rf05r-stgrd
          i_budat      = rf05r-budat
          i_monat      = rf05r-monat
          i_xsimu      = 'X'
          i_bldat      = rf05r-bldat                    "N1580518
          i_vatdate    = rf05r-vatdate                  "N1660511
        IMPORTING
          e_budat      = l_stodt
          e_monat      = l_stomo
        EXCEPTIONS
          not_possible = 4.

      IF sy-subrc <> 0. "시뮬레이션 실패

        e_result = 'F'.
        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
          EXPORTING
            msgid               = syst-msgid
            msgnr               = syst-msgno
            msgv1               = syst-msgv1
            msgv2               = syst-msgv2
            msgv3               = syst-msgv3
            msgv4               = syst-msgv4
          IMPORTING
            message_text_output = err_txt.


      ELSE. "시뮬레이션 성공

*전표 재설정
        CALL FUNCTION 'CALL_FBRA'          "Rücknahme des Ausgleichs
          EXPORTING
            i_bukrs = rf05r-bukrs
            i_augbl = rf05r-augbl
            i_gjahr = rf05r-gjahr
            i_xerlk = l_xerlk
*           i_augdt = augdt
            i_stodt = l_stodt
            i_stomo = l_stomo
          TABLES
            t_accnt = it_xaccnt.


        IF sy-subrc <> 0. "재설정 실패
          e_result = 'F'.
          CALL FUNCTION 'MESSAGE_TEXT_BUILD'
            EXPORTING
              msgid               = syst-msgid
              msgnr               = syst-msgno
              msgv1               = syst-msgv1
              msgv2               = syst-msgv2
              msgv3               = syst-msgv3
              msgv4               = syst-msgv4
            IMPORTING
              message_text_output = err_txt.

        ELSE. "재설정 성공

          CALL FUNCTION 'CALL_FB08'          "Storno des Ausgleichsbelegs
            EXPORTING
              i_bukrs   = rf05r-bukrs
              i_belnr   = rf05r-augbl
              i_gjahr   = rf05r-gjahr
              i_stgrd   = rf05r-stgrd
              i_budat   = rf05r-budat
              i_monat   = rf05r-monat
              i_bldat   = rf05r-bldat                    "N1580518
              i_vatdate = rf05r-vatdate.

          IF sy-subrc <> 0.
            e_result = 'F'.
            CALL FUNCTION 'MESSAGE_TEXT_BUILD'
              EXPORTING
                msgid               = syst-msgid
                msgnr               = syst-msgno
                msgv1               = syst-msgv1
                msgv2               = syst-msgv2
                msgv3               = syst-msgv3
                msgv4               = syst-msgv4
              IMPORTING
                message_text_output = err_txt.
            EXIT.

          ELSE.
            e_result = 'S'.
            e_rbelnr = sy-msgv1.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = e_rbelnr
              IMPORTING
                output = e_rbelnr.

          ENDIF.

        ENDIF.

      ENDIF.


    WHEN 4.
      e_result = 'F'.

    WHEN 8.
      e_result = 'F'.
      IF rf05r-gjahr = space.
        MESSAGE e429(fi) WITH rf05r-augbl rf05r-bukrs INTO err_txt.
      ELSE.
        MESSAGE e238(fi) WITH rf05r-augbl rf05r-bukrs rf05r-gjahr INTO err_txt.
      ENDIF.

    WHEN OTHERS.
      e_result = 'F'.
      MESSAGE a370(fi) WITH 'READ_DOCUMENT_HEADER' INTO err_txt.
  ENDCASE.




ENDFUNCTION.
