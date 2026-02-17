variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Failover DNS name (e.g. portal.example.gov)"
  type        = string
  default     = ""
}

variable "primary_lb_dns_name" {
  type    = string
  default = ""
}

variable "primary_lb_zone_id" {
  type    = string
  default = ""
}

variable "dr_lb_dns_name" {
  type    = string
  default = ""
}

variable "dr_lb_zone_id" {
  type    = string
  default = ""
}

variable "health_check_path" {
  type    = string
  default = "/healthz"
}

variable "health_check_failure_threshold" {
  type    = number
  default = 3
}

variable "tags" {
  type    = map(string)
  default = {}
}
