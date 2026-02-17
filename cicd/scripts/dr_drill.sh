#!/usr/bin/env bash
set -euo pipefail

MODE="dry-run"
PRIMARY_CLUSTER="mis-prod"
DR_CLUSTER="mis-prod-dr"
PRIMARY_REGION="us-east-1"
DR_REGION="us-west-2"
NAMESPACE="mis-prod"
PORTAL_URL="https://portal.example.gov/health"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      MODE="$2"
      shift 2
      ;;
    --primary-cluster)
      PRIMARY_CLUSTER="$2"
      shift 2
      ;;
    --dr-cluster)
      DR_CLUSTER="$2"
      shift 2
      ;;
    --primary-region)
      PRIMARY_REGION="$2"
      shift 2
      ;;
    --dr-region)
      DR_REGION="$2"
      shift 2
      ;;
    --namespace)
      NAMESPACE="$2"
      shift 2
      ;;
    --portal-url)
      PORTAL_URL="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac

done

report() {
  echo "$1" | tee -a dr-drill-report.txt
}

: > dr-drill-report.txt

report "DR drill mode: ${MODE}"
report "Primary cluster: ${PRIMARY_CLUSTER} (${PRIMARY_REGION})"
report "DR cluster: ${DR_CLUSTER} (${DR_REGION})"
report "Namespace: ${NAMESPACE}"

aws eks update-kubeconfig --name "${PRIMARY_CLUSTER}" --region "${PRIMARY_REGION}" >/dev/null
PRIMARY_READY=$(kubectl -n "${NAMESPACE}" get pods --no-headers | wc -l | tr -d ' ')
report "Primary pod count: ${PRIMARY_READY}"

aws eks update-kubeconfig --name "${DR_CLUSTER}" --region "${DR_REGION}" >/dev/null
DR_READY=$(kubectl -n "${NAMESPACE}" get pods --no-headers | wc -l | tr -d ' ')
report "DR pod count before scale: ${DR_READY}"

if [[ "${MODE}" == "execute" ]]; then
  report "Scaling DR backend/frontend/celery for drill execution"
  kubectl -n "${NAMESPACE}" scale rollout backend --replicas=6
  kubectl -n "${NAMESPACE}" scale rollout frontend --replicas=4
  kubectl -n "${NAMESPACE}" scale deployment celery-worker --replicas=6

  kubectl -n "${NAMESPACE}" rollout status rollout/backend --timeout=10m
  kubectl -n "${NAMESPACE}" rollout status rollout/frontend --timeout=10m
  kubectl -n "${NAMESPACE}" rollout status deployment/celery-worker --timeout=10m

  report "Executing portal smoke test"
  if curl -sf "${PORTAL_URL}" >/dev/null; then
    report "Portal health check passed"
  else
    report "Portal health check failed"
    exit 2
  fi
else
  report "Dry-run mode: no scaling or traffic changes executed"
fi

report "DR drill completed"
