variable "name" {}
variable "location" {}
variable "network" {}
variable "subnetwork" {}
variable "project" {}
variable "org_domain" {}
# variable "cluster_secondary_range_name" {}
# variable "services_secondary_range_name" {}

# you cannot use master, node, Pod, or Service IP range that overlaps with 172.17.0.0/16
# variable "master_ipv4_cidr_block" {
#   description = "The IP range in CIDR notation to use for the hosted master network"
#   default     = "172.16.0.0/28"
# }

variable "maintenance_start_time" {
  description = "Time window specified for daily maintenance operations. Specify start_time in RFC3339 format HH:MM"
  default     = "01:00"
}

variable "release_channel" {
  description = "STABLE, REGULAR or RAPID"
  default     = "STABLE"
}

variable "enable_pod_security_policy" {
  description = "Enable Pod Security Policy"
  default     = true
}

variable "enable_network_policy" {
  description = "Enable Network Policy"
  default     = true
}

variable "disable_network_policy" {
  description = "Enable Network Policy"
  default     = false
}
