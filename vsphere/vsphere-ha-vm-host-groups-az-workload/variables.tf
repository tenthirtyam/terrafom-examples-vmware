##################################################################################
# VARIABLE DEFINITION
##################################################################################

# Credentials

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance (e.g. sfo-w01-vc01.sfo.rainpole.io)"
}

variable "vsphere_user" {
  type        = string
  description = "The username to login to the vCenter Server instance. (e.g. administrator@vsphere.local)"
  default     = "administrator@vsphere.local"
}

variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance"
}

variable "vsphere_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates."
  default     = false
}

# vSphere Objects

variable "vsphere_datacenter" {
  type        = string
  description = "The target vSphere datacenter object name (e.g. sfo-w01-dc01)"
}
variable "vsphere_cluster" {
  type        = string
  description = "The target vSphere cluster object name (e.g. sfo-w01-cl01)"
}

# Host Groups for Availability Zones

variable "host_group_name_az_1" {
  type        = string
  description = "The name of the host group for Availability Zone 1. (e.g. host-group-w01-cl01-az-1)"
}

variable "host_group_hosts_az_1" {
  type        = list(string)
  description = "A list of hosts for Availability Zone 1."
}

variable "host_group_name_az_2" {
  type        = string
  description = "The name of the host group for Availability Zone 2. (e.g. host-group-w01-cl01-az-2)"
}

variable "host_group_hosts_az_2" {
  type        = list(string)
  description = "A list of hosts for Availability Zone 2."
}

#VM Groups for Availability Zones

variable "vm_group_name" {
  type        = string
  description = "The name of the virtual machine group (e.g. vm-group-w01-cl01-az-preferred)"
}

variable "vm_group_vms" {
  type        = list(string)
  description = "A list of virtual machines for Availability Zone 1 Preference."
}

# VM/Host Group Dependency Rule

variable "vm_host_group_ruleset_enable" {
  type        = bool
  default     = true
  description = "Enable the virtual machine / host group dependency rule. (e.g. true | false)"
}

variable "vm_host_group_ruleset_mandatory" {
  type        = bool
  default     = false
  description = "Is the virtual machine / host group dependency rule mandatory. (e.g. true = must | false = should)"
}

variable "vm_host_group_ruleset_name" {
  type        = string
  description = "The name of the virtual machine / host group dependency rule (e.g. vvm-host-group-w01-cl01-az-preferred)"
}
