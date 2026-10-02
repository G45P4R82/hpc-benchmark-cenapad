#!/usr/bin/env bash
set -u

IMAGE="${1:-}"
OSU_BIN="${2:-${OSU_BW:-}}"
printf 'host=%s\n' "$(hostname -f 2>/dev/null || hostname)"
command -v mpiexec >/dev/null 2>&1 && mpiexec --version || true
command -v mpichversion >/dev/null 2>&1 && mpichversion || true
command -v mpicc >/dev/null 2>&1 && mpicc -show || true
command -v ucx_info >/dev/null 2>&1 && ucx_info -v || true

if [[ -n "$OSU_BIN" && -x "$OSU_BIN" ]]; then
    printf '\n===== host ldd %s =====\n' "$OSU_BIN"
    ldd "$OSU_BIN" || true
fi

if [[ -n "$IMAGE" ]]; then
    command -v apptainer >/dev/null 2>&1 || { echo 'apptainer not found' >&2; exit 1; }
    printf '\n===== container versions =====\n'
    apptainer exec "$IMAGE" sh -c 'command -v mpichversion && mpichversion; command -v ucx_info && ucx_info -v; env | sort | grep -E "^(PATH|LD_LIBRARY_PATH|UCX_|MPICH_)" || true'
fi
