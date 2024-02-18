*&---------------------------------------------------------------------*
*& Report YE03_EX022
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YE03_EX022.

INCLUDE YE03_EX022_TOP. " 전역 변수만 넣기에 실행 로직이 존재하지 않음.
INCLUDE YE03_EX022_SCR. " Selection Screen 만 (실행 로직 X)
INCLUDE YE03_EX022_F01.

" 아래 FORM 안의 로직이 호출되었을 때만 실행됨.


INITIALIZATION.       " 주로 Selection Screen 의 초기값 설정 등
                      " 프로그램이 실행되면, 가장 먼저 호출되는 이벤트

*  WRITE SY-UZEIT TO GV_TIME. "--> 여기에 넣으면, 엔터를 눌러도 현재 시간이
*                                 변하지를 않음.

*--------------------------------------------------------------------*

AT SELECTION-SCREEN OUTPUT. " PBO에 해당됨
                      " 주로 Selection Screen 화면 속성 변경이나
                      " 출력하고 싶은 부분의 변경,
                      " 화면이 출력되기 전에 처리해야하는 로직 등.

*  MESSAGE SY-UZEIT TYPE 'I'.
  WRITE SY-UZEIT TO GV_TIME.  " GV_TIME에게 SY-UZEIT의 값을 출력하여 기록
                              " 엔터를 치면

*--------------------------------------------------------------------*

  AT SELECTION-SCREEN.  " PAI에 해당됨
                        " 주로 Selction Screen 의 입력 값 점검 등
                        " 사용자가 Enter 키를 누르거나,
                        " user-command 가 있는 항목을 클릭했을 때,
                        " 호출되는 이벤트.

*   MESSAGE SY-UZEIT TYPE 'I'. "-> 여기에 이게 있으면 처음에 실행 시, 뜨지 않음
*                                 처음에 실행 시, PAI가 수행되지 않기 때문에
*                                 엔터를 누르기전까지 시간이 뜨지 않음
PERFORM USER_COMMAND_0100.

*--------------------------------------------------------------------*

START-OF-SELECTION.

PERFORM SUBROUTINES1.



*-----------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Include          YE03_EX022_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form SUBROUTINES1
*&---------------------------------------------------------------------*
FORM SUBROUTINES1 .

WRITE 'AA'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form USER_COMMAND_0100
*&---------------------------------------------------------------------*
FORM USER_COMMAND_0100 .

" SY-UCOMM 에는 Selection Screen의 User Command 값이 기록되는가?
" A 를 출력한다는 버튼을 눌러서 확인해보자.
***IF SY-UCOMM EQ 'COMM1'.
***
***  MESSAGE 'A' TYPE 'I'.
***
***  ENDIF.
***
***  IF
***" Structure SSCRFIELDS 의 UCOMM 필드에도 위와 같이 User Command 값이
***" 기록되는가? 'B'를 출력 한다는 버튼을 눌러서 확인해보자.
***  SSCRFIELDS-UCOMM EQ 'COMM2'.
***
***    MESSAGE 'ABCDEFG' TYPE 'I'.
***
***ENDIF.

" 위에 문장 처럼 사용하는게 아닌 아래와 처럼 보통 구성함.
" 한의 변수를 갖고 여러가지 값을 비교해 보는 과정을 거칠때는
" CASE 문을 로직을 작성하는게 훨씬 편하다.
" --> 이러한 과정을 '로직을 분기하다.' 라고 이야기함.

CASE SSCRFIELDS-UCOMM.
  WHEN 'COMM1'.
    MESSAGE 'A' TYPE 'I'.
  WHEN 'COMM2'.
        MESSAGE 'A' TYPE 'I'.
  WHEN 'COMM3'.
    CALL SELECTION-SCREEN 1100
    STARTING AT 30 " 왼쪽으로부터 30 떨어져있고
                5.  " 위로부터 5만큼 떨어져있음.

  WHEN 'COMM4'.  " 이 USER-COMMAN는 1100번 화면의 버튼이 가지고 있다.
    MESSAGE '닫기 버튼을 눌렀습니다.' TYPE 'I'.
    LEAVE TO SCREEN 0. " 이전화면으로 이동 (즉, 팝업창 출력 전 화면)
ENDCASE.

ENDFORM.
