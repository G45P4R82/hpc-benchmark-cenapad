#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTAINER_DIR="${ROOT_DIR}/container"
BUNDLE_DIR="${OFFLINE_BUNDLE:-${CONTAINER_DIR}/offline-bundle}"
RECIPE="${CONTAINER_RECIPE:-${CONTAINER_DIR}/recipe-offline.py}"
BASE_IMAGE="${BASE_IMAGE:?Defina BASE_IMAGE para uma base Ubuntu 24.04 local/aprovada}"
FORMAT="${1:-singularity}"

[[ -d "$BUNDLE_DIR" ]] || { echo "Bundle ausente: $BUNDLE_DIR" >&2; exit 1; }
for component in runtime mpich libfabric osu rdma; do
    [[ -d "$BUNDLE_DIR/$component" ]] || {
        echo "Componente ausente no bundle: $component" >&2
        exit 1
    }
done

case "$FORMAT" in
    singularity)
        command -v hpccm >/dev/null 2>&1 || { echo 'hpccm nao encontrado' >&2; exit 1; }
        hpccm --recipe "$RECIPE" --format singularity \
            --userarg "base=${BASE_IMAGE}" \
            --userarg "bundle=${BUNDLE_DIR}" \
            > "${CONTAINER_DIR}/Singularity.offline.def"
        printf 'Generated %s\n' "${CONTAINER_DIR}/Singularity.offline.def"
        if command -v apptainer >/dev/null 2>&1 && [[ "${BUILD_IMAGE:-0}" == 1 ]]; then
            apptainer build "${CONTAINER_DIR}/osu-mpich-ucx-offline.sif" \
                "${CONTAINER_DIR}/Singularity.offline.def"
        else
            printf 'Build not run: Apptainer unavailable or BUILD_IMAGE is not 1.\n'
        fi
        ;;
    docker)
        command -v hpccm >/dev/null 2>&1 || { echo 'hpccm nao encontrado' >&2; exit 1; }
        hpccm --recipe "$RECIPE" --format docker \
            --userarg "base=${BASE_IMAGE}" \
            --userarg "bundle=${BUNDLE_DIR}" \
            > "${CONTAINER_DIR}/Dockerfile.offline"
        printf 'Generated %s\n' "${CONTAINER_DIR}/Dockerfile.offline"
        ;;
    *)
        echo "Uso: $0 [singularity|docker]" >&2
        exit 2
        ;;
esac
