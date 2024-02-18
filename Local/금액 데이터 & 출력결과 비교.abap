*&---------------------------------------------------------------------*
*& Report YE03_EX023
*&---------------------------------------------------------------------*
*& 금액 데이터 & 출력결과 비교
*&---------------------------------------------------------------------*
REPORT YE03_EX023.

DATA: GV_PRICE_KRW TYPE SFLIGHT-PRICE,
      GV_PRICE_USD TYPE SFLIGHT-PRICE,
      GV_PRICE_EUR TYPE SFLIGHT-PRICE,
      GV_PRICE_JPY TYPE SFLIGHT-PRICE.

CONSTANTS: GC_CURRENCY_KRW TYPE SFLIGHT-CURRENCY VALUE 'KRW',
           GC_CURRENCY_USD TYPE SFLIGHT-CURRENCY VALUE 'USD',
           GC_CURRENCY_EUR TYPE SFLIGHT-CURRENCY VALUE 'EUR',
           GC_CURRENCY_JPY TYPE SFLIGHT-CURRENCY VALUE 'JPY'.


INITIALIZATION.

START-OF-SELECTION.

" 4개의 변수에 모두 숫자 1000을 기록
GV_PRICE_KRW = GV_PRICE_USD = GV_PRICE_EUR = GV_PRICE_JPY = 1000.

ULINE.
WRITE: / '통화코드 적용없이 그냥 숫자 출력',
       / 'KRW  = ', GV_PRICE_KRW,
       / 'USD  = ', GV_PRICE_USD,
       / 'EUR  = ', GV_PRICE_EUR,
       / 'JPY  = ', GV_PRICE_JPY.
ULINE.
SKIP.

ULINE.
WRITE : / '통화코드 적용된 금액 출력',
        / 'KRW = ', GV_PRICE_KRW CURRENCY GC_CURRENCY_KRW,
        / 'USD = ', GV_PRICE_KRW CURRENCY GC_CURRENCY_USD,
        / 'EUR = ', GV_PRICE_KRW CURRENCY GC_CURRENCY_EUR,
        / 'JPY = ', GV_PRICE_KRW CURRENCY GC_CURRENCY_JPY.
