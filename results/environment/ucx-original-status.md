# Original CH4:UCX Experiment Status

## Completed

- MPICH 4.1.1 was compiled in user space with `--with-device=ch4:ucx`.
- UCX 1.15.0 was used as the MPICH UCX dependency.
- `mpichversion` reports `MPICH Device: ch4:ucx`.
- OSU Micro-Benchmarks 7.5.2 were rebuilt with the custom MPICH wrappers.
- A real Spack lockfile was generated with the requested MPICH/UCX spec.

## Pending PBS jobs

- `1029486.ada`: native CH4:UCX benchmark, queued in `parexp`.
- `1029489.ada`: container CH4:UCX benchmark, queued in `parexp`.

Both jobs currently report `Not enough free nodes available`. No final UCX
benchmark logs exist yet.

## Container limitation

The Ubuntu SIF starts and the OSU executable is visible, but UCX inside the
container could not open the `mlx5_0` verbs memory domain. It only exposed
TCP and memory transports. This is not accepted as an InfiniBand result. The
container job must either receive the correct RDMA userspace/provider mounts
or be marked blocked; TCP fallback must not be reported as UCX/InfiniBand.

The earlier OFI pilot remains documented separately and must not be mixed with
this original CH4:UCX experiment.
