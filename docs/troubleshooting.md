# Troubleshooting

## `mpicc` usa o MPI errado

Ative o ambiente Spack explicitamente, confira `which mpicc`, `mpicc -show` e
`ldd` nos binários do OSU. Não misture `mpiexec`, `libmpi` e wrappers de
instalações diferentes.

## O contêiner não enxerga InfiniBand

Confirme montagem de `/dev/infiniband`, bibliotecas de usuário OFED, `ibv_devinfo`
host.

## O launcher não inicia o binário do contêiner

Verifique a compatibilidade do Hydra/PMI/ABI do MPICH. Execute um caso mínimo,
registre o comando completo e consulte a política do cluster antes de usar
`--mpi` ou bind automático de bibliotecas do host, pois isso pode mascarar a
origem real do MPI usado pelo benchmark.

## O desempenho parece Ethernet

Não conclua pelo valor apenas. Consulte os diagnósticos UCX, o provider ativo,
os dispositivos IB e as variáveis `UCX_TLS`, `UCX_NET_DEVICES` e `MPICH_*`.

## O parser não encontra dados

Use os nomes `native_bw_rep01.out`, `container_bw_rep01.out`,
`native_latency_rep01.out` e `container_latency_rep01.out`. Preserve as duas
colunas numéricas do OSU e remova apenas cabeçalhos que não sejam dados.
