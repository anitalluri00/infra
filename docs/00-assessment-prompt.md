# Assessment Prompt (Verbatim)

Enterprise Hybrid Infrastructure & Disaster Recovery Design (Hands-On)
You are hired as a DevOps / Infrastructure Architect for a government-scale enterprise building a mission-critical Integrated Management Information System (MIS).

Business Context
The system must support:
- 1,000+ concurrent users
- Multiple departments and role-based access
- Web and API-based integrations
- 99.9% uptime SLA
- Data protection and audit compliance
- Hybrid deployment (On-Prem + AWS Cloud)
- Mandatory Disaster Recovery (DR)

Application Stack (Assumed)
- Backend: Containerized Python FastAPI
- Frontend: React SPA
- Database: PostgreSQL
- Cache: Redis
- Background Workers: Celery
- Object Storage: Documents and files
- Secure citizen-facing portal

You are NOT required to write application code.
You ARE required to design and implement enterprise-grade infrastructure.

Your Deliverables
You must provide:

1. Infrastructure as Code (IaC)
- Terraform for cloud and hybrid components
- Kubernetes YAML manifests
- Helm values where applicable

2. Architecture Coverage
- On-Prem Architecture
- AWS Cloud Architecture
- Hybrid Connectivity
- Disaster Recovery (DR)
- Security, CI/CD, Monitoring, Backup

3. Mandatory Architecture Requirements

Infrastructure Design
- Segmented VPC (DMZ + Private Subnets)
- Internet LB -> App LB -> Kubernetes
- Kubernetes for orchestration
- HA PostgreSQL with replication
- Redis HA with failover
- Centralized object storage
- Firewall + WAF at edge

High Availability (99.9%)
- Multi-AZ across all tiers
- Stateless apps with HPA
- DB streaming replication
- No single point of failure

Disaster Recovery
- Defined RTO and RPO
- Active-Passive or Active-Active
- Cross-region replication
- Automated failover
- DR runbooks and drills

Security
- IAM + RBAC (least privilege)
- Secrets Manager / Vault
- TLS everywhere
- WAF + DDoS protection
- Zero-trust networking
- Centralized audit logs

CI/CD
- Jenkins CI
- Docker image build and scanning
- Blue-Green Kubernetes deploys
- Terraform IaC pipeline

Monitoring & Observability
- Prometheus + Grafana
- ELK stack
- Distributed tracing
- SLA/SLO-based alerting

Capacity & Cost
- Designed for 1,000 users
- 5-year scalability model
- Horizontal scaling preferred
- High-level AWS cost estimate
