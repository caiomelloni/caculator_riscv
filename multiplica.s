fun_multiplica:
# faz o produto entre a0 e a1
# retorna o resultado em a0 e o sinal da operação em a1 (0 para negativo e 1 para positivo)

# s0 -> produto
# s1 -> multiplicando (a0) 
# s2 -> multiplicador (a1)

# comparacao de sinais
# s3 -> 0 se multiplicando e multiplicador possuem sinais opostos
addi t0, zero, 1
addi t1, zero, 1
addi s3, zero, 1
bgt a0, zero, a0_positivo
addi t0, zero,0
## pega o módulo de a0
lui t2, 0xfffff
addi t2, t2, 0xfff
xor a0, a0, t2
addi a0, a0, 1
## 
a0_positivo:
bgt a1, zero, a1_positivo
addi t1, zero,0
## pega o módulo de a1
lui t2, 0xfffff
addi t2, t2, 0xfff
xor a1, a1, t2
addi a1, a1, 1
## 
a1_positivo:
beq t0, t1, fim_comparacao
addi s3, zero, 0
fim_comparacao:

# 1: início
addi s0, zero, 0
addi s1, a0, 0
addi s2, a1, 0

# 2: teste o valor do multiplicando e do multiplicador
# # se multiplicando = 0 ou multiplicador = 0; pule para o passo 7
beq s1, zero, fim
beq s2, zero, fim 

# 3: teste o bit menos significativo do multiplicador
## se for 1; entao produto += multiplicando 
teste_lsb:
andi t0, s2, 1
## se nao, pule para o passo 4
beq t0, zero, desloca_esquerda
add s0, s0, s1

# 4: desloca o multiplicando 1 bit para esquerda
desloca_esquerda:
slli s1, s1, 1

# 5: desloque o multiplicador 1 bit para direita
srli s2, s2, 1

# 6: teste o valor do multiplicador
## se multiplicador == 0; pule para o passo 7
beq s2, zero, fim
## se não; pule para o passo 3
j teste_lsb

# 7:
fim:
addi a0, s0, 0
addi a1, s3, 0
ret