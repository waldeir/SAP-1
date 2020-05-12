Language: [English](https://github.com/waldeir/SAP-1)

# Simple As Possible computer - 1 (SAP-1)

Esta é uma implementação em VHDL do conhecido computador SAP-1, descrito no
livro [Malvino - Digital Computer Electronics - 3rd Edition][book]. Ela usa
modelagem comportamental para criar os blocos do computador e modelagem
estrutural para montar esses blocos em uma unidade computacional, **Figura 1**.
Os estados ativos dos sinais foram escolhidos para corresponder aos descritos
no livro, portanto, as mesmas formas de onda apresentadas no capítulo do SAP-1
podem ser visualizadas na simulação.

![](images/block_diagram_sap1.png)

**Figura 1**: Modelo estrutural do SAP1, onde cada bloco usa modelagem
comportamental. Ao lado de cada sinal, há seu nome implementado no código VHDL.

## Particularidades desta implementação

O objetivo desta implementação é fornecer uma maneira de visualizar os sinais
internos do SAP-1 durante a execução de um programa. Os blocos
do computador foram implementados com as mesmas entradas e saídas especificadas
em [Malvino - Digital Computer Electronics - 3rd Edition][book] exceto o
*Controller Sequencer*, que não possui as saídas `clr`, `bar_clr`, `clk` e `bar_clk`,
mas possui uma entrada `clk`. Como mostrado na **Figura 2**, esses sinais são
fornecidos do lado de fora do bloco SAP-1 e são distribuídos para as unidades
correspondentes.




![](images/sap1_top_level.png)

**Figura 2**: Entradas e saídas desta implementação do SAP-1.

A **entrada de dados** por meio do *Memory Address Register* (MAR) não foi
implementada, mas você pode programar o computador escrevendo diretamente no
arquivo `RAM.vhd` e simular o resultado com o `testbench` fornecido, que é o
arquivo `sap1_tb.vhd`.

Embora os sinais `clr` e `bar_clr` apareçam nos diagramas de blocos, eles
permanecem desativados durante a simulação, porque são usados
apenas para alternar para o modo de *entrada de dados*, que não foi
implementado. 


## Linux e GHDL

Se você estiver no Linux, certifique-se de ter o programa *ghdl* instalado e
execute

```
git clone https://github.com/waldeir/SAP-1
cd SAP-1 /
faço
./sap1_tb --vcd = waveform.vcd
```


O procedimento gera o arquivo de forma de onda `waveform.vcd`, que pode ser
aberto em um programa como o *gtkwave*. Os nomes das variáveis de
sinal são apresentados na **Figura 1** e seu comportamento durante o tempo é
armazenado no arquivo `waveform.vcd`.

[book]:https://www.amazon.com/Digital-Computer-Electronics-Albert-Malvino/dp/0028005945 "https://www.amazon.com/Digital-Computer-Electronics-Albert-Malvino/dp/0028005945"
