*&---------------------------------------------------------------------*
*& Report YE00_EX031
*&---------------------------------------------------------------------*
*& Class 연습
*&---------------------------------------------------------------------*
REPORT YE03_EX031.

DATA GO_CAR1 TYPE REF TO YCL_E00_CAR.
DATA GO_CAR2 TYPE REF TO YCL_E00_CAR.
DATA GX_MODEL_CHECK TYPE REF TO CX_ROOT.

START-OF-SELECTION.
  DATA LV_MODEL TYPE CHAR20.

  TRY.

      CREATE OBJECT GO_CAR1
        EXPORTING
          IV_MODEL = ''. " 자동차의 모델 정보를 기록하기 위한 Parameter

      " CREATE OBJECT가 Exception 발생하지 않으면 아래 문장을 수행한다.
      LV_MODEL = GO_CAR1->GET_MODEL( ).
      WRITE : / '1번 자동차 모델은', LV_MODEL, '입니다.'.

    CATCH YCX_E00_CAR_MODEL_CHECK INTO GX_MODEL_CHECK. " 자동차 모델을 점검하기 위한 Exception Class
*    CATCH CX_STATIC_CHECK INTO GX_MODEL_CHECK. " 자동차 모델을 점검하기 위한 Exception Class
*    CATCH CX_ROOT INTO GX_MODEL_CHECK. " 자동차 모델을 점검하기 위한 Exception Class
*    CATCH CX_NO_CHECK INTO GX_MODEL_CHECK. " 자동차 모델을 점검하기 위한 Exception Class

      " CREATE OBJECT 에서 YCX_E00_CAR_MODEL_CHECK 라는 Exception Class 가 발생해서
      " 즉시 이 구간의 문장으로 내려와 수행된다.

      DATA LV_MSG TYPE STRING.
      LV_MSG = GX_MODEL_CHECK->GET_TEXT( ). " Exception 에서 에러메시지 가져오기

      " 가져온 에러메시지를 팝업으로 출력할 때 오류메시지처럼 보여주기.
      MESSAGE LV_MSG TYPE 'I' DISPLAY LIKE 'E'.

  ENDTRY.


  CREATE OBJECT GO_CAR2
    EXPORTING
      IV_MODEL = 'AVANTE'. " 자동차의 모델 정보를 기록하기 위한 Parameter

  LV_MODEL = GO_CAR2->GET_MODEL( ).
  WRITE : / '2번 자동차 모델은', LV_MODEL, '입니다.'.
