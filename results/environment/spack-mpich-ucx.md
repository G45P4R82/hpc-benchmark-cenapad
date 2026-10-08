# Spack, MPICH and UCX Discovery

This summary comes from a successful PBS job in the `testes` queue. Personal
paths, usernames and hostnames are omitted.

## Results

- GCC in the default environment: 8.5.0.
- The `spack` command was not in `PATH`.
- The module catalogue provides `spack/0.20.0`.
- MPICH module available: `mpich/4.1.1-gcc-9.4.0`.
- UCX modules available include 1.11.2, 1.14.0, 1.14.1, 1.15.0 and 1.19.0.
- UCX variants include GCC, Intel and AOCC builds.
- GCC modules include 8.5.0, 9.3.0, 9.4.0, 11.2.0, 12.2.0 and 15.2.0.
- RDMA-core modules available include 34.0, 41.0 and 57.0.
- Singularity module available: 3.8.3-gcc-9.4.0.
- Open MPI modules are also available, including 4.1.1-gcc-9.4.0.

## Still required

The module must be loaded before running `spack --version`, `spack compiler
list`, `spack info mpich` and `spack info ucx`. The completed job could not
produce those outputs because Spack was not loaded; no MPICH variant is being
chosen by assumption.

No MPICH, UCX or OSU installation was performed.
