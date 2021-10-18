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
  description = "The network isolation type. (e.g. SUBNET)"
  default     = "SUBNET"
}

variable "isolated_network_domain_cidr" {
  type        = string
  description = "The network CIDR (e.g. 192.168.128.0/18)"
}

variable "isolated_network_cidr_prefix" {
  type        = string
  description = "The network CIDR prefix (e.g. 28)"
}

variable "onDemandNetworkIPAssignmentType" {
  type        = string
  description = "The network CIDR prefix (e.g. static)"
}

variable "network_domain_name" {
  type        = string
  description = "The network domain name."
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet"
}

variable "ip_range_name" {
  type        = string
  description = "The name of the IP range."
}

variable "ip_range_description" {
  type        = string
  description = "A description for the IP range."
}

variable "start_ip_address" {
  type        = string
  description = "The staring IP address in the IP range."
}

variable "end_ip_address" {
  type        = string
  description = "The ending IP address in the IP range."
}

variable "ip_version" {
  type        = string
  description = "The version for IP Addresses."
  default     = "IPv4"
}