variable "product" {
  type = "string"
}

variable "raw_product" {
  default = "rd" // jenkins-library overrides product for PRs and adds e.g. pr-123-ia
}

variable "component" {
  type = "string"
}

variable "location" {
  type    = "string"
  default = "UK South"
}

variable "env" {
  type = "string"
}

variable "subscription" {
  type = "string"
}

variable "ilbIp" {}

variable "common_tags" {
  type = "map"
}

variable "capacity" {
  default = "1"
}

variable "instance_size" {
  default = "I1"
}

variable "postgresql_user" {
  default = "rd_jrd_ref_data"
}

variable "database_name" {
  default = "rd_jrd_ref_data"
}

variable "appinsights_instrumentation_key" {
  default = ""
}

variable "root_logging_level" {
  default = "INFO"
}

variable "log_level_spring_web" {
  default = "INFO"
}

variable "log_level_rd" {
  default = "INFO"
}