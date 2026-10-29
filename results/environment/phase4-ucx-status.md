# Phase 4 UCX Tuning Status

## Completed

- A real Spack lockfile was generated with the requested spec:
  `mpich@4.1.1%gcc@9.4.0 device=ch4 netmod=ucx`.
- `patchelf` was compiled in user space and `clingo` was made available in the
  user Python environment.
- MPICH 4.1.1 was manually compiled with `--with-device=ch4:ucx` and UCX
  1.15.0.
- `mpichversion` confirmed `MPICH Device: ch4:ucx`.
- OSU 7.5.2 was rebuilt with the custom MPICH wrappers.
- Native UCX execution in job `1035086.ada` detected `rc_mlx5`, `rc_verbs`,
  `ud_mlx5` and `mlx5_0:1`.
- Native UCX bandwidth reached approximately 12.3 GB/s at large messages,
  close to the 100 Gb/s theoretical limit.

## Spack installation limitation

The Spack install attempt in job `1035112.ada` still failed while fetching
bootstrap/build dependencies such as `findutils-4.9.0` and `libiconv`. The
cluster does not expose a usable source/binary mirror for those dependencies.
This is separate from the valid MPICH CH4/UCX lock and manual build.

## Container limitation

The container job could not open the UCX verbs domain `mlx5_0`. It exposed TCP
fallback transports and failed MPI initialization with `Destination is
unreachable`. TCP fallback is not accepted as an InfiniBand result.

No final container UCX performance result is claimed.
