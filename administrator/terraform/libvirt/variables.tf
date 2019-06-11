variable "libvirt_url" {
  type        = "string"
  default     = "qemu:///system"
  description = "Libvirt URL terraform will connect to"
}

variable "base_image" {
  type        = "string"
  default     = "CentOS-7-x86_64-GenericCloud.qcow2"
  description = "Base image used to spawn VMs from it"
}

variable "vcpus" {
  type        = "string"
  default     = "4"
  description = "vCPUs to assign to the VMs"
}

variable "memory" {
  type        = "string"
  default     = "16384"
  description = "Memory, in megabytes, to assign to the VMs"
}

variable "osdisk" {
  type        = "string"
  default     = "32212254720"
  description = "OS disk size"
}

variable "pvs_disk_size" {
  type        = "string"
  default     = "10737418240"
  description = "PVs data disks size"
}

variable "ssh_pub_key" {
  type        = "string"
  description = "SSH Public key, it's added to the user cloud"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5Qbj7vDf0uYQpeYb432g5R4YvYJaPfPA4EM4qc3lO62c7oUsWbZlZBl5neEWX41HGCIP4Zm1ybN9iiDyeIns6hg5OkU2vUGuPtV2KCAZOI7snzXeZxlrjsVMjMy/CYUlvIOAPxY4XzfzMMAJjIJni18R2PqVRI4f4SeSq3IIzpnOu2VQmqjFmmdybQY83BvBvWj6KLszAXkJk9LkZSAoktXimDBWFPQYikzZihLolRxwHzo21lXSw58D1N+6IeMudOviAte5yu6FBUN6dFYbt9dkLuH2/ONliFz/042n5UNp0wC5BLdpVwJpWqqrCVaeXBgla/gYm8YNZJIAlf8K5 kboumedh@vegeta.local"
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

variable "master_mac_address" {
  type = "string"
  default = "e6:fa:a6:92:a1:af"
  description = "kubemaster mac address, useful for DHCP reservations"
}

variable "hostname_prefix" {
  type        = "string"
  default     = "kubevirt-lab"
  description = "Prefix add to hostnames"
}
