*&---------------------------------------------------------------------*
*& Include          MZHWE03_4_E03O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
 SET PF-STATUS 'S0100'.
* Task 1-5-1
 CASE MY_TABSTRIP-ACTIVETAB.
     WHEN 'FC1'. " 첫번째 Tab이 눌려있는 상태
       SET TITLEBAR 'T0100' WITH SY-UNAME TEXT-T01. " 타이틀바 + 로그인한 ID + 탭별 TEXT

    WHEN 'FC2'. " 두번쨰 Tab이 눌려있는 상태
      SET TITLEBAR 'T0100' WITH SY-UNAME TEXT-T02.

    WHEN 'FC3'. " 세번째 Tab이 눌려있는 상태
     SET TITLEBAR 'T0100' WITH SY-UNAME TEXT-T03.

     " 0110번 스크린을 처음에 보여줄 탭으로(디폴트) 설정하였기에 위와 같이 선언.
     " 첫 실행 시, Bokking Info. 타이틀이 보임.
    WHEN OTHERS.
     SET TITLEBAR 'T0100' WITH SY-UNAME TEXT-T01.
 ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT : OK_CODE 클리어 모듈
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.

  CLEAR OK_CODE.

ENDMODULE.

*&---------------------------------------------------------------------*
*& Module FILL_DYNNR OUTPUT : TabStrips 제어 모듈 선언
*&---------------------------------------------------------------------*
* Task 1-4
MODULE FILL_DYNNR OUTPUT.
  CASE MY_TABSTRIP-ACTIVETAB.
    WHEN 'FC1'.       " 첫번째 Tab일때
      DYNNR = '0110'. " 110번 스크린 호출
    WHEN 'FC2'.       " 두번째 Tab일때
      DYNNR = '0120'. " 120번 스크린 호출
    WHEN 'FC3'.       " 세번째 Tab일때
      DYNNR = '0130'. " 130번 스크린 호출
    WHEN OTHERS.      " 프로그램 첫 실행 시,
                      " 110번 스크린 호출
      MY_TABSTRIP-ACTIVETAB = '0110'.
      DYNNR = '0110'.

      ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module ICON_CREATE OUTPUT : Status Icon 설정을 위한 모듈
*&---------------------------------------------------------------------*
* Task 1-3
MODULE ICON_CREATE OUTPUT.

  PERFORM ICON_CREATE.

ENDMODULE.

* 아래부터는 입력필드 값에 해당되는 Record를 조회하기 위한 모듈
* Task 1-5-2
*&---------------------------------------------------------------------*
*&      Module  CHECK_BOOKINGINFO OUTPUT : Booking Info를 조회하기 위한 모듈
*&---------------------------------------------------------------------*
MODULE CHECK_BOOKING_INFO OUTPUT.

  PERFORM CHECK_BOOKING_INFO.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  CHECK_FLIGHT_INFO OUTPUT : FLIGHT_INFO를 조회하기 위한 모듈
*&---------------------------------------------------------------------*
MODULE CHECK_FLIGHT_INFO OUTPUT.

  PERFORM CHECK_FLIGHT_INFO.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  CHECK_SCUSTOM OUTPUT : FLIGHT_INFO를 조회하기 위한 모듈
*&---------------------------------------------------------------------*
MODULE CHECK_SCUSTOM OUTPUT.

  PERFORM CHECK_SCUSTOM.

ENDMODULE.
