# Inventory Limitations

The inventory now contains two distinct compute nodes and a successful PBS
allocation. All public files are sanitized.

## Observable data

- Two-node PBS allocation with scatter:exclhost.
- PBS 22.05.11 and /opt/pbs/bin/mpiexec.
- InfiniBand, UCX, GCC, Singularity and per-node environment data.
- Spack 0.20.0.dev0, MPICH metadata and UCX metadata.

## Still pending or not observable

- The RDMA/OFED job 1027401.ada is still queued. Its output must provide
  libmlx5, libibverbs, librdmacm, headers, paths, driver and firmware details.
- The MPICH concretization job is still running; no install has been done.
- Administrative policy for fakeroot, build services and container binds is
  not observable with the user account. This is documented as unknown rather
  than invented.

No benchmark, installation, OSU compilation or container build was performed.
