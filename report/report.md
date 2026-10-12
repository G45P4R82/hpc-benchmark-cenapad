# Relatorio do experimento HPC CENAPAD

## Status do documento

Este relatorio esta em consolidacao. Os dados reais ja coletados estao
registrados abaixo. Os campos marcados com `AQUI ENTRA O RESULTADO` devem ser
substituidos depois que os jobs UCX originais e a concretizacao Spack
terminarem. Nenhum valor pendente deve ser inventado.

## 1. Objetivo

Comparar a comunicacao MPI nativa e em container entre dois nos do CENAPAD,
usando OSU Micro-Benchmarks. O protocolo original solicita MPICH CH4/UCX,
UCX 1.15.0, OSU 7.5.2 e tres repeticoes por benchmark.

Durante a preparacao, o modulo institucional MPICH foi identificado como
CH4:OFI/libfabric. Por isso, o piloto ja executado usa OFI. Uma compilacao
manual de MPICH CH4/UCX foi concluida e os jobs do protocolo original foram
submetidos, mas ainda aguardam recursos.

## 2. Ambiente observado

| Item | Valor |
|---|---|
| Sistema | AlmaLinux 8.10 |
| CPU de computacao | AMD EPYC 7443, 48 CPUs |
| GCC | 9.4.0 no ambiente de build |
| Spack | 0.20.0.dev0 |
| MPICH do modulo | 4.1.1, CH4:OFI/libfabric |
| MPICH manual | 4.1.1, CH4:UCX |
| UCX | 1.15.0 |
| OSU | 7.5.2 |
| PBS | 22.05.11 |
| Launcher | Hydra via `mpiexec` |
| Singularity | 3.8.5-2.el8 |
| Rede | InfiniBand HDR100, 100 Gb/s |
| Firmware observado | 20.43.3608 |

## 3. Reproducibilidade

### Arquivos e comandos

- Receita HPCCM: `container/recipe-offline.py`.
- Definicao gerada: `container/Singularity.offline.def`.
- Script PBS: `pbs/run_pilot_benchmarks.pbs`.
- Parser: `scripts/parse_osu.py`.
- Graficos: `scripts/plot_results.py`.
- Ambiente Spack: `spack/phase2-env/spack.yaml` ou `spack/phase3-env/spack.yaml`.
- Lockfile: `[AQUI ENTRA O spack.lock REAL APOS O JOB 1029493.ada]`.

### Instalacao Spack

Comandos planejados:

```bash
module load spack/0.20.0
module load gcc/9.4.0
spack compiler find
spack env activate spack/phase3-env
spack add mpich@4.1.1%gcc@9.4.0 device=ch4 netmod=ucx
spack concretize -f
spack install
```

O ambiente Spack criado inicialmente falhou no bootstrap de `patchelf`, pois o
indice binario estava vazio e as receitas nao encontraram URLs validas. Uma
nova tentativa esta no job `1029493.ada`.

`[AQUI ENTRA: status final do job 1029493.ada, caminho do spack.lock e saida
de spack concretize]`

## 4. Coleta PBS e rede

O job `1027757.ada` alocou dois nos distintos com:

```text
queue=paralela
select=2:ncpus=128
place=scatter:exclhost
```

A primeira tentativa falhou por chaves SSH antigas. A tentativa corrigida
removeu as chaves antigas e usou `ssh-keyscan` antes de iniciar o Hydra.

O smoke test nativo confirmou dois hosts e comunicacao MPI. O teste observou
InfiniBand ativo, UCX 1.15.0 e firmware 20.43.3608.

## 5. Compilacao OSU

A fonte oficial OSU 7.5.2 foi baixada com autorizacao e validada:

```text
SHA-256 = 618de3d0b1122f73a9229177d2da1e5cd62e431190580cb915f2605849cbbbdc
```

A compilacao com o modulo MPICH CH4:OFI terminou no job `1028337.ada`.
Depois, MPICH 4.1.1 foi compilado manualmente com `--with-device=ch4:ucx` e
OSU foi recompilado contra esse MPICH no job `1029481.ada`.

`[AQUI ENTRA: mpichversion, mpicc -show e build-manifest do OSU CH4:UCX]`

## 6. Piloto nativo e container

O piloto foi executado com MPICH CH4:OFI/libfabric, nao com CH4:UCX.
Parametros:

