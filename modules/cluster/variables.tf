# cluster configuration
variable "name" {}
variable "location" {}
variable "network" {}
variable "subnetwork" {}
variable "project" {}
variable "organization" {}

variable "service_account" {}

variable "enable_private_endpoint" {
  description = "Whether the master's internal IP address is used as the cluster endpoint"
  default     = false
}

variable "enable_private_nodes" {
  description = "Whether nodes have internal IP addresses only"
  default     = true
}

# you cannot use master, node, Pod, or Service IP range that overlaps with 172.17.0.0/16
variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation to use for the hosted master network"
  default     = "172.16.0.0/28"
}

# node_pool configuration
variable "preemptible" {
  description = "Allow to use preemptible nodes"
  default     = false
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "initial_node_count" {
  default = 1
}

variable "min_node_count" {
  default = 1
}

variable "max_node_count" {
  default = 10
}

variable "auto_repair" {
  default = true
}

variable "auto_upgrade" {
  default = true
}