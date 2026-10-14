# OSU Build Manifest

The OSU Micro-Benchmarks 7.5.2 source was downloaded from the official
MVAPICH source endpoint after external download was explicitly authorized.

- Source: `osu-micro-benchmarks-7.5.2.tar.gz`
- SHA-256: `618de3d0b1122f73a9229177d2da1e5cd62e431190580cb915f2605849cbbbdc`
- Build job: `1028337.ada`
- Build result: `Exit_status=0`
- Compiler module: `gcc/9.4.0`
- MPI module: `mpich/4.1.1-gcc-9.4.0`
- UCX module: `ucx/1.15.0`
- OSU version: `7.5.2`
- Binaries: `osu_bw` and `osu_latency`

The generated binaries were checked with `ldd`. They use MPICH 4.1.1 and
GCC 9.4.0 libraries from the cluster. The MPICH module reports `ch4:ofi` and
libfabric, not `ch4:ucx`; UCX 1.15.0 was present but was not the MPICH netmod.

The offline container workflow was adjusted to bundle `libfabric` instead of
assuming UCX as the MPICH transport. No SIF, benchmark result or performance
claim is included yet.
