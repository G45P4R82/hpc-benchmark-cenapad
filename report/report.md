# Relatório: MPICH/UCX no Host e em Contêiner

> Este relatório é um modelo. Substitua todos os campos entre colchetes por
> dados coletados no cluster. Não declare que InfiniBand foi utilizado sem
> evidência nos logs de UCX/RDMA.

## Resumo

Foram comparadas as execuções nativa e em contêiner dos benchmarks
`osu_bw` e `osu_latency` em dois nós CPU do CENAPAD, com um processo MPI por
nó e [N] repetições por cenário.

## Ambiente

| Item | Valor |
|---|---|
| Nós | [node0, node1] |
| Sistema/kernel | [valor] |
| CPU | [valor] |
| GCC | [valor] |
| Spack | [valor] |
| MPICH | [valor] |
| UCX | [valor] |
| Mellanox OFED | [valor] |
| Apptainer | [valor] |
| OSU Micro-Benchmarks | [valor] |
| Rede verificada | [evidência] |

## Procedimento

Descrever a instalação Spack, a compilação do OSU, a receita HPCCM, a
construção da imagem e o script PBS. Informar os parâmetros exatos do
benchmark, a política de afinidade e os tamanhos de mensagem.

## Resultados

![Largura de banda](../results/plots/bandwidth_comparison.png)

![Latência](../results/plots/latency_comparison.png)

As tabelas completas estão em `results/processed/measurements.csv` e
`results/processed/summary.csv`.

## Análise

- Maior largura de banda: [valor] MB/s.
- Percentual de 100 Gb/s: [valor] %.
- Tamanho a partir do qual a largura de banda estabiliza: [valor] bytes.
- Diferença host/contêiner: [valor e interpretação].
- Variabilidade entre repetições: [desvio-padrão ou intervalo].

Usar a conversão `100 Gb/s = 12.500 MB/s` quando a saída estiver em MB/s
decimal. Portanto, `percentual = MB/s / 125`. Explicar limitações causadas por
protocolo, cabeçalhos, PCIe, NUMA, afinidade, memória, congestionamento,
firmware e overhead de MPI/UCX.

## Reprodutibilidade

Listar os comandos executados e referenciar os arquivos versionados:

- `spack/spack.yaml`;
- `spack/spack.lock`;
- `container/recipe.py`;
- `container/Singularity.def`;
- `pbs/run_benchmarks.pbs`;
- logs completos em `results/raw/`;
- diagnóstico do ambiente em `results/environment/`.
