# Manual
**Calculadora feita em RiscV, conta com as operações de soma, subtração, multiplicação e divisão, além da conversão entre bases (hexadecimal, decimal e binária)**

`Observações: Visando um bom desempenho no simulador, a calculadora foi dividida em duas partes, uma para as operações (calculadora.s) e outra para as conversões  entre bases (conversor.s).`

## Execução
- Use o [BRISC-V Simulator](https://ascslab.org/research/briscv/simulator/simulator.html) para executar o código

## Algoritmos com deslocamento de bit

### Multiplicação:
- Entrada: Multiplicando e Multiplicador
- Saída: Produto

    **Algoritmo de multiplicação multiciclo:**
    
    1- Inicialize um registrador que irá guardar o produto com zero
    
    2- Se multiplicando = 0 ou multiplicador = 0, pule para o passo 7. Senão, prossiga para o passo 3
    
    3- Se o LSB do multiplicador é 1, então, produto += multiplicando. Se não, prossiga para o passo 4

    4- Desloque o multiplicando 1 bit para a esquerda

    5- Desloque o multiplicador 1 bit para a direita

    6-  Se multiplicador = 0, vá para o passo 7. Senão, volte para o passo 3

    7- Retorne o valor do registrador que guarda o produto

### Divisão:
- Entrada: Dividendo e Divisor
- Saída: Quociente e Resto

    **Algoritmo de divisão binária:**

    1- alinhamento
        
        - desloque o divisor para esquerda enquanto ele for maior que zero
        - desloque o divisor uma posição para direita, tornando-o positivo
        

    2- inicie o quociente com 0
    
    3- se o dividendo for maior ou igual que o divisor:
        
        - dividendo = dividendo - divisor
        - desloque o quociente para esquerda 1 vez e some 1 nele
        se nao:
        - desloque o quociente logicamente para esquerda
    
    4 - desloque o divisor 1 vez para a direita
    
    5 - se dividendo >= divisor ou se o divisor não chegou em um valor menor que o inicial, então pule para o passo 3
    
    6 - quociente está correto, e o valor do registrador que guarda o dividendo é igual ao resto

`Observação: esses algoritmos de deslocamento usam os módulos dos números. Então, antes disso, salvamos em um registrador se o resultado deve ser positivo ou negativo na hora da impressão pelo console`