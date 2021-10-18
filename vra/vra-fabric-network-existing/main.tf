##################################################################################
# PROVIDERS
##################################################################################

provider "vra" {
  url           = var.vra_url
  refresh_token = var.vra_api_token
  insecure      = var.vra_insecure
}

##################################################################################
# RESOURCES
##################################################################################

# Add network fabric settings for internal (non-IPAM) IP address management.

resource "vra_fabric_network_vsphere" "network0" {
  cidr                 = var.cidr_network0
  default_gateway      = var.default_gateway_network0
  domain               = var.domain
  dns_search_domains   = var.dns_search_domains
  dns_server_addresses = var.dns_server_addresses
}

resource "vra_fabric_network_vsphere" "network1" {
  cidr                 = var.cidr_network1
  default_gateway      = var.default_gateway_network1
  domain               = var.domain
  dns_search_domains   = var.dns_search_domains
  dns_server_addresses = var.dns_server_addresses
}