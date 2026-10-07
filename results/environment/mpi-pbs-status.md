# MPI and PBS Collection Status

The corrected job `1027757.ada` completed with `Exit_status=0`.

- Queue: `paralela`.
- Allocation: two chunks of 128 CPUs.
- Placement: `scatter:exclhost`.
- Two distinct compute nodes were allocated and collected.
- SSH collection used `StrictHostKeyChecking=no` and an isolated known-hosts file because the first attempt failed on host-key verification.

The first attempt obtained two nodes but did not collect their data. Its zero exit status was not evidence of success because the script tolerated SSH failures. The corrected job is the authoritative two-node inventory.

No MPI communication benchmark was run.
