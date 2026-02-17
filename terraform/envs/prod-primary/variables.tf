variable "project" {
  type    = string
  default = "mis"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "primary_region" {
  type    = string
  default = "us-east-1"
}

variable "dr_region" {
  type    = string
  default = "us-west-2"
}

variable "primary_vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "dr_vpc_cidr" {
  type    = string
  default = "10.30.0.0/16"
}

variable "primary_dmz_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.0.0/20", "10.20.16.0/20", "10.20.32.0/20"]
}

variable "primary_app_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.64.0/20", "10.20.80.0/20", "10.20.96.0/20"]
}

variable "primary_data_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.128.0/20", "10.20.144.0/20", "10.20.160.0/20"]
}

variable "dr_dmz_subnet_cidrs" {
  type    = list(string)
  default = ["10.30.0.0/20", "10.30.16.0/20", "10.30.32.0/20"]
}

variable "dr_app_subnet_cidrs" {
  type    = list(string)
  default = ["10.30.64.0/20", "10.30.80.0/20", "10.30.96.0/20"]
}

variable "dr_data_subnet_cidrs" {
  type    = list(string)
  default = ["10.30.128.0/20", "10.30.144.0/20", "10.30.160.0/20"]
}

variable "onprem_public_ip" {
  description = "Public IP address of on-prem VPN endpoint"
  type        = string
}

variable "onprem_cidr" {
  description = "On-prem network CIDR"
  type        = string
  default     = "172.16.0.0/16"
}

variable "onprem_bgp_asn" {
  type    = number
  default = 65010
}

variable "db_name" {
  type    = string
  default = "mis"
}

variable "db_username" {
  type    = string
  default = "mis_admin"
}

variable "app_jwt_public_key" {
  description = "JWT public key distributed to backend services"
  type        = string
  sensitive   = true
}

variable "alert_email_endpoints" {
  type    = list(string)
  default = []
}

variable "portal_domain" {
  description = "DNS name for citizen portal"
  type        = string
  default     = ""
}

variable "route53_zone_id" {
  type    = string
  default = ""
}

variable "primary_edge_lb_dns_name" {
  type    = string
  default = ""
}

variable "primary_edge_lb_zone_id" {
  type    = string
  default = ""
}

variable "dr_edge_lb_dns_name" {
  type    = string
  default = ""
}

variable "dr_edge_lb_zone_id" {
  type    = string
  default = ""
}

variable "edge_alb_arn" {
  description = "Optional ALB ARN for WAF association"
  type        = string
  default     = ""
}

variable "alb_arn_suffix" {
  description = "Optional ALB ARN suffix for alarm dimensions"
  type        = string
  default     = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
