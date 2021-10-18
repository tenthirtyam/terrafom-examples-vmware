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

resource "vra_fabric_network_vsphere" "this" {
  cidr                 = var.cidr
  default_gateway      = var.default_gateway
  domain               = var.domain
  dns_search_domains   = var.dns_search_domains
  dns_server_addresses = var.dns_server_addresses
}