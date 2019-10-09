.text
.global main
main:
  LDR   R3, =array       ; load base address of array into R3
  BL    SORT             ; start sorting algorithm on array
  LDR   R3, =array1      ; load base address of array into R3
  BL    SORT             ; start sorting algorithm on array1
  LDR   R3, =array2      ; load base address of array into R3
  BL    SORT             ; starting sorting algorithm on array2
  B     END
SORT:
  MOV   R0, #0           ; i = 0
  MOV   R1, #12          ; n = 12

L1:
  CMP   R0, R1           ; i >= n?
  BGE   E1               ; if so, branch to end of loop
  MOV   R2, #0           ; j = 0
        SUB   R6, R1, R2 ; load max increment of (n-i)-1
  SUB   R6, R6, #1
L2:
  CMP   R2, R6           ; j >= n-i - 1?
  BGE   E2               ; if so, branch to end of loop
  ADD   R7, R2, #1       ; r7 = j + 1
  LDRSB R4, [R3, R2]     ; r4 = array[j]
  LDRSB R5, [R3, R7]     ; r4 = array[j + 1]
  CMP   R4, R5           ; check if array[j] > array[j+1]
  BLT   SWAPDONE
  STRB  R5, [R3, R2]     ; if so, swap the two
  STRB  R4, [R3, R7]
SWAPDONE:
  ADD   R2, R2, #1
  B     L2               ; restart inner loop
E2:
  ADD   R0, R0, #1       ; i = i + 1
  B     L1               ; restart outer loop
E1:
done: NOP                ; dummy instruction for breakpoint
  BX LR
END:
.data
array:
  .byte 0x42 ; 23
  .byte 0x52 ; 112
  .byte 0x32 ; 120
  .byte 0x62 ; 64
  .byte 0x22 ; 48
  .byte 0x72 ; 84
  .byte 0x12 ; 102
  .byte 0x82 ; 113
  .byte 0x02 ; 119
  .byte 0x92 ; 81
  .byte 0xF2 ; 54
  .byte 0x42 ;

; sorted: [0x17, 0x30, 0x36, 0x36, 0x40, 0x51, 0x54, 0x66, 0x70, 0x71, 0x77, 0x78]

array1:
  .byte 0xF8 ; -8
  .byte 0x86 ; -122
  .byte 0xFF ; -1
  .byte 0xD1 ; -47
  .byte 0x94 ; -108
  .byte 0xF6 ; -10
  .byte 0x89 ; -119
  .byte 0xDA ; -38
  .byte 0xA4 ; -92
  .byte 0xEC ; -20
  .byte 0xCF ; -49
  .byte 0xAD ; -83

; sorted: [0x86, 0x89, 0x94, 0xA4, 0xAD, 0xCF, 0xD1, 0xDA, 0xEC, 0xF6, 0xF8, 0xFF]

array2:
  .byte 0xD7 ; -41
  .byte 0x12 ; 18
  .byte 0x4A ; 74
  .byte 0xC4 ; -60
  .byte 0x80 ; -128
  .byte 0x95 ; -107
  .byte 0xF3 ; -13
  .byte 0xD0 ; -48
  .byte 0x31 ; 49
  .byte 0x2D ; 45
  .byte 0x1C ; 28
  .byte 0x0E ; 14

; sorted: [0x80, 0x95, 0xC4, 0xD0, 0xD7, 0xF3, 0x0E, 0x12, 0x1C, 0x2D, 0x31, 0x4A]

.end
