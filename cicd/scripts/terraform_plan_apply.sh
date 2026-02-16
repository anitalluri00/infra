#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT=${1:?"Environment is required (prod-primary|prod-dr)"}
ACTION=${2:?"Action is required (validate|plan|apply)"}

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TF_DIR="${ROOT_DIR}/terraform/envs/${ENVIRONMENT}"

if [[ ! -d "${TF_DIR}" ]]; then
  echo "Terraform env directory not found: ${TF_DIR}" >&2
  exit 1
fi

cd "${TF_DIR}"

terraform init -input=false

case "${ACTION}" in
  validate)
    terraform validate
    ;;
  plan)
    terraform plan -input=false -out=tfplan
    ;;
  apply)
    if [[ -f tfplan ]]; then
      terraform apply -input=false tfplan
    else
      terraform apply -input=false -auto-approve
    fi
    ;;
  *)
    echo "Unsupported action: ${ACTION}" >&2
    exit 1
    ;;
esac
