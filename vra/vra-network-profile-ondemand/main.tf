##################################################################################
# PROVIDERS
##################################################################################

provider "vra" {
  url           = var.vra_url
  refresh_token = var.vra_api_token
  insecure      = var.vra_insecure
}

##################################################################################
# DATA
##################################################################################

// CLOUD ASSEMBLY

data "vra_cloud_account_vsphere" "this" {
  name = var.cloud_account_vsphere
}

data "vra_cloud_account_nsxt" "this" {
  name = var.cloud_account_nsxt
}

data "vra_region" "this" {
  cloud_account_id = data.vra_cloud_account_vsphere.this.id
  region           = var.region
}

data "vra_network_domain" "this" {
  filter = "name eq '${var.network_domain_name}' and cloudAccountId eq '${data.vra_cloud_account_nsxt.this.id}'"
}

data "vra_fabric_network" "this" {
  filter = "name eq '${var.subnet_name}' and cloudAccountId eq '${data.vra_cloud_account_nsxt.this.id}'"
}

##################################################################################
# RESOURCES
##################################################################################

# Add a network profile for on-demand networks.

resource "vra_network_profile" "this" {
  name                                = var.name
  description                         = var.description
  region_id                           = data.vra_region.this.id
  fabric_network_ids                  = [data.vra_fabric_network.this.id]
  isolation_type                      = var.isolation_type
  isolated_network_domain_id          = data.vra_network_domain.this.id
  isolated_network_domain_cidr        = var.isolated_network_domain_cidr
  isolated_network_cidr_prefix        = var.isolated_network_cidr_prefix
  isolated_external_fabric_network_id = data.vra_fabric_network.this.id
  custom_properties = {
    onDemandNetworkIPAssignmentType   = var.onDemandNetworkIPAssignmentType 
  }
  tags {
    key   = "network"
    value = "ondemand"
  }
  tags {
    key   = "env"
    value = "prod"
  }
  tags {
    key   = "env"
    value = "dev"
  }
}

# Add network IP range for internal IP address management.

resource "vra_network_ip_range" "this" {
  fabric_network_id = data.vra_fabric_network.this.id
  name              = var.ip_range_name
  description       = var.ip_range_description
  start_ip_address  = var.start_ip_address
  end_ip_address    = var.end_ip_address
  ip_version        = var.ip_version
}