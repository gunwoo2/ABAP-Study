*&---------------------------------------------------------------------*
*& Report YE03_EX019
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YE03_EX019.
" TEXT-T01 : Selection Options
SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME
                                    TITLE TEXT-T01.

  PARAMETERS:
    PA_AG RADIOBUTTON GROUP RAG1, " 동의
    PA_RJ RADIOBUTTON GROUP RAG1. " 거절

  PARAMETERS:
    PA_CAR TYPE SCARR-CARRID,
    PA_CON TYPE SPFLI-CONNID.


SELECTION-SCREEN END OF BLOCK B01.


" 거절을 선택한 경우 오류 메시지 출력
*AT SELECTION-SCREEN.
AT SELECTION-SCREEN ON RADIOBUTTON GROUP RAG1. " 거절을 선택한 경우 오류 메시지 출력
  IF PA_RJ EQ 'X'.  "PA_AG를 선택하면 안됨. 에러 발생함. RJ를 검사하기로 했으니까!!
    MESSAGE '동의하셔야 진행이 가능합니다.' TYPE 'E'.
    ENDIF.

    START-OF-SELECTION.
    MESSAGE '다음 단계 진행 성공' TYPE 'I'.
