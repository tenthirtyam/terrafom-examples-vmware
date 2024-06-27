##################################################################################
# VARIABLES
##################################################################################

# Credentials

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance. (e.g. sfo-m01-vc01.sfo.rainpole.io)"
}

variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance. (e.g. administrator@vsphere.local)"
  default     = "administrator@vsphere.local"
}

variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance"
  sensitive   = true
}

variable "vsphere_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates"
  default     = false
}

# vSphere Objects

variable "vsphere_datacenter" {
  type        = string
  description = "The target vSphere datacenter object name. (e.g. sfo-m01-dc01)"
}

variable "vsphere_cluster" {
  type        = string
  description = "The target vSphere cluster object name. (e.g. sfo-m01-cl01)"
}

variable "vsphere_host_group" {
  type        = string
  description = "The target Host Group for the First Availability Zone. (e.g. sfo-hostgroup-az1)"
}

variable "cba_vm_host_rule" {
  type        = string
  description = "The name of the VM to Host Rule. (e.g. vm-host-rule-az1-vmc)"
  default     = "vm-host-rule-az1-vmc"
}

variable "cba_group_name" {
  type        = string
  description = "The name of the VM Group. (e.g. sfo-vmgroup-az-vmc)"
}

variable "cba_group_vms" {
  type        = list(string)
  description = "List of VMs"
}

variable "cba_host_group_ruleset_enable" {
  type        = bool
  default     = true
  description = "Enable the virtual machine / host group dependency rule. (e.g. true | false)"
}

variable "cba_host_group_ruleset_mandatory" {
  type        = bool
  default     = false
  description = "Is the virtual machine / host group dependency rule mandatory. (e.g. true = must | false = should)"
}