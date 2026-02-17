variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "onprem_public_ip" {
  description = "Public IP of on-prem VPN gateway"
  type        = string
}

variable "onprem_bgp_asn" {
  description = "BGP ASN of on-prem gateway"
  type        = number
  default     = 65010
}

variable "onprem_cidr" {
  description = "On-prem CIDR routed through VPN"
  type        = string
}

variable "static_routes_only" {
  description = "Use static routing for VPN"
  type        = bool
  default     = true
}

variable "propagate_route_table_ids" {
  description = "Route tables that should learn on-prem routes via VPN gateway propagation"
  type        = list(string)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
