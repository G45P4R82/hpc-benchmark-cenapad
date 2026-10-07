# Effective Spack Package Information

The following data was collected after loading the `spack/0.20.0` module in a
successful PBS job. The reported Spack version is `0.20.0.dev0`.

## Compilers

The active Spack compiler configuration listed GCC 8.5.0, 9.4.0, 12.2.0 and
15.2.0; AOCC 4.2.0; Intel 2021.3.0, 2022.0.1, 2023.2.1 and 2025.1.1; and
NVHPC 23.3 and 23.5.

## MPICH

- Preferred version: 4.1.1.
- Device choices: `ch3` and `ch4`; default: `ch4`.
- Netmod choices: `tcp`, `mxm`, `ofi` and `ucx`; default: `ofi`.
- Hydra is enabled by default.
- PMI choices include `off`, `pmi`, `pmi2`, `pmix` and `cray`; default: `pmi`.
- Verbs support exists and is disabled by default.
- The package exposes UCX as a dependency for the CH4/UCX configuration.

## UCX

`spack info ucx` completed successfully. Its package metadata exposes CUDA,
RDMACM and verbs options; all three are disabled by default. The command did
not resolve a preferred or safe UCX version in this site configuration, so a
UCX version must not yet be selected by assumption.
