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

#vSphere Objects

variable "vsphere_datacenter" {
  type        = string
  description = "The target vSphere datacenter object name. (e.g. sfo-w01-dc01)."
}

variable "vsphere_datastore" {
  type        = string
  description = "The target vSphere datastore object name. (e.g. sfo-w01-cl01-ds-vsan01)"
}

# Content Library Settings

variable "vsphere_content_library_name" {
  type        = string
  description = "The target vSphere Content Library object name. (e.g. sfo-w01-lib01)"
}

variable "vsphere_content_library_description" {
  type        = string
  description = "The target vSphere Content Library datacenter object description."
}

variable "vsphere_content_library_auth" {
  type        = string
  description = "The target vSphere Content Library authentication."
  default     = "NONE"
}

variable "vsphere_content_library_published" {
  type        = bool
  description = "The publication status of the vSphere Content Library. (e.g. true | false)"
  default     = "true"
}