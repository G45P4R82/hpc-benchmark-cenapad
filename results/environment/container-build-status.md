# Container Build Status

The native OSU pilot is complete, but no SIF was built.

- Singularity on the cluster: 3.8.5-2.el8.
- Local fakeroot build attempt: failed because the user has no `/etc/subuid`
  mapping.
- Remote builder: reachable, but no authentication token is configured.
- No Ubuntu 24.04 SIF or approved offline bundle is available in the searched
  cluster paths.

The offline workflow was adjusted to the observed MPICH transport,
`CH4:OFI/libfabric`. It requires a locally supplied base image and bundle with
MPICH, libfabric, OSU, RDMA userspace and runtime files. No external image was
accepted as a substitute for the approved bundle, and no SIF or container
benchmark was fabricated.
