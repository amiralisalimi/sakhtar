PRG1    START   0
        STM     14,12,12(13)
        BALR    12,0
        USING   *,12

DERIV   L       1,NUM
        LA      4,COEFF
        LA      5,RES
MULT    LR      2,1
        M       2,(4)
        ST      (5),2
        A       4,4
        A       5,4
        BCT     1,MULT

        LM      14,12,12(13)
        BR      14
        END     PRG1

COEFF   DS      5,2,8,1,9
RES     DS      100X
NUM     DS      4