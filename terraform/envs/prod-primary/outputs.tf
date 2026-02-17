output "primary_vpc_id" {
  value = module.network_primary.vpc_id
}

output "dr_vpc_id" {
  value = module.network_dr.vpc_id
}

output "eks_primary_cluster" {
  value = module.eks_primary.cluster_name
}

output "eks_dr_cluster" {
  value = module.eks_dr.cluster_name
}

output "postgres_primary_endpoint" {
  value = module.rds.primary_endpoint
}

output "postgres_dr_endpoint" {
  value = module.rds.dr_replica_endpoint
}

output "redis_primary_endpoint" {
  value = module.redis.primary_endpoint
}

output "documents_bucket" {
  value = module.storage.primary_bucket_name
}

output "documents_dr_bucket" {
  value = module.storage.dr_bucket_name
}

output "vpn_connection_id" {
  value = module.hybrid_connectivity.vpn_connection_id
}

output "waf_acl_arn" {
  value = module.security.waf_web_acl_arn
}

output "failover_fqdn" {
  value = module.dr_failover.failover_fqdn
}

output "backup_plan_id" {
  value = module.backup.backup_plan_id
}
