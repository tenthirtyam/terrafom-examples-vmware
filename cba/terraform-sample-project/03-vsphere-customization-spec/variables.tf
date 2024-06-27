##################################################################################
# VARIABLES
##################################################################################

# vCenter Server Endpoint

variable "vsphere_server" {
  type        = string
  description = "Fully qualified domain name or IP address of the vCenter Server instance. (e.g. sfo-m01-vc01.sfo.rainpole.io)"
}

variable "vsphere_username" {
  type        = string
  description = "Username to login to the vCenter Server instance. (e.g administrator@vsphere.local)"
  default     = "administrator@vsphere.local"
}

variable "vsphere_password" {
  type        = string
  description = "Password for the user to login to the vCenter Server instance"
}

variable "customization_name" {
  type        = string
  description = "Name of the vSphere VM Customization Specification"
}

variable "customization_description" {
  type = string
  description = "Decription for the vSphere VM Customization Specification"
}

variable "customization_type" {
  type = string
  description = "Target Operating System for the vSphere VM Customization Specification"
}

variable "customization_domain" {
  type = string
  description = "Target domain for the vSphere VM Customization Specification"
}

variable "customization_timezone" {
  type = string
  description = "Target timezone for the vSphere VM Customization Specification"
}
