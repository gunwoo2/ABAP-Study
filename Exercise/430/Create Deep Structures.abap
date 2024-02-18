*&---------------------------------------------------------------------*
*& Report ZBC430_E00_STRUCT_DEEP
*&---------------------------------------------------------------------*
*& Exercise 4 Create Deep Structures
*&---------------------------------------------------------------------*
REPORT ZBC430_E00_STRUCT_DEEP.

" SE11 에서 선언한 Nested Structure를 변수의 타입으로 선언함
DATA GS_PERSON TYPE ZPERSON_E00.

GS_PERSON-NAME-FIRSTNAME = '훈영'.
GS_PERSON-NAME-LASTNAME  = '정'.
GS_PERSON-STREET = '도로명주소'.
GS_PERSON-NR     = 12345.
GS_PERSON-ZIP    = '우편번호'.
GS_PERSON-CITY   = '도시'.


DATA GV_FIRSTNAME TYPE ZFIRSTNAME_E00.

GV_FIRSTNAME = '문자열 30자리를 입력할 수 있음'.


TYPES: BEGIN OF TY_S_NAME,
         FIRSTNAME TYPE ZFIRSTNAME_E00,
         LASTNAME  TYPE ZLASTNAME_E00,
       END OF TY_S_NAME.

DATA GS_NAME TYPE TY_S_NAME.

TYPES: BEGIN OF TY_S_PERSON,
         NAME TYPE TY_S_NAME,
       END OF TY_S_PERSON.

DATA GS_PERSON2 TYPE TY_S_PERSON.

GS_NAME-FIRSTNAME         = '이건 GS_NAME의 FIRSTNAME 필드'.
GS_PERSON2-NAME-FIRSTNAME = '이건 GS_PERSON2의 NAME의 FIRSTNAME 필드'.

WRITE : /1(100) GS_NAME-FIRSTNAME,
        /1(100) GS_PERSON2-NAME-FIRSTNAME.

" 39p 에 있는 3번 문항, 새롭게 추가된 ZPERSON의 PHONE 필드의
" 작업공간으로 사용하기 위해 WA_PHONE 이라는 Structure 변수를 선언함

" Structure 변수이나 목적을 알기 어려운 방법
***DATA WA_PHONE TYPE STR_PHONE.

" 위와 동일한 Structure 변수이면서 GS_PERSON-PHONE을 위한
" 작업공간이라는 의미를 확실하게 표현함
DATA WA_PHONE LIKE LINE OF GS_PERSON-PHONE.


" 4번, wa_phone 을 이용해서 3개의 연락처 정보를 GS_PERSON-PHONE에
"      추가하고, 해당 Itab을 이용해서 Loop로 모든 연락처를 화면에
"      출력해라..

" 1. wa_phone 에는 무슨 필드들이 있는가?
" 2. wa_phone 의 각 필드들은 어떤 값을 전달해야 옳은가?
" 3. wa_phone 을 gs_person-phone에 한줄씩 추가하려면 어떤 명령어를
"    작성해야 하는가?
" 4. gs_person-phone 에 있는 모든 정보를 화면에 출력하려면
"    LOOP 문을 어떻게 작성해야 하는가?

WA_PHONE-P_TYPE = 'M'.
WA_PHONE-P_NUMBER = '010-1234-5678'.
INSERT WA_PHONE INTO TABLE GS_PERSON-PHONE.

CLEAR WA_PHONE.
WA_PHONE-P_TYPE = 'P'.
WA_PHONE-P_NUMBER = '02-333-4444'.
INSERT WA_PHONE INTO TABLE GS_PERSON-PHONE.

CLEAR WA_PHONE.
WA_PHONE-P_TYPE = 'F'.
WA_PHONE-P_NUMBER = '02-777-9999'.
INSERT WA_PHONE INTO TABLE GS_PERSON-PHONE.

LOOP AT GS_PERSON-PHONE INTO WA_PHONE.
  WRITE : / '타입: ', WA_PHONE-P_TYPE,
            '번호: ', WA_PHONE-P_NUMBER.
ENDLOOP.
