variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "bucket_prefix" {
  type    = string
  default = "documents"
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "replication_storage_class" {
  type    = string
  default = "STANDARD_IA"
}

variable "tags" {
  type    = map(string)
  default = {}
}
