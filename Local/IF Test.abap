*&---------------------------------------------------------------------*
*& Report YE03_EX003
*&---------------------------------------------------------------------*
*& IF문 연습
*&---------------------------------------------------------------------*
REPORT YE03_EX003.

PARAMETERS PA_INT TYPE I.


IF PA_INT > 0 . "PA_INT가 0보다 크다면,

  WRITE / 'PA_INT가 0보다 크다. '.

  ELSEIF PA_INT = 0. "A_INT가 0과 같다면,

    WRITE / 'PA_INT가 0과 같다. '.

    ELSE. "IF 조건 또는 ELSEIF 조건이 모두 성립되지 않았다면,

      WRITE / 'PA_INT가 0보다 크지 않고 0과 같지도 않다. '.

      ENDIF.

*IF gv_carrid IS NOT INITIAL. "초기 상태가 아니라면
  "IF gv_carrid IS INITIAl. 초기 상태일때 = 어떤것이라도 들어가있으면
  "초기상태가 아님

*  ELSE.

*    ENDIF.

*IF ( gv_carrid = 'AA' or gv_carrid = 'LH' ) AND gv_fldate = sy-datum.


*  ELSEIF ( gv_carrid = 'UA' or gv_carrid = 'DL' ) AND gv_fldate > sy-datum.

*    ENDIF.

*IF  NOT ( gv_carrid = 'AA' OR gv_carrid = 'UA' ). AND gv_fldate > sy-datum.


*ENDIF.
