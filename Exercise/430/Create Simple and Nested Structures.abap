*&---------------------------------------------------------------------*
*& Report ZBC430_E00_STRUCT_NESTED
*&---------------------------------------------------------------------*
*& Exercise 2 Create Simple and Nested Structures
*&---------------------------------------------------------------------*
REPORT ZBC430_E00_STRUCT_NESTED.

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
