# 02. On-Prem Architecture

## Scope

On-prem is used for:
- Departmental systems that cannot fully move to cloud
- Internal integrations and secure file exchange
- Optional private portal access for internal staff

## On-Prem Components

- Edge firewall pair (active/standby)
- Internal load balancer (HAProxy/F5 or equivalent)
- Kubernetes cluster for local services (optional overlay: `kubernetes/overlays/onprem`)
- PostgreSQL read-only mirror (optional reporting tier)
- Redis local cache/sentinel (optional)
- Vault for secrets if local-only workloads require non-AWS secret backend

Reference Helm values for on-prem data services:
- `helm-values/postgresql-ha-values.yaml`
- `helm-values/redis-ha-values.yaml`
- `helm-values/minio-values.yaml`

## Security Controls

- Segmented VLANs / micro-segmentation
- Zero-trust east-west filtering
- Private CA for internal TLS
- SIEM forwarding to centralized audit stack

## Hybrid Operations Model

- Cloud remains system of record for primary workload.
- On-prem services integrate via VPN with strict allowlists.
- Data synchronization to on-prem is one-way where required by policy.
