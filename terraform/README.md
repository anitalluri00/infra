# Terraform Design

## Environments

- `envs/prod-primary`: Primary region + DR region resources in one state (recommended for this assessment)
- `envs/prod-dr`: Standalone DR cluster deployment state (optional isolated operations)

## Modules

- `network`: Segmented VPC with DMZ, app, and data subnets across 3 AZs
- `eks`: Multi-AZ EKS clusters for primary and DR
- `rds`: PostgreSQL Multi-AZ + cross-region read replica
- `redis`: ElastiCache Redis HA + global replication for DR
- `storage`: S3 object storage + cross-region replication
- `backup`: AWS Backup vaults/plans/selections with cross-region copy
- `hybrid_connectivity`: Site-to-Site VPN for on-prem integration
- `security`: WAF, CloudTrail, KMS, GuardDuty, Security Hub
- `dr`: Route53 health-check based automated DNS failover
- `monitoring`: CloudWatch alarms + SNS alerting

## Notes

- Replace sample account IDs, ARNs, domains, and backend state settings.
- Configure provider credentials via IAM role federation (recommended) or environment variables.
- Provide `app_jwt_public_key` in `terraform/envs/prod-primary/terraform.tfvars` (no insecure default is used).
