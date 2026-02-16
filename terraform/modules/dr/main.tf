locals {
  enable_dns = (
    var.zone_id != "" &&
    var.domain_name != "" &&
    var.primary_lb_dns_name != "" &&
    var.primary_lb_zone_id != "" &&
    var.dr_lb_dns_name != "" &&
    var.dr_lb_zone_id != ""
  )
}

resource "aws_route53_health_check" "primary" {
  count = local.enable_dns ? 1 : 0

  fqdn              = var.primary_lb_dns_name
  port              = 443
  type              = "HTTPS"
  resource_path     = var.health_check_path
  request_interval  = 30
  failure_threshold = var.health_check_failure_threshold

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-primary-health"
  })
}

resource "aws_route53_record" "primary" {
  count = local.enable_dns ? 1 : 0

  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  set_identifier = "primary"

  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = var.primary_lb_dns_name
    zone_id                = var.primary_lb_zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.primary[0].id
}

resource "aws_route53_record" "secondary" {
  count = local.enable_dns ? 1 : 0

  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  set_identifier = "dr"

  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {
    name                   = var.dr_lb_dns_name
    zone_id                = var.dr_lb_zone_id
    evaluate_target_health = true
  }
}
