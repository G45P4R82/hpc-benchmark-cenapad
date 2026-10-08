# Phase 2: Spack and MPICH Status

The second-stage PBS job created the Spack environment file
`spack/phase2-env/spack.yaml` with this requested spec:

    mpich@4.1.1%gcc@9.4.0 device=ch4 netmod=ucx

Spack 0.20.0.dev0 and GCC 9.4.0 were loaded, and `spack compiler find`
registered the available GCC compilers in the user configuration.

## Current result

Installation did not complete. Spack attempted to bootstrap `patchelf`, but
its binary index was empty and the package recipe could not find a valid URL
for `patchelf` 0.17.2 or 0.13.1. The job log records the complete failure.

No MPICH package, UCX package or OSU benchmark was installed. No lockfile was
produced because concretization/installation did not finish. This is an
environment/network/bootstrap limitation, not a selected MPICH variant.

The raw PBS log is intentionally not versioned because it contains cluster
paths and job metadata.
