# HPC Benchmark CENAPAD

Experimento reprodutível para comparar os OSU Micro-Benchmarks executados

## Objetivos

- Instalar MPICH e OSU Micro-Benchmarks no espaço do usuário com Spack.
- Criar uma imagem Ubuntu 24.04 com HPCCM, GCC, MPICH/UCX e OSU.
- Executar `osu_bw` e `osu_latency` em dois nós CPU, com um processo por nó.
- Comparar média e variabilidade entre execução nativa e em contêiner.
- Verificar que os testes utilizam efetivamente InfiniBand.

## Estrutura

```text
spack/       Ambiente Spack, especificação e comandos de reprodução
container/   Receita HPCCM e arquivos gerados para o contêiner
pbs/         Scripts de submissão e execução dos experimentos
results/     Logs, dados processados e gráficos
report/      Relatório final
scripts/     Coleta, análise e geração dos gráficos
docs/        Plano experimental e decisões do ambiente
```

## Status

O repositório contém a documentação inicial. As versões exatas, a versão do
Mellanox OFED e os nomes dos nós serão registrados após a consulta ao ambiente
do cluster.

## Referências

- [HPC Container Maker](https://github.com/NVIDIA/hpc-container-maker)
- [Documentação do HPCCM](https://nvidia.github.io/hpc-container-maker/)
- [Workshop18 sobre HPCCM](https://github.com/HPCSYSPROS/Workshop18/blob/5cfaca3428a925423bc7eb4b31fc0d2fb97e1c10/Making_Containers_Easier_with_HPC_Container_Maker/ws_hpcsysp103.pdf)
- [OSU Micro-Benchmarks](https://mvapich.cse.ohio-state.edu/benchmarks/)

## Reprodução

Os comandos definitivos serão documentados em [`docs/experimental-plan.md`](docs/experimental-plan.md)
