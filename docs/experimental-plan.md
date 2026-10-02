# Plano Experimental

## Pergunta

Qual é a diferença de desempenho entre executar os OSU Micro-Benchmarks
diretamente no host e executá-los em um contêiner Apptainer/Singularity,
mantendo MPICH, UCX, GCC, parâmetros do benchmark e condições do cluster
equivalentes?

## Escopo

O estudo deve ser executado entre dois nós CPU do CENAPAD, com um processo MPI
por nó. A máquina local serve para desenvolvimento, construção autorizada da
imagem e análise; ela não participa das medições.

## Ambiente a registrar

- distribuição, kernel, arquitetura e modelo de CPU;
- GCC, Spack, MPICH, UCX e Apptainer/Singularity;
- versão e caminho das bibliotecas de usuário Mellanox OFED;
- HPCCM e OSU Micro-Benchmarks;
- nomes dos nós, fila, recursos e opções PBS;
- `ibstat`, `ibv_devinfo`, `ucx_info -v` e `ucx_info -d`;
- variáveis MPI/UCX relevantes e comandos completos.

O inventário é coletado por `scripts/collect_environment.sh` e
`scripts/check_infiniband.sh`.

## Instalação nativa

O ambiente Spack deve instalar MPICH com GCC, dispositivo CH4 e netmod UCX,
usando as variantes confirmadas por `spack info mpich` na versão real do
Spack. O OSU deve ser compilado usando os wrappers desse MPICH. Devem ser
preservados `spack.yaml`, `spack.lock`, a especificação concretizada, o log de
instalação e a saída de `ldd` dos benchmarks.

## Contêiner

A receita HPCCM usa Ubuntu 24.04 e compila GCC/UCX/MPICH/OSU no mesmo conjunto
de versões escolhido para o host. O espaço de usuário OFED é uma entrada
explícita da receita (`ofed_url`) e deve ser obtido de fonte aprovada pelo
cluster. Drivers de kernel não são instalados no contêiner.

A imagem é lançada pelo MPI do host, mas o executável OSU e suas bibliotecas
MPI/UCX devem ser os do contêiner. Essa combinação precisa ser validada, pois
launcher, PMI, ABI, UCX e bibliotecas OFED devem ser compatíveis.

## Execução

Executar pelo PBS, nos mesmos dois nós e com os mesmos parâmetros:

1. `osu_bw` nativo;
2. `osu_bw` no contêiner;
3. `osu_latency` nativo;
4. `osu_latency` no contêiner.

Cada cenário deve ter pelo menos três repetições. O script
`pbs/run_benchmarks.pbs` salva comando, ambiente, diagnóstico e saída completa.

## Verificação da rede

Não basta observar bons números. Cada cenário deve registrar dispositivos
InfiniBand, transportes UCX e configurações MPI, demonstrando que não houve
fallback silencioso para TCP.

## Análise

O parser calcula média, desvio-padrão, mínimo e máximo por tamanho de mensagem.
Os gráficos usam o tamanho da mensagem em escala logarítmica e exibem barras
de erro para host e contêiner.

Com MB decimal:

```text
100 Gb/s = 12.500 MB/s
percentual do teórico = largura_de_banda_MB_s / 125
```

O relatório deve explicar a influência do tamanho da mensagem, o ponto de
saturação, a maior largura de banda, a variabilidade e diferenças entre host e
contêiner. Também deve discutir protocolo, cabeçalhos, PCIe, NUMA, afinidade,
memória, congestionamento, firmware e overhead MPI/UCX.

## Critérios de conclusão

- [ ] Inventário do ambiente versionado.
- [ ] Spack reproduzível com `spack.yaml` e `spack.lock` reais.
- [ ] OSU nativo validado.
- [ ] Receita HPCCM e arquivos gerados versionados.
- [ ] Imagem Apptainer validada.
- [ ] Comunicação InfiniBand comprovada nos dois cenários.
- [ ] Três ou mais repetições por teste e cenário.
- [ ] Logs, CSVs, gráficos e relatório entregues.
