Language: [English](https://github.com/waldeir/SAP-1)

# Simple As Possible Computer - 1 (SAP-1)

Esta é uma implementação em VHDL do conhecido computador SAP-1, descrito no
livro [Malvino - Eletrônica Digital para Computadores - 3ª Edição] [livro]. A
**Figura 1** mostra o diagrama de blocos da unidade computacional, onde os
estados ativos dos sinais foram escolhidos para corresponder aos descritos no
livro. Deste modo, as mesmas formas de onda apresentadas no capítulo SAP-1
podem ser visualizadas na simulação.


![](images/isap1_block_diagram.png)

**Figura 1**: Diagrama de blocos do SAP-1 com entradas de dados.  Ao lado de
cada sinal, está como seu nome é referido no código VHDL.

Conforme mostrado na **Figura 2**, o computador possui oito entradas: os
*switches* `s1` para `s7`, descritos na **Tabela 1**, e a entrada de clock `in_clk`. O programa
é carregado na memória RAM de 16 bits antes do computador iniciar, usando
os interruptores `s1`,` s3` e `s4`. Enquanto `s5` estiver definido como 0
(clear) e `s2` estiver definido como 0 (prog), os dados e seu endereço de
destino são alimentados respectivamente em `s3` e` s1` e um pulso em `s4` é
executado para escrever a informação. A operação é repetida até que todos o
programa é gravado, então `s2` é definido como 0 (run), conectando o 
*Memory Address Register* (MAR) ao barramento W.

Se `s7` for 0 (auto), o programa será iniciado quando `s5` for 1
(start) e o computador será executado até encontrar a instrução HLT. Caso
contrário, se `s7` for 1 (manual), o relógio deve ser fornecido manualmente
pressionando `s6` repetidamente.


![](images/isap1_top_level.png)

**Figura 2**: Entradas e saídas desta implementação do SAP-1.

**Tabela 1**: Switches SAP-1

| Switch | Função |
|:-------------:| --------------- |
| `s1` | Endereço de memória |
| `s2` |'1' (run): conecta a entrada MAR ao barramento W - '0' (prog): conecta a entrada do MAR ao `s1` |
| `s3` | Entrada de dados |
| `s4` | '1' (read): a memória está pronta para ser lida pelo SAP-1 - '0' (write): escreva na RAM o conteúdo de `s3` no endereço especificado por` s1` |
| `s5` | '1' (start): Coloca os sinais `clr` e` bar_clr` nos estados inativos, iniciando o computador - 0 (clear): Redefine o Contador de Programa para 0, o Contador em Anel  para o estado T1 e o Registrador de Instrução para '00000000' |
| `s6` | Passo único |
| `s7` | '1' (manual): O clock é fornecido pressionando-se sucessivamente `s6` - '0' (auto): o clock é lido a partir de `in_clk` |




## Simulação com GHDL

A simulação é realizada usando [GHDL][ghdl].  Programas personalizados podem
ser gravados no arquivo testbench `isap1_tb.vhd`, onde serão carregados na RAM
do SAP-1 e executados.

Se você estiver no Linux, certifique-se de ter *git*, *make* e [GHDL][ghdl]
instalados e execute:

```bash
git clone https://github.com/waldeir/SAP-1
cd SAP-1 /
make
./isap1_tb --vcd = waveform.vcd
```

O procedimento gera o arquivo `waveform.vcd`, que pode ser aberto no
um programa visualizador de ondas como *gtkwave*. Os nomes das variáveis de sinal são apresentados nas 
**Figuras 1** e **2**, e seu comportamento durante o tempo são armazenados no arquivo
`waveform.vcd`.


## SAP-1 sem *Switches* de entrada

Esta implementação visa principalmente fornecer uma maneira de ver os sinais do
SAP-1 durante a execução de um programa. Portanto, uma versão sem as entradas
de dados também é fornecida, onde a simulação é realizada sem a etapa de
gravação. O programa é escrito diretamente pelo usuário no arquivo RAM
`ram.vhd` e no o início da execução é controlado com o *switch* `s5`.

A **Figura 3** mostra o diagrama de blocos com o *Memory Address Register*
(`imar.vhd`) e RAM (`iram.vhd`) substituídos por sua versão sem entrada,
`mar.vhd` e `ram.vhd`, respectivamente. A **Figura 4** apresenta o resultado
versão simplificada do SAP-1.

Para executar esta versão faça:

```bash
make sap1_tb
./sap1_tb --vcd = waveform.vcd
``` 

Em seguida, abra o arquivo `waveform.vcd` com um programa visualizador de ondas como [gtkwave][gtkwave].


![](images/block_diagram_sap1.png)

<<<<<<< HEAD
**Figura 3**: Modelo estrutural do SAP-1 sem os *switches* de entrada.
=======
**Figura 3**: Modelo estrutural do SAP1 sem os *switches* de entrada.
>>>>>>> 7e904880a110b16eeb3021afd40c2a09b89a2b17

![](images/sap1_top_level.png)

**Figura 4**: SAP-1 apenas com o *switch* start/clear.

[gtkwave]:http://gtkwave.sourceforge.net/ "Visualizador de ondas"

[livro]:https://www.amazon.com/Digital-Computer-Electronics-Albert-Malvino/dp/0028005945 "https://www.amazon.com/Digital-Computer-Electronics-Albert-Malvino/dp/ 0028005945 "

[ghdl]:http://ghdl.free.fr/ "simulador VHDL"


