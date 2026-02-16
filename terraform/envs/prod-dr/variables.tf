variable "project" {
  type    = string
  default = "mis"
}

variable "environment" {
  type    = string
  default = "prod-dr"
}

variable "dr_region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.30.0.0/16"
}

variable "dmz_subnet_cidrs" {
  type    = list(string)
  default = ["10.30.0.0/20", "10.30.16.0/20", "10.30.32.0/20"]
}

variable "app_subnet_cidrs" {
  type    = list(string)
  default = ["10.30.64.0/20", "10.30.80.0/20", "10.30.96.0/20"]
}

variable "data_subnet_cidrs" {
  type    = list(string)
  default = ["10.30.128.0/20", "10.30.144.0/20", "10.30.160.0/20"]
}

variable "tags" {
  type    = map(string)
  default = {}
}
