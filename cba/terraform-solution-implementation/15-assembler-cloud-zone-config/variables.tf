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

# Aria Automation Assembler

variable "cloud_zone_name" {
  type        = string
  description = "The name of the Cloud Zone (e.g. sfo-w01-vc01)"
}

variable "workload_target_folder" {
  type        = string
  description = "The name of the folder within the Cloud Zone to provision virtual machines too (e.g. sfo-w01-fd-workload)"
}

variable "fabric_compute_name" {
  type        = string
  description = "The name of the resource pool within the Cloud Zone to provision virtual machines too (e.g. sfo-w01-cl01 / sfo-w01-cl01-rp-workload)"
}

variable "tag_value" {
  type        = string
  description = "The tag value for the Compute resource. (e.g. true)"
}
