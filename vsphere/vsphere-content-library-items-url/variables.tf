##################################################################################
# VARIABLE
##################################################################################

# Credentials

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
  description = "The password for the login to the vCenter Server instance."
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

variable "vsphere_datastore" {
  type        = string
  description = "The target vSphere datastore object name. (e.g. sfo-w01-ds-vsan01)."
}

# Content Library Settings

variable "content_library_item_repo" {
  type        = string
  description = "The base URL of an accessible source repository (e.g. https://repo.rainpole.io/ovf-images)."
}

variable "content_library_name" {
  type        = string
  description = "The target vSphere Content Library object name. (e.g. sfo-w01-lib01)"
}

variable "content_library_item" {
  type = map(object({
    name        = string
    description = string
    file_url    = string
  }))
  description = "The OVF images to load into the vSphere Content Library."
}