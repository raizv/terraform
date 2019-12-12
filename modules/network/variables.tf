variable "project" {}
variable "network" {}
variable "region" {}

variable "ip_cidr_range" {}
variable "pod_ip_cidr_range" {}
variable "service_ip_cidr_range" {}

variable "subnetwork_name" {
  default = "default"
}

variable "router_name" {
  default = "default"
}

variable "nat_name" {
  default = "default"
}
