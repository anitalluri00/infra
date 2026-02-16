# 03. AWS Cloud Architecture

## VPC Segmentation
Implemented in `terraform/modules/network`:
- DMZ/Public subnets across 3 AZs
- Private app subnets across 3 AZs
- Private data subnets across 3 AZs
- NAT gateways for private egress, no direct internet ingress to private/data tiers

## Request Path
1. Internet traffic enters through internet-facing edge load balancer/WAF.
2. Traffic is forwarded to Kubernetes ingress/app load balancing layer.
3. Ingress routes to FastAPI/React services in EKS.

Relevant files:
- `helm-values/ingress-nginx-values.yaml`
- `kubernetes/base/ingress/citizen-portal-ingress.yaml`
- `terraform/modules/security/main.tf`

## Compute Layer
- EKS primary cluster (`terraform/modules/eks`)
- Multi-AZ worker node groups
- Kubernetes HPA + PDB + topology spread constraints

## Data Layer
- PostgreSQL Multi-AZ primary + cross-region read replica (`terraform/modules/rds`)
- Redis multi-AZ replication group + global replication to DR (`terraform/modules/redis`)
- S3 document bucket with cross-region replication (`terraform/modules/storage`)

## Governance Layer
- CloudTrail, KMS, GuardDuty, and WAF (`terraform/modules/security`)
- CloudWatch alarms + SNS notifications (`terraform/modules/monitoring`)
