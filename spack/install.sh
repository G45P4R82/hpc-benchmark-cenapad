#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_DIR="${SPACK_ENV_DIR:-${ROOT_DIR}/spack/env}"
ENV_NAME="${SPACK_ENV_NAME:-cenapad-mpich-ucx}"
MPICH_SPEC="${MPICH_SPEC:?Defina MPICH_SPEC apos consultar: spack info mpich}"

command -v spack >/dev/null 2>&1 || { echo 'spack nao encontrado' >&2; exit 1; }
mkdir -p "$ENV_DIR"

if [[ ! -f "$ENV_DIR/spack.yaml" ]]; then
    spack env create -d "$ENV_DIR" "$ENV_NAME"
fi

spack env activate "$ENV_DIR"
spack add "$MPICH_SPEC"
spack concretize -f
spack spec "$MPICH_SPEC" | tee "$ROOT_DIR/spack/concretized-spec.txt"
spack install --fail-fast 2>&1 | tee "$ROOT_DIR/spack/install.log"
spack find -lv | tee "$ROOT_DIR/spack/installed.txt"
spack env deactivate

printf '\nSpack environment created at %s\n' "$ENV_DIR"
printf 'Commit spack.yaml, spack.lock, concretized-spec.txt and installed.txt after review.\n'
