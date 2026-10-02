# Estado do Repositório

## Inicialização

- Repositório público: `https://github.com/G45P4R82/hpc-benchmark-cenapad`
- Branch principal: `main`
- Diretório local: `/home/juan/IC/hpc/atividade`
- Data de inicialização: 2026-10-01

## Artefatos de automação

- `scripts/collect_environment.sh`
- `scripts/check_infiniband.sh`
- `scripts/check_mpi_compatibility.sh`
- `spack/install.sh`
- `container/recipe.py`
- `container/build.sh`
- `pbs/run_benchmarks.pbs`
- `scripts/parse_osu.py`
- `scripts/plot_results.py`

## Artefatos gerados no cluster

Os seguintes arquivos ainda dependem da execução real e não devem ser
fabricados:

- `spack/spack.yaml` e `spack/spack.lock` concretizados;
- `container/Singularity.def` e `container/Dockerfile` gerados pela versão
  instalada do HPCCM;
- `container/osu-mpich-ucx.sif`;
- logs PBS e benchmarks em `results/raw/`;
- CSVs, gráficos e relatório preenchido.
