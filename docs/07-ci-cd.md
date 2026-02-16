# 07. CI/CD Design

## Pipelines

- `cicd/Jenkinsfile`
  - Build backend/frontend images
  - Run container vulnerability scanning (Trivy)
  - Push images to ECR
  - Trigger blue-green deployment via Argo Rollouts

- `cicd/Jenkinsfile.terraform`
  - Terraform fmt/check
  - Terraform validate/plan
  - Manual approval gate
  - Terraform apply

- `cicd/Jenkinsfile.dr-drill`
  - Quarterly/adhoc DR drill automation
  - Dry-run and execute modes
  - Captures drill report as build artifact

## Deployment Strategy

- Blue-Green using Argo Rollouts
- Preview service verification before promotion
- Manual promotion for regulated environments

## Security Gates

- Build fails on HIGH/CRITICAL image vulnerabilities
- IaC validation before apply
- Manual approval for production apply

## Operational Automation Scripts

- `cicd/scripts/bootstrap_platform.sh`: Installs ingress, monitoring, logging, tracing, secrets, and vault platform services.
  - Adds/updates Helm repos and waits for required CRDs before workload deployment.
- `cicd/scripts/deploy_workloads.sh`: Applies AWS or on-prem Kubernetes overlay.
- `cicd/scripts/dr_drill.sh`: Executes DR readiness and failover drill workflow.
