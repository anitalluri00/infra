data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  common_tags = merge(var.tags, {
    System = "Enterprise-MIS"
    Owner  = "InfraTeam"
    Tier   = "DR"
  })
}

module "network" {
  source = "../../modules/network"

  project           = var.project
  environment       = var.environment
  vpc_cidr          = var.vpc_cidr
  azs               = local.azs
  dmz_subnet_cidrs  = var.dmz_subnet_cidrs
  app_subnet_cidrs  = var.app_subnet_cidrs
  data_subnet_cidrs = var.data_subnet_cidrs
  tags              = local.common_tags
}

module "eks" {
  source = "../../modules/eks"

  project             = var.project
  environment         = var.environment
  cluster_name        = "${var.project}-${var.environment}"
  vpc_id              = module.network.vpc_id
  private_subnet_ids  = module.network.private_app_subnet_ids
  dmz_subnet_ids      = module.network.dmz_subnet_ids
  node_instance_types = ["m6i.large"]
  node_desired_size   = 2
  node_min_size       = 1
  node_max_size       = 10
  tags                = local.common_tags
}
