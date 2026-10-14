# Native OSU Final-Pilot Summary

Job `1028628.ada` completed with `Exit_status=0` using two distinct PBS nodes,
MPICH 4.1.1 `ch4:ofi`/libfabric and OSU Micro-Benchmarks 7.5.2.

Parameters used for this pilot:

    -m 1:1048576 -x 10 -i 100

Three repetitions were parsed successfully. At 1 MiB:

- `osu_bw`: mean 3250.81 MB/s, standard deviation 10.86 MB/s, range
  3239.02--3260.40 MB/s.
- `osu_latency`: mean 410.16 us, standard deviation 45.00 us, range
  381.32--462.01 us.

The original 64 MiB bandwidth run with more iterations did not progress in
this CH4:OFI module and was stopped to avoid wasting the allocation. This is
therefore a native pilot/fallback dataset, not the final host-versus-container
experiment. No container run was performed.
