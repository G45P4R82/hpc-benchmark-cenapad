# Offline Bundle

This directory is a manifest only. Do not commit binaries, images, private
cluster paths, or credentials here.

The cluster operator must prepare a local bundle with this layout:

```text
offline-bundle/
├── runtime/   # Ubuntu 24.04 runtime packages or approved runtime files
├── mpich/     # MPICH 4.1.1 built with CH4/OFI and GCC 9.4.0
├── libfabric/ # libfabric used by MPICH CH4:OFI
├── osu/       # OSU Micro-Benchmarks built with the same MPICH
└── rdma/      # approved libibverbs, librdmacm and libmlx5 userspace files
```

The bundle must originate from software already available at CENAPAD. Record
checksums and source/module information in `manifest.txt`, but do not publish
private paths or credentials.

At minimum, verify before packaging:

```bash
mpichversion
ucx_info -v
find "$OSU_PREFIX" -type f \( -name osu_bw -o -name osu_latency \)
ldd "$OSU_PREFIX"/**/osu_bw
```

The `runtime` directory is needed only when the base image does not already
contain the required runtime libraries. A base Ubuntu 24.04 image must be
provided locally or by the cluster; this workflow never pulls it from the
Internet.
