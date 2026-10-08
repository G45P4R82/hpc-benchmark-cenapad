# Two-node MPI and PBS Inventory

The corrected PBS job completed with `Exit_status=0` using two distinct
compute nodes. Hostnames are represented as `node0` and `node1` here to keep
the public record sanitized.

PBS queue: `paralela`
PBS allocation: two chunks of 128 CPUs
Placement: `scatter:exclhost`
PBS version: 22.05.11

Both nodes reported:

- InfiniBand port ACTIVE, LinkUp, 100 Gb/s, InfiniBand link layer.
- Firmware version 20.43.3608.
- UCX 1.15.0 with RDMA devices visible.
- `/opt/pbs/bin/mpiexec` available.
- `mpirun` and `mpiexec.hydra` were not found.
- Singularity 3.8.5-2.el8 available; Apptainer was not found.

The first attempt obtained two nodes but failed SSH host-key verification.
The corrected job used an isolated known-hosts configuration and completed
