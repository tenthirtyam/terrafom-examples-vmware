##################################################################################
# VARIABLES
##################################################################################

# VMware Aria Automation Endpoint

variable "aria_automation_url" {
  type        = string
  description = "Base URL for VMware Aria Automation endpoint. (e.g. https://api.mgmt.cloud.vmware.com)"
  default     = "https://api.mgmt.cloud.vmware.com"
}

variable "aria_automation_api_token" {
  type        = string
  description = "API token for the VMware Aria Automation endpoint"
  sensitive   = true
}

variable "aria_automation_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates"
  default     = false
}

# vCenter Server Endpoint

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance. (e.g. sfo-m01-vc01.sfo.rainpole.io)"
}

variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance"
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

# Aria Automation Assembler Storage Profile

variable "storage_profile_vsphere" {
  type = map(object({
    cloud_account_name = string
    name               = string
    datastore          = string
    disk_type          = string
    default_item       = bool
    provisioning_type  = string
    storage_policy     = string
    tag_tier           = string
  }))
  description = "A mapping of objects for Storage Profiles for vSphere and their associated settings"
}
