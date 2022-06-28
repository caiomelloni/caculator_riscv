.section .data
msgInput:
    .word 0x006d6562
	.word 0x6e697620
	.word 0x650a6f64
	.word 0x6c6f6373
	.word 0x61206168
	.word 0x65706f20
	.word 0x61636172
	.word 0x310a3a6f
	.word 0x6d6f732e
	.word 0x2e320a61
	.word 0x74627573
	.word 0x61636172
	.word 0x2e330a6f
	.word 0x746c756d
	.word 0x696c7069
	.word 0x61636163
	.word 0x2e340a6f
	.word 0x69766964
	.word 0x0a6f6173

msgNum1:
    .word 0x0000006e
	.word 0x72656d75
	.word 0x3a31206f

msgNum2:
    .word 0x0000006e
	.word 0x72656d75
	.word 0x3a32206f

msgrResultado:
    .word 0x00006572
	.word 0x746c7573
	.word 0x3a6f6461

msgOverFlow:
    .word 0x6f727265
	.word 0x20656420
	.word 0x7265766f
	.word 0x776f6c66

msgResto:
    .word 0x00006572
	.word 0x3a6f7473

.section .text
    somar:
        
        num1soma:
            lw a0, 0(sp)
            addi sp, sp, 4
            # numero 1 em s1
            add s1, zero, a0

            # sinal do num1
            andi a1, a0, 2147483648
            beq a1, zero, num2soma
            addi a1, zero, 1


        num2soma:
            lw a0, 0(sp)    
            addi sp, sp, 4
            # numero 2 em s2
            add s2, zero, a0

            # sinal do num2
            andi a2, a0, 2147483648
            beq a2, zero, fazerSoma
            addi a2, zero, 1


        fazerSoma:
            # soma
            add s3, s1, s2

            # sinal da soma
            andi a3, s3, 2147483648
            beq a3, zero, verificarOverFlow
            # numero negativo
            addi a3, zero, 1

            # faz o modulo do numero negativo
                
            xori s3, s3, 4294967295
            addi s3, s3, 1

            # sinal para printar negativo
            addi s6, zero, 1

            

        


        verificarOverFlow:
            # testa se os sinais sao iguais
            # se os sinais forem diferents nunca havera overflow
            bne a1, a2, finalSoma
            # sinais iguais:
            
            # testa se o sinal da soma e diferente so sinal do num 1
            and a4, a3, a1
            beq a4, a1, finalSoma
            # overflow
            lui a0, %hi(msgOverFlow)
            addi a0, a0, %lo(msgOverFlow)
            addi t0, zero, 3
            addi a1, zero, 16
            ecall

        finalSoma:
            addi sp, sp, -4
            sw s3, 0(sp) 
            ret

    subtrair:
        num1sub:
            lw a0, 0(sp)
            addi sp, sp, 4
            # numero 1 em s1
            add s1, zero, a0

            # sinal do num1
            andi a1, a0, 2147483648
            beq a1, zero, num2sub
            addi a1, zero, 1


        num2sub:
            lw a0, 0(sp)    
            addi sp, sp, 4
            # numero 2 em s2
            add s2, zero, a0

            # sinal do num2
            andi a2, a0, 2147483648
            beq a2, zero, fazersubtracao
            addi a2, zero, 1

        fazersubtracao:

            # subtracao
            xori s1, s1, 4294967295
            addi s1, s1, 1
            add s3, s2, s1

            # sinal da subtracao
            andi a3, s3, 2147483648
            beq a3, zero, verificarOverFlow
            # sinal negativo
            addi a3, zero, 1
            
            xori s3, s3, 4294967295
            addi s3, s3, 1


            # sinal para printar negativo
            addi s6, zero, 1
            
            j finalSubtracao
        verificarOverFlow:
            # overflow ocorre quando o sinal da subtracao e igual ao sinal do numero subtraido
            # como foi usado a pilha o numero 1 e o segundo numero inserido
            bne a3, a1, finalSubtracao

            # overflow
            lui a0, %hi(msgOverFlow)
            addi a0, a0, %lo(msgOverFlow)
            addi t0, zero, 3
            addi a1, zero, 16
            ecall

        finalSubtracao:
            addi sp, sp, -4
            sw s3, 0(sp) 
            ret

    multiplicar:
        num1mult:
            lw a0, 0(sp)
            addi sp, sp, 4
            # numero 1 = multiplicador
            add s1, zero, a0    


        num2mult:
            lw a0, 0(sp)    
            addi sp, sp, 4
            # numero 2 = multiplicando
            add s2, zero, a0

        # produto
        addi s3, zero, 0

        # testa se num1 e num2 = 0

        beq s1, zero, finalMultiplicacao
        beq s2, zero, finalMultiplicacao

        pegaBit:
        # pega o LSB do multiplicador
        andi a1, s1, 1
        beq a1, zero, shift

        # produto = produto + multiplicando
        add s3, s3, s2

        # shifts
        shift:
            slli s2, s2, 1
            srli s1, s1, 1

        # teste multiplicador
        testeMultiplicador:
            beq s1, zero, finalMultiplicacao
            j pegaBit   

        
        finalMultiplicacao:
            # pegar sinal do produto
            andi a3, s3, 2147483648
            beq a3, zero, terminarMultiplicacao 
            # sinal negativo
            
            # inverter produto

            xori s3, s3, 4294967295
            addi s3, s3, 1

            # sinal para printar negativo
            addi s6, zero, 1



        terminarMultiplicacao:
            addi sp, sp, -4
            sw s3, 0(sp) 
            ret

    dividir:

        num1Divisao:
            lw a1, 0(sp)
            addi sp, sp, 4
               
        num2Divisao:
            lw a0, 0(sp)    
            addi sp, sp, 4


        # retorno: a0 = resto, a1 = quociente
        # a0 = dividendo
        # a1 = divisor
        # s0 = quociente

        # t4 e t5 guardam os sinais dos divisores e dividendos para comparar se sao iguais
        # s5 = 1 para sinais iguais, 0 para diferentes

        # analise de sinal
        addi t4, zero, 1
        addi t5, zero, 1
        addi s5, zero, 1
        # pega os modulos

        # modulo de a0
        bgt a0, zero, a0_positivo
        addi t4, zero, 0 # a0 com sinal negativo
        lui t0, 0xfffff
        addi t0, t0, 0xfff
        xor a0, a0, t0
        addi a0, a0, 1
        a0_positivo:

        # modulo de a1
        bgt a1, zero, a1_positivo
        addi t5, zero, 0 # a1 com sinal negativo
        lui t0, 0xfffff
        addi t0, t0, 0xfff
        xor a1, a1, t0
        addi a1, a1, 1
        a1_positivo:

        beq t4, t5, sinais_iguais
        addi s5, zero, 0

        sinais_iguais:

        # s1 = guarda o divisor a fim de comparacao
        addi s1, a1, 0

        # 1 = alinhamento de dividendo e divisor

        # deslocamento do divisor para a esquerda ate o MSB ser 1
        alinhamento_1:
        blt a1, zero, fim_deslocamento_1
        slli a1, a1, 1
        j alinhamento_1
        fim_deslocamento_1:

        # torna divisor positivo, apos o alinhamento
        srli a1, a1, 1

        # 2- inicie o quociente com 0
        addi s0, zero, 0

        # 3- se o dividendo for maior ou igual que o divisor:
        passo_3:
        blt a0, a1, else
        # dividendo = dividendo - divisor
        ## pega o negativo do divisor
        lui t0, 0xfffff
        addi t0, t0, 0xfff
        xor t1, a1, t0
        addi t1, t1, 1
        ## 
        add a0, a0, t1
        # desloque o quociente para esquerda 1 vez e some 1 nele
        slli s0, s0, 1
        addi s0, s0, 1
        j passo_4

        # se nao:
        else:
        # desloque o quociente logicamente para esquerda
        slli s0, s0, 1

        # 4 - desloque o divisor 1 vez para a direita
        passo_4:
        srli a1, a1, 1

        # 5 - 
        # se dividendo menor igual divisor, pule para o passo 3
        bge a0, s1, passo_3
        # se o divisor chegou em um valor menor que o inicial, entao pare
        bge a1, s1, passo_3

        # 6 - quociente esta correto, resto = dividendo
        add a1, zero, s0

        # 7 - inversao dos sinais se necessario
        bne s5, zero, nao_inverta_sinais
        # addi t0, zero, 0
        # lui t0, 0xfffff
        # addi t0, t0, 0xfff
        # xor a0, a0, t0
        # addi a0, a0, 1

        # addi t0, zero, 0
        # lui t0, 0xfffff
        # addi t0, t0, 0xfff
        # xor a1, a1, t0
        # addi a1, a1, 1
        # sinal para printar negativo
        

        addi s6, zero, 1

        nao_inverta_sinais:

        # guarda os numeros na pilha
        addi sp, sp, -4
        sw a0, 0(sp)

        addi sp, sp, -4
        sw a1, 0(sp)
        ret
        
    

   
    main:
        addi sp, sp, -4
        sw ra, 0(sp) 
        # sinal para printar negativo
        addi s6, zero, 0
        lui a0, %hi(msgInput)
        addi a0, a0, %lo(msgInput)

        addi t0, zero, 3
        addi a1, zero, 76
        ecall

        # operacao
        addi t0, zero, 4
        ecall
        # coloca a opcao de escolha em s5
        add s5, zero, a0

        addi t0, zero, 3
        lui a0, %hi(msgNum1)
        addi a0, a0, %lo(msgNum1)
        addi a1, zero, 12
        ecall

        # input do primeiro num
        addi t0, zero, 4
        ecall
        addi sp, sp, -4
        sw a0, 0(sp) 

        addi t0, zero, 3
        lui a0, %hi(msgNum2)
        addi a0, a0, %lo(msgNum2)
        addi a1, zero, 12
        ecall

        # input do segundo num
        addi t0, zero, 4
        ecall
        addi sp, sp, -4
        sw a0, 0(sp) 
        
        # opcoes de operacao
        addi s1, zero, 1
        addi s2, zero, 2
        addi s3, zero, 3
        addi s4, zero, 4

        beq s5, s1, soma
        beq s5, s2, subtracao
        beq s5, s3, multiplicacao
        beq s5, s4, divisao
        # print msg de erro na opcao

        soma:
            call somar
        j resultado

        subtracao:
            call subtrair
        j resultado

        multiplicacao:
            call multiplicar

        j resultado

        divisao:
            call dividir
            addi s5, zero, 4



        resultado:


            lui a0, %hi(msgrResultado)
            addi a0, a0, %lo(msgrResultado)
            addi t0, zero, 3
            addi a1, zero, 12
            ecall
            addi t0, zero, 1
            beq s6, zero, printarPositivo
            # printar negativo

            addi t0, zero, 2
            addi a0, zero, 45
            ecall

            # pega o resultado
            lw a0, 0(sp)
            addi sp, sp, 4 
            addi t0, zero, 1
            ecall

            j resto
            printarPositivo:
            # pega o resultado
            lw a0, 0(sp)
            addi sp, sp, 4 
            addi t0, zero, 1
            ecall

            resto:
            # divisao
            bne s5, s4, terminarPrograma
            # printar resto 

            lui a0, %hi(msgResto)
            addi a0, a0, %lo(msgResto)
            addi t0, zero, 3
            addi a1, zero, 8
            ecall

            beq s6, zero, resto_positivo
            # printar negativo do resto

            addi t0, zero, 2
            addi a0, zero, 45
            ecall

            resto_positivo:

            # pega o resto
            lw a0, 0(sp)
            addi sp, sp, 4 
            addi t0, zero, 1
            ecall

        terminarPrograma:
        lw ra, 0(sp)
        addi sp, sp, 4 
        