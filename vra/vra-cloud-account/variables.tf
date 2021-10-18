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

variable "cloud_accounts_vsphere" {
  type = map(object({
    name        = string
    description = string
    hostname    = string
    username    = string
    password    = string
    region      = string
    tag_cloud   = string
    tag_region  = string
    association = list(string)
  }))
  description = "A mapping of objects for vCenter Server cloud accounts and their associated settings."
}

variable "cloud_accounts_nsx" {
  type = map(object({
    name        = string
    description = string
    hostname    = string
    username    = string
    password    = string
    tag_cloud   = string
  }))
  description = "A mapping of objects for NSX Manager cloud accounts and their associated settings."
}

variable "accept_self_signed" {
  type        = bool
  default     = false
  description = "Accept self-signed certificates. (e.g true | false)"
}
