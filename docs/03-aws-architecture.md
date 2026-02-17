# 03. AWS Cloud Architecture

## VPC Segmentation

Implemented in Terraform module: `terraform/modules/network`

- DMZ/Public Subnets (3 AZ): internet-facing load balancer tier
- Private App Subnets (3 AZ): EKS worker nodes and app tier
- Private Data Subnets (3 AZ): PostgreSQL and Redis tiers

## Traffic Pattern (Mandatory)

Internet LB -> App LB -> Kubernetes

- Internet LB: NLB created by ingress-nginx service annotations
- App LB: NGINX Ingress Controller (L7 routing)
- Kubernetes: FastAPI, React, Celery workloads in EKS

## Data Tier

- PostgreSQL: Amazon RDS PostgreSQL, Multi-AZ, encrypted, backups
- Redis: ElastiCache Redis replication group, Multi-AZ failover
- Object storage: S3 with versioning and cross-region replication

## Security Tier

- AWS WAF managed rule sets
- CloudTrail multi-region audit logs
- KMS encryption for audit and data services
- GuardDuty + Security Hub baseline

## Compute Tier

- EKS clusters (primary + DR)
- Node group autoscaling
- Kubernetes HPA and rollouts for stateless app components
