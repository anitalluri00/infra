# Canonical File Names

Use the files below as the official deliverables.

## Root
- `README.md`
- `Makefile`
- `FILE_INDEX.md`

## Terraform
- `terraform/README.md`
- `terraform/envs/prod-primary/backend.tf`
- `terraform/envs/prod-primary/main.tf`
- `terraform/envs/prod-primary/outputs.tf`
- `terraform/envs/prod-primary/variables.tf`
- `terraform/envs/prod-primary/versions.tf`
- `terraform/envs/prod-primary/terraform.tfvars.example`
- `terraform/envs/prod-dr/backend.tf`
- `terraform/envs/prod-dr/main.tf`
- `terraform/envs/prod-dr/outputs.tf`
- `terraform/envs/prod-dr/variables.tf`
- `terraform/envs/prod-dr/versions.tf`
- `terraform/envs/prod-dr/terraform.tfvars.example`
<<<<<<< HEAD
=======
- `terraform/scripts/bootstrap_backend.sh`
>>>>>>> 6f3b0ea (Local changes before pull)

Modules:
- `terraform/modules/network/*`
- `terraform/modules/eks/*`
- `terraform/modules/rds/*`
- `terraform/modules/redis/*`
- `terraform/modules/storage/*`
- `terraform/modules/backup/*`
- `terraform/modules/hybrid_connectivity/*`
- `terraform/modules/security/*`
- `terraform/modules/dr/*`
- `terraform/modules/monitoring/*`

## Kubernetes
- `kubernetes/base/kustomization.yaml`
- `kubernetes/base/namespaces/namespaces.yaml`
- `kubernetes/base/rbac/serviceaccounts.yaml`
- `kubernetes/base/rbac/roles.yaml`
- `kubernetes/base/secrets/secretstore-aws.yaml`
- `kubernetes/base/secrets/external-secrets.yaml`
- `kubernetes/base/app/configmap.yaml`
- `kubernetes/base/app/backend-analysis-template.yaml`
- `kubernetes/base/app/backend-rollout.yaml`
- `kubernetes/base/app/frontend-rollout.yaml`
- `kubernetes/base/services/backend-services.yaml`
- `kubernetes/base/services/frontend-services.yaml`
- `kubernetes/base/workers/celery-deployment.yaml`
- `kubernetes/base/autoscaling/hpa-backend.yaml`
- `kubernetes/base/autoscaling/hpa-frontend.yaml`
- `kubernetes/base/autoscaling/hpa-celery.yaml`
- `kubernetes/base/autoscaling/pdb.yaml`
- `kubernetes/base/networkpolicies/default-deny.yaml`
- `kubernetes/base/networkpolicies/allow-ingress.yaml`
- `kubernetes/base/networkpolicies/allow-egress-data.yaml`
- `kubernetes/base/ingress/citizen-portal-ingress.yaml`
- `kubernetes/base/observability/prometheus-rules.yaml`
- `kubernetes/base/observability/servicemonitors.yaml`
- `kubernetes/overlays/aws/kustomization.yaml`
- `kubernetes/overlays/aws/patch-ingress.yaml`
- `kubernetes/overlays/aws/patch-backend-sa.yaml`
- `kubernetes/overlays/aws/patch-worker-sa.yaml`
- `kubernetes/overlays/onprem/kustomization.yaml`
- `kubernetes/overlays/onprem/patch-ingress-onprem.yaml`
- `kubernetes/overlays/onprem/patch-secretstore-vault.yaml`

## Helm Values
- `helm-values/ingress-nginx-values.yaml`
- `helm-values/argo-rollouts-values.yaml`
- `helm-values/kube-prometheus-stack-values.yaml`
- `helm-values/elasticsearch-values.yaml`
- `helm-values/logstash-values.yaml`
- `helm-values/kibana-values.yaml`
- `helm-values/fluent-bit-values.yaml`
- `helm-values/jaeger-values.yaml`
- `helm-values/external-secrets-values.yaml`
- `helm-values/vault-values.yaml`
- `helm-values/postgresql-ha-values.yaml`
- `helm-values/redis-ha-values.yaml`
- `helm-values/minio-values.yaml`

## CI/CD
- `cicd/Jenkinsfile`
- `cicd/Jenkinsfile.terraform`
- `cicd/Jenkinsfile.dr-drill`
- `cicd/scripts/container_scan.sh`
- `cicd/scripts/blue_green_deploy.sh`
- `cicd/scripts/terraform_plan_apply.sh`
- `cicd/scripts/dr_drill.sh`
- `cicd/scripts/bootstrap_platform.sh`
- `cicd/scripts/deploy_workloads.sh`

## Documentation
- `docs/00-assessment-prompt.md`
- `docs/01-architecture-overview.md`
- `docs/02-on-prem-architecture.md`
- `docs/03-aws-architecture.md`
- `docs/04-hybrid-connectivity.md`
- `docs/05-disaster-recovery.md`
- `docs/06-security-and-compliance.md`
- `docs/07-ci-cd.md`
- `docs/08-monitoring-and-observability.md`
- `docs/09-backup-and-restore.md`
- `docs/10-capacity-and-cost.md`
- `docs/11-requirements-traceability-matrix.md`
- `docs/runbooks/dr-failover.md`
- `docs/runbooks/dr-failback.md`
- `docs/runbooks/dr-drill-checklist.md`
- `docs/diagrams/hybrid-topology.mmd`
- `docs/diagrams/dr-failover.mmd`
