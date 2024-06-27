##################################################################################
# VARAIBLES
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

# VMware Aria Automation Assembler

variable "cloud_templates" {
  type = map(object({
    name                = string
    description         = string
    project_name        = string
    content             = string
    release_changelog   = string
    release_description = string
    release_version     = string
    release_status      = bool
  }))
}