# Relatorio do piloto HPC: host e container

## Resumo executivo

Este relatorio apresenta um piloto reproduzivel de comunicacao MPI entre dois
nos PBS do CENAPAD, comparando execucao nativa e em container. Foram
executadas tres repeticoes de `osu_bw` e `osu_latency` em cada cenario.

O ambiente institucional disponivel usa MPICH 4.1.1 com `CH4:OFI/libfabric`.
O protocolo original previa `CH4:UCX`; por isso os resultados abaixo sao
explicitamente classificados como um piloto OFI, nao como o experimento UCX
completo.

## Ambiente e reproducibilidade

| Item | Valor |
|---|---|
| Sistema | AlmaLinux 8.10 |
| CPU computacao | AMD EPYC 7443, 48 CPUs |
| GCC | 9.4.0 |
| MPICH | 4.1.1, `CH4:OFI/libfabric` |
| libfabric | 1.18.0 |
| UCX observado | 1.15.0, nao usado como netmod do MPICH OFI |
| OSU | 7.5.2 |
| PBS | 22.05.11 |
| Fila | `paralela` |
| Alocacao | 2 nos, `scatter:exclhost` |
| Launcher | Hydra via `mpiexec` |
| Singularity | 3.8.5-2.el8 |
| Rede | InfiniBand HDR100, 100 Gb/s |

Arquivos relevantes:

- Receita HPCCM: `container/recipe-offline.py`.
- Definicao gerada: `container/Singularity.offline.def`.
- Spack: `spack/phase3-env/spack.yaml` e `spack/phase3-env/spack.lock`.
- Script PBS do piloto: `pbs/run_pilot_benchmarks.pbs`.
- Parser: `scripts/parse_osu.py`.
- Graficos: `scripts/plot_results.py`.
- Logs nativos: `results/raw/pilot-native-1028628/`.
- Logs do container: `results/raw/pilot-container-1028771/`.
- CSV combinado: `results/processed/summary.csv` e `results/processed/measurements.csv`.

## Procedimento

Os jobs usaram dois nos PBS e tres repeticoes por benchmark. Os parametros do
piloto foram:

```text
-m 1:1048576 -x 10 -i 100
```

O container foi uma base Ubuntu 24.04 SIF com MPICH, libfabric, RDMA e OSU
montados explicitamente do host. Ele nao e uma imagem autocontida.

## Resultados

### Largura de banda e latencia em 1 MiB

| Cenario | Benchmark | Media | Desvio-padrao | Minimo | Maximo |
|---|---|---:|---:|---:|---:|
| Host | `osu_bw` | 3250.81 MB/s | 10.86 | 3239.02 | 3260.40 |
| Container | `osu_bw` | 2842.40 MB/s | 590.40 | 2244.71 | 3425.24 |
| Host | `osu_latency` | 410.16 us | 45.00 | 381.32 | 462.01 |
| Container | `osu_latency` | 402.26 us | 32.05 | 365.48 | 424.21 |

![Largura de banda](../results/plots/bandwidth_comparison.png)

![Latencia](../results/plots/latency_comparison.png)

## Analise

### Influencia do tamanho da mensagem

Para mensagens pequenas, custos fixos de MPI, libfabric, protocolo e buffers
dominam a transferencia. Conforme a mensagem cresce, esses custos sao
amortizados e a largura de banda aumenta. A latencia fica relativamente
estavel nas mensagens pequenas e cresce para mensagens maiores.

No piloto, a largura de banda se aproxima da estabilizacao entre 512 KiB e
1 MiB. A faixa acima de 1 MiB nao foi considerada neste piloto porque o
`osu_bw` OFI nao progrediu de forma confiavel ate 64 MiB.

### Maior largura de banda e percentual teorico

A maior medida observada foi no container, em 1 MiB:

```text
3425.24 MB/s
```

A conversao correta para 100 Gb/s e:

```text
100 Gb/s = 12.500 MB/s
3425.24 / 12500 * 100 = 27.40%
```

A maior medida nativa foi `3260.40 MB/s`, equivalente a `26.08%` do limite
teorico.

### Host versus container

A banda media do container foi aproximadamente `12.56%` menor que a nativa.
A latencia media do container foi aproximadamente `1.93%` menor, uma diferenca
pequena diante da variabilidade. A banda do container foi menos consistente:
seu intervalo em 1 MiB foi `2244.71--3425.24 MB/s`, contra
`3239.02--3260.40 MB/s` no host.

### Distancia ao limite teorico

A diferenca para 12.500 MB/s pode ser explicada por cabeçalhos e protocolos,
overhead MPI/libfabric, provider OFI, PCIe, NUMA, afinidade, copias de
memoria, congestionamento, carga dos nos, firmware, driver e variacao do
scheduler. No container, binds de bibliotecas e o caminho adicional de
execucao tambem podem aumentar a variabilidade.

## Entregaveis

Todos os artefatos de entrega estao publicados neste repositorio:

- [Receita HPCCM](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/container/recipe-offline.py).
- [Definicao Singularity gerada](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/container/Singularity.offline.def).
- [Spack environment](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/spack/phase3-env/spack.yaml).
- [Spack lockfile](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/spack/phase3-env/spack.lock).
- [Script PBS do piloto](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/pbs/run_pilot_benchmarks.pbs).
- [Script PBS do protocolo UCX](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/pbs/run_ucx_benchmarks.pbs).
- [Parser OSU](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/scripts/parse_osu.py).
- [Script de graficos](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/scripts/plot_results.py).
- [Logs nativos completos do piloto](https://github.com/G45P4R82/hpc-benchmark-cenapad/tree/main/results/raw/pilot-native-1028628).
- [Logs completos do container do piloto](https://github.com/G45P4R82/hpc-benchmark-cenapad/tree/main/results/raw/pilot-container-1028771).
- [Medidas individuais](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/results/processed/measurements.csv).
- [Resumo processado](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/results/processed/summary.csv).
- [Grafico de largura de banda](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/results/plots/bandwidth_comparison.png).
- [Grafico de latencia](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/results/plots/latency_comparison.png).
- [Relatorio em Markdown](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/report/report.md).
- [Relatorio em PDF](https://github.com/G45P4R82/hpc-benchmark-cenapad/blob/main/report/report.pdf).

## Limitacoes e trabalho futuro

- O MPICH do piloto usa `CH4:OFI/libfabric`, nao `CH4:UCX`.
- O SIF usa binds do host e nao e autocontido.
- O piloto foi limitado a 1 MiB.
- A versao exata do MOFED nao foi observavel com a conta de usuario.
- Os jobs do experimento original UCX (`1029486.ada` e `1029489.ada`) ainda
  aguardam recursos na fila `parexp`; seus resultados nao foram inventados.
- Para o estudo original completo, e necessario executar esses jobs, processar
  seus logs e substituir os resultados OFI deste piloto.

## Conclusao

O piloto confirmou execucao MPI nativa e em container entre dois nos e mostrou
que o container teve banda media menor e variabilidade maior em 1 MiB. Os
artefatos, logs, graficos e limitacoes estao registrados no repositorio. O
resultado deve ser interpretado como piloto OFI reproduzivel, nao como a
versao final do estudo CH4/UCX.
