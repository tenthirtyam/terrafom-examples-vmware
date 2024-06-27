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

# VMware Aria Automation Assembler

variable "cidr_network0" {}
variable "default_gateway_network0" {}
variable "cidr_network1" {}
variable "default_gateway_network1" {}
variable "domain" {}
variable "dns_search_domains" {}
variable "dns_server_addresses" {}
