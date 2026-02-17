#!/usr/bin/env bash
set -euo pipefail

mkdir -p scan-reports

if ! command -v trivy >/dev/null 2>&1; then
  echo "trivy not found; install trivy in Jenkins agent" >&2
  exit 1
fi

if [[ "$#" -lt 1 ]]; then
  echo "usage: container_scan.sh <image> [image...]" >&2
  exit 1
fi

for image in "$@"; do
  report_name=$(echo "$image" | tr '/:' '__')
  trivy image --severity CRITICAL,HIGH --no-progress --exit-code 1 "$image" | tee "scan-reports/${report_name}.txt"
done
