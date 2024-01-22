*&---------------------------------------------------------------------*
*& Include          ZHWE03_REVIEW_3ASCR
*&---------------------------------------------------------------------*

" TEXT-T01 : Execute Mode
SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-T01.
SELECTION-SCREEN BEGIN OF LINE.

PARAMETERS PA_INS RADIOBUTTON GROUP RAG1.
" TEXT-L01: Insert Data
SELECTION-SCREEN COMMENT (15) TEXT-L01 FOR FIELD PA_INS.

PARAMETERS PA_SEL RADIOBUTTON GROUP RAG1.
" TEXT-L02: Select Data
SELECTION-SCREEN COMMENT (15) TEXT-L02 FOR FIELD PA_SEL.

PARAMETERS PA_DEL RADIOBUTTON GROUP RAG1.
" TEXT-L03: Delete All Data
SELECTION-SCREEN COMMENT (15) TEXT-L03 FOR FIELD PA_DEL.

SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK B01.

" TEXT-T02 : Selection Options
SELECTION-SCREEN BEGIN OF BLOCK B02 WITH FRAME TITLE TEXT-T02.
SELECT-OPTIONS:
  SO_CAR FOR ZDETAIL_E03_REV-CARRID,
  SO_CON FOR ZDETAIL_E03_REV-CONNID,
  SO_DAT FOR ZDETAIL_E03_REV-FLDATE,
  SO_ODT FOR ZDETAIL_E03_REV-ORDER_DATE.
SELECTION-SCREEN END OF BLOCK B02.

" TEXT-T03 : Additional Options
SELECTION-SCREEN BEGIN OF BLOCK B03 WITH FRAME TITLE TEXT-T03.
SELECT-OPTIONS:
  SO_CTRF FOR ZDETAIL_E03_REV-COUNTRYFR NO INTERVALS NO-EXTENSION,
  SO_CITF FOR ZDETAIL_E03_REV-CITYFROM  NO INTERVALS NO-EXTENSION,
  SO_CTRT FOR ZDETAIL_E03_REV-COUNTRYTO NO INTERVALS NO-EXTENSION,
  SO_CITT FOR ZDETAIL_E03_REV-CITYTO    NO INTERVALS NO-EXTENSION.
PARAMETERS
  PA_INCL AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK B03.
