#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash terraform/scripts/bootstrap_backend.sh <prod-primary|prod-dr>

Optional environment variables:
  STATE_BUCKET   Override the S3 bucket name for Terraform state.
  STATE_REGION   Override the backend bucket region.
EOF
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

ENVIRONMENT="$1"
case "${ENVIRONMENT}" in
  prod-primary)
    DEFAULT_REGION="us-east-1"
    ;;
  prod-dr)
    DEFAULT_REGION="us-west-2"
    ;;
  *)
    echo "Unsupported environment: ${ENVIRONMENT}"
    usage
    exit 1
    ;;
esac

if ! command -v aws >/dev/null 2>&1; then
  echo "aws CLI is required."
  exit 1
fi

if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform CLI is required."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ENV_DIR="${REPO_ROOT}/terraform/envs/${ENVIRONMENT}"

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
if [[ -z "${ACCOUNT_ID}" || "${ACCOUNT_ID}" == "None" ]]; then
  echo "Unable to resolve AWS account ID from current credentials."
  exit 1
fi

STATE_BUCKET="${STATE_BUCKET:-mis-terraform-state-${ACCOUNT_ID}-${ENVIRONMENT}}"
STATE_REGION="${STATE_REGION:-${DEFAULT_REGION}}"

if aws s3api head-bucket --bucket "${STATE_BUCKET}" >/dev/null 2>&1; then
  echo "State bucket exists: ${STATE_BUCKET}"
else
  echo "Creating state bucket: ${STATE_BUCKET} (${STATE_REGION})"
  if [[ "${STATE_REGION}" == "us-east-1" ]]; then
    aws s3api create-bucket \
      --bucket "${STATE_BUCKET}" \
      --region "${STATE_REGION}" >/dev/null
  else
    aws s3api create-bucket \
      --bucket "${STATE_BUCKET}" \
      --region "${STATE_REGION}" \
      --create-bucket-configuration "LocationConstraint=${STATE_REGION}" >/dev/null
  fi
fi

aws s3api put-bucket-versioning \
  --bucket "${STATE_BUCKET}" \
  --versioning-configuration Status=Enabled >/dev/null

aws s3api put-bucket-encryption \
  --bucket "${STATE_BUCKET}" \
  --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}' >/dev/null

aws s3api put-public-access-block \
  --bucket "${STATE_BUCKET}" \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true >/dev/null

terraform -chdir="${ENV_DIR}" init -reconfigure \
  -backend-config="bucket=${STATE_BUCKET}" \
  -backend-config="region=${STATE_REGION}"

cat <<EOF
Backend initialized for ${ENVIRONMENT}
  bucket: ${STATE_BUCKET}
  region: ${STATE_REGION}
EOF