```text
-m 1:1048576 -x 10 -i 100
```

Foram feitas tres repeticoes nativas e tres em container Ubuntu 24.04 com
bind dos binarios e bibliotecas do host.

### Resultados em 1 MiB

| Cenário | Benchmark | Media | Desvio-padrao | Minimo | Maximo |
|---|---|---:|---:|---:|---:|
| Host | osu_bw | 3250.81 MB/s | 10.86 | 3239.02 | 3260.40 |
| Container | osu_bw | 2842.40 MB/s | 590.40 | 2244.71 | 3425.24 |
| Host | osu_latency | 410.16 us | 45.00 | 381.32 | 462.01 |
| Container | osu_latency | 402.26 us | 32.05 | 365.48 | 424.21 |

A banda media do container foi 12.56% menor. A latencia media do container
foi 1.93% menor, dentro da variabilidade observada. A banda do container teve
variabilidade muito maior.

### Arquivos do piloto

- Logs nativos: `results/raw/pilot-native-1028628/`.
- Logs container: `results/raw/pilot-container-1028771/`.
- Medidas: `results/processed/measurements.csv`.
- Resumo: `results/processed/summary.csv`.
- Grafico de banda: `results/plots/bandwidth_comparison.png`.
- Grafico de latencia: `results/plots/latency_comparison.png`.

## 7. Analise solicitada

### Influencia do tamanho da mensagem

Para mensagens pequenas, o custo fixo de MPI, libfabric, inicializacao e
protocolo domina. Com o aumento da mensagem, esse custo e amortizado e a
banda cresce. A latencia permanece mais estavel em mensagens pequenas e
cresce conforme aumenta o volume transferido.

No piloto, a banda se aproxima da estabilizacao entre 512 KiB e 1 MiB. Essa
conclusao e limitada porque o teste OFI ate 64 MiB nao progrediu.

`[AQUI ENTRA A ANALISE FINAL DE ESTABILIZACAO COM OS CSVs CH4:UCX]`

### Maior banda e percentual teorico

A maior medida do piloto foi no container, em 1 MiB:

```text
3425.24 MB/s
```

A conversao correta e:

```text
100 Gb/s = 12.500 MB/s
percentual = 3425.24 / 12500 * 100 = 27.40%
```

A maior medida nativa foi `3260.40 MB/s`, equivalente a `26.08%` do teorico.

`[AQUI ENTRA A MAIOR BANDA DO EXPERIMENTO CH4:UCX]`

### Host versus container

No piloto OFI, o container teve banda media menor e variabilidade maior. A
latencia media foi semelhante e a diferenca ficou dentro da variabilidade.

`[AQUI ENTRA A COMPARACAO FINAL NATIVO/CONTAINER CH4:UCX]`

### Diferenca para o limite teorico

Possiveis fatores:

- cabecalhos e overhead de protocolo;
- MPI e libfabric;
- provider de rede selecionado;
- PCIe e caminho da placa;
- NUMA e afinidade dos processos;
- memoria e copias de buffers;
- congestionamento;
- firmware e driver;
- carga dos nos;
- variabilidade do scheduler;
- binds e bibliotecas montadas no container.

## 8. Jobs UCX pendentes

O protocolo original foi submetido nos jobs:

```text
1029486.ada  - nativo CH4:UCX
1029489.ada  - container CH4:UCX
```

Ambos estao aguardando dois nos livres na fila `parexp`.

`[AQUI ENTRA: logs completos native-ucx e container-ucx, CSVs, graficos e
resultados finais dos jobs 1029486.ada e 1029489.ada]`

## 9. Limitacoes

- O piloto OFI nao substitui o experimento original UCX.
- O container piloto usa binds do host e nao e autocontido.
- A versao exata do MOFED nao foi observada com a conta de usuario.
- O `spack.lock` depende da concretizacao bem-sucedida.
- Resultados finais UCX dependem da disponibilidade dos dois nos PBS.

## 10. Conclusao provisoria

O piloto demonstra que os binarios OSU funcionam em dois nos nativos e em um
container Ubuntu com bibliotecas do host. A banda do container foi menor e
mais variavel no ponto de 1 MiB.

A conclusao definitiva do experimento original sera escrita somente apos a
execucao dos jobs CH4:UCX, a obtencao do `spack.lock` e a atualizacao das
figuras e tabelas marcadas acima.
