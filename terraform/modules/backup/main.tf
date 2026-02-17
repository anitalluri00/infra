terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.dr]
    }
  }
}

locals {
  common_tags = merge(var.tags, {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

data "aws_iam_policy_document" "backup_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "backup" {
  name               = "${var.project}-${var.environment}-backup-role"
  assume_role_policy = data.aws_iam_policy_document.backup_assume_role.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "backup_policy" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role_policy_attachment" "restore_policy" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}

resource "aws_iam_role_policy_attachment" "s3_backup_policy" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Backup"
}

resource "aws_iam_role_policy_attachment" "s3_restore_policy" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Restore"
}

resource "aws_backup_vault" "primary" {
  name = "${var.project}-${var.environment}-backup-vault"

  tags = local.common_tags
}

resource "aws_backup_vault" "dr" {
  provider = aws.dr
  count    = var.copy_to_dr ? 1 : 0

  name = "${var.project}-${var.environment}-backup-vault-dr"

  tags = merge(local.common_tags, {
    Tier = "dr"
  })
}

resource "aws_backup_plan" "this" {
  name = "${var.project}-${var.environment}-backup-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.primary.name
    schedule          = var.daily_schedule
    start_window      = 60
    completion_window = 180

    lifecycle {
      delete_after = var.daily_delete_after_days
    }

    dynamic "copy_action" {
      for_each = var.copy_to_dr ? [1] : []
      content {
        destination_vault_arn = aws_backup_vault.dr[0].arn

        lifecycle {
          delete_after = var.copy_delete_after_days
        }
      }
    }
  }

  rule {
    rule_name         = "weekly-backup"
    target_vault_name = aws_backup_vault.primary.name
    schedule          = var.weekly_schedule
    start_window      = 120
    completion_window = 360

    lifecycle {
      delete_after = var.weekly_delete_after_days
    }

    dynamic "copy_action" {
      for_each = var.copy_to_dr ? [1] : []
      content {
        destination_vault_arn = aws_backup_vault.dr[0].arn

        lifecycle {
          delete_after = var.copy_delete_after_days
        }
      }
    }
  }

  tags = local.common_tags
}

resource "aws_backup_selection" "this" {
  iam_role_arn = aws_iam_role.backup.arn
  name         = "${var.project}-${var.environment}-selection"
  plan_id      = aws_backup_plan.this.id
  resources    = var.protected_resource_arns

  depends_on = [
    aws_iam_role_policy_attachment.backup_policy,
    aws_iam_role_policy_attachment.restore_policy,
    aws_iam_role_policy_attachment.s3_backup_policy,
    aws_iam_role_policy_attachment.s3_restore_policy
  ]
}
