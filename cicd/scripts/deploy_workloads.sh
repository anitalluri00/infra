#!/usr/bin/env bash
set -euo pipefail

OVERLAY=${1:-aws}

if [[ "${OVERLAY}" != "aws" && "${OVERLAY}" != "onprem" ]]; then
  echo "Usage: $0 [aws|onprem]" >&2
  exit 1
fi

kubectl apply -k "kubernetes/overlays/${OVERLAY}"

echo "Workloads applied using overlay: ${OVERLAY}"
