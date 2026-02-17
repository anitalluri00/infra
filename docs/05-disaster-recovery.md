# 05. Disaster Recovery

## DR Strategy

- Model: Active-Passive (warm standby)
- Primary: AWS Region A
- DR: AWS Region B
- Trigger: Route53 health-check driven DNS failover + runbook execution

## DR Targets

- RTO: 60 minutes
- RPO: 15 minutes

## Replication Architecture

- PostgreSQL: Cross-region read replica (streaming replication)
- Redis: Global replication group (primary + DR secondary)
- S3: Cross-region replication with versioning enabled
- Container images: ECR replication policy (recommended)

## Automated Failover Controls

- Route53 failover record sets with health checks
- Kubernetes rollout promotion controls in DR cluster
- Jenkins DR pipeline for infrastructure and app failover steps

## Manual Control Gates

- SOC/SRE approval before final DNS cutover (policy driven)
- Compliance validation checklist for incident closure

## DR Drill Cadence

- Quarterly controlled failover drill
- Annual full-region simulation
- Post-drill action tracking and remediation ownership

## Drill Automation

- Jenkins pipeline: `cicd/Jenkinsfile.dr-drill`
- Execution script: `cicd/scripts/dr_drill.sh`
- Evidence artifact: `dr-drill-report.txt`
