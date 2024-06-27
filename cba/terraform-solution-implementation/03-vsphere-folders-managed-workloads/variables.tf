##################################################################################
# VARIABLES
##################################################################################

# vSphere Credentials

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance. (e.g. sfo-w01-vc01.sfo.rainpole.io)"
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
  description = "The target vSphere datacenter object name. (e.g. sfo-w01-dc01)"
}

variable "vsphere_cluster" {
  type        = string
  description = "The target vSphere cluster object name. (e.g. sfo-w01-cl01)"
}

# Folders and Resource Pools

variable "vsphere_folders" {
  type = map(object({
    path = string
    type = string
  }))
  description = "A mapping of objects for vSphere folder names and their associated type"
}

variable "vsphere_resource_pools" {
  type = map(object({
    name = string
  }))
  description = "A mapping of objects for vSphere resource pools"
}