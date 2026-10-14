# PBS

O script deve ser submetido no cluster, não em uma máquina local. Host e
contêiner são executados nos mesmos dois nós reservados pelo job.

Exemplo de submissão:

```bash
export PROJECT_ROOT="$PWD"
export OSU_BW="$HOME/opt/osu/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw"
export OSU_LATENCY="$HOME/opt/osu/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency"
export CONTAINER_IMAGE="$PROJECT_ROOT/container/osu-mpich-ucx.sif"
export MPIEXEC_EXTRA_ARGS="-f $PBS_NODEFILE"
export CONTAINER_RUNTIME=singularity
qsub -v PROJECT_ROOT,OSU_BW,OSU_LATENCY,CONTAINER_IMAGE,MPIEXEC_EXTRA_ARGS,CONTAINER_RUNTIME \
  pbs/run_benchmarks.pbs
```

O caminho de `CONTAINER_OSU_BW` e `CONTAINER_OSU_LATENCY` deve ser ajustado
após verificar a instalação dentro da imagem. O launcher, a opção de hostfile
e os recursos PBS podem variar; confirme-os com o administrador do cluster.

O script usa `/opt/pbs/bin/mpiexec` e `singularity` por padrão, conforme o
inventário do CENAPAD. Eles podem ser substituídos pelas variáveis `MPIEXEC` e
`CONTAINER_RUNTIME`, sem alterar o restante do experimento.

## Compilar OSU no cluster

Não compile os binários nativos nesta máquina local: o cluster usa AlmaLinux,
GCC/MPICH/UCX próprios. O script `scripts/build_osu_cluster.sh` não baixa
nada; ele exige uma árvore do OSU já existente no cluster e usa os módulos:

```bash
export PROJECT_ROOT="$PWD"
export OSU_SOURCE_DIR="$HOME/src/osu-micro-benchmarks-7.5.2"
export OSU_PREFIX="$HOME/opt/osu-7.5.2-mpich-4.1.1"
qsub -v PROJECT_ROOT,OSU_SOURCE_DIR,OSU_PREFIX pbs/build_osu.pbs
```

Após o job, confira os caminhos indicados no manifesto:

```text
$OSU_PREFIX/**/osu_bw
$OSU_PREFIX/**/osu_latency
$OSU_PREFIX/build-manifest.txt
```

Se a fonte não existir em `$HOME`, ela deve ser fornecida pelo administrador
ou por um artefato institucional aprovado. Este procedimento não usa Internet.

Cada saída começa com um comentário contendo cenário, benchmark e comando
completo. O arquivo `run-environment.txt` registra diagnósticos do job.
