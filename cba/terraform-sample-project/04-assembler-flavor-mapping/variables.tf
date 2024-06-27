##################################################################################
# VARIABLES
##################################################################################

// VMware Aria Automation Endpoint

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

# Aria Automation Assembler

variable "cloud_account_vsphere" {
  type        = string
  description = "Name of the vCenter Server Cloud Acount in VMware Aria Automation Assembler. (e.g sfo-w01-vc01)"
}

variable "flavor_mappings" {
  type = map(object({
    name      = string
    cpu_count = string
    memory    = string
  }))
  description = "Mapping of objects for flavor mappings and their associated settings"
}
