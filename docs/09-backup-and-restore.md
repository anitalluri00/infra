# 09. Backup and Restore

## Backup Strategy

- PostgreSQL (RDS)
  - Automated backups enabled (14 days)
  - Cross-region replica for DR
  - Snapshot policy before major changes
  - AWS Backup policy managed as code (`terraform/modules/backup`)

- Redis (ElastiCache)
  - Daily snapshots
  - Multi-AZ automatic failover
  - Global replication for DR region

- S3 Documents
  - Versioning enabled
  - Cross-region replication enabled
  - Lifecycle to lower-cost archival tiers
  - AWS Backup selection for immutable recovery points

- Kubernetes
  - etcd snapshots (if self-managed control planes)
  - Manifest/IaC in Git as source of truth

## Restore Sequence

1. Restore database from latest snapshot or promote DR replica.
2. Restore cache baseline snapshot if needed.
3. Validate object store replication consistency.
4. Redeploy app workloads from immutable images.
5. Run smoke/regression checks and reopen traffic.

## Backup IaC Artifacts

- `terraform/modules/backup/main.tf`
- `terraform/envs/prod-primary/main.tf` (backup module wiring)
