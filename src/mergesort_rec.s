.text
.global main
main:
  MOV    R1, #12        // n = 12
  LDR    R0, =array     // load base address of array into R0
  BL     SORT           // start sorting algorithm on array
  LDR    R0, =array1    // load base address of array into R0
  BL     SORT           // start sorting algorithm on array1
  LDR    R0, =array2    // load base address of array into R0
  BL     SORT           // starting sorting algorithm on array2
  B      END
SORT:                   // R0 = l, R1 = n
  CMP    R1, #1         // n =< 1?
  BXLE   LR             // if so, return
  PUSH   {LR}           // save preserved registers
  LSR    R2, R1, #1     // R2 = n/2
  PUSH   {R0, R1, R2}   // save nonpreserved registers
  MOV    R1, R2         // R1 = n/2
  BL     SORT
  POP    {R0, R1, R2}   // restore nonpreserved registers
  ADD    R0, R0, R2     // R0 = l + n/2
  SUB    R1, R1, R2     // R1 = n - n/2
  PUSH   {R0, R1, R2}   // save nonpreserved registers
  BL     SORT
  POP    {R0, R1, R2}   // restore nonpreserved registers
  SUB    R1, R0, #1     // R1 = m = l + n/2 - 1
  SUB    R0, R0, R2     // R0 = l = l + n/2 - n/2
  ADD    R2, R2, R1     // R2 = r = l + n - 1
  BL     MERGE          // call merge function
  POP    {LR}           // restore preserved registers
  BX     LR             // return
MERGE:                  // merge function: R0 = l, R1 = m, R2 = r
  SUB    R6, R2, R0     // R6 = r - l
  ADD    R6, R6, #1     // R6 = r - l + 1 = n
  SUB    SP, SP, R6     // make space on stack for r - l + 1 characters
  MOV    R7, R0         // i = l
  ADD    R8, R1, #1     // j = m + 1
  MOV    R9, #0         // k = 0
MERGELOOP:              // loop portion of merge function
  CMP    R7, R1         // i > m ?
  BGT    RLOOP          // if so, branch to loop for unloading right data
  CMP    R8, R2         // j > r ?
  BGT    LLOOP          // if so, branch to loop for unloading left data
  LDRSB  R10, [R7]      // R10 = mem[i]
  LDRSB  R11, [R8]      // R11 = mem[j]
  CMP    R10, R11       // R10 >= R11 ?
  MOVGE  R10, R11       // if so, use value in R11
  STRB   R10, [SP, R9]  // starray[k] = R10
  ADDLT  R7, #1         // if using left array element, i++
  ADDGE  R8, #1         // if using right array element, j++
  ADD    R9, #1         // k++
  B      MERGELOOP
RLOOP:                  // loop for unloading right array when left is finished
  CMP    R8, R2         // j > r ?
  BGT    MOVESTACK      // if so, branch to array replacement function
  LDRSB  R11, [R8]      // R11 = mem[j]
  STRB   R11, [SP, R9]  // starray[k] = R11
  ADD    R8, #1         // j++
  ADD    R9, #1         // k++
  B      RLOOP
LLOOP:                  // loop for unloading left array when right is finished
  CMP    R7, R1         // i > m ?
  BGT    MOVESTACK      // if so, branch to array replacement function
  LDRSB  R10, [R7]      // R10 = mem[i]
  STRB   R10, [SP, R9]  // starray[k] = R10
  ADD    R7, #1         // i++
  ADD    R9, #1         // k++
  B      LLOOP
MOVESTACK:              // move elements back into array
  CMP    R9, #0         // k == 0 ?
  ADDEQ  SP, SP, R6     // if so, deallocate stack space
  BXEQ   LR             // and return to sorting
  SUB    R9, #1         // otherwise, k--
  ADD    R11, R0, R9    // x = k + l
  LDRSB  R10, [SP, R9]  // R10 = starray[k]
  STRB   R10, [R11]     // mem[x] = R10
  B      MOVESTACK
END:
  NOP                   // dummy instruction for breakpoint
.data
array:
  .byte 0x42 // 23
  .byte 0x52 // 112
  .byte 0x32 // 120
  .byte 0x62 // 64
  .byte 0x22 // 48
  .byte 0x72 // 84
  .byte 0x12 // 102
  .byte 0x82 // 113
  .byte 0x02 // 119
  .byte 0x92 // 81
  .byte 0xF2 // 54
  .byte 0x42 //

// sorted: [0x17, 0x30, 0x36, 0x36, 0x40, 0x51, 0x54, 0x66, 0x70, 0x71, 0x77, 0x78]

array1:
  .byte 0xF8 // -8
  .byte 0x86 // -122
  .byte 0xFF // -1
  .byte 0xD1 // -47
  .byte 0x94 // -108
  .byte 0xF6 // -10
  .byte 0x89 // -119
  .byte 0xDA // -38
  .byte 0xA4 // -92
  .byte 0xEC // -20
  .byte 0xCF // -49
  .byte 0xAD // -83

// sorted: [0x86, 0x89, 0x94, 0xA4, 0xAD, 0xCF, 0xD1, 0xDA, 0xEC, 0xF6, 0xF8, 0xFF]

array2:
  .byte 0xD7 // -41
  .byte 0x12 // 18
  .byte 0x4A // 74
  .byte 0xC4 // -60
  .byte 0x80 // -128
  .byte 0x95 // -107
  .byte 0xF3 // -13
  .byte 0xD0 // -48
  .byte 0x31 // 49
  .byte 0x2D // 45
  .byte 0x1C // 28
  .byte 0x0E // 14

// sorted: [0x80, 0x95, 0xC4, 0xD0, 0xD7, 0xF3, 0x0E, 0x12, 0x1C, 0x2D, 0x31, 0x4A]

.end
