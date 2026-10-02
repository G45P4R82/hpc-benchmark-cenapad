#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTAINER_DIR="${ROOT_DIR}/container"
RECIPE="${CONTAINER_RECIPE:-${CONTAINER_DIR}/recipe.py}"
FORMAT="${1:-singularity}"

command -v hpccm >/dev/null 2>&1 || { echo 'hpccm nao encontrado' >&2; exit 1; }

case "$FORMAT" in
    singularity)
        hpccm --recipe "$RECIPE" --format singularity > "${CONTAINER_DIR}/Singularity.def"
        printf 'Generated %s\n' "${CONTAINER_DIR}/Singularity.def"
        if command -v apptainer >/dev/null 2>&1 && [[ "${BUILD_IMAGE:-0}" == 1 ]]; then
            apptainer build "${CONTAINER_DIR}/osu-mpich-ucx.sif" "${CONTAINER_DIR}/Singularity.def"
        fi
        ;;
    docker)
        hpccm --recipe "$RECIPE" --format docker > "${CONTAINER_DIR}/Dockerfile"
        printf 'Generated %s\n' "${CONTAINER_DIR}/Dockerfile"
        ;;
    *)
        echo "Uso: $0 [singularity|docker]" >&2
        exit 2
        ;;
esac
