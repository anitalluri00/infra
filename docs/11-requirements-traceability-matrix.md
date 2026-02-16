# 11. Requirement Traceability Matrix

| Requirement | Implementation Artifact |
|-------------|--------------------------|
| Segmented VPC (DMZ + Private) | `terraform/modules/network/*` |
| Internet LB -> App LB -> Kubernetes | `helm-values/ingress-nginx-values.yaml`, `kubernetes/base/ingress/citizen-portal-ingress.yaml` |
| Kubernetes orchestration | `terraform/modules/eks/*`, `kubernetes/base/*` |
| HA PostgreSQL + replication | `terraform/modules/rds/*` |
| Redis HA + failover | `terraform/modules/redis/*` |
| Centralized object storage | `terraform/modules/storage/*` |
| Firewall + WAF edge | `terraform/modules/security/*` |
| Multi-AZ across tiers | `terraform/modules/network/*`, `terraform/modules/eks/*`, `terraform/modules/rds/*`, `terraform/modules/redis/*` |
| Stateless apps + HPA | `kubernetes/base/app/*`, `kubernetes/base/autoscaling/*` |
| No SPOF | Multi-AZ architecture in Terraform modules and PDB/HPA manifests |
| RTO/RPO defined | `docs/05-disaster-recovery.md` |
| Active-Passive DR | `docs/05-disaster-recovery.md`, `terraform/modules/dr/*` |
| Cross-region replication | `terraform/modules/rds/*`, `terraform/modules/redis/*`, `terraform/modules/storage/*` |
| Automated failover | `terraform/modules/dr/*`, `docs/runbooks/dr-failover.md` |
| DR runbooks and drills | `docs/runbooks/*` |
| IAM + RBAC least privilege | `terraform/modules/eks/*`, `kubernetes/base/rbac/*` |
| Secrets Manager / Vault | `kubernetes/base/secrets/*`, `kubernetes/overlays/onprem/*` |
| TLS everywhere | `kubernetes/base/ingress/citizen-portal-ingress.yaml`, helm TLS configs |
| WAF + DDoS | `terraform/modules/security/*` |
| Zero-trust networking | `kubernetes/base/networkpolicies/*` |
| Centralized audit logs | `terraform/modules/security/*`, `helm-values/*` (ELK) |
| Jenkins CI | `cicd/Jenkinsfile`, `cicd/Jenkinsfile.terraform` |
| Docker build + scanning | `cicd/Jenkinsfile`, `cicd/scripts/container_scan.sh` |
| Blue-Green deploys | `kubernetes/base/app/*rollout.yaml`, `cicd/scripts/blue_green_deploy.sh` |
| Terraform IaC pipeline | `cicd/Jenkinsfile.terraform`, `cicd/scripts/terraform_plan_apply.sh` |
| DR drill automation | `cicd/Jenkinsfile.dr-drill`, `cicd/scripts/dr_drill.sh` |
| Prometheus + Grafana | `helm-values/kube-prometheus-stack-values.yaml` |
| ELK stack | `helm-values/elasticsearch-values.yaml`, `helm-values/logstash-values.yaml`, `helm-values/kibana-values.yaml`, `helm-values/fluent-bit-values.yaml` |
| Distributed tracing | `helm-values/jaeger-values.yaml` |
| SLO alerting | `terraform/modules/monitoring/*`, `docs/08-monitoring-and-observability.md` |
| 1,000 users + 5-year growth | `docs/10-capacity-and-cost.md` |
| High-level AWS cost estimate | `docs/10-capacity-and-cost.md` |
| Backup as code | `terraform/modules/backup/*`, `docs/09-backup-and-restore.md` |
