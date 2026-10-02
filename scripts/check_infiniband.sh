#!/usr/bin/env bash
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${1:-${ROOT_DIR}/results/environment}"
mkdir -p "$OUT_DIR"
OUT_FILE="${OUT_DIR}/infiniband-$(hostname -s)-$(date -u +%Y%m%dT%H%M%SZ).txt"

capture() {
    printf '\n===== %s =====\n' "$1" | tee -a "$OUT_FILE"
    shift
    if command -v "$1" >/dev/null 2>&1; then
        "$@" 2>&1 | tee -a "$OUT_FILE" || true
    else
        printf 'NOT FOUND: %s\n' "$1" | tee -a "$OUT_FILE"
    fi
}

printf 'collection_utc=%s\nhostname=%s\n' "$(date -u +%FT%TZ)" "$(hostname -f 2>/dev/null || hostname)" | tee "$OUT_FILE"
capture 'IB status' ibstat
capture 'IB device information' ibv_devinfo
capture 'RDMA link information' rdma link
capture 'UCX devices and transports' ucx_info -d
capture 'UCX version and build configuration' ucx_info -v
capture 'libfabric providers' fi_info
capture 'network interfaces' ip -br link

printf '\nSaved InfiniBand diagnostics to %s\n' "$OUT_FILE"
