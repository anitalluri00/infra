<<<<<<< HEAD
=======
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

>>>>>>> 6f3b0ea (Local changes before pull)
locals {
  az_count = length(var.azs)

  subnet_matrix = {
    for idx, az in var.azs : az => {
      dmz  = var.dmz_subnet_cidrs[idx]
      app  = var.app_subnet_cidrs[idx]
      data = var.data_subnet_cidrs[idx]
    }
  }

  nat_subnet_keys = var.single_nat_gateway ? [var.azs[0]] : var.azs

  common_tags = merge(var.tags, {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-igw"
  })
}

resource "aws_subnet" "dmz" {
  for_each = local.subnet_matrix

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = each.value.dmz
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name                     = "${var.project}-${var.environment}-dmz-${each.key}"
    Tier                     = "dmz"
    "kubernetes.io/role/elb" = "1"
  })
}

resource "aws_subnet" "app" {
  for_each = local.subnet_matrix

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = each.value.app

  tags = merge(local.common_tags, {
    Name                              = "${var.project}-${var.environment}-app-${each.key}"
    Tier                              = "app"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

resource "aws_subnet" "data" {
  for_each = local.subnet_matrix

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = each.value.data

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-data-${each.key}"
    Tier = "data"
  })
}

resource "aws_eip" "nat" {
  for_each = toset(local.nat_subnet_keys)

  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-nat-eip-${each.key}"
  })
}

resource "aws_nat_gateway" "this" {
  for_each = toset(local.nat_subnet_keys)

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.dmz[each.key].id

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-nat-${each.key}"
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "dmz" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-dmz-rt"
  })
}

resource "aws_route_table_association" "dmz" {
  for_each = aws_subnet.dmz

  subnet_id      = each.value.id
  route_table_id = aws_route_table.dmz.id
}

resource "aws_route_table" "app" {
  for_each = aws_subnet.app

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = (
      var.single_nat_gateway
      ? aws_nat_gateway.this[var.azs[0]].id
      : aws_nat_gateway.this[each.key].id
    )
  }

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-app-rt-${each.key}"
  })
}

resource "aws_route_table_association" "app" {
  for_each = aws_subnet.app

  subnet_id      = each.value.id
  route_table_id = aws_route_table.app[each.key].id
}

resource "aws_route_table" "data" {
  for_each = aws_subnet.data

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-data-rt-${each.key}"
  })
}

resource "aws_route_table_association" "data" {
  for_each = aws_subnet.data

  subnet_id      = each.value.id
  route_table_id = aws_route_table.data[each.key].id
}
