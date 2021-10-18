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
  description = "The username to login to the vCenter Server instance."
  sensitive   = true
}

variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
  sensitive   = true
}

variable "vsphere_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates."
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

# Virtual Machines Group - Groups

variable "vm_group_name_0" {
  type        = string
  description = "The name of the virtual machine group."
}

variable "dependency_vm_group_name_0" {
  type        = string
  description = "The name of the dependency virtual machine group."
}

# Virtual Machines Group - Virtual Machines

variable "vm_group_vms_0" {
  type        = list(string)
  description = "A list of virtual machines."
}

# Virtual Machine - Virtual Machine Dependency Rules

variable "vm_vm_dependency_rule_name_0" {
  type        = string
  description = "The name of the vm-vm group rule."
}