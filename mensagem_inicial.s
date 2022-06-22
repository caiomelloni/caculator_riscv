main:
.section .rodata
    .MENSAGEM:
        .word 0x6f637345
        .word 0x2061686c
        .word 0x20616d75
        .word 0x7265706f
        .word 0x6f616361
        .word 0x20310a3a
        .word 0x6f73202d
        .word 0x320a616d
        .word 0x73202d20
        .word 0x72746275
        .word 0x6f616361
        .word 0x2d20330a
        .word 0x6c756d20
        .word 0x6c706974
        .word 0x63616369
        .word 0x340a6f61
        .word 0x64202d20
        .word 0x73697669
        .word 0x350a6f61
        .word 0x63202d20
        .word 0x65766e6f
        .word 0x6f617372
        .word 0x63656420
        .word 0x6c616d69
        .word 0x3e2d3c20
        .word 0x6e696220
        .word 0x616972e1
        .word 0x2d20360a
        .word 0x6e6f6320
        .word 0x73726576
        .word 0x64206f61
        .word 0x6d696365
        .word 0x3c206c61
        .word 0x68203e2d
        .word 0x64617865
        .word 0x6d696365
        .word 0x370a6c61
        .word 0x63202d20
        .word 0x65766e6f
        .word 0x6f617372
        .word 0x6e696220
        .word 0x616972e1
        .word 0x3e2d3c20
        .word 0x78656820
        .word 0x63656461
        .word 0x6c616d69
        .word 0x0000000a
.text
lui a0, %hi(.MENSAGEM)
addi a0, a0, %lo(.MENSAGEM)
addi t0, zero, 3
addi a1, zero, 185
ecall