# 01. Architecture Overview

## Target Pattern

- Deployment model: Hybrid Active-Passive
- Primary site: AWS primary region (production traffic)
- Secondary site: AWS DR region (warm standby)
- On-prem: Department integrations, legacy systems, private services
- Connectivity: Site-to-Site VPN (expandable to Direct Connect)

## High-Level Flow

1. Citizen traffic enters edge through internet-facing NLB + WAF protections.
2. Traffic reaches app ingress (NGINX Ingress Controller) in EKS.
3. Ingress routes to FastAPI backend and React frontend rollouts.
4. Backend uses PostgreSQL (RDS Multi-AZ), Redis HA, and S3 object storage.
5. DR region receives continuous data replication (DB, Redis, S3).
6. Route53 health checks trigger DNS failover when primary is unhealthy.

## SLA and Reliability Targets

- SLA: 99.9% uptime
- RTO: 60 minutes
- RPO: 15 minutes
- Pattern: Active-Passive with automated DNS failover + documented failover/failback runbooks

## Core Availability Controls

- Multi-AZ subnets, EKS nodes, RDS, Redis
- HPA for stateless services (backend/frontend/workers)
- Pod anti-affinity + PodDisruptionBudget
- No single point of failure in networking, compute, and data tiers

