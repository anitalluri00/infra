# Enterprise Hybrid Infrastructure and Disaster Recovery Design (Hands-On)

This repository implements an enterprise-grade reference architecture for a mission-critical government MIS platform with:

- Hybrid deployment: On-Prem + AWS
- 99.9% SLA target
- 1,000+ concurrent users baseline
- Mandatory DR with cross-region replication and failover
- Security, observability, CI/CD, and backup controls

## Folder Structure

```text
infra/
  terraform/
    modules/
      network/
      eks/
      rds/
      redis/
      storage/
      backup/
      hybrid_connectivity/
      security/
      dr/
      monitoring/
    envs/
      prod-primary/
      prod-dr/
  kubernetes/
    base/
      namespaces/
      rbac/
      secrets/
      app/
      workers/
      services/
      autoscaling/
      networkpolicies/
      ingress/
    overlays/
      aws/
      onprem/
  helm-values/
  cicd/
    Jenkinsfile
    Jenkinsfile.terraform
    Jenkinsfile.dr-drill
    scripts/
  docs/
    00-assessment-prompt.md
    01-architecture-overview.md
    02-on-prem-architecture.md
    03-aws-architecture.md
    04-hybrid-connectivity.md
    05-disaster-recovery.md
    06-security-and-compliance.md
    07-ci-cd.md
    08-monitoring-and-observability.md
    09-backup-and-restore.md
    10-capacity-and-cost.md
    11-requirements-traceability-matrix.md
    runbooks/
    diagrams/
  legacy/
    docs/
    kubernetes/
```

## Quick Start

1. Configure Terraform backends and `terraform.tfvars` in:
   - `terraform/envs/prod-primary/`
   - `terraform/envs/prod-dr/`
   - Set a real `app_jwt_public_key` value in `terraform/envs/prod-primary/terraform.tfvars`
2. Deploy infrastructure:
   - `cd terraform/envs/prod-primary && terraform init && terraform apply`
3. Deploy platform services (ingress/monitoring/logging/tracing/security):
   - `helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace -f helm-values/ingress-nginx-values.yaml`
   - `helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n observability --create-namespace -f helm-values/kube-prometheus-stack-values.yaml`
   - `helm upgrade --install elasticsearch elastic/elasticsearch -n observability -f helm-values/elasticsearch-values.yaml`
   - `helm upgrade --install kibana elastic/kibana -n observability -f helm-values/kibana-values.yaml`
   - `helm upgrade --install logstash elastic/logstash -n observability -f helm-values/logstash-values.yaml`
   - `helm upgrade --install jaeger jaegertracing/jaeger -n observability -f helm-values/jaeger-values.yaml`
   - `helm upgrade --install external-secrets external-secrets/external-secrets -n security --create-namespace -f helm-values/external-secrets-values.yaml`
4. Deploy workloads:
   - `kubectl apply -k kubernetes/overlays/aws`

## One-Command Ops

- Validate all artifacts:
  - `make all-check`
- Bootstrap platform services:
  - `make deploy-platform`
- Deploy workloads:
  - `make deploy-workloads`

## Validation Commands

- Terraform formatting and validation:
  - `terraform fmt -recursive terraform`
  - `cd terraform/envs/prod-primary && terraform validate`
- Kubernetes manifest validation:
  - `kubectl kustomize kubernetes/overlays/aws`

## Requirement Traceability

See:
- `docs/00-assessment-prompt.md` (prompt verbatim)
- `docs/11-requirements-traceability-matrix.md` (requirement-to-code matrix)
- `FILE_INDEX.md` (canonical file-name list for submission)
