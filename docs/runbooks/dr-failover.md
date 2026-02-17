# DR Runbook: Failover (Primary -> DR)

## Preconditions

- Major incident declared in primary region
- Incident commander approval obtained
- DR readiness checks passed

## Steps

1. Confirm primary outage via monitoring and health checks.
2. Freeze non-essential deployments.
3. Promote PostgreSQL DR read replica to writable primary.
4. Validate Redis DR replication group health.
5. Scale DR EKS workloads to production desired counts.
6. Verify secrets, configs, and ingress readiness in DR cluster.
7. Update or confirm Route53 failover to DR endpoint.
8. Run smoke tests:
   - `/health`
   - authentication
   - document upload/download
   - critical business transaction flow
9. Announce DR mode activation to stakeholders.

## Exit Criteria

- Core user journeys pass
- Error rate within accepted threshold
- Incident status updated with DR active
