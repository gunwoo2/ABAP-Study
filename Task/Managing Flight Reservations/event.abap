*&---------------------------------------------------------------------*
*& Include          ZHWE03_3A_E01 / event
*&---------------------------------------------------------------------*

*--------------------------------------------------------------------*
*                           INITIALIZATION
*--------------------------------------------------------------------*
INITIALIZATION.


*--------------------------------------------------------------------*
*                        AT SELECTION-SCREEN.
*--------------------------------------------------------------------*
" Selection Options 블록 BL2에 대한 점검
" (Airline, Connection Number, Flight Date, Posting Date)

" Select data 라디오 버튼이 체크되어 데이터를 조회할 때,
" Selection Options가 하나라도 선택되어 있지 않으면 안내 메시지를 출력.
" 이때 SELECT-OPTIONS의 경우 선택되지 않더라도 프로세스가 진행될 수 있기에
" 메시지 타입을 E로 수행하지 않고 I로 선언하여 중단되지 않고 다음 프로세스가
" 수행될 수 있도록 선언함.
AT SELECTION-SCREEN ON BLOCK BL2.
  IF ( SO_CAR IS INITIAL AND SO_CON IS INITIAL
    AND SO_FLD IS INITIAL AND SO_CITO IS INITIAL ) AND PA_RAD2 EQ 'X'.

    MESSAGE I010(ZTEST03_MSG). " 하나 이상의 Select options을 선택 시,
                               " 더 효과적인 조회가 가능합니다.
  ENDIF.

*   ENDCASE.

*--------------------------------------------------------------------*
*                        START-OF-SELECTION.
*--------------------------------------------------------------------*
START-OF-SELECTION.

  CASE ABAP_ON.   " 'X'

    WHEN PA_RAD1. " Insert Data 라디오 버튼 선택 시,

      IF PA_BOOK EQ GC_MARK.      " 체크박스 선택 시,
        PERFORM INSERT_CHECKDATA. " 'INSERT_CHECKDATA' Subroutine 함수 호출
                                  " CANCELLED 필드에 조건이 없는 값이 삽입됨

      ELSEIF
        PA_BOOK NE GC_MARK.         " 체크박스 미 선택 시,
        PERFORM INSERT_NOCHECKDATA. " 'INSERT_NOCHECKDATA' Subroutine 함수 호출
                                    " CANCELLED 필드가 공란인 값이 삽입됨

      ENDIF.

    WHEN PA_RAD2. " Select Data 라디오 버튼 선택 시,
        PERFORM SELECT_DATA.  " ZDETAIL_E03으로 부터 Ineternal Table로 가져옴
        PERFORM DISPLAY_DATA. " 조회한 데이터에 대해 SALV를 사용하여 출력

    WHEN PA_RAD3. " Delete All Date 라디오 버튼 선택 시,
        PERFORM DELETE_DATA. " ZDETAIL_E03의 모든 데이터를 삭제.

  ENDCASE.
