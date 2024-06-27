##################################################################################
# VARIABLES
##################################################################################

# Endpoints

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

# VMware Aria Automation Service Broker

variable "catalog_source_entitlements" {
  type = map(object({
    source_name  = string
    project_name = string
  }))
}