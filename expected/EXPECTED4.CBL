000010 IDENTIFICATION DIVISION.                                         AAAAAAAA
000020 PROGRAM-NAME. COPY3LVL.                                          AAAAAAAA
000030 ENVIRONMENT DIVISION.                                            AAAAAAAA
000040 DATA DIVISION.                                                   AAAAAAAA
000050 WORKING-STORAGE SECTION.                                         AAAAAAAA
000060 01  WS-FOO.                                                      AAAAAAAA
000070     05  WS-BAR            PIC X(05).                             AAAAAAAA
000080     05  WS-BAZ            PIC X(10).                             AAAAAAAA
000010* Copybook with nested COPY statements (3 deep)                   AAAAAAAA
000020 01  THREE-DEEP-COPY3-GROUP.                                      AAAAAAAA
000030     05  THREE-DEEP-COPY3-ITEM1 PIC X.                            AAAAAAAA
000040     05  THREE-DEEP-COPY3-ITEM2 PIC X.                            AAAAAAAA
000010* Copybook with nested COPY statement                             AAAAAAAA
000020 01  TWO-DEEP-COPY2-GROUP.                                        AAAAAAAA
000030     05  TWO-DEEP-COPY2-ITEM1 PIC X.                              AAAAAAAA
000040     05  TWO-DEEP-COPY2-ITEM2 PIC X.                              AAAAAAAA
000010* Copybook with no nested COPY statements                         AAAAAAAA
000020 01  TWO-DEEP-COPY1-GROUP.                                        AAAAAAAA
000030     05  TWO-DEEP-COPY1-ITEM1 PIC X.                              AAAAAAAA
000040     05  TWO-DEEP-COPY1-ITEM2 PIC X.                              AAAAAAAA
000060 01  TWO-DEEP-COPY2-GROUP2.                                       AAAAAAAA
000070     05  TWO-DEEP-COPY2-ITEM1 PIC X.                              AAAAAAAA
000080     05  TWO-DEEP-COPY2-ITEM2 PIC X.                              AAAAAAAA
000060 01  THREE-DEEP-COPY3-GROUP2.                                     AAAAAAAA
000070     05  THREE-DEEP-COPY3-ITEM1 PIC X.                            AAAAAAAA
000080     05  THREE-DEEP-COPY3-ITEM2 PIC X.                            AAAAAAAA
000010* Copybook with no nested COPY statements                         AAAAAAAA
000020 01  ANOTHER-COPY1-GROUP.                                         AAAAAAAA
000030     05  ANOTHER-COPY1-ITEM1 PIC X.                               AAAAAAAA
000040     05  ANOTHER-COPY1-ITEM2 PIC X.                               AAAAAAAA
000060 01  THREE-DEEP-COPY3-GROUP3.                                     AAAAAAAA
000070     05  THREE-DEEP-COPY3-ITEM3 PIC X.                            AAAAAAAA
000080     05  THREE-DEEP-COPY3-ITEM4 PIC X.                            AAAAAAAA
000100 01  WS-BLAH.                                                     AAAAAAAA
000110     05  WS-BLAH-BLAH      PIC X.                                 AAAAAAAA
000120     05  WS-BLAH-BLAH-BLAH PIC X.                                 AAAAAAAA
000130 PROCEDURE DIVISION.                                              AAAAAAAA
000140     DISPLAY 'This program contains COPY statements '             AAAAAAAA
000150             '3 LEVELS DEEP.'                                     AAAAAAAA
000160     GOBACK                                                       AAAAAAAA
000170     .                                                            AAAAAAAA
