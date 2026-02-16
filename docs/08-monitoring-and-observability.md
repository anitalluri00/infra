# 08. Monitoring and Observability

## Stack

- Metrics: Prometheus + kube-state-metrics
- Dashboards: Grafana
- Logs: Fluent Bit -> Logstash -> Elasticsearch -> Kibana
- Tracing: Jaeger (OTLP)
- Infra alarms: CloudWatch + SNS

## SLA/SLO Alerting

- API availability SLO: >= 99.9%
- P95 API latency target: <= 500 ms
- Error budget burn alerts (fast burn and slow burn)
- DB/Redis saturation alarms
- PrometheusRule and ServiceMonitor manifests in:
  - `kubernetes/base/observability/prometheus-rules.yaml`
  - `kubernetes/base/observability/servicemonitors.yaml`

## Sample Alert Domains

- Platform availability (ingress, API, DNS)
- Database health (CPU, failover events, replica lag)
- Queue lag and worker saturation
- Security events (WAF blocks, GuardDuty findings)

## Retention

- Prometheus: 30 days in-cluster (remote write recommended for long-term)
- Logs: 90 days hot, 365+ days archived
- Traces: 7-14 days hot (policy-based)
