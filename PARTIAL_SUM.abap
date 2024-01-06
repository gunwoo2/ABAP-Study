*&---------------------------------------------------------------------*
*& Report ZHWE03_1B
*&---------------------------------------------------------------------*
*& 특정 구간 누적 합 계산기 (Partial_SUM)
*&---------------------------------------------------------------------*
REPORT ZHWE03_1B.

* 정수를 입력 받기 위한 2개의 Parameters 선언
PARAMETERS PA_NUM1 TYPE I.
PARAMETERS PA_NUM2 TYPE I.

* 전역 변수 생성
* GV_B 와 GV_C의 타입은 PA_NUM1/2 와 동일
DATA GV_A TYPE I.
DATA GV_B LIKE PA_NUM1.
DATA GV_C LIKE PA_NUM2.

*입력받은 PA_NUM1, PA_NUM2 의 값을 전역변수에 저장
MOVE PA_NUM1 TO GV_B.
MOVE PA_NUM2 TO GV_C.

* PARTIAL_SUM 이라는 Subroutines 호출
* 이때 call by Ref. 방식을 사용
PERFORM PARTIAL_SUM CHANGING GV_A GV_B GV_C.


*--------------------------------------------------------------------*
*                 'PARTIAL_SUM' Subroutines 함수                     *
*--------------------------------------------------------------------*

* 정수형의 PV_A, PV_B, PV_C 라는 지역변수를 선언
* PV_A는 결과 값 출력을 위한 변수 / PV_B, PV_C 는 입력 받은 변수를 담을 공간
* call by Ref. 방식을 사용
FORM PARTIAL_SUM CHANGING PV_A TYPE I
                          PV_B TYPE I
                          PV_C TYPE I.


* 두 입력값 중 하나가 0보다 작고 다른 하나가 100보다 클 때 오류 메시지 출력
  IF PV_B < 0 AND PV_C > 100 OR PV_B > 100 AND PV_C < 0.
    MESSAGE I008(ZTEST03_MSG). "'1에서 100 사이의 값을 입력해주세요.' 출력

* 입력 받은 정수 중 하나라도 1보다 작을 때 오류 메시지 출력
   ELSEIF

    PV_B < 1 OR PV_C < 1.

   MESSAGE I005(ZTEST03_MSG). "'입력 숫자가 1보다 작습니다'. 오류 출력

* 입력 받은 정수 중 하나라도 100보다 클 때 오류 메시지 출력
  ELSEIF

    PV_B > 100 OR PV_C > 100.
    MESSAGE I006(ZTEST03_MSG). "'입력 숫자가 100보다 큽니다'. 오류 출력

* 입력받은 첫번째 정수가 두번째 정수보다 클때 오류 메시지 출력
  ELSEIF

    PV_B > PV_C.
    MESSAGE I007(ZTEST03_MSG). "'시작 정수가 종료 정수보다 큽니다.' 오류 출력



* 정상의 값이 입력된  경우
  ELSE.

      DO  ( PV_C - PV_B + 1 ) TIMES. " 큰 정수-작은 정수 + 1 만큼의
                                     " 반복문을 수행

" 누적합 계산을 위해 다음과 같은 알고리즘을 이용.
" '10', '13'이 입력 될 시, 4번의 반복문이 수행됨
" 따라서 첫번째 반복문 수행 시, SY-INDEX는 1이고 PV_B 10 이기에 PV_A에 10이 저장
" 두번째 반복문 시, PV_A = 10, PV_B= 10, SY-INDEX = 2 이기에
" 10 + ( 10 + 1 ) = 21이 PV_A에 이 저장
" 이 과정을 5까지 반복하여 특정 구간 누적합을 계산함
          PV_A = PV_A + ( PV_B +  ( SY-INDEX - 1 ) ).

      ENDDO.

   " 반복문이 완료되었을 때 특정 구간 누적합이 출력되도록, 반복문 밖에 선언
   WRITE : / '특정범위의 누적합 계산 결과 = ', PV_A.

  ENDIF.

ENDFORM.
