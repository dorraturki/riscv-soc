# prog1.s : Sum of two tables of 16 signed integers ( 1 byte each)
    .data
tab1:   .byte   1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
tab2:   .byte   -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16
tab3:   .byte   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

   .text
    .globl _start
_start:
    la   t0, tab1      # t0 = address of table 1
    la   t1, tab2      # t1 = address of table 2
    la   t2, tab3      # t2 = address of result

    li   t3, 16        # t3 = counter
loop:
    lb   t4, 0(t0)     # t4 <- table1[i] (signed 8 bits)
    lb   t5, 0(t1)     # t5 <- table2[i] (signed 8 bits)
    add  t6, t4, t5    # t6 = t4 + t5

    sb   t6, 0(t2)     # result in tab3[i]

    addi t0, t0, 1     # t0++
    addi t1, t1, 1     # t1++
    addi t2, t2, 1     # t2++
    addi t3, t3, -1    # Decrease the counter
    bnez t3, loop      # if counter != 0, loop

    nop