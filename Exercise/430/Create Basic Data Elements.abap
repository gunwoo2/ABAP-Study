*&---------------------------------------------------------------------*
*& Report ZBC430_E03_DATA_ELEMENTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC430_E03_DATA_ELEMENTS.

PARAMETERS :

  PA_FNAME TYPE ZFIRSTNAME_E03,
  PA_LNAME TYPE ZLASTNAME_E03,
  PA_ACTIV TYPE ZASSETS_E03,
  PA_LIABS TYPE ZLIABILITIES_E03.

INITIALIZATION.
  " 프로그램 실행 시 최초로 실행되는 이벤트 구간
  " Selection Screen이 화면에 출력되기 전에 호출되므로,
  " 위에 선언된 PARANETERS 나 SELECT-OPTIONS 에 초기값을
  " 설정하는 목적으로 사용되기도 한다.


AT SELECTION-SCREEN.
  " Selection Screen이 호출된 이후 사용자가 버튼이나
  " 입력 필드에서 enter 키를 누른 경우 등 무언가 이벤트가
  "발생할 때 호출되는 이벤트 구간
  " 주로 입력필드에 입력된 값을 점검하는 목적 또는
  " 실행 버튼 눌렀을 때, 실행권한이 있는지 점검하는 목적
  " 등으로 사용된다.

START-OF-SELECTION.
  " Selection Screen에서 실행버튼을 눌렀을 때,
  " AT SELECTION-SCREEN의 이벤트 구간을 에러 메시지 없이
  " 잘 통과하였을 때 실행되는 이벤트 구간
  " 주로 데이터 조회 및 결과화면 출력이나
  " 데이터 저장 등 실질적인 프로그램 로직이 작성된다.

  WRITE : / '이름 :' , PA_LNAME, PA_FNAME.

  " 자산과 부채의 차이를 저장할 변수를 선언
  " 자본
  DATA LV_RESULT LIKE PA_ACTIV.

  LV_RESULT = PA_ACTIV - PA_LIABS.

  WRITE : / '자산 :', PA_ACTIV,
          / '부채 :', PA_LIABS,
          / '자본 :', LV_RESULT.

* end-of-SELECTION
