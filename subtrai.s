subtrai: # retorno: a0 = a0 - a1 -> em complemento de dois
# inverte os bits de a1
lui t0, 0xfffff
addi t0, t0, 0xfff
xor a1, a1, t0
# soma 1, para finalizar a inversão do sinal
addi a1, a1, 1

add a0, a0, a1
ret