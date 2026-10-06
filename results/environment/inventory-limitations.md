# Inventory Limitations

This PR records the sanitized information collected before installation or
benchmarking.

## Successful collection

- One compute-node job in `testes` completed with `Exit_status=0`.
- AlmaLinux 8.10, GCC 8.5.0 and AMD EPYC 7443 were recorded.
- InfiniBand `mlx5_0`, port ACTIVE/LINK_UP, 100 Gb/s, firmware 20.43.3608.
- UCX 1.15.0 detected `rc_mlx5`, `dc_mlx5` and `ud_mlx5`.
- RDMA userspace packages were version 48.0-1.el8.x86_64.

## Problems

- The two-node parexp job waited for resources and exceeded its walltime.
- PBS assigned the same host to both chunks, so it was not two-node evidence.
- The testes queue repeatedly selected the same shared compute node.
- Host requests for other nodes were rejected by the testes Qlist.
- `module avail` blocked one diagnostic job and was removed from the run.
- `ibv_devinfo`, `ofed_info` and Spack were unavailable on the node.

## Consequence

