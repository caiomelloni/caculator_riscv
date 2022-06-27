from math import ceil
text = "erro de overflow"


# transforma para hex
text16 = text.encode('utf=8')
textList = list(text16.hex())
# adiciona os elementos da lista em grupos de 2
textHex = []
for i in range(round(len(textList)/2)):
    x = 2*i
    aux = textList[x:x+2]
    textHex.append(''.join(aux))
textHex.reverse()


# adiciona os elementos da lista em grupos de 4
textFinal = []
for i in range(ceil(len(textHex)/4)):
    x = 4*i
    aux = textHex[x:x+4]
    textFinal.append(''.join(aux))

# preenche com zero o ultimo elemento
lastElem = textFinal[-1]
lastElem = lastElem.zfill(8)
textFinal[-1] = lastElem

# inverte a lista
textFinal.reverse()

# escreve para um arquivo no formato correto
f = open("HexForRiscV", mode="w")
for i in textFinal:
    f.write("\t.word 0x" + i + "\n")

f.write("\nsize:" + str(len(textFinal) * 4))

f.close
