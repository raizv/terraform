variable "project" {}
variable "network" {}
variable "region" {}

variable "ip_cidr_range" {}
variable "pod_ip_cidr_range" {}
variable "service_ip_cidr_range" {}

variable "subnetwork_name" {
  default = "subnetwork"
}

variable "router_name" {
  default = "router"
}

variable "nat_name" {
  default = "nat"
}

variable "deploy_router" {
  description = "Deploy GCP Router"
  default     = true
  type        = bool
}

variable "deploy_nat" {
  description = "Deploy GCP NAT"
  default     = true
  type        = bool
}
