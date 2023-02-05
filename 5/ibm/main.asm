MAIN    START   0
        STM     14,12,12(13)
        BALR    12,0
        USING   *,12

        XOR     1,1
        L       2,NUM
        LA      3,VAL
OUTER   L       4,NUM
        LA      5,VAL
INNER   L       6,3
        L       7,5
        SR      6,7
        A       5,WORDL
        BNZ     NXT
        A       1,ONE
NXT     BCTR    4,INNER
        A       3,WORDL
        BCTR    2,OUTER        

        LM      14,12,12(13)
        BR      14
        END     MAIN

NUM     DC      12
VAL     DC      1,2,4,5,4,5,5,6,7,7,7,7
ONE     DC      1
WORDL   DC      4