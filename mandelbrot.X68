FP_mul  EQU $1088           ; Define the memory location of the fixed-point multiplication subroutine

    ORG     $1000           ; Set the origin (starting address) for the program at memory location $1000
START
    INCBIN 'N4.BIN'         ; Include binary data from external file 'N4.BIN'

Iterate:
    LINK A6,#-12            ; Create a stack frame by reserving 12 bytes of local storage
    MOVEM.L D1/A1/D0,-(A7)  ; Save registers D1, A1, and D0 on the stack
    CLR.L -4(A6)            ; Clear local variable at offset -4 (likely real part of Z)
    CLR.L -8(A6)            ; Clear local variable at offset -8 (likely imaginary part of Z)

Loop:
    MOVE.L -4(A6),-(A7)     ; Push the real part of Z onto the stack
    MOVE.L -4(A6),-(A7)     ; Push the real part of Z again for multiplication

    CMP.L #100,D0           ; Compare the current iteration count (D0) to the maximum (100)
    BGE ExitLoop            ; If the iteration count exceeds or equals 100, exit the loop

    JSR FP_mul              ; Call fixed-point multiplication subroutine (Z_real * Z_real)
    ADDQ.L #8,A7            ; Adjust the stack pointer after the multiplication
    MOVE.L D0,-12(A6)       ; Store the result of the multiplication (Z_real^2) at offset -12

    MOVE.L -8(A6),-(A7)     ; Push the imaginary part of Z onto the stack
    MOVE.L -8(A6),-(A7)     ; Push the imaginary part of Z again for multiplication

    JSR FP_mul              ; Call fixed-point multiplication subroutine (Z_imag * Z_imag)
    ADDQ.L #8,A7            ; Adjust the stack pointer after the multiplication
    MOVE.L D0,-16(A6)       ; Store the result of the multiplication (Z_imag^2) at offset -16

    MOVE.L -12(A6),D0       ; Load Z_real^2 into D0
    ADD.L -16(A6),D0        ; Add Z_imag^2 to Z_real^2
    CMP.L #$400000,D0       ; Compare the sum (magnitude squared of Z) to the divergence threshold
    BGE ExitLoop            ; If the threshold is exceeded, exit the loop

    MOVE.L -12(A6),D0       ; Load Z_real^2 into D0
    SUB.L -16(A6),D0        ; Subtract Z_imag^2 from Z_real^2
    ADD.L D1,D0             ; Add the real part of the constant C to the result
    MOVE.L D0,-4(A6)        ; Store the updated real part of Z at offset -4

    MOVE.L -4(A6),-(A7)     ; Push the real part of Z onto the stack
    MOVE.L -8(A6),-(A7)     ; Push the imaginary part of Z onto the stack

    JSR FP_mul              ; Call fixed-point multiplication subroutine
    ADDQ.L #8,A7            ; Adjust the stack pointer after the multiplication
    LSL.L #1,D0             ; Left shift D0 by 1 (equivalent to multiplying by 2)
    ADDQ.L #1,D0            ; Increment D0 by 1
    ADD.L A1,D0             ; Add the imaginary part of the constant C to the result
    MOVE.L D0,-8(A6)        ; Store the updated imaginary part of Z at offset -8

    MOVE.L 0(A6),D0         ; Load the current iteration count into D0
    ADDQ.L #1,D0            ; Increment the iteration count
    MOVE.L D0,0(A6)         ; Store the updated iteration count
    BRA Loop                ; Repeat the loop

ExitLoop:
    MOVEM.L (A7)+,D1/A1     ; Restore registers D1 and A1 from the stack
    UNLK A6                 ; Restore the previous stack frame
    RTS                     ; Return from subroutine

    END START               ; Mark the end of the program, starting execution at the START label

