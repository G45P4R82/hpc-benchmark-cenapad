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
qsub -v PROJECT_ROOT,OSU_BW,OSU_LATENCY,CONTAINER_IMAGE,MPIEXEC_EXTRA_ARGS \
  pbs/run_benchmarks.pbs
```

O caminho de `CONTAINER_OSU_BW` e `CONTAINER_OSU_LATENCY` deve ser ajustado
após verificar a instalação dentro da imagem. O launcher, a opção de hostfile
e os recursos PBS podem variar; confirme-os com o administrador do cluster.

Cada saída começa com um comentário contendo cenário, benchmark e comando
completo. O arquivo `run-environment.txt` registra diagnósticos do job.
