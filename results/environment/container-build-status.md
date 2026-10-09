# Container Build Status

A base Ubuntu 24.04 SIF foi obtida no cluster com autorização para download
externo e está mantida apenas como artefato local em `container/build/`.

- Singularity: 3.8.5-2.el8.
- `singularity exec` validou a execução de `osu_latency --help` dentro da base.
- Os binários OSU, MPICH e bibliotecas libfabric/RDMA são montados do host.
- O fluxo atual não é uma imagem autocontida; é um teste de contêiner com
  bind explícito dos artefatos do host.
- O job `1028771.ada` foi submetido para três repetições via contêiner, mas
  ainda está aguardando recursos na fila `paralela`.

A tentativa de construir uma imagem autocontida com `--fakeroot` continua
bloqueada pela ausência de entrada `/etc/subuid`. O remote builder também não
tem token autenticado. Nenhum resultado de contêiner foi declarado antes da
execução do job PBS.
