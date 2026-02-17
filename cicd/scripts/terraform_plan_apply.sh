#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT=${1:?"Environment is required (prod-primary|prod-dr)"}
ACTION=${2:?"Action is required (validate|plan|apply)"}
<<<<<<< HEAD
=======
BOOTSTRAP_BACKEND=${BOOTSTRAP_BACKEND:-true}
>>>>>>> 6f3b0ea (Local changes before pull)

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TF_DIR="${ROOT_DIR}/terraform/envs/${ENVIRONMENT}"

if [[ ! -d "${TF_DIR}" ]]; then
  echo "Terraform env directory not found: ${TF_DIR}" >&2
  exit 1
fi

<<<<<<< HEAD
cd "${TF_DIR}"

terraform init -input=false
=======
if [[ "${BOOTSTRAP_BACKEND}" == "true" ]]; then
  export STATE_BUCKET="${TF_STATE_BUCKET:-}"
  export STATE_REGION="${TF_STATE_REGION:-}"
  bash "${ROOT_DIR}/terraform/scripts/bootstrap_backend.sh" "${ENVIRONMENT}"
else
  if [[ -z "${TF_STATE_BUCKET:-}" || -z "${TF_STATE_REGION:-}" ]]; then
    echo "Set TF_STATE_BUCKET and TF_STATE_REGION when BOOTSTRAP_BACKEND=false." >&2
    exit 1
  fi

  terraform -chdir="${TF_DIR}" init -input=false -reconfigure \
    -backend-config="bucket=${TF_STATE_BUCKET}" \
    -backend-config="region=${TF_STATE_REGION}"
fi

cd "${TF_DIR}"
>>>>>>> 6f3b0ea (Local changes before pull)

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
