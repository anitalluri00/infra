variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "edge_alb_arn" {
  description = "Optional edge ALB ARN to associate WAF"
  type        = string
  default     = ""
}

variable "waf_scope" {
  description = "WAF scope: REGIONAL for ALB, CLOUDFRONT for CloudFront"
  type        = string
  default     = "REGIONAL"
}

variable "enable_guardduty" {
  type    = bool
  default = true
}

variable "enable_securityhub" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
