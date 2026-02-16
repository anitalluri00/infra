output "failover_fqdn" {
  value = local.enable_dns ? var.domain_name : null
}

output "primary_health_check_id" {
  value = try(aws_route53_health_check.primary[0].id, null)
}
