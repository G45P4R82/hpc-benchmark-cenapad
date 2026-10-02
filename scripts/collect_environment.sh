#!/usr/bin/env bash
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${1:-${ROOT_DIR}/results/environment}"
mkdir -p "$OUT_DIR"
OUT_FILE="${OUT_DIR}/environment-$(hostname -s)-$(date -u +%Y%m%dT%H%M%SZ).txt"

run() {
    printf '\n===== %s =====\n' "$1" | tee -a "$OUT_FILE"
    shift
    if command -v "$1" >/dev/null 2>&1; then
        "$@" 2>&1 | tee -a "$OUT_FILE" || true
    else
        printf 'NOT FOUND: %s\n' "$1" | tee -a "$OUT_FILE"
    fi
}

{
    printf 'collection_utc=%s\n' "$(date -u +%FT%TZ)"
    printf 'hostname=%s\n' "$(hostname -f 2>/dev/null || hostname)"
    printf 'user=%s\n' "${USER:-unknown}"
    printf 'pwd=%s\n' "$PWD"
    printf 'PBS_JOBID=%s\n' "${PBS_JOBID:-unset}"
    printf 'PBS_QUEUE=%s\n' "${PBS_QUEUE:-unset}"
    printf 'PBS_NODEFILE=%s\n' "${PBS_NODEFILE:-unset}"
} | tee "$OUT_FILE"

run 'operating system' bash -c 'cat /etc/os-release'
run 'kernel' uname -a
run 'architecture' lscpu
run 'GCC' gcc --version
run 'Spack' spack --version
run 'MPICH wrapper' mpicc --version
run 'MPICH version' mpichversion
run 'UCX version' ucx_info -v
run 'Apptainer version' apptainer --version
run 'Singularity version' singularity --version
run 'HPCCM version' hpccm --version
run 'OFED/RDMA packages' bash -c 'command -v ofed_info && ofed_info -s || true; command -v ibv_devinfo && ibv_devinfo -v || true'
run 'loaded modules' bash -c 'command -v module && module list 2>&1 || true'
run 'relevant environment' bash -c 'env | sort | grep -E "^(PATH|LD_LIBRARY_PATH|LIBRARY_PATH|CPATH|UCX_|MPICH_|HYDRA_|FI_|OMPI_|PBS_)" || true'

if [[ -n "${PBS_NODEFILE:-}" && -r "$PBS_NODEFILE" ]]; then
    run 'PBS node file' bash -c 'sort "$PBS_NODEFILE" | uniq -c'
fi
