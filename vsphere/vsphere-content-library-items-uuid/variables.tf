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

# Content Library Settings

variable "content_library_name" {
  type        = string
  description = "The target vSphere Content Library object name. (e.g. sfo-w01-lib01)"
}

variable "content_library_items" {
  type = map(object({
    name        = string
    description = string
    source_uuid = string
  }))
  description = "The machine images to load into the vSphere Content Library."
}