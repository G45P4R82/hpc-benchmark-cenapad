# Relatorio do piloto: host e container

## Escopo

Este documento registra um piloto reproduzivel entre dois nos PBS do CENAPAD.
Foram executadas tres repeticoes nativas e tres repeticoes em um container
Ubuntu 24.04, usando OSU Micro-Benchmarks 7.5.2.

O ambiente real disponivel usa MPICH 4.1.1 com `CH4:OFI` e libfabric. Ele nao
corresponde ao alvo original `CH4:UCX`; essa diferenca e uma limitacao deste
piloto e nao deve ser ocultada.

## Configuracao

| Item | Valor |
|---|---|
| Fila PBS | `paralela` |
| Alocacao | 2 nos, `scatter:exclhost` |
| Launcher | Hydra do MPICH, via `mpiexec` do modulo |
| GCC | 9.4.0 |
| MPICH | 4.1.1, `CH4:OFI` |
| libfabric | 1.18.0 |
| UCX observado | 1.15.0, nao usado como netmod do MPICH |
| OSU | 7.5.2 |
| Container | Ubuntu 24.04 SIF com bind dos artefatos do host |
| Parametros | `-m 1:1048576 -x 10 -i 100` |

## Resultados em 1 MiB

| Cenário | Benchmark | Media | Desvio-padrao | Minimo | Maximo |
|---|---|---:|---:|---:|---:|
| Host | `osu_bw` | 3250.81 MB/s | 10.86 | 3239.02 | 3260.40 |
| Container | `osu_bw` | 2842.40 MB/s | 590.40 | 2244.71 | 3425.24 |
| Host | `osu_latency` | 410.16 us | 45.00 | 381.32 | 462.01 |
| Container | `osu_latency` | 402.26 us | 32.05 | 365.48 | 424.21 |

A banda media do container foi 12.56% menor que a nativa. A latencia media
do container foi 1.93% menor, dentro da variabilidade observada. A variacao
da banda no container foi muito maior.

Considerando 100 Gb/s como 12500 MB/s, os valores em 1 MiB correspondem a
aproximadamente 26.01% do teorico no host e 22.74% no container. Essa
comparacao e apenas uma referencia: protocolo, libfabric, PCIe, NUMA,
afinidade, memoria, firmware e congestionamento influenciam o resultado.

## Graficos e dados

- `results/processed/summary.csv` contem as medias e a variabilidade.
- `results/processed/measurements.csv` contem as medidas individuais.
- Os graficos deste piloto estao em `results/plots/` quando a biblioteca
  grafica estiver disponivel no ambiente de analise.

## Limitacoes

- O MPICH disponivel foi compilado como `CH4:OFI`, nao `CH4:UCX`.
- O container nao e autocontido: MPICH, libfabric, RDMA e OSU foram montados
  do host.
- O teste com mensagens ate 64 MiB nao progrediu neste setup; por isso este
  piloto foi limitado a 1 MiB.
- A versao exata do MOFED nao foi observavel com a conta de usuario.
- Nao ha afirmacao de que este piloto substitua o experimento completo
  originalmente planejado.

Nenhuma imagem autocontida, instalacao Spack final ou resultado inexistente
foi fabricado.
