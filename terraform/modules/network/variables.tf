variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones to use"
  type        = list(string)
}

variable "dmz_subnet_cidrs" {
  description = "CIDR blocks for DMZ/public subnets"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for private app subnets"
  type        = list(string)
}

variable "data_subnet_cidrs" {
  description = "CIDR blocks for private data subnets"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway (lower cost, lower availability)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
