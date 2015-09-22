000010 IDENTIFICATION DIVISION.                                         AAAAAAAA
000020 PROGRAM-NAME. COPY3LVL.                                          AAAAAAAA
000030 ENVIRONMENT DIVISION.                                            AAAAAAAA
000040 DATA DIVISION.                                                   AAAAAAAA
000050 WORKING-STORAGE SECTION.                                         AAAAAAAA
000060 01  WS-FOO.                                                      AAAAAAAA
000070     05  WS-BAR            PIC X(05).                             AAAAAAAA
000080     05  WS-BAZ            PIC X(10).                             AAAAAAAA
000090     COPY COPY3 REPLACING ==:PREFIX:== BY ==THREE-DEEP==.         AAAAAAAA
000100 01  WS-BLAH.                                                     AAAAAAAA
000110     05  WS-BLAH-BLAH      PIC X.                                 AAAAAAAA
000120     05  WS-BLAH-BLAH-BLAH PIC X.                                 AAAAAAAA
000130 PROCEDURE DIVISION.                                              AAAAAAAA
000140     DISPLAY 'This program contains COPY statements '             AAAAAAAA
000150             '3 LEVELS DEEP.'                                     AAAAAAAA
000160     GOBACK                                                       AAAAAAAA
000170    .                                                             AAAAAAAA