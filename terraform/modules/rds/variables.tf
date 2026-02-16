variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "engine_version" {
  type    = string
  default = "16.3"
}

variable "instance_class" {
  type    = string
  default = "db.r6g.large"
}

variable "allocated_storage" {
  type    = number
  default = 200
}

variable "max_allocated_storage" {
  type    = number
  default = 1000
}

variable "backup_retention_days" {
  type    = number
  default = 14
}

variable "multi_az" {
  type    = bool
  default = true
}

variable "apply_immediately" {
  type    = bool
  default = false
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "source_security_group_ids" {
  description = "Security groups that can access Postgres"
  type        = list(string)
}

variable "create_dr_replica" {
  description = "Create cross-region read replica"
  type        = bool
  default     = true
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

variable "dr_instance_class" {
  type    = string
  default = "db.r6g.large"
}

variable "dr_kms_key_arn" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
