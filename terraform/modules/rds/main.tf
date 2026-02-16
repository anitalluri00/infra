terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.dr]
    }
    random = {
      source = "hashicorp/random"
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

locals {
  dr_kms_key_to_use = (
    var.create_dr_replica
    ? coalesce(var.dr_kms_key_arn, try(aws_kms_key.dr_replica[0].arn, null))
    : null
  )
}

resource "random_password" "master" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.project}/${var.environment}/postgres"
  description = "PostgreSQL master credentials"

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.master.result
    dbname   = var.db_name
    host     = aws_db_instance.primary.address
    port     = 5432
    uri      = "postgresql://${var.db_username}:${random_password.master.result}@${aws_db_instance.primary.address}:5432/${var.db_name}"
  })
}

resource "aws_db_subnet_group" "primary" {
  name       = "${var.project}-${var.environment}-db-subnets"
  subnet_ids = var.subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-db-subnets"
  })
}

resource "aws_security_group" "primary" {
  name        = "${var.project}-${var.environment}-postgres-sg"
  description = "Allow Postgres access from application nodes"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-postgres-sg"
  })
}

resource "aws_security_group_rule" "primary_ingress" {
  for_each = toset(var.source_security_group_ids)

  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.primary.id
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "primary_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.primary.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_db_instance" "primary" {
  identifier                        = "${var.project}-${var.environment}-postgres"
  engine                            = "postgres"
  engine_version                    = var.engine_version
  instance_class                    = var.instance_class
  allocated_storage                 = var.allocated_storage
  max_allocated_storage             = var.max_allocated_storage
  storage_type                      = "gp3"
  storage_encrypted                 = true
  db_name                           = var.db_name
  username                          = var.db_username
  password                          = random_password.master.result
  multi_az                          = var.multi_az
  iam_database_authentication_enabled = true
  backup_retention_period           = var.backup_retention_days
  backup_window                     = "02:00-03:00"
  maintenance_window                = "sun:03:00-sun:04:00"
  auto_minor_version_upgrade        = true
  performance_insights_enabled      = true
  deletion_protection               = var.deletion_protection
  apply_immediately                 = var.apply_immediately
  publicly_accessible               = false
  skip_final_snapshot               = true
  copy_tags_to_snapshot             = true
  db_subnet_group_name              = aws_db_subnet_group.primary.name
  vpc_security_group_ids            = [aws_security_group.primary.id]

  tags = local.common_tags
}

resource "aws_db_subnet_group" "dr" {
  provider = aws.dr
  count    = var.create_dr_replica ? 1 : 0

  name       = "${var.project}-${var.environment}-db-subnets-dr"
  subnet_ids = var.dr_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-db-subnets-dr"
  })
}

resource "aws_kms_key" "dr_replica" {
  provider = aws.dr
  count    = var.create_dr_replica && var.dr_kms_key_arn == null ? 1 : 0

  description             = "KMS key for DR PostgreSQL replica encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-postgres-dr-kms"
    Tier = "dr"
  })
}

resource "aws_kms_alias" "dr_replica" {
  provider = aws.dr
  count    = var.create_dr_replica && var.dr_kms_key_arn == null ? 1 : 0

  name          = "alias/${var.project}-${var.environment}-postgres-dr"
  target_key_id = aws_kms_key.dr_replica[0].key_id
}

resource "aws_security_group" "dr" {
  provider = aws.dr
  count    = var.create_dr_replica ? 1 : 0

  name        = "${var.project}-${var.environment}-postgres-dr-sg"
  description = "Allow DR Postgres replica access"
  vpc_id      = var.dr_vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-postgres-dr-sg"
  })
}

resource "aws_security_group_rule" "dr_ingress" {
  provider = aws.dr
  for_each = var.create_dr_replica ? toset(var.dr_source_security_group_ids) : toset([])

  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dr[0].id
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "dr_egress" {
  provider = aws.dr
  count    = var.create_dr_replica ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.dr[0].id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_db_instance" "dr_replica" {
  provider = aws.dr
  count    = var.create_dr_replica ? 1 : 0

  identifier                = "${var.project}-${var.environment}-postgres-dr"
  replicate_source_db       = aws_db_instance.primary.arn
  instance_class            = var.dr_instance_class
  storage_type              = "gp3"
  storage_encrypted         = true
  kms_key_id                = local.dr_kms_key_to_use
  auto_minor_version_upgrade = true
  apply_immediately         = var.apply_immediately
  publicly_accessible       = false
  skip_final_snapshot       = true
  copy_tags_to_snapshot     = true
  db_subnet_group_name      = aws_db_subnet_group.dr[0].name
  vpc_security_group_ids    = [aws_security_group.dr[0].id]

  tags = merge(local.common_tags, {
    Tier = "dr"
  })
}
