##################################################################################
# VARIABLES
##################################################################################

# Credentials

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance. (e.g. sfo-w01-vc01.sfo.rainpole.io)"
}

variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance. (e.g. administrator@vsphere.local)"
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

# vSphere Settings

variable "vsphere_datacenter" {
  type        = string
  description = "The target vSphere datacenter object name. (e.g. sfo-w01-dc01)."
}

# Roles

variable "vra_vsphere_role" {
  type        = string
  description = "The name for the vRealize Automation to vSphere custom role."
}

variable "vro_vsphere_role" {
  type        = string
  description = "The name for the vRealize Orchestrator to vSphere.custom role."
}

variable "vra_vsphere_privileges" {
  type        = list(string)
  description = "The vSphere permissions for the vRealize Automation to vSphere custom role."
}

variable "vro_vsphere_privileges" {
  type        = list(string)
  description = "The vSphere permissions for the vRealize Orchestrator to vSphere.custom role."
}
