# Native and Container OSU Comparison

The native and container jobs each completed three repetitions on two PBS
nodes using OSU 7.5.2, MPICH 4.1.1 `ch4:ofi`/libfabric and message sizes up
to 1 MiB. Parameters were `-m 1:1048576 -x 10 -i 100`.

At 1 MiB, parsed with `scripts/parse_osu.py`:

| Scenario | Benchmark | Mean | Std. dev. | Range |
|---|---|---:|---:|---:|
| Native | osu_bw | 3250.81 MB/s | 10.86 | 3239.02--3260.40 |
| Container | osu_bw | 2842.40 MB/s | 590.40 | 2244.71--3425.24 |
| Native | osu_latency | 410.16 us | 45.00 | 381.32--462.01 |
| Container | osu_latency | 402.26 us | 32.05 | 365.48--424.21 |

The container bandwidth mean was approximately 12.56% lower than native at
1 MiB. Container latency was approximately 1.93% lower, within the observed
variability. The bandwidth variability was much higher in the container
sample.

The container was an Ubuntu 24.04 base SIF with host MPICH, libfabric, RDMA
and OSU paths bound explicitly. It was not a self-contained image. These are
pilot results with CH4:OFI/libfabric, not MPICH CH4:UCX, and do not replace
the original full-range three-repeat experiment.
