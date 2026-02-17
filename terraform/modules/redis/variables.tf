variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "source_security_group_ids" {
  type = list(string)
}

variable "engine_version" {
  type    = string
  default = "7.1"
}

variable "node_type" {
  type    = string
  default = "cache.r7g.large"
}

variable "num_cache_clusters" {
  type    = number
  default = 3
}

variable "apply_immediately" {
  type    = bool
  default = false
}

variable "snapshot_retention_limit" {
  type    = number
  default = 7
}

variable "create_global_replication" {
  type    = bool
  default = true
}

variable "dr_vpc_id" {
  type    = string
  default = null
}

variable "dr_subnet_ids" {
  type    = list(string)
  default = []
}

variable "dr_source_security_group_ids" {
  type    = list(string)
  default = []
}

variable "dr_node_type" {
  type    = string
  default = "cache.r7g.large"
}

variable "tags" {
  type    = map(string)
  default = {}
}
