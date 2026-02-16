# 10. Capacity and Cost Model

## Baseline Capacity for 1,000 Concurrent Users

Assumptions:
- 1,000 concurrent users
- Peak 1,200 API requests/sec burst
- Average 300-500 API requests/sec
- 20% headroom for incident and patch windows

Baseline deployment:
- EKS primary: 6 x m6i.xlarge worker nodes
- EKS DR: 2 x m6i.large worker nodes (warm standby)
- RDS PostgreSQL: Multi-AZ db.r6g.large-class baseline
- Redis: 3-node Multi-AZ replication group
- Object storage: 5 TB active + versioned history

## 5-Year Horizontal Scalability Model

| Year | Concurrent Users | App Pods (Peak) | Worker Pods (Peak) | DB Class Target | Notes |
|------|------------------|-----------------|--------------------|-----------------|-------|
| Y1 | 1,000 | 40 | 30 | db.r6g.large | Initial production |
| Y2 | 1,500 | 60 | 45 | db.r6g.xlarge | Department onboarding |
| Y3 | 2,200 | 90 | 60 | db.r6g.2xlarge | API ecosystem growth |
| Y4 | 3,200 | 130 | 90 | db.r6g.2xlarge + read scaling | Heavy analytics and integrations |
| Y5 | 5,000 | 200 | 140 | Sharded/read-heavy architecture | Multi-cluster and partitioning |

## High-Level AWS Cost Estimate (USD/month)

Estimate date: February 16, 2026
Region basis: US East (N. Virginia) primary + US West DR warm standby
Pricing model: On-Demand baseline, excludes enterprise discounts/Savings Plans

| Cost Area | Estimated Monthly Range |
|-----------|-------------------------|
| EKS control planes + worker compute | $3,500 - $6,500 |
| RDS PostgreSQL Multi-AZ + backup | $1,200 - $2,800 |
| Redis HA + global replication | $900 - $2,200 |
| S3 storage + replication + requests | $400 - $1,200 |
| Load balancing, NAT, VPN, data transfer | $800 - $2,000 |
| Security services (WAF/GuardDuty/CloudTrail/KMS) | $300 - $1,200 |
| Observability (Prometheus/Grafana/ELK/CloudWatch) | $1,000 - $3,500 |
| CI/CD and image registry | $200 - $800 |
| **Total** | **$8,300 - $20,200 / month** |

For exact production pricing, use AWS Pricing Calculator with measured traffic, log ingestion, and data transfer profiles.

## Pricing Reference Sources (Checked on February 16, 2026)

- Amazon EKS pricing: https://aws.amazon.com/eks/pricing/
- Amazon EC2 pricing: https://aws.amazon.com/ec2/pricing/
- Amazon RDS for PostgreSQL pricing: https://aws.amazon.com/rds/postgresql/pricing/
- Amazon ElastiCache pricing: https://aws.amazon.com/elasticache/pricing/
- Amazon S3 pricing: https://aws.amazon.com/s3/pricing/
- Amazon VPC pricing (NAT Gateway): https://aws.amazon.com/vpc/pricing/
- AWS WAF pricing: https://aws.amazon.com/waf/pricing/
- AWS Pricing Calculator: https://docs.aws.amazon.com/pricing-calculator/latest/userguide/what-is-pricing-calculator.html

## Public Pricing References (checked on February 16, 2026)

- EKS pricing (cluster management fee model): https://aws.amazon.com/eks/pricing/
- VPC NAT Gateway pricing (hourly + data processing): https://aws.amazon.com/vpc/pricing/
- AWS WAF pricing model (web ACL, rules, requests): https://aws.amazon.com/waf/pricing/
- CloudWatch pricing examples: https://aws.amazon.com/cloudwatch/pricing/
