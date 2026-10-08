# Why Phase Two Matters

The Spack/MPICH/OSU phase converts the cluster inventory into a reproducible,
executable environment. It must be completed before performance measurements.

## Purpose

- `spack.yaml` declares the requested MPICH environment.
- `spack.lock` records exact versions, compilers, variants and dependencies.
- The MPICH specification validates `device=ch4` and `netmod=ucx` with the
  actual Spack configuration instead of a guessed variant.
- Building OSU with the installed MPICH wrappers prevents mixing `mpicc`,
  `libmpi`, `mpiexec` and UCX installations from different environments.
- A working native installation provides the baseline for comparing the later
  container execution.

## Current blocker

The phase-two job created `spack/phase2-env/spack.yaml`, loaded Spack
0.20.0.dev0 and GCC 9.4.0, and added:

    mpich@4.1.1%gcc@9.4.0 device=ch4 netmod=ucx

Installation did not complete because Spack could not bootstrap `patchelf`.
The binary index was empty and the package recipes could not find valid URLs
for patchelf 0.17.2 or 0.13.1. Consequently, no MPICH package, UCX package,
OSU binary or `spack.lock` was produced.

The job's PBS exit status is not treated as installation success because the
collection script records package errors while continuing to write the log.

## Next step

Resolve the user-space Spack bootstrap source for `patchelf`, rerun
concretization and installation, then verify `mpicc --version` and
`mpicc -show` before compiling OSU. No benchmark or container result is valid
until that native baseline exists.
