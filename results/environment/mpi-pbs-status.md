# MPI and PBS Collection Status

## First two-node allocation

Job `1027399.ada` was accepted by the `paralela` queue with two chunks of 128
CPUs and `scatter:exclhost` placement. PBS allocated two distinct compute
hosts. The allocation was therefore valid for the host-separation check.

The per-node collection did not complete because SSH host-key verification
failed for both allocated hosts. The job exited with status zero only because
the diagnostic script intentionally tolerated command failures. Its output
must not be treated as a valid MPI or node inventory.

## Corrected collection

Job `1027757.ada` repeats the same two-node collection with
`StrictHostKeyChecking=no` and an isolated known-hosts file for the allocated
hosts. It is queued in `paralela`; its output is not available yet.

## RDMA collection

Job `1027401.ada` remains queued in `parexp` for the RDMA, OFED, firmware,
driver and library-path collection.

