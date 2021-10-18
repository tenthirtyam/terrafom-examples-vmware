##################################################################################
# VARIABLES
##################################################################################

# Endpoints

variable "vra_url" {
  type        = string
  description = "The base URL of the vRealize Automation endpoint. (e.g. https://xint-vra01.rainpole.io)"
}

variable "vra_api_token" {
  type        = string
  description = "API token from the vRealize Automation endpoint."
  sensitive   = true
}

variable "vra_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates."
  default     = false
}

# Cloud Assembly

variable "cloud_account_vsphere" {
  type        = string
  description = "The name of the vCenter Server cloud account. (e.g sfo-w01-vc01)"
}

variable "region" {
  type        = string
  description = "The region for the flavor mappings."
}

variable "flavor_mappings" {
  type = map(object({
    name      = string
    cpu_count = string
    memory    = string
  }))
  description = "A mapping of objects for flavor mappings and their associated settings."
}