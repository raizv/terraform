variable "project" {}
variable "location" {}
variable "cluster" {}
variable "service_account" {}

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
