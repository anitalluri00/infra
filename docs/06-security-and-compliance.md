# 06. Security and Compliance

## Identity and Access

- AWS IAM least-privilege roles for Terraform, Jenkins, and workload IRSA
- Kubernetes RBAC roles scoped per namespace and service account
- Separation of duties: infra admins, platform admins, app deployers, auditors

## Secrets Management

- Primary pattern: AWS Secrets Manager + External Secrets Operator
- On-prem pattern: Vault SecretStore overlay (`kubernetes/overlays/onprem`)
- No static secrets in Git

## Network Security

- DMZ/app/data subnet segmentation
- Default deny network policies
- Explicit ingress/egress allowlists only
- Private endpoints for database/cache tiers

## Edge Protection

- AWS WAF with managed rule groups
- DDoS baseline protection through AWS Shield Standard
- TLS 1.2+ enforced on ingress

## Audit and Compliance

- CloudTrail multi-region enabled
- Centralized logs in ELK + immutable object storage backups
- KMS encryption for sensitive logs and data
- Supports compliance evidence generation for audit controls
