variable "appsvpc_id" {}
variable "internal_dashboard_cidr_block" {}
variable "external_dashboard_cidr_block" {}
variable "data_ingest_cidr_block" {}
variable "data_pipe_apps_cidr_block" {}
variable "data_feeds_cidr_block" {}
variable "opssubnet_cidr_block" {}
variable "peering_cidr_block" {}
variable "az" {}
variable "dq_database_cidr_block" {}

variable "naming_suffix" {
  default     = false
  description = "Naming suffix for tags, value passed from dq-tf-apps"
}

variable "route_table_id" {
  default     = false
  description = "Value obtained from Apps module"
}
