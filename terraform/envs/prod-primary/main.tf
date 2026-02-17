data "aws_availability_zones" "primary" {
  state = "available"
}

data "aws_availability_zones" "dr" {
  provider = aws.dr
  state    = "available"
}

locals {
  primary_azs = slice(data.aws_availability_zones.primary.names, 0, 3)
  dr_azs      = slice(data.aws_availability_zones.dr.names, 0, 3)

  common_tags = merge(var.tags, {
    System = "Enterprise-MIS"
    Owner  = "InfraTeam"
    SLA    = "99.9"
  })
}

module "network_primary" {
  source = "../../modules/network"

  project           = var.project
  environment       = var.environment
  vpc_cidr          = var.primary_vpc_cidr
  azs               = local.primary_azs
  dmz_subnet_cidrs  = var.primary_dmz_subnet_cidrs
  app_subnet_cidrs  = var.primary_app_subnet_cidrs
  data_subnet_cidrs = var.primary_data_subnet_cidrs
  tags              = local.common_tags
}

module "network_dr" {
  source = "../../modules/network"

  providers = {
    aws = aws.dr
  }

  project           = var.project
  environment       = "${var.environment}-dr"
  vpc_cidr          = var.dr_vpc_cidr
  azs               = local.dr_azs
  dmz_subnet_cidrs  = var.dr_dmz_subnet_cidrs
  app_subnet_cidrs  = var.dr_app_subnet_cidrs
  data_subnet_cidrs = var.dr_data_subnet_cidrs
  tags              = local.common_tags
}

module "eks_primary" {
  source = "../../modules/eks"

  project             = var.project
  environment         = var.environment
  cluster_name        = "${var.project}-${var.environment}"
  vpc_id              = module.network_primary.vpc_id
  private_subnet_ids  = module.network_primary.private_app_subnet_ids
  dmz_subnet_ids      = module.network_primary.dmz_subnet_ids
  node_instance_types = ["m6i.xlarge"]
  node_desired_size   = 6
  node_min_size       = 3
  node_max_size       = 30
  tags                = local.common_tags
}

module "eks_dr" {
  source = "../../modules/eks"

  providers = {
    aws = aws.dr
  }

  project             = var.project
  environment         = "${var.environment}-dr"
  cluster_name        = "${var.project}-${var.environment}-dr"
  vpc_id              = module.network_dr.vpc_id
  private_subnet_ids  = module.network_dr.private_app_subnet_ids
  dmz_subnet_ids      = module.network_dr.dmz_subnet_ids
  node_instance_types = ["m6i.large"]
  node_desired_size   = 2
  node_min_size       = 1
  node_max_size       = 10
  tags                = local.common_tags
}

module "rds" {
  source = "../../modules/rds"

  providers = {
    aws    = aws
    aws.dr = aws.dr
  }

  project                      = var.project
  environment                  = var.environment
  db_name                      = var.db_name
  db_username                  = var.db_username
  vpc_id                       = module.network_primary.vpc_id
  subnet_ids                   = module.network_primary.private_data_subnet_ids
  source_security_group_ids    = [module.eks_primary.node_security_group_id]
  create_dr_replica            = true
  dr_vpc_id                    = module.network_dr.vpc_id
  dr_subnet_ids                = module.network_dr.private_data_subnet_ids
  dr_source_security_group_ids = [module.eks_dr.node_security_group_id]
  tags                         = local.common_tags
}

module "redis" {
  source = "../../modules/redis"

  providers = {
    aws    = aws
    aws.dr = aws.dr
  }

  project                      = var.project
  environment                  = var.environment
  vpc_id                       = module.network_primary.vpc_id
  subnet_ids                   = module.network_primary.private_data_subnet_ids
  source_security_group_ids    = [module.eks_primary.node_security_group_id]
  create_global_replication    = true
  dr_vpc_id                    = module.network_dr.vpc_id
  dr_subnet_ids                = module.network_dr.private_data_subnet_ids
  dr_source_security_group_ids = [module.eks_dr.node_security_group_id]
  tags                         = local.common_tags
}

resource "aws_secretsmanager_secret" "application" {
  name        = "${var.project}/${var.environment}/application"
  description = "Application runtime secrets consumed by ExternalSecret"

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "application" {
  secret_id = aws_secretsmanager_secret.application.id
  secret_string = jsonencode({
    DATABASE_URL      = module.rds.connection_uri
    REDIS_URL         = module.redis.connection_uri
    CELERY_BROKER_URL = module.redis.connection_uri
    JWT_PUBLIC_KEY    = var.app_jwt_public_key
  })
}

module "storage" {
  source = "../../modules/storage"

  providers = {
    aws    = aws
    aws.dr = aws.dr
  }

  project     = var.project
  environment = var.environment
  tags        = local.common_tags
}

module "backup" {
  source = "../../modules/backup"

  providers = {
    aws    = aws
    aws.dr = aws.dr
  }

  project                 = var.project
  environment             = var.environment
  protected_resource_arns = [module.rds.primary_instance_arn, module.storage.primary_bucket_arn]
  copy_to_dr              = true
  tags                    = local.common_tags
}

module "hybrid_connectivity" {
  source = "../../modules/hybrid_connectivity"

  project          = var.project
  environment      = var.environment
  vpc_id           = module.network_primary.vpc_id
  onprem_public_ip = var.onprem_public_ip
  onprem_cidr      = var.onprem_cidr
  onprem_bgp_asn   = var.onprem_bgp_asn
  propagate_route_table_ids = concat(
    module.network_primary.app_route_table_ids,
    module.network_primary.data_route_table_ids
  )
  tags             = local.common_tags
}

module "security" {
  source = "../../modules/security"

  project      = var.project
  environment  = var.environment
  edge_alb_arn = var.edge_alb_arn
  tags         = local.common_tags
}

module "dr_failover" {
  source = "../../modules/dr"

  project             = var.project
  environment         = var.environment
  zone_id             = var.route53_zone_id
  domain_name         = var.portal_domain
  primary_lb_dns_name = var.primary_edge_lb_dns_name
  primary_lb_zone_id  = var.primary_edge_lb_zone_id
  dr_lb_dns_name      = var.dr_edge_lb_dns_name
  dr_lb_zone_id       = var.dr_edge_lb_zone_id
  tags                = local.common_tags
}

module "monitoring" {
  source = "../../modules/monitoring"

  project                    = var.project
  environment                = var.environment
  rds_instance_id            = module.rds.primary_instance_id
  redis_replication_group_id = module.redis.primary_replication_group_id
  alb_arn_suffix             = var.alb_arn_suffix
  alert_email_endpoints      = var.alert_email_endpoints
  tags                       = local.common_tags
}
