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
  common_tags = merge(var.tags, {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

resource "aws_vpn_gateway" "this" {
  vpc_id = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-vgw"
  })
}

resource "aws_customer_gateway" "this" {
  bgp_asn    = var.onprem_bgp_asn
  ip_address = var.onprem_public_ip
  type       = "ipsec.1"

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-cgw"
  })
}

resource "aws_vpn_connection" "this" {
  vpn_gateway_id      = aws_vpn_gateway.this.id
  customer_gateway_id = aws_customer_gateway.this.id
  type                = "ipsec.1"
  static_routes_only  = var.static_routes_only

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-vpn"
  })
}

resource "aws_vpn_connection_route" "onprem" {
  count = var.static_routes_only ? 1 : 0

  destination_cidr_block = var.onprem_cidr
  vpn_connection_id      = aws_vpn_connection.this.id
}

resource "aws_vpn_gateway_route_propagation" "private" {
  for_each = toset(var.propagate_route_table_ids)

  vpn_gateway_id = aws_vpn_gateway.this.id
  route_table_id = each.value
}
