output "primary_replication_group_id" {
  value = aws_elasticache_replication_group.primary.id
}

output "primary_endpoint" {
  value = aws_elasticache_replication_group.primary.primary_endpoint_address
}

output "reader_endpoint" {
  value = aws_elasticache_replication_group.primary.reader_endpoint_address
}

output "global_replication_group_id" {
  value = try(aws_elasticache_global_replication_group.this[0].global_replication_group_id, null)
}

output "dr_replication_group_id" {
  value = try(aws_elasticache_replication_group.dr_secondary[0].id, null)
}

output "credentials_secret_arn" {
  value = aws_secretsmanager_secret.redis_credentials.arn
}

output "connection_uri" {
  value = "rediss://default:${random_password.auth_token.result}@${aws_elasticache_replication_group.primary.primary_endpoint_address}:6379/0"
}
