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

data "vra_fabric_network" "this" {
  for_each = var.network_ip_ranges
  filter   = "name eq '${each.value.subnet_name}' and cloudAccountId eq '${data.vra_cloud_account_nsxt.this.id}'"
}

##################################################################################
# RESOURCES
##################################################################################

# Add network profile using the IP ranges defined in the plan.

resource "vra_network_profile" "this" {
  name               = var.name
  description        = var.description
  region_id          = data.vra_region.this.id
  fabric_network_ids = [for i in data.vra_fabric_network.this : i.id]
  isolation_type     = var.isolation_type
  tags {
    key   = "network"
    value = "existing"
  }
}

# Add network IP ranges for internal (non-IPAM) IP address management.

resource "vra_network_ip_range" "this" {
  for_each          = var.network_ip_ranges
  fabric_network_id = data.vra_fabric_network.this[each.key].id
  name              = each.value["ip_range_name"]
  description       = each.value["ip_range_description"]
  start_ip_address  = each.value["start_ip_address"]
  end_ip_address    = each.value["end_ip_address"]
  ip_version        = each.value["ip_version"]
}