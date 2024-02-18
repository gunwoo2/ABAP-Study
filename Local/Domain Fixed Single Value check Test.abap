*&---------------------------------------------------------------------*
*& Report YE03_EX014
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YE03_EX014.

" Domain S_CLASS 는 Fixed Single Value가 지정되어 있다.
" C = Business Class
" Y = Economy Class
" F = First Class

" 위의 Domain S_CLASS는 Data Element S_CLASS에서만 사용되고 있다.

" Data Element S_CLASS는 다양한 곳에서 사용되고 있음을 확인했고,
" 그 중에 Tranparent Table S_BOOK에서 CLASS 필드의 타입으로
" Data Element S_CLASS를 사용하고 있었다.

" 이에 PARAMETERS 를 아래와 같이 선언하여 Input Check를 테스트 하자.

PARAMETERS PA_CLASS TYPE SBOOK-CLASS
                    VALUE CHECK. " Domain에 설정된 값 제한을 검사하거나
                                 " Table의 Check Table 기준으로 검사한다.

WRITE '성공적으로 실행됨'.
