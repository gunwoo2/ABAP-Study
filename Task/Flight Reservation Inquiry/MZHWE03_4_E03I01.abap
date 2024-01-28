*&---------------------------------------------------------------------*
*& Include          MZHWE03_4_E03I01 : BACK 버튼 및 TAB 이벤트 처리
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

* USER COMMAND 값이 OK_CODE에 담겼을 때,
  CASE OK_CODE.
    WHEN 'BACK'.         " 'BACK' 일시
      LEAVE TO SCREEN 0. " 이전화면으로 이동

* Tab 버튼을 눌렀을 때 해당 Tab이 활성화 되도록 Function Code를 기록.
    WHEN 'FC1' OR 'FC2' OR 'FC3'.
      MY_TABSTRIP-ACTIVETAB = OK_CODE.
    WHEN OTHERS.
  ENDCASE.


ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0100  INPUT : EIXT 버튼 누를 시, 수행되는 팝업 창
*&---------------------------------------------------------------------*
MODULE EXIT_COMMAND_0100 INPUT.


* USER COMMAND 값이 OK_CODE에 담겼을 때,
  CASE OK_CODE.
    WHEN 'EXIT'. " 'EXIT' 버튼이 눌렸을 때 프로그램 종료를 수행

      PERFORM POPUP_TO_CONFIRM. " 팝업창을 위한 서브루틴 (함수 호출)

    WHEN 'CANC'. " 'CANC' 가 눌렸을 때 입력된 데이터가 모두 삭제되도록 함
                 " 다음 변수들을 초기화함.

      PERFORM CLEAR_INPUT_VALUES.

  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  CHECK_INPUT_VALUES  INPUT : 입력된 값이 존재하는지 검증하는 모듈
*&---------------------------------------------------------------------*
MODULE CHECK_INPUT_VALUES INPUT.

  PERFORM CHECK_INPUT_VALUES.

ENDMODULE.
