*&---------------------------------------------------------------------*
*& Report ZBC400_E03_HELLO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC400_E03_HELLO.

* string : 길이가 정해지지 않은 문자열
* Selection Screen 이라는 화면에 입력필드를 생성시키고, 해당 입력필드에
* 값을 입력하면 PA_NAME에 해당 값이 저장된다.
PARAMETERS PA_NAME TYPE string.

*write는 우측의 문자열을 화면에 출력
WRITE 'Hello world!'.

NEW-LINE.

WRITE: 'Hello', PA_NAME.

NEW-LINE.

* WRITE 'Hello'.
* WRITE 'PA_NAME'.
