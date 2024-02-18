*&---------------------------------------------------------------------*
*& Report YE03_EX020
*&---------------------------------------------------------------------*
*& Dictionary Structure 연습
*&---------------------------------------------------------------------*
REPORT YE03_EX020.

DATA SCARR TYPE SCARR.
DATA SPFLI TYPE SPFLI.

TABLES SFLIGHT.

SCARR-CARRID = 'AA'.
SCARR-CARRNAME = '미국 항공사'.

WRITE: / SCARR-CARRID,
         SCARR-CARRNAME.


SFLIGHT-CARRID = 'A'.
SFLIGHT-CONNID = '0017'.
SFLIGHT-FLDATE = '20240101'.
SFLIGHT-SEATSMAX = 200.
SFLIGHT-SEATSOCC = 150.

WRITE :/ SFLIGHT-CARRID,
         SFLIGHT-CONNID,
         SFLIGHT-FLDATE,
         SFLIGHT-SEATSMAX,
         SFLIGHT-SEATSOCC.
