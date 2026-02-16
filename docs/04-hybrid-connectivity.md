# 04. Hybrid Connectivity

## Connectivity Method

Terraform module: `terraform/modules/hybrid_connectivity`

- AWS Site-to-Site VPN
- Customer Gateway (on-prem VPN device)
- Virtual Private Gateway (AWS)
- Routed on-prem CIDR to AWS VPC
- VPN gateway route propagation to app/data route tables (private tier reachability)

## Optional Upgrade Path

- Add AWS Direct Connect for predictable throughput and lower latency
- Keep VPN as backup path for resilience

## Network Security Rules

- Only required ports opened between on-prem and cloud services
- Database and cache are not internet reachable
- Security groups restricted to known app node security groups

## Hybrid Integration Use Cases

- Department-to-MIS API integration
- Secure document transfer and archival workflows
- Internal reporting and compliance extraction
