#!/usr/bin/env python3
"""Offline HPCCM recipe for the observed MPICH CH4:OFI environment."""
from hpccm.primitives import baseimage, copy, environment, shell


base = "ubuntu-24.04.sif"
bundle = "/opt/cenapad/offline-bundle"
prefix = "/opt/cenapad"

Stage0 += baseimage(image=base, _bootstrap="localimage", _docker_env=False)
Stage0 += copy(
    src=[
        f"{bundle}/runtime",
        f"{bundle}/mpich",
        f"{bundle}/libfabric",
        f"{bundle}/osu",
        f"{bundle}/rdma",
    ],
    dest=f"{prefix}/",
)
Stage0 += shell(
    commands=[
        "set -eux",
        f"test -x {prefix}/mpich/bin/mpiexec || test -x {prefix}/mpich/bin/mpicc",
        f"test -d {prefix}/libfabric || true",
        f"test -x {prefix}/osu/bin/osu_bw || find {prefix}/osu -type f -name osu_bw -print -quit",
        f"test -d {prefix}/rdma || true",
    ]
)
Stage0 += environment(
    variables={
        "CENAPAD_PREFIX": prefix,
        "PATH": f"{prefix}/osu/bin:{prefix}/mpich/bin:{prefix}/libfabric/bin:$PATH",
        "LD_LIBRARY_PATH": f"{prefix}/mpich/lib:{prefix}/libfabric/lib:{prefix}/rdma/lib:$LD_LIBRARY_PATH",
    }
)
