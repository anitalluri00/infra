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

resource "aws_elasticache_subnet_group" "primary" {
  name       = "${var.project}-${var.environment}-redis-subnets"
  subnet_ids = var.subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-redis-subnets"
  })
}

resource "random_password" "auth_token" {
  length  = 32
  special = false
}

resource "aws_security_group" "primary" {
  name        = "${var.project}-${var.environment}-redis-sg"
  description = "Allow Redis access from app nodes"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-redis-sg"
  })
}

resource "aws_security_group_rule" "primary_ingress" {
  for_each = toset(var.source_security_group_ids)

  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
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

resource "aws_elasticache_replication_group" "primary" {
  replication_group_id       = "${var.project}-${var.environment}-redis"
  description                = "Primary Redis replication group"
  engine                     = "redis"
  engine_version             = var.engine_version
  node_type                  = var.node_type
  port                       = 6379
  parameter_group_name       = "default.redis7"
  num_cache_clusters         = var.num_cache_clusters
  automatic_failover_enabled = true
  multi_az_enabled           = true
  subnet_group_name          = aws_elasticache_subnet_group.primary.name
  security_group_ids         = [aws_security_group.primary.id]
  transit_encryption_enabled = true
  at_rest_encryption_enabled = true
  snapshot_retention_limit   = var.snapshot_retention_limit
  maintenance_window         = "sun:05:00-sun:06:00"
  apply_immediately          = var.apply_immediately
  auth_token                 = random_password.auth_token.result

  tags = local.common_tags
}

resource "aws_elasticache_subnet_group" "dr" {
  provider = aws.dr
  count    = var.create_global_replication ? 1 : 0

  name       = "${var.project}-${var.environment}-redis-subnets-dr"
  subnet_ids = var.dr_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-redis-subnets-dr"
  })
}

resource "aws_security_group" "dr" {
  provider = aws.dr
  count    = var.create_global_replication ? 1 : 0

  name        = "${var.project}-${var.environment}-redis-dr-sg"
  description = "Allow Redis DR access from DR app nodes"
  vpc_id      = var.dr_vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-redis-dr-sg"
  })
}

resource "aws_security_group_rule" "dr_ingress" {
  provider = aws.dr
  for_each = var.create_global_replication ? toset(var.dr_source_security_group_ids) : toset([])

  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dr[0].id
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "dr_egress" {
  provider = aws.dr
  count    = var.create_global_replication ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.dr[0].id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_elasticache_global_replication_group" "this" {
  count = var.create_global_replication ? 1 : 0

  global_replication_group_id_suffix = "${var.project}-${var.environment}-redis"
  primary_replication_group_id       = aws_elasticache_replication_group.primary.id
}

resource "aws_elasticache_replication_group" "dr_secondary" {
  provider = aws.dr
  count    = var.create_global_replication ? 1 : 0

  replication_group_id        = "${var.project}-${var.environment}-redis-dr"
  description                 = "DR Redis replication group"
  global_replication_group_id = aws_elasticache_global_replication_group.this[0].global_replication_group_id
  node_type                   = var.dr_node_type
  num_cache_clusters          = 2
  subnet_group_name           = aws_elasticache_subnet_group.dr[0].name
  security_group_ids          = [aws_security_group.dr[0].id]
  automatic_failover_enabled  = true
  multi_az_enabled            = true
  transit_encryption_enabled  = true
  at_rest_encryption_enabled  = true
  apply_immediately           = var.apply_immediately

  tags = merge(local.common_tags, {
    Tier = "dr"
  })
}

resource "aws_secretsmanager_secret" "redis_credentials" {
  name        = "${var.project}/${var.environment}/redis"
  description = "Redis access details"

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "redis_credentials" {
  secret_id = aws_secretsmanager_secret.redis_credentials.id
  secret_string = jsonencode({
    endpoint = aws_elasticache_replication_group.primary.primary_endpoint_address
    reader   = aws_elasticache_replication_group.primary.reader_endpoint_address
    port     = 6379
    token    = random_password.auth_token.result
    uri      = "rediss://default:${random_password.auth_token.result}@${aws_elasticache_replication_group.primary.primary_endpoint_address}:6379/0"
  })
}
