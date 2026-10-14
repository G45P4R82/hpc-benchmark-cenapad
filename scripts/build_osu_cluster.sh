#!/usr/bin/env bash
set -euo pipefail

# Build OSU from a source tree already present on the cluster.
# This script intentionally has no download or package-manager command.

OSU_SOURCE_DIR="${OSU_SOURCE_DIR:?Defina OSU_SOURCE_DIR para a fonte local do OSU}"
OSU_PREFIX="${OSU_PREFIX:?Defina OSU_PREFIX para uma instalação no seu HOME}"
GCC_MODULE="${GCC_MODULE:-gcc/9.4.0}"
MPICH_MODULE="${MPICH_MODULE:-mpich/4.1.1-gcc-9.4.0}"
UCX_MODULE="${UCX_MODULE:-ucx/1.15.0}"
MANIFEST="${OSU_PREFIX}/build-manifest.txt"

if command -v module >/dev/null 2>&1; then
    module load "$GCC_MODULE"
    module load "$MPICH_MODULE"
    module load "$UCX_MODULE"
elif [[ -r /etc/profile.d/modules.sh ]]; then
    # PBS non-interactive shells may not initialize the module function.
    source /etc/profile.d/modules.sh
    module load "$GCC_MODULE"
    module load "$MPICH_MODULE"
    module load "$UCX_MODULE"
fi

command -v mpicc >/dev/null 2>&1 || { echo 'mpicc nao encontrado apos carregar modulos' >&2; exit 1; }
command -v mpicxx >/dev/null 2>&1 || { echo 'mpicxx nao encontrado apos carregar modulos' >&2; exit 1; }
[[ -d "$OSU_SOURCE_DIR" ]] || { echo "Fonte OSU ausente: $OSU_SOURCE_DIR" >&2; exit 1; }

mkdir -p "$OSU_PREFIX"
cd "$OSU_SOURCE_DIR"
if [[ ! -x configure ]]; then
    ./autogen.sh
fi
./configure CC="$(command -v mpicc)" CXX="$(command -v mpicxx)" --prefix="$OSU_PREFIX"
make -j"${PBS_NCPUS:-4}"
make install

{
    printf 'built_utc=%s\n' "$(date -u +%FT%TZ)"
    printf 'source=%s\n' "$OSU_SOURCE_DIR"
    printf 'prefix=%s\n' "$OSU_PREFIX"
    printf 'gcc_module=%s\nmpich_module=%s\nucx_module=%s\n' "$GCC_MODULE" "$MPICH_MODULE" "$UCX_MODULE"
    mpicc --version
    mpicc -show
    command -v mpichversion && mpichversion || true
    command -v ucx_info && ucx_info -v || true
    find "$OSU_PREFIX" -type f \( -name osu_bw -o -name osu_latency \) -print -exec ldd {} \;
} > "$MANIFEST" 2>&1

printf 'OSU instalado em %s\nManifesto: %s\n' "$OSU_PREFIX" "$MANIFEST"
