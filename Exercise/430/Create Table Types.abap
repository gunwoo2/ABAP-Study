*&---------------------------------------------------------------------*
*& Report ZBC430_E03_ITAB_SORTED
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC430_E03_ITAB_SORTED.

DATA WA_SFLIGHT TYPE SFLIGHT.

"스트럭처를 통해서 Internal Table 선언하는 방법
DATA GT_SFLIGHT_STANDARD TYPE TABLE OF SFLIGHT.
DATA GT_SFLIGHT_STANDARD2 LIKE TABLE OF WA_SFLIGHT.

" Table Type을 통해서 Internal Table 선언하는 방법
" ZIT_SFLIGHT_E00 : Sorted Internal Table이고,
*                    데이터가 변경될 때마다
*                    항상 FLDATE 기준으로 정렬되도록 설정되어 있음
DATA GT_SFLIGHT_SORTED TYPE ZIT_SFLIGHT_E03.


SELECT *
  FROM SFLIGHT
  INTO TABLE GT_SFLIGHT_STANDARD
  WHERE CARRID EQ 'JL'.

WRITE : / '스탠다드 인터널 테이블의 출력'.
LOOP AT GT_SFLIGHT_STANDARD INTO WA_SFLIGHT.
  WRITE: / WA_SFLIGHT-CARRID,
           WA_SFLIGHT-CONNID,
           WA_SFLIGHT-FLDATE.
ENDLOOP.
ULINE.

" GT_SFLIGHT_SORTED은 SELECT 문에 의해서 DATABASE TABLE인 SFLIGHT
" 로부터 데이터를 기록할 때 FLDATE 필드 기준으로 정렬되어 기록된다.
" 왜?? GT_SFLIGHT_SORTED은 SORTED INTERNAL TABLE 이라서 항상
" 특정 필드 기준으로 정렬 되어 있어야 하는데,
" 그 필드 기준으로 SE11에서 TABLE TYPE 만들 때, FLDATE로 지정했기 때문에
" 그러하다.
SELECT *
  FROM SFLIGHT
  INTO TABLE GT_SFLIGHT_SORTED
  WHERE CARRID EQ 'JL'.

WRITE : / 'SORTED INTERNAL TABLE의 출력'.
ULINE.

" GT_SFLIGHT_SORTED의 첫번째 줄은 FLDATE 필드의 값이 가장 작은
" 라인이 무조건 첫번째 줄에 위치하고, FLDATE 필드의 값이 가장 큰
" 라인이 무조건 마지막 줄에 위치한다.
" 그래서 출력도 동일한 기준으로 출력이 된다.
LOOP AT GT_SFLIGHT_SORTED INTO WA_SFLIGHT.
  WRITE: / WA_SFLIGHT-CARRID,
           WA_SFLIGHT-CONNID,
           WA_SFLIGHT-FLDATE.
ENDLOOP.
ULINE.


* GT_SFLIGHT_STANDARD의 첫번째 줄부터, 마지막 줄까지 한줄씩
* WRITE 문을 통해서 CARRID 필드와, CONNID 필드와 FLDATE 필드를
* 화면에 한줄씩 출력한다
*  SELECT *
*  FROM SFLIGHT
*  INTO TABLE GT_SFLIGHT_SORTEDWA_SFLIGHT
*  WHERE CARRID EQ 'JL'.
*
*  WRITE: / WA_SFLIGHT-CARRID,
*           WA_SFLIGHT-CONNID,
*           WA_SFLIGHT-FLDATE.
*
*  ENDSELECT.
