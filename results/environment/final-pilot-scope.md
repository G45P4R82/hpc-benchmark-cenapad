# Final Pilot Scope

This phase delivers a reproducible pilot comparing native and container
execution on two PBS nodes. It is not the original full-range CH4/UCX study.

## Executed

- Native job: `1028628.ada`.
- Container job: `1028771.ada`.
- Three repetitions per scenario.
- OSU Micro-Benchmarks: 7.5.2.
- Parameters: `-m 1:1048576 -x 10 -i 100`.
- Message range: 1 byte through 1 MiB.
- MPI: MPICH 4.1.1 `ch4:ofi` with libfabric.
- Two-node placement: PBS `paralela`, `scatter:exclhost`.

## Results at 1 MiB

| Scenario | Benchmark | Mean | Std. dev. | Range |
|---|---|---:|---:|---:|
| Native | osu_bw | 3250.81 MB/s | 10.86 | 3239.02--3260.40 |
| Container | osu_bw | 2842.40 MB/s | 590.40 | 2244.71--3425.24 |
| Native | osu_latency | 410.16 us | 45.00 | 381.32--462.01 |
| Container | osu_latency | 402.26 us | 32.05 | 365.48--424.21 |

The container bandwidth mean was 12.56% lower than native. Container latency
was 1.93% lower, within the observed variability. Container bandwidth was
considerably more variable in this sample.

## Limitations

- The available MPICH module is `ch4:ofi`/libfabric, not `ch4:ucx`.
- The container is an Ubuntu 24.04 base SIF with host MPICH, libfabric, RDMA
  and OSU paths bound explicitly; it is not self-contained.
- The full 64 MiB range with the original iteration count did not progress in
  this CH4:OFI setup, so the delivered pilot is limited to 1 MiB.
- The exact MOFED version was not observable with the user account.
- These results must not be presented as the original full-range UCX study.
