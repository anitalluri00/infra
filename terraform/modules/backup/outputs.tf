output "backup_plan_id" {
  value = aws_backup_plan.this.id
}

output "primary_vault_arn" {
  value = aws_backup_vault.primary.arn
}

output "dr_vault_arn" {
  value = try(aws_backup_vault.dr[0].arn, null)
}

output "backup_role_arn" {
  value = aws_iam_role.backup.arn
}
