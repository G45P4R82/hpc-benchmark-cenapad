#!/usr/bin/env python3
"""HPCCM recipe for a self-contained MPICH/UCX OSU benchmark image.

The exact OFED userspace source is intentionally an input. Set `ofed_url` to
the cluster-approved userspace bundle, or leave it empty to use Ubuntu RDMA
userspace packages for development only.
"""
from hpccm import Stage
from hpccm.building_blocks import apt_get
from hpccm.primitives import baseimage, environment, shell


def arg(name, default):
    return USERARG.get(name, default)


ubuntu = arg("base", "ubuntu:24.04")
gcc_version = arg("gcc", "")
ucx_version = arg("ucx", "1.18.1")
mpich_version = arg("mpich", "4.2.3")
osu_version = arg("osu", "7.5.2")
ofed_url = arg("ofed_url", "")
prefix = "/opt/cenapad"

Stage0 += baseimage(image=ubuntu)
Stage0 += apt_get(
    ospackages=[
        "build-essential",
        "ca-certificates",
        "curl",
        "file",
        "git",
        "libibverbs-dev",
        "librdmacm-dev",
        "libnuma-dev",
        "pkg-config",
        "rdma-core",
        "tar",
        "wget",
    ]
)

commands = [
    "set -eux",
    "export DEBIAN_FRONTEND=noninteractive",
    f"mkdir -p {prefix}/src {prefix}/ucx {prefix}/mpich {prefix}/osu",
]

if gcc_version:
    commands += [
        f"apt-get update && apt-get install -y gcc-{gcc_version} g++-{gcc_version} gfortran-{gcc_version}",
        f"update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-{gcc_version} 100",
        f"update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-{gcc_version} 100",
    ]

if ofed_url:
    commands += [
        f"wget -q {ofed_url} -O /tmp/ofed-userspace.tar.gz",
        "mkdir -p /tmp/ofed-userspace",
        "tar -xzf /tmp/ofed-userspace.tar.gz --strip-components=1 -C /tmp/ofed-userspace",
        "if [ -x /tmp/ofed-userspace/install.sh ]; then /tmp/ofed-userspace/install.sh --user-space-only; fi",
    ]

commands += [
    f"cd {prefix}/src",
    f"wget -q https://github.com/openucx/ucx/releases/download/v{ucx_version}/ucx-{ucx_version}.tar.gz",
    f"tar -xzf ucx-{ucx_version}.tar.gz",
    f"cd ucx-{ucx_version} && ./configure --prefix={prefix}/ucx --with-verbs --with-rdmacm",
    "make -j$(nproc) && make install",
    f"cd {prefix}/src",
    f"wget -q https://www.mpich.org/static/downloads/{mpich_version}/mpich-{mpich_version}.tar.gz",
    f"tar -xzf mpich-{mpich_version}.tar.gz",
    f"cd mpich-{mpich_version} && ./configure --prefix={prefix}/mpich --with-device=ch4:ucx --with-ucx={prefix}/ucx --with-pm=hydra",
    "make -j$(nproc) && make install",
    f"cd {prefix}/src",
    f"wget -q https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-{osu_version}.tar.gz",
    f"tar -xzf osu-micro-benchmarks-{osu_version}.tar.gz",
    f"cd osu-micro-benchmarks-{osu_version} && ./configure CC={prefix}/mpich/bin/mpicc CXX={prefix}/mpich/bin/mpicxx --prefix={prefix}/osu",
    "make -j$(nproc) && make install",
    "rm -rf /var/lib/apt/lists/* /tmp/ofed-userspace /tmp/ofed-userspace.tar.gz",
]

Stage0 += shell(commands=commands)
Stage0 += environment(
    variables={
        "CENAPAD_PREFIX": prefix,
        "PATH": f"{prefix}/osu/bin:{prefix}/mpich/bin:{prefix}/ucx/bin:$PATH",
        "LD_LIBRARY_PATH": f"{prefix}/mpich/lib:{prefix}/ucx/lib:$LD_LIBRARY_PATH",
        "UCX_TLS": "rc,ud,sm,self",
    }
)
