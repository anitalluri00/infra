# DR Runbook: Failback (DR -> Primary)

## Preconditions

- Primary region restored and validated
- Change window approved
- Data reconciliation plan approved

## Steps

1. Enable replication back from DR primary to restored primary.
2. Validate data consistency checkpoints.
3. Deploy and warm primary app stacks.
4. Execute controlled traffic shift (canary -> full).
5. Monitor latency, error rates, and transaction integrity.
6. Once stable, return Route53 primary failover role.
7. Scale DR back to warm standby footprint.
8. Publish post-incident report and corrective actions.
