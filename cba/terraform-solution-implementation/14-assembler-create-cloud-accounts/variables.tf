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

# VMware Aria Automation Assembler

variable "cloud_accounts_vsphere" {
  type = map(object({
    name        = string
    description = string
    hostname    = string
    username    = string
    password    = string
    region      = string
    tag_region  = string
    association = list(string)
  }))
  description = "A mapping of objects for vCenter Server Cloud Account and their associated settings"
}

variable "cloud_accounts_nsx" {
  type = map(object({
    name        = string
    description = string
    hostname    = string
    username    = string
    password    = string
    tag_region   = string
  }))
  description = "A mapping of objects for NSX Manager Cloud Account and their associated settings"
}

variable "accept_self_signed" {
  type        = bool
  default     = false
  description = "Accept self-signed certificates. (e.g true | false)"
}

variable "cloud_proxy" {
  type        = string
  description = ""
}
