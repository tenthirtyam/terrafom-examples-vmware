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

variable "cloud_account_nsxt" {
  type        = string
  description = "The name of the NSX-T cloud account. (e.g sfo-w01-nsx01)"
}

variable "cloud_account_vsphere" {
  type        = string
  description = "The name of the vCenter Server cloud account. (e.g sfo-w01-vc01)"
}

variable "region" {
  type        = string
  description = "The region for the network profile"
}

variable "name" {
  type        = string
  description = "A name for the network profile"
}

variable "description" {
  type        = string
  description = "A description for the network profile."
}

variable "isolation_type" {
  type        = string
  description = "The network isolation type. (e.g. NONE)"
}

variable "network_ip_ranges" {
  type = map(object({
    subnet_name          = string
    ip_range_name        = string
    ip_range_description = string
    start_ip_address     = string
    end_ip_address       = string
    ip_version           = string
  }))
  description = "A mapping of objects for network IP ranges associated with a network profile."
}