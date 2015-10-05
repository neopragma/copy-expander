000001 IDENTIFICATION DIVISION.                                         AAAAAAAA
000002* This is a comment                                               AAAAAAAA
000003 PROGRAM-NAME. NOCOPY.                                            AAAAAAAA
000004 ENVIRONMENT DIVISION.                                            AAAAAAAA
000005 DATA DIVISION.                                                   AAAAAAAA
000006 WORKING-STORAGE SECTION.                                         AAAAAAAA
000007 01  WS-FOO.                                                      AAAAAAAA
000008     05  WS-BAR            PIC X(05).                             AAAAAAAA
000009     05  WS-BAZ            PIC X(10).                             AAAAAAAA
000010 01  WS-BLAH.                                                     AAAAAAAA
000011     05  WS-BLAH-BLAH      PIC X.                                 AAAAAAAA
000012     05  WS-BLAH-BLAH-BLAH PIC X.                                 AAAAAAAA
000013 PROCEDURE DIVISION.                                              AAAAAAAA
000014     DISPLAY 'This program contains no COPY statements.'          AAAAAAAA
000015     GOBACK                                                       AAAAAAAA
000016     .                                                            AAAAAAAA
