# Native OSU Smoke Test

The first corrected two-node native smoke test completed successfully in PBS
job `1028607.ada` with `Exit_status=0`.

- Queue: `paralela`.
- Placement: `scatter:exclhost`.
- Launcher: MPICH Hydra from the cluster MPICH module.
- MPICH configuration: `ch4:ofi` with libfabric.
- OSU version: 7.5.2.
- `osu_latency` and `osu_bw` both executed across two distinct nodes.

The launcher initially failed in earlier attempts because stale SSH host keys
were present. The successful job removed stale per-user keys and populated
current keys with `ssh-keyscan` before invoking Hydra.

Smoke-test results are not the final experiment. They only validate that the
native OSU binaries can start across two PBS nodes. The final three-repeat
comparison and container test remain pending.
