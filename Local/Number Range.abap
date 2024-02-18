*&---------------------------------------------------------------------*
*& Report YE03_EX026
*&---------------------------------------------------------------------*
*& Number Range 연습
*&---------------------------------------------------------------------*
REPORT YE03_EX026.

" TEXT-L01 : 번호표 발급
SELECTION-SCREEN PUSHBUTTON /1(10) TEXT-L01 USER-COMMAND BT_FC1.
" 한 줄 건너띄기
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN COMMENT /1(50) STAT_TXT.

DATA GV_NUMBER TYPE CHAR3.

INITIALIZATION.
STAT_TXT = '번호표 발급 전입니다.'.

AT SELECTION-SCREEN.
CASE SY-UCOMM.
  WHEN 'BT_FC1'.
    PERFORM NUMVER_GET_NEXT CHANGING GV_NUMBER.
    STAT_TXT = '발급된 번호는' && GV_NUMBER && '입니다'.
ENDCASE.


*&---------------------------------------------------------------------*
*& Form NUMVER_GET_NEXT
*&---------------------------------------------------------------------*
FORM NUMVER_GET_NEXT  CHANGING CV_NUMBER.

  DATA LV_RC TYPE INRI-RETURNCODE.

 CALL FUNCTION 'NUMBER_GET_NEXT'
   EXPORTING
     NR_RANGE_NR             = '01'            " Number range number
     OBJECT                  = 'YCAFENOE00'    " Name of number range object
   IMPORTING
     NUMBER                  =  CV_NUMBER       " free number
     RETURNCODE              =  LV_RC           " Return code
   EXCEPTIONS
     INTERVAL_NOT_FOUND      = 1                " Interval not found
     NUMBER_RANGE_NOT_INTERN = 2                " Number range is not internal
     OBJECT_NOT_FOUND        = 3                " Object not defined in TNRO
     QUANTITY_IS_0           = 4                " Number of numbers requested must be > 0
     QUANTITY_IS_NOT_1       = 5                " Number of numbers requested must be 1
     INTERVAL_OVERFLOW       = 6                " Interval used up. Change not possible.
     BUFFER_OVERFLOW         = 7                " Buffer is full
     OTHERS                  = 8.

   IF SY-SUBRC EQ 0 AND LV_RC IS INITIAL.
     MESSAGE 'Number Range의 Next Number 가져오기 성공' TYPE 'S'.
    ELSE.
      MESSAGE 'Number Range의 Next Number 가져오기 실패' TYPE 'I'
      DISPLAY LIKE 'E'.

   ENDIF.

ENDFORM.
