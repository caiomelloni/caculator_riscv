.section .data
input:
	.word 0x75706e69
	.word 0x310a3a74
	.word 0x6365642e
	.word 0x682e320a
	.word 0x330a7865
	.word 0x6e69622e


output:
	.word 0x0000756f
	.word 0x74757074
	.word 0x2e310a3a
	.word 0x0a636564
	.word 0x65682e32
	.word 0x2e330a78
	.word 0x0a6e6962

.section .text
printHex:
    # copia o numero para s2
    add s2, zero, s1
    # aux
    addi s3, zero, 0

    # primeiro digito
    addi s8, zero, 0
    # segundo digito
    addi s9, zero, 0

    addi sp, sp, -4
    sw s2, 0(sp)
    srli s2, s2, 8

    addi sp, sp, -4
    sw s2, 0(sp)
    srli s2, s2, 8

    addi sp, sp, -4
    sw s2, 0(sp)
    srli s2, s2, 8

    addi sp, sp, -4
    sw s2, 0(sp)
    

    # i
    addi t3, zero, 4
    addi t2, zero, 0
    addi s11, zero, 57
    for4:
        beq t2, t3, endPrintHex

        # segundo digito
        andi s9, s2, 15
        addi s9, s9, 48
        ble s9, s11, proximoDigito
            # transforma em letra
            addi s9, s9, 7

        proximoDigito:
        
        # pega o prox hex
        srli s2, s2, 4
        
        # primeiro digito
        andi s8, s2, 15
        addi s8, s8, 48
        ble s8, s11, proximoHex
            # transforma em letra
            addi s9, s9, 7
       
        proximoHex:
        # print char
        addi t0, zero, 2
        
        add a0, zero, s8
        ecall

        add a0, zero, s9
        ecall

        # passa para o prox byte na pilha
        addi sp, sp, 4
        lw s2, 0(sp)
        # i++
        addi t2, t2, 1
        j for4



    endPrintHex:
        ret


    

    



printBin:
    # copia o numero para s2
    add s2, zero, s1

    # i
    addi t3, zero, 32
    addi t2, zero, 0

    addi a0, zero, 0
    addi s11, zero, 48
    forBin:
        beq t2, t3, endPrintBin
        andi a0, s2, 2147483648 
        slli s2, s2, 1
        addi a0, a0, 48
        # se a0 for igual a zero
        beq a0, s11, printChar

        addi a0, zero, 49

        printChar:
            # printa o char
            addi t0, zero, 2
            ecall
        # i++
        addi t2, t2, 1
        j forBin
    endPrintBin:
        ret


string2bin:
    
    # char 0 
    addi s10, zero, 48

    # desempilha o endereco do heap em a1
    lw a1, 0(sp)
    addi sp, sp, 4
    
    # resultado
    addi s1, zero, 0

    # i
    addi t3, zero, 31
    addi t2, zero, 0
    loop32:
        # calculo do expoente na base 2
        sub t4, t3, t2

        # se expoente for 0 e o ultim elemento
        bne t4, zero, notLast
        addi s1, s1, 1

        
        notLast:
        beq t2, t3, end
        lbu a2, 0(a1)

        
        # se for zero vai para o prox
        beq a2, s10, proximo
        
        # se expoente for 0 adiciona 1 no res
        beq t4, zero, add0
        
        # j
        addi t5, zero, 1

        # resultado parcial
        addi s2, zero, 2
        for2:
            beq t5, t4, add 
            # multiplicacao
            add s2, s2, s2

            # j++
            addi t5, t5, 1
            j for2
        


        
        add:
        # atualiza o resultado
        add s1, s1, s2
        
        proximo:
        # prox 8 bits do heap
        addi a1, a1, 1
        # i++
        addi t2, t2, 1
        j loop32
    end:
        ret

lerString:


    # cria um heap
    addi t0, zero, 7
    addi a0, zero, 32
    ecall

    # empilha o endereco do heap
    addi sp, sp, -4
    sw a0, 0(sp)

    # le a string e guarda no heap
    addi t0, zero, 6
    addi a1, zero, 32
    ecall

    ret

input:
    addi sp, sp, -4
    sw ra, 0(sp)

    # input da opcao
    addi t0, zero, 4
    ecall

    # opcao 3
    addi t1, zero, 3
    beq a0, t1, inputBin
    # input nao binario

    # le o numero
    ecall
    # coloca o numero em s1
    add s1, zero, a0
    j endInput
    inputBin:
    # input binario

    call lerString
    call string2bin

    # destroi o heap
    addi t0, zero, 7
    addi a0, zero, -32
    ecall

    endInput:
    lw ra, 0(sp)
    addi sp, sp, 4

    # empilha o numero
    addi sp, sp, -4
    sw s1, 0(sp)
    ret

output:
    # desempilha o numero
    lw s1, 0(sp)
    addi sp, sp, 4

    addi sp, sp, -4
    sw ra, 0(sp)

    # input da opcao
    addi t0, zero, 4
    ecall

    addi t1, zero, 3
    beq a0, t1, outputBin
    
    addi t1, zero, 2
    beq a0, t1, outputHex
    # output decimal

    add a0, zero, s1

    # printa o numero
    addi t0, zero, 1
    ecall

    j endOutput
    outputBin:
    call printBin
    j endOutput
    outputHex:
    call printHex
    endOutput:
        lw ra, 0(sp)
        addi sp, sp, 4
        ret

main:
    addi sp, sp, -4
    sw ra, 0(sp)

    # print texto para input
    lui a0, %hi(input)
    addi a0, a0, %lo(input)
    addi t0, zero, 3
    addi a1, zero, 24
    ecall

    # da \n
    addi t0, zero, 2
    addi a0, zero, 13 
    ecall

    call input  
    

    # print texto para output
    lui a0, %hi(output)
    addi a0, a0, %lo(output)
    addi t0, zero, 3
    addi a1, zero, 28
    ecall

    call output

  
    lw ra, 0(sp)
    addi sp, sp, 4
    ret