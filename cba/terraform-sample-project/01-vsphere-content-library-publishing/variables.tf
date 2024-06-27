##################################################################################
# VARIABLES
##################################################################################

// vCenter Server Endpoint

variable "vsphere_server" {
  type        = string
  description = "Fully qualified domain name or IP address of the vCenter Server instance. (e.g. sfo-w01-vc01.sfo.rainpole.io)"
}

variable "vsphere_username" {
  type        = string
  description = "Username to login to the vCenter Server instance. (e.g administrator@vsphere.local)"
  default     = "administrator@vsphere.local"
}

variable "vsphere_password" {
  type        = string
  description = "Password for the user to login to the vCenter Server instance"
  sensitive   = true
}

variable "vsphere_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates"
  default     = false
}

#vSphere Objects

variable "vsphere_datacenter" {
  type        = string
  description = "Target vSphere datacenter object name. (e.g. sfo-w01-dc01)"
}

variable "vsphere_datastore" {
  type        = string
  description = "Target vSphere datastore object name. (e.g. sfo-w01-cl01-ds-vsan01)"
}

# Content Library Settings

variable "vsphere_content_library_name" {
  type        = string
  description = "Target vSphere Content Library object name. (e.g. sfo-cba-lib01)"
}

variable "vsphere_content_library_description" {
  type        = string
  description = "Target vSphere Content Library object description"
}

variable "vsphere_content_library_auth" {
  type        = string
  description = "Target vSphere Content Library authentication"
  default     = "NONE"
}

variable "vsphere_content_library_published" {
  type        = bool
  description = "Publication status of the vSphere Content Library. (e.g. true | false)"
  default     = "true"
}