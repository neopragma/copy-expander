000010 IDENTIFICATION DIVISION.                                         AAAAAAAA
000020 PROGRAM-NAME. COPY1LVLA.                                         AAAAAAAA
000030 ENVIRONMENT DIVISION.                                            AAAAAAAA
000040 DATA DIVISION.                                                   AAAAAAAA
000050 WORKING-STORAGE SECTION.                                         AAAAAAAA
000060 01  WS-FOO.                                                      AAAAAAAA
000070     05  WS-BAR            PIC X(05).                             AAAAAAAA
000080     05  WS-BAZ            PIC X(10).                             AAAAAAAA
000010* Copybook with no nested COPY statements                         AAAAAAAA
000020 01  WS1-COPY1-GROUP.                                             AAAAAAAA
000030     05  WS1-COPY1-ITEM1 PIC X.                                   AAAAAAAA
000040     05  WS1-COPY1-ITEM2 PIC X.                                   AAAAAAAA
000010* Copybook with no nested COPY statements                         AAAAAAAA
000020 01  WS2-COPY1A-GROUP.                                            AAAAAAAA
000030     05  WS2-COPY1A-ITEM1 PIC X.                                  AAAAAAAA
000040     05  WS2-COPY1A-ITEM2 PIC X.                                  AAAAAAAA
000110 01  WS-BLAH.                                                     AAAAAAAA
000120     05  WS-BLAH-BLAH      PIC X.                                 AAAAAAAA
000130     05  WS-BLAH-BLAH-BLAH PIC X.                                 AAAAAAAA
000140 PROCEDURE DIVISION.                                              AAAAAAAA
000150     DISPLAY 'This program contains 2 COPY statements '           AAAAAAAA
000160             '1 LEVEL DEEP.'                                      AAAAAAAA
000170     GOBACK                                                       AAAAAAAA
000180    .                                                             AAAAAAAA