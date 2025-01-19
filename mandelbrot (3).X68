*-----------------------------------------------------------
* Title      : mandelbrot
* Your Name  : Tiffany Mares
* Your ID    : 1265498
* Lab Sec    : 108
* Date       : Nov 7, 2024
*-----------------------------------------------------------
FP_mul  EQU $1088

    ORG     $1000
START
    INCBIN 'N4.BIN'

Iterate:
    LINK A6,#-12
    MOVEM.L D1/A1/D0,-(A7)
    CLR.L -4(A6)
    CLR.L -8(A6)

Loop:
    MOVE.L -4(A6),-(A7)
    MOVE.L -4(A6),-(A7)

    CMP.L #100,D0
    BGE ExitLoop
        
    JSR FP_mul
    ADDQ.L #8,A7
    MOVE.L D0,-12(A6)
    MOVE.L -8(A6),-(A7)
    MOVE.L -8(A6),-(A7)
    
    JSR FP_mul
    ADDQ.L #8,A7
    MOVE.L D0,-16(A6)
    MOVE.L -12(A6),D0
    ADD.L -16(A6),D0
    CMP.L #$400000,D0
    BGE ExitLoop
    
    MOVE.L -12(A6),D0
    SUB.L -16(A6),D0
    ADD.L D1,D0
    MOVE.L D0,-4(A6)
    MOVE.L -4(A6),-(A7)
    MOVE.L -8(A6),-(A7)
    
    JSR FP_mul
    ADDQ.L #8,A7
    LSL.L #1,D0
    ADDQ.L #1,D0
    ADD.L A1,D0
    MOVE.L D0,-8(A6)
    MOVE.L 0(A6),D0
    ADDQ.L #1,D0
    MOVE.L D0,0(A6)
    BRA Loop

ExitLoop:
    MOVEM.L (A7)+,D1/A1
    UNLK A6
    RTS

    END START






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
