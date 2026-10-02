# Guia de Execução para Outra IA

Este documento é o procedimento operacional. Execute cada etapa na ordem e
não invente valores ausentes. Se um comando falhar por política do cluster,
registre o erro e adapte somente o mecanismo, mantendo os mesmos artefatos.

## A. Preparação local

```bash
git clone https://github.com/G45P4R82/hpc-benchmark-cenapad.git
cd hpc-benchmark-cenapad
```

A máquina local pode editar, gerar a receita e analisar resultados. Ela não
deve ser usada para medir desempenho da rede do CENAPAD.

## B. Inventário no cluster

```bash
bash scripts/collect_environment.sh
bash scripts/check_infiniband.sh
```

Verifique os arquivos em `results/environment/`. Confirme que existem dois
nós de computação CPU e que o job PBS fornece um `PBS_NODEFILE` com dois nós
distintos.

## C. Spack e OSU nativos

Consulte as variantes reais antes de escolher a especificação:

```bash
spack info mpich
spack info ucx
spack compiler list
```

Defina uma especificação compatível com CH4/UCX e execute:

```bash
export MPICH_SPEC='SUBSTITUA_PELA_ESPECIFICACAO_VALIDADA'
bash spack/install.sh
```

Compile o OSU usando os wrappers do ambiente Spack. Registre a versão estável
escolhida, checksum, prefixo e comando de configuração. Verifique os binários
com:

```bash
ldd "$OSU_BW"
ldd "$OSU_LATENCY"
bash scripts/check_mpi_compatibility.sh '' "$OSU_BW"
```

## D. HPCCM e imagem

Defina as versões encontradas no inventário. O `ofed_url` deve ser o pacote de
usuário aprovado pelo cluster, não um download arbitrário.

```bash
hpccm --version
hpccm --recipe container/recipe.py --format singularity \
  --userarg mpich=MPICH_VERSION \
  --userarg ucx=UCX_VERSION \
  --userarg osu=OSU_VERSION \
  --userarg ofed_url=OFED_USERSPACE_URL \
  > container/Singularity.def
```

Construa conforme a política do ambiente:

```bash
apptainer build container/osu-mpich-ucx.sif container/Singularity.def
```

Teste a imagem antes do PBS:

```bash
apptainer exec container/osu-mpich-ucx.sif mpichversion
apptainer exec container/osu-mpich-ucx.sif ucx_info -v
apptainer exec --bind /dev/infiniband:/dev/infiniband \
  container/osu-mpich-ucx.sif ibv_devinfo
```

Descubra os caminhos dos binários dentro da imagem e exporte
`CONTAINER_OSU_BW` e `CONTAINER_OSU_LATENCY`.

## E. Teste controlado

Antes das três repetições, execute uma chamada pequena do launcher host para
cada cenário. Confirme nos logs que o MPI do host consegue iniciar o binário
do contêiner e que UCX enxerga o dispositivo InfiniBand.

## F. PBS definitivo

```bash
export PROJECT_ROOT="$PWD"
export OSU_BW="$HOME/opt/osu/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw"
export OSU_LATENCY="$HOME/opt/osu/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency"
export CONTAINER_IMAGE="$PROJECT_ROOT/container/osu-mpich-ucx.sif"
export CONTAINER_OSU_BW=/opt/cenapad/osu/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw
export CONTAINER_OSU_LATENCY=/opt/cenapad/osu/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
export REPETITIONS=3
export BENCHMARK_ARGS='-m 1:67108864 -x 100 -i 1000'
qsub -v PROJECT_ROOT,OSU_BW,OSU_LATENCY,CONTAINER_IMAGE,CONTAINER_OSU_BW,CONTAINER_OSU_LATENCY,REPETITIONS,BENCHMARK_ARGS pbs/run_benchmarks.pbs
```

Se o launcher não aceitar `-f PBS_NODEFILE`, ajuste `MPIEXEC_EXTRA_ARGS`
conforme a implementação instalada e registre a mudança no relatório.

## G. Processamento

Copie ou mantenha os logs no diretório `results/raw/` com os nomes esperados:

```text
native_bw_rep01.out
container_bw_rep01.out
native_latency_rep01.out
container_latency_rep01.out
```

Depois execute:

```bash
python3 -m pip install -r scripts/requirements.txt
python3 scripts/parse_osu.py --raw-dir results/raw --processed-dir results/processed
python3 scripts/plot_results.py --summary results/processed/summary.csv --output-dir results/plots
```

Revise os CSVs e preencha `report/report.md`. Nunca remova os logs originais.

## H. Checklist de entrega

- [ ] `spack.yaml` e `spack.lock` do cluster.
- [ ] Receita HPCCM e arquivos gerados.
- [ ] Script PBS usado sem alterações omitidas.
- [ ] Diagnósticos de InfiniBand e UCX.
- [ ] Logs completos dos quatro cenários.
- [ ] CSV bruto/processado.
- [ ] Dois gráficos com médias e barras de erro.
- [ ] Relatório com conversão para 100 Gb/s.
- [ ] Commit e push de todos os artefatos não confidenciais.
