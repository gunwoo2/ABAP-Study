*&---------------------------------------------------------------------*
*& Report YE03_EX028
*&---------------------------------------------------------------------*
*& Constructor 연습
*&---------------------------------------------------------------------*
REPORT YE03_EX028.

CLASS LCL_TEST DEFINITION.
  PUBLIC SECTION.
    " Static 은 참조변수 없이 사용할 수 있음.
    CLASS-METHODS WRITE_ALONE. " Static Methods
    CLASS-METHODS CLASS_CONSTRUCTOR. " Static Constructor
    METHODS CONSTRUCTOR. " Instance Constructor
    METHODS WRITE_HELLO. " Instance Methods
  PRIVATE SECTION.
    METHODS SECRET_METHOD. " Instance Methods
ENDCLASS.

CLASS LCL_TEST IMPLEMENTATION.
  METHOD WRITE_ALONE.
    WRITE : / '난 객체 없어도 실행 가능한 Public Static Method야.'.
    WRITE : / '대신 클래스로 호출해줘'.
    ULINE.
  ENDMETHOD.
*--------------------------------------------------------------------*
  METHOD CLASS_CONSTRUCTOR.
    WRITE : / 'LCL_TEST는 처음이지? 온 걸 환영해'.
    WRITE : / 'LCL_TEST를 사용하면 제일 먼저 나를 거칠 거야'.
    ULINE.
  ENDMETHOD.
*--------------------------------------------------------------------*
  METHOD CONSTRUCTOR.
    WRITE : / '객체를 생성하면서 제가 자동으로 실행됩니다.'.
    WRITE : / '저는 Public Instance Constructor(생성자) 입니다.'.
    ULINE.
  ENDMETHOD.
*--------------------------------------------------------------------*
  METHOD WRITE_HELLO.
    WRITE : / '안녕하세요 저는 Public Instance Method 입니다.'.
    WRITE : / '나는 Private에 접근이 가능해, 내가 호출할게'.
    ULINE.
    CALL METHOD ME->SECRET_METHOD.
  ENDMETHOD.
*--------------------------------------------------------------------*
  METHOD SECRET_METHOD.
    WRITE : / '나는 외부에서 호출할 수 없는 Private Instance Method 야'.
    ULINE.
  ENDMETHOD.
ENDCLASS.

DATA GO_TEST TYPE REF TO LCL_TEST.

START-OF-SELECTION.

  CALL METHOD LCL_TEST=>WRITE_ALONE.

  CREATE OBJECT GO_TEST.
  CREATE OBJECT GO_TEST.
  CREATE OBJECT GO_TEST.

  CALL METHOD GO_TEST->WRITE_HELLO.

*  Private SECTION 에 있기에 호출 불가
*  CALL METHOD GO_TEST->SECRET_METHOD.
