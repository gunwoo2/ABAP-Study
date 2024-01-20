*&---------------------------------------------------------------------*
*& Report ZHWE03_1A
*&---------------------------------------------------------------------*
*& 누적 합 계산기 (PREFIX_SUM)
*&---------------------------------------------------------------------*
REPORT ZHWE03_1A.

* 정수를 입력 받기 위한 Parameters 선언
PARAMETERS PA_NUM TYPE I.

* 전역 변수 생성
DATA GV_A TYPE I.      "GV_A 라는 변수를 정수형 타입으로 선언
DATA GV_B LIKE PA_NUM. "GV_B 라는 변수를 PA_NUM과 동일한 타입으로 선언.
                       "이때 PA_NUM이 정수형이므로 GV_B도 정수형 타입

" PA_NUM 값을 GV_B에 저장
"예를 들어 입력 필드에서 5를 입력 시, GV_B에 5가 들어감
MOVE PA_NUM TO GV_B.

* PREFIX_SUM 이라는 Subroutines 호출
* 이때 call by Ref. 방식을 사용
PERFORM PREFIX_SUM CHANGING GV_A GV_B.


*--------------------------------------------------------------------*
*                 'PREFIX_SUM' Subroutines 함수                     *
*--------------------------------------------------------------------*

* PREFIX_SUM 이라는 Subroutines 함수
* 정수형의 PV_A, PV_B 라는 지역변수를 선언
* call by Ref. 방식을 사용
FORM PREFIX_SUM CHANGING PV_A TYPE I
                         PV_B TYPE I.

* 입력 받은 정수가 1보다 작을 때 오류 메시지를 출력.
  IF PV_B < 1.

    MESSAGE I005(ZTEST03_MSG). "'입력 숫자가 1보다 작습니다'. 오류 창 출력


* 입력 받은 정수가 100보다 클 때 오류 메시지를 출력.
  ELSEIF

    PV_B > 100.

    MESSAGE I006(ZTEST03_MSG). " '입력 숫자가 100보다 큽니다'. 오류 창 출력

* 정상의 값이 입력된 경경우 1부터 누적합산하여 WRITE문으로 출력.

  ELSE.

    DO  PV_B TIMES. " 무한루프에 빠지는 걸 방지하기 위해 DO N TIME 사용
                    " PV_B는 전역변수 GV_B를 참조
                    " PV_B는 PA_NUM의 값을 받기에
                    " 즉, PA_NUM의 값이 PV_B 적용됨

" 누적합 계산을 위해 다음과 같은 알고리즘을 이용.
" '5'가 입력 될 시, 5번의 반복문이 수행됨
" 따라서 첫번째 반복문 수행 시, SY-INDEX는 1이고 PV_A는 0이기에 PV_A에 1이 저장
" 두번째 반복문 시, PV_A는 1, SY-INDEX는 2 이기에 PV_A에 3이 저장
" 이 과정을 5까지 반복하여 누적합을 계산함
      PV_A = PV_A +  SY-INDEX.

    ENDDO.

    " 반복문이 완료되었을 때 누적합이 출력되도록, 반복문 밖에서 선언
    WRITE : / '누적합 계산 결과 = ', PV_A.

  ENDIF.

ENDFORM.
