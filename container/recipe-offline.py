#!/usr/bin/env python3
"""Offline HPCCM recipe.

All files under ``bundle`` must be supplied by the cluster operator. This
recipe intentionally has no network access, package-manager calls, or URLs.
"""
from hpccm.primitives import baseimage, copy, environment, shell


def arg(name, default):
    return USERARG.get(name, default)


base = arg("base", "ubuntu:24.04")
bundle = arg("bundle", "container/offline-bundle")
prefix = "/opt/cenapad"

Stage0 += baseimage(image=base)
Stage0 += copy(
    src=[
        f"{bundle}/runtime",
        f"{bundle}/mpich",
        f"{bundle}/ucx",
        f"{bundle}/osu",
        f"{bundle}/rdma",
    ],
    dest=f"{prefix}/",
)
Stage0 += shell(
    commands=[
        "set -eux",
        f"test -x {prefix}/mpich/bin/mpiexec || test -x {prefix}/mpich/bin/mpicc",
        f"test -d {prefix}/ucx || true",
        f"test -x {prefix}/osu/bin/osu_bw || find {prefix}/osu -type f -name osu_bw -print -quit",
        f"test -d {prefix}/rdma || true",
    ]
)
Stage0 += environment(
    variables={
        "CENAPAD_PREFIX": prefix,
        "PATH": f"{prefix}/osu/bin:{prefix}/mpich/bin:{prefix}/ucx/bin:$PATH",
        "LD_LIBRARY_PATH": f"{prefix}/mpich/lib:{prefix}/ucx/lib:{prefix}/rdma/lib:$LD_LIBRARY_PATH",
        "UCX_TLS": "rc,ud,sm,self",
    }
)
