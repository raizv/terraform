# cluster configuration
variable "name" {}
variable "location" {}
variable "network" {}
variable "subnetwork" {}
variable "project" {}
variable "org_domain" {}
variable "service_account" {}

variable "cluster_secondary_range_name" {}
variable "services_secondary_range_name" {}

# you cannot use master, node, Pod, or Service IP range that overlaps with 172.17.0.0/16
variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation to use for the hosted master network"
  default     = "172.16.0.0/28"
}

variable "maintenance_start_time" {
  description = "Time window specified for daily maintenance operations. Specify start_time in RFC3339 format HH:MM"
  default     = "01:00"
}


# Node Pool configuration
variable "preemptible" {
  description = "Allow to use preemptible nodes"
  default     = false
}

# https://cloud.google.com/compute/docs/machine-types
variable "machine_type" {
  description = "Instance type to use in a node pool"
  default     = "n2-standard-4"
}

variable "initial_node_count" {
  description = "Initial number of instances in a node pool"
  default     = 1
}

variable "min_node_count" {
  description = "Minimum number of instances in a node pool"
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of instances in a node pool"
  default     = 6
}

variable "auto_repair" {
  default = true
}

variable "auto_upgrade" {
  default = true
}

variable "disk_type" {
  default = "pd-standard"
}

variable "disk_size_gb" {
  default = 100
}
