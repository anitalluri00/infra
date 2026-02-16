variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "protected_resource_arns" {
  description = "List of ARNs protected by AWS Backup"
  type        = list(string)
}

variable "copy_to_dr" {
  description = "Copy backup recovery points to DR region vault"
  type        = bool
  default     = true
}

variable "daily_schedule" {
  description = "Daily backup cron in UTC"
  type        = string
  default     = "cron(0 2 * * ? *)"
}

variable "weekly_schedule" {
  description = "Weekly backup cron in UTC"
  type        = string
  default     = "cron(0 3 ? * SUN *)"
}

variable "daily_delete_after_days" {
  type    = number
  default = 35
}

variable "weekly_delete_after_days" {
  type    = number
  default = 180
}

variable "copy_delete_after_days" {
  type    = number
  default = 180
}

variable "tags" {
  type    = map(string)
  default = {}
}
