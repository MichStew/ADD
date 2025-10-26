.text
main:
    csrrw x1, 0xf00, x0


    lui x9, 0x40
    addi x9, x9, -1
    and x1, x1, x9


    lui x2, 0x1999a
    addi x2, x2, -0x666

    addi x3, x0, 10
    addi x4, x0, 0

    #digit 0
    mulhu x5, x1, x2
    mul x6, x5, x3
    sub x7, x1, x6
    or x4, x4, x7

    #digit 1
    mv x1, x5
    mulhu x5, x1, x2
    mul x6, x5, x3
    sub x7, x1, x6
    slli x7, x7, 4
    or x4, x4, x7

    #digit 2
    mv x1, x5
    mulhu x5, x1, x2
    mul x6, x5, x3
    sub x7, x1, x6
    slli x7, x7, 8
    or x4, x4, x7

    #digit 3
    mv x1, x5
    mulhu x5, x1, x2
    mul x6, x5, x3
    sub x7, x1, x6
    slli x7, x7, 12
    or x4, x4, x7

    #digit 4
    mv x1, x5
    mulhu x5, x1, x2
    mul x6, x5, x3
    sub x7, x1, x6
    slli x7, x7, 16
    or x4, x4, x7

    #digit 5
    mv x1, x5
    mulhu x5, x1, x2
    mul x6, x5, x3
    sub x7, x1, x6
    slli x7, x7, 20
    or x4, x4, x7

    csrrw x0, 0xf02, x4

    addi x0, x0, 0
    addi x0, x0, 0


