#!/usr/bin/env bash
set -euo pipefail

MODE="${1:?usage: blue_green_deploy.sh <preview|promote> <namespace> <tag>}"
NAMESPACE="${2:?missing namespace}"
TAG="${3:?missing image tag}"
REGISTRY="${REGISTRY:-123456789012.dkr.ecr.us-east-1.amazonaws.com}"

BACKEND_IMAGE="${REGISTRY}/mis/backend:${TAG}"
FRONTEND_IMAGE="${REGISTRY}/mis/frontend:${TAG}"

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is required" >&2
  exit 1
fi

if ! kubectl argo rollouts version >/dev/null 2>&1; then
  echo "kubectl-argo-rollouts plugin not found" >&2
  exit 1
fi

if [[ "${MODE}" == "preview" ]]; then
  kubectl -n "${NAMESPACE}" argo rollouts set image backend backend="${BACKEND_IMAGE}"
  kubectl -n "${NAMESPACE}" argo rollouts set image frontend frontend="${FRONTEND_IMAGE}"
  kubectl -n "${NAMESPACE}" argo rollouts get rollout backend --watch
  kubectl -n "${NAMESPACE}" argo rollouts get rollout frontend --watch
elif [[ "${MODE}" == "promote" ]]; then
  kubectl -n "${NAMESPACE}" argo rollouts promote backend
  kubectl -n "${NAMESPACE}" argo rollouts promote frontend
else
  echo "Invalid mode: ${MODE}. expected preview or promote" >&2
  exit 1
fi
