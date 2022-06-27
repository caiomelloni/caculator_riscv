/*
Divisão binária
1- alinhe o dividendo e o divisor
2- inicie o quociente com 0
3- se o dividendo for maior ou igual que o divisor:
    - dividendo = dividendo - divisor
    - desloque o quociente para esquerda 1 vez e some 1 nele
    se nao:
    - desloque o quociente logicamente para esquerda
4 - desloque o divisor 1 vez para a direita
5 - se dividendo >= divisor ou se o divisor chegou em um valor menor que o inicial, então pare
    pule para o passo 3
6 - quociente está correto, resto <- dividendo
*/

fun_divide: # retorno: a0 -> resto | a1 -> quociente | a3 -> 0 para resultado negativo, 1 para positivo
# a0 -> dividendo
# a1 -> divisor
# s0 -> quociente
# s1 -> guarda o divisor a fim de comparacao

# 1- alinhamento de dividendo e divisor
# deslocamento do dividendo para a esquerda até o MSB ser 1
addi t0, zero, 0
addi t1, a0, 0
addi s1, a1, 0
alinhamento_1:
blt a0, zero, fim_deslocamento_1
slli a0, a0, 1
addi t0, t0, 1
j alinhamento_1
fim_deslocamento_1:
addi a0, t1, 0

# deslocamento do divisor para a esquerda até o MSB ser 1
alinhamento_2:
blt a1, zero, fim_deslocamento_2
slli a1, a1, 1
j alinhamento_2
fim_deslocamento_2:
# alinha o divisor e o dividendo
srl a1, a1, t0

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
# se dividendo >= divisor, pule para o passo 3
bge a0, s1, passo_3
# se o divisor chegou em um valor menor que o inicial, então pare
bge a1, s1, passo_3

# 6 - quociente está correto, resto <- dividendo
add a1, zero, s0
ret