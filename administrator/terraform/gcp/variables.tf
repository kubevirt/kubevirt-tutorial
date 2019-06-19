variable "gcp_project" {
  type        = "string"
  default     = "cnvlab-209908"
  description = "GCE Project to work with"
}

variable "gcp_region" {
  type        = "string"
  default     = "europe-west4"
  description = "GCE Region to work with"
}

variable "gcp_zone" {
  type        = "string"
  default     = "europe-west4-a"
  description = "GCE Zone to work with"
}

variable "gcp_firewall_rule_name" {
  type        = "string"
  default     = "gcp_firewall_rule_name"
  description = "GCE Name for firewall bucket rule"
}

variable "gcp_network_name" {
  type        = "string"
  default     = "malpar-io"
  description = "GCE Network Name"
}

variable "gcp_instances" {
  type        = "string"
  default     = "1"
  description = "Number of instances to create in GCE"
}

variable "gcp_instance_size" {
  type        = "string"
  default     = "n1-standard-4"
  description = "GCE Size of the instances to create"
}

variable "gcp_boot_image" {
  type        = "string"
  default     = "nested-centos7"
  description = "GCE Image to boot on the created instances"
}

variable "gcp_boot_image_size_gb" {
  type        = "string"
  default     = "20"
  description = "GCE Image size to boot on the created instances in gb"
}

variable "gcp_instance_tag" {
  type        = "string"
  default     = "kubevirtlab"
  description = "GCE Tag for instances created"
}

variable "gcp_sa" {
  type        = "string"
  description = "GCE SA to use for provision"
}

variable "ssh_pub_key" {
  type        = "string"
  description = "SSH Public key, it's added to the cloud user"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD0IFmpMQHlk87299njLxEgMJ3BAVN0zXlPQvE/vT1rHrluD+/vosXNdpzCEMSd3VQHduzXTOhNxYYAEgL3vy9EgCWnofJ96aPTLUz6aNdviltkfwtn8npPQ7ojnsa02ATHUjqI5ZbiQo2BcJScx3bEr/nvlczcuV6QF0EmKTPAEYRM1QQtE3TpozEAjOzElQkMepZc+RxI9k3HoSlWRiZK9o2mu96Y+aaCs9hXlmiYL7fbPVMnN83U3NMAAGqzUXT0QXjdVIuxEEvRYX2vE4LqjAopmTvfLy6c3VvO88w/0nbabQCoiWSTkZ/Wh4Pv0WVAyuahnr99sURQ5j2Zmd2f jparrill@deimos.localdomain"
}

variable "dns_domain_name" {
  type        = "string"
  default     = "kubevirtlab.local"
  description = "DNS domain name"
}

variable "host_bridge_iface" {
  type        = "string"
  description = "Bridge interface the VMs will use for network connection"
}

variable "hostname_prefix" {
  type        = "string"
  default     = "kubevirt-lab"
  description = "Prefix add to hostnames"
}

variable "lab_description" {
  type        = "string"
  default     = "OpenSouthCode 2019"
  description = "User data for new user"
}

variable "lab_username" {
  type        = "string"
  default     = "kubevirt"
  description = "New user for Laboratory"
}
