output "primary_instance_id" {
  value = aws_db_instance.primary.id
}

output "primary_endpoint" {
  value = aws_db_instance.primary.address
}

output "primary_instance_arn" {
  value = aws_db_instance.primary.arn
}

output "connection_uri" {
  value = "postgresql://${var.db_username}:${random_password.master.result}@${aws_db_instance.primary.address}:5432/${var.db_name}"
}

output "credentials_secret_arn" {
  value = aws_secretsmanager_secret.db_credentials.arn
}

output "dr_replica_id" {
  value = try(aws_db_instance.dr_replica[0].id, null)
}

output "dr_replica_endpoint" {
  value = try(aws_db_instance.dr_replica[0].address, null)
}
