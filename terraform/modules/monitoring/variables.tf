variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "rds_instance_id" {
  type    = string
  default = ""
}

variable "redis_replication_group_id" {
  type    = string
  default = ""
}

variable "alb_arn_suffix" {
  description = "Optional ALB ARN suffix for 5xx/latency alerts"
  type        = string
  default     = ""
}

variable "alert_email_endpoints" {
  type    = list(string)
  default = []
}

variable "rds_cpu_threshold" {
  type    = number
  default = 75
}

variable "redis_cpu_threshold" {
  type    = number
  default = 75
}

variable "alb_5xx_threshold" {
  type    = number
  default = 50
}

variable "tags" {
  type    = map(string)
  default = {}
}
