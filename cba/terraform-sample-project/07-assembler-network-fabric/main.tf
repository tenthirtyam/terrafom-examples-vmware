##################################################################################
# PROVIDERS
##################################################################################
# PROVIDERS
##################################################################################

provider "vra" {
  url           = var.aria_automation_url
  refresh_token = var.aria_automation_api_token
  insecure      = var.aria_automation_insecure
}

##################################################################################
# RESOURCES
##################################################################################

# Add network fabric settings for internal (non-IPAM) IP address management to
# VMware Aria Automation Assembler.

resource "vra_fabric_network_vsphere" "network0" {
  cidr                 = var.cidr_network0
  default_gateway      = var.default_gateway_network0
  domain               = var.domain
  dns_search_domains   = var.dns_search_domains
  dns_server_addresses = var.dns_server_addresses
  tags {
    key   = "network"
    value = "prod"
  }
}

resource "vra_fabric_network_vsphere" "network1" {
  cidr                 = var.cidr_network1
  default_gateway      = var.default_gateway_network1
  domain               = var.domain
  dns_search_domains   = var.dns_search_domains
  dns_server_addresses = var.dns_server_addresses
  tags {
    key   = "network"
    value = "dev"
  }
}