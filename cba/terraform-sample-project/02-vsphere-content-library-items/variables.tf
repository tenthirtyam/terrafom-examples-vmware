##################################################################################
# VARIABLES
##################################################################################

# vSphere Credentials

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
  description = "Password for user to login to the vCenter Server instance"
  sensitive   = true
}

variable "vsphere_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates"
  default     = false
}

# Content Library Settings

variable "content_library_name" {
  type        = string
  description = "Ttarget vSphere Content Library object name. (e.g. sfo-cba-lib01)"
}

variable "content_library_items" {
  type = map(object({
    name        = string
    description = string
    file_url    = string
  }))
  description = "Machine images to load into the vSphere Content Library"
}